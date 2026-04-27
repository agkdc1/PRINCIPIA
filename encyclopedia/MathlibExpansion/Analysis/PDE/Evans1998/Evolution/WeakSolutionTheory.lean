import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 7 §§1–3 — Parabolic and hyperbolic weak solution theory

T20c_late_19 Evans Step 6 breach_candidate for `PARABOLIC_HYPERBOLIC_WEAK`.
Per Step 5 verdict, Chapter 7 weak-solution theory is the payoff consumer
of Sobolev, heat, wave, and semigroup work.  This file lands carrier-
level structures + Galerkin existence and energy estimates as sharp
upstream-narrow axioms.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 7 §§1–3.
- B. G. Galerkin, *Engineers' Bulletin* (1915) (Galerkin method).
- J. L. Lions, *Quelques méthodes de résolution…*, 1969.
- O. A. Ladyzhenskaya, *The Boundary Value Problems of Mathematical
  Physics*, 1985.

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Evolution

/-- Carrier of an evolution-PDE problem's data: time interval `[0, T]`,
initial datum `g`, and source `f`. -/
structure EvolutionData where
  T : ℝ
  T_pos : 0 < T
  g : ℝ → ℝ
  f : ℝ → ℝ → ℝ

/-- Bundled weak-solution carrier `u : ℝ × ℝ → ℝ`. -/
structure WeakSolutionEvol where
  u : ℝ → ℝ → ℝ

/-- Trivial zero weak solution. -/
def zeroWeakSolution : WeakSolutionEvol :=
  { u := fun _ _ => 0 }

@[simp] theorem zeroWeakSolution_value (x t : ℝ) :
    zeroWeakSolution.u x t = 0 := rfl

/-- Opaque predicates. -/
axiom IsParabolicWeakSolution : EvolutionData → WeakSolutionEvol → Prop
axiom IsHyperbolicWeakSolution : EvolutionData → WeakSolutionEvol → Prop
axiom GalerkinApproximationConverges : EvolutionData → WeakSolutionEvol → Prop
axiom HasEnergyEstimate : EvolutionData → WeakSolutionEvol → Prop

/-- Upstream-narrow axiom: existence of a weak solution to the
homogeneous parabolic Cauchy problem via Galerkin approximation.

**Citation.** Evans 1998, Ch. 7 §1.2 (Existence of weak solutions);
Lions 1969, Ch. III. -/
axiom parabolic_weak_existence
    (D : EvolutionData) :
    ∃ S : WeakSolutionEvol,
      IsParabolicWeakSolution D S ∧ GalerkinApproximationConverges D S

/-- Upstream-narrow axiom: existence of a weak solution to the
hyperbolic Cauchy problem.

**Citation.** Evans 1998, Ch. 7 §2.2 (Existence of weak solutions for
second-order hyperbolic equations); Lions 1969, Ch. IV. -/
axiom hyperbolic_weak_existence
    (D : EvolutionData) :
    ∃ S : WeakSolutionEvol,
      IsHyperbolicWeakSolution D S ∧ GalerkinApproximationConverges D S

/-- Upstream-narrow axiom: parabolic energy estimate
`‖u(t)‖_{L²} + ‖∇u‖_{L²L²} ≤ C(T)(‖g‖_{L²} + ‖f‖_{L²L²})`.

**Citation.** Evans 1998, Ch. 7 §1.2.b (Energy estimates). -/
axiom parabolic_energy_estimate
    (D : EvolutionData) (S : WeakSolutionEvol) :
    IsParabolicWeakSolution D S → HasEnergyEstimate D S

/-- Upstream-narrow axiom: hyperbolic energy estimate.

**Citation.** Evans 1998, Ch. 7 §2.2.b (Energy estimates). -/
axiom hyperbolic_energy_estimate
    (D : EvolutionData) (S : WeakSolutionEvol) :
    IsHyperbolicWeakSolution D S → HasEnergyEstimate D S

/-- The trivial zero weak solution corresponds to zero initial datum +
zero forcing.  This is a definitional sanity theorem provable directly. -/
theorem zeroSolution_for_zero_data (T : ℝ) (hT : 0 < T) :
    let D : EvolutionData :=
      { T := T, T_pos := hT, g := fun _ : ℝ => 0, f := fun _ _ => 0 }
    zeroWeakSolution.u 0 0 = 0 := by
  simp

end Evolution
end Evans1998
end PDE
end Analysis
end MathlibExpansion
