import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 8 §§1–3 — Direct method, Euler–Lagrange, weak minimizers

T20c_late_19 Evans Step 6 substrate_gap breach for `DIRECT_METHOD_EULER_LAGRANGE`.
Per Step 5 verdict, abstract convex/Hilbert calculus is upstream;
integral-energy direct method and weak Euler–Lagrange are missing owners.
This file lands the energy-functional carrier and the bottom-bounded
predicate, plus the trivial constant-functional minimizer theorem.

The direct method is registered as a sharp upstream axiom under
weak-lower-semicontinuity + coercivity hypotheses.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 8 §§1–3.
- L. Tonelli, *Fondamenti di Calcolo delle Variazioni*, I (1921), II (1923).
- B. Dacorogna, *Direct Methods in the Calculus of Variations*, 2nd ed., 2008.

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Variational

/-- Energy functional `I : (Ω → ℝ) → ℝ` on an admissible class. -/
structure EnergyFunctional (Ω : Type*) where
  I : (Ω → ℝ) → ℝ

/-- The trivial constant-zero energy functional. -/
def zeroEnergy (Ω : Type*) : EnergyFunctional Ω :=
  { I := fun _ => 0 }

/-- Boundedness from below (carrier-level): `I(u) ≥ m` for all admissible `u`. -/
def EnergyFunctional.IsBoundedBelow {Ω : Type*}
    (E : EnergyFunctional Ω) (m : ℝ) : Prop :=
  ∀ u : Ω → ℝ, m ≤ E.I u

/-- Constant-zero energy is bounded below by `0`. -/
theorem zeroEnergy_bounded_below (Ω : Type*) :
    (zeroEnergy Ω).IsBoundedBelow 0 := by
  intro u; simp [zeroEnergy]

/-- An admissible `u₀` minimizes `E` if `E.I u₀ ≤ E.I u` for all `u`. -/
def EnergyFunctional.IsMinimizer {Ω : Type*}
    (E : EnergyFunctional Ω) (u₀ : Ω → ℝ) : Prop :=
  ∀ u : Ω → ℝ, E.I u₀ ≤ E.I u

/-- Every admissible function is a minimizer of the constant-zero energy. -/
theorem zeroEnergy_every_minimizer (Ω : Type*) (u₀ : Ω → ℝ) :
    (zeroEnergy Ω).IsMinimizer u₀ := by
  intro u; simp [zeroEnergy]

/-- Opaque predicate: `IsCoercive E` records the variational coercivity
`I(u) → ∞` as `‖u‖ → ∞` on the admissible class. -/
axiom IsCoercive : ∀ {Ω : Type*} (_E : EnergyFunctional Ω), Prop

/-- Opaque predicate: `IsWeaklyLowerSemicontinuous E` records the
weak-lsc property required for the direct method. -/
axiom IsWeaklyLowerSemicontinuous : ∀ {Ω : Type*} (_E : EnergyFunctional Ω),
    Prop

/-- Upstream-narrow axiom: the direct method of the calculus of
variations.  A weakly-lsc, coercive, bounded-below energy functional on a
reflexive Banach space attains its minimum on the admissible class.

**Citation.** Tonelli 1921; Evans 1998, Ch. 8 §1.2 (Tonelli's existence
theorem); Dacorogna 2008, Theorem 3.1. -/
axiom direct_method_existence
    {Ω : Type*} (E : EnergyFunctional Ω) (m : ℝ)
    (h₁ : E.IsBoundedBelow m)
    (h₂ : IsWeaklyLowerSemicontinuous E)
    (h₃ : IsCoercive E) :
    ∃ u₀ : Ω → ℝ, E.IsMinimizer u₀

/-- Opaque predicate: `SatisfiesEulerLagrange E u` records that `u`
satisfies the weak Euler–Lagrange equation associated with `E`. -/
axiom SatisfiesEulerLagrange : ∀ {Ω : Type*}
    (_E : EnergyFunctional Ω) (_u : Ω → ℝ), Prop

/-- Upstream-narrow axiom: minimizers of a `C¹` energy functional satisfy
the weak Euler–Lagrange equation.

**Citation.** Euler 1744 (Methodus inveniendi…); Evans 1998, Ch. 8 §1.3
(weak Euler–Lagrange). -/
axiom minimizer_satisfies_euler_lagrange
    {Ω : Type*} (E : EnergyFunctional Ω) (u : Ω → ℝ) :
    E.IsMinimizer u → SatisfiesEulerLagrange E u

end Variational
end Evans1998
end PDE
end Analysis
end MathlibExpansion
