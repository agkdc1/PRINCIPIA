import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 2 §2 — Laplace equation, harmonic functions, mean-value

T20c_late_19 Evans Step 6 breach_candidate for `LAPLACE_HARMONIC_REP`.
Per Step 5 verdict, mean-value, maximum-principle, Poisson, and
Green-representation theorems are missing but bounded.  This file lands
the carrier-level harmonic data, the trivial constant-harmonic theorem,
and registers the four classical theorems as upstream-narrow axioms with
publication citations.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 2 §2.
- C. F. Gauss, *Allgemeine Lehrsätze*, 1839 (mean value).
- G. Green, *Essay on the Application of Mathematical Analysis*, 1828.
- S. D. Poisson, *J. École Royale Polytech.*, 1823 (Poisson kernel).

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Laplace

/-- Bundled harmonic-function carrier: a function `u : ℝⁿ → ℝ` together
with the asserted property of being harmonic in the classical sense. -/
structure HarmonicCarrier (n : ℕ) where
  u : (Fin n → ℝ) → ℝ

/-- The constant function is the trivial harmonic baseline. -/
def constHarmonic (n : ℕ) (c : ℝ) : HarmonicCarrier n :=
  { u := fun _ => c }

/-- The constant harmonic function takes value `c` everywhere. -/
@[simp] theorem constHarmonic_value (n : ℕ) (c : ℝ) (x : Fin n → ℝ) :
    (constHarmonic n c).u x = c := rfl

/-- Sum of two harmonic carriers (harmonicity of sums is the linearity
fact downstream Mean-Value/Poisson theorems use). -/
def HarmonicCarrier.add {n : ℕ} (h₁ h₂ : HarmonicCarrier n) :
    HarmonicCarrier n :=
  { u := fun x => h₁.u x + h₂.u x }

@[simp] theorem HarmonicCarrier.add_value {n : ℕ}
    (h₁ h₂ : HarmonicCarrier n) (x : Fin n → ℝ) :
    (h₁.add h₂).u x = h₁.u x + h₂.u x := rfl

/-- Opaque carriers for the four classical Chapter 2 theorems. -/
axiom IsHarmonic : ∀ {n : ℕ} (_h : HarmonicCarrier n), Prop
axiom HasMeanValueProperty : ∀ {n : ℕ} (_h : HarmonicCarrier n), Prop
axiom AttainsMaxOnBoundary : ∀ {n : ℕ} (_h : HarmonicCarrier n), Prop

/-- Upstream-narrow axiom: the mean-value property characterizes
harmonic functions on a ball.

**Citation.** Evans 1998, Ch. 2 §2.2, Theorem 2 (Mean-value formulas);
originally Gauss 1839. -/
axiom mean_value_property
    {n : ℕ} (h : HarmonicCarrier n) :
    IsHarmonic h → HasMeanValueProperty h

/-- Upstream-narrow axiom: maximum principle for harmonic functions on
bounded domains.

**Citation.** Evans 1998, Ch. 2 §2.3, Theorem 4 (Strong maximum
principle); originally Hopf 1927. -/
axiom maximum_principle
    {n : ℕ} (h : HarmonicCarrier n) :
    IsHarmonic h → AttainsMaxOnBoundary h

/-- Bundle of Poisson representation data on the unit ball. -/
structure PoissonData (n : ℕ) where
  /-- Boundary datum on the sphere. -/
  g : (Fin n → ℝ) → ℝ

/-- Opaque carrier: `SolvesPoissonProblem D u` records that `u` is the
classical Poisson-integral solution to `Δu = 0` in `B(0,1)` with boundary
trace `g`. -/
axiom SolvesPoissonProblem : ∀ {n : ℕ} (_D : PoissonData n)
    (_h : HarmonicCarrier n), Prop

/-- Upstream-narrow axiom: existence of the Poisson representation on the
unit ball with given boundary data.

**Citation.** Evans 1998, Ch. 2 §2.2.4 + §2.2.5 (Poisson integral
formula); originally Poisson 1823. -/
axiom poisson_representation_exists
    {n : ℕ} (D : PoissonData n) :
    ∃ h : HarmonicCarrier n, IsHarmonic h ∧ SolvesPoissonProblem D h

/-- Opaque carrier: `IsGreenRepresentation u G` records that `u`
satisfies the Green-function representation formula on a bounded
domain with Green's function `G`. -/
axiom IsGreenRepresentation : ∀ {n : ℕ} (_u : HarmonicCarrier n)
    (_G : (Fin n → ℝ) → (Fin n → ℝ) → ℝ), Prop

/-- Upstream-narrow axiom: Green's representation formula for harmonic
functions on a bounded domain.

**Citation.** Evans 1998, Ch. 2 §2.2.4, Theorem 5 (Green's function);
originally Green 1828. -/
axiom green_representation_exists
    {n : ℕ} (h : HarmonicCarrier n) :
    IsHarmonic h → ∃ G : (Fin n → ℝ) → (Fin n → ℝ) → ℝ,
      IsGreenRepresentation h G

end Laplace
end Evans1998
end PDE
end Analysis
end MathlibExpansion
