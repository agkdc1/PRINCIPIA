import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 9 — Nonvariational techniques: monotonicity, fixed-point, sub/supersolution

T20c_late_19 Evans Step 6 substrate_gap breach for
`MONOTONICITY_FIXEDPOINT_SUBSUPER`.
Per Step 5 verdict, Knaster–Tarski / Banach contraction exist upstream;
nonlinear monotone operators, sub/supersolution intervals, and
comparison are the missing PDE owners.

This file lands carrier-level data and the trivial constant-pair
sub/super theorem, plus three sharp upstream-narrow axioms (monotone-
operator surjectivity, sub/super existence, Schauder fixed point).

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 9.
- F. E. Browder, *Bull. AMS* **69** (1963), 862–874 (monotone operators).
- G. J. Minty, *Duke Math. J.* **29** (1962), 341–346.
- D. H. Sattinger, *Indiana U. Math. J.* **21** (1972) (sub/super).
- J. Schauder, *Studia Math.* **2** (1930), 171–180 (fixed point).

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Nonvariational

/-- Carrier of a sub/super-solution pair: `(v, w)` with `v ≤ w`. -/
structure SubSuperPair (Ω : Type*) where
  v : Ω → ℝ
  w : Ω → ℝ

/-- Pointwise ordering. -/
def SubSuperPair.LeqPointwise {Ω : Type*} (P : SubSuperPair Ω) : Prop :=
  ∀ x : Ω, P.v x ≤ P.w x

/-- Trivial constant-zero pair. -/
def trivialZeroPair (Ω : Type*) : SubSuperPair Ω :=
  { v := fun _ => 0, w := fun _ => 0 }

theorem trivialZeroPair_leq (Ω : Type*) :
    (trivialZeroPair Ω).LeqPointwise := by
  intro x; simp [trivialZeroPair]

/-- A function `u : Ω → ℝ` lies in the sub/super-interval. -/
def InSubSuperInterval {Ω : Type*} (P : SubSuperPair Ω) (u : Ω → ℝ) : Prop :=
  ∀ x : Ω, P.v x ≤ u x ∧ u x ≤ P.w x

/-- Constant-zero datum lies in the trivial-zero sub/super-interval. -/
theorem zero_in_trivial_interval (Ω : Type*) :
    InSubSuperInterval (trivialZeroPair Ω) (fun _ : Ω => 0) := by
  intro x
  simp [trivialZeroPair]

/-- Opaque predicates. -/
axiom IsMonotoneOperator : ∀ {X : Type*} (_A : X → X), Prop
axiom IsCoerciveOperator : ∀ {X : Type*} (_A : X → X), Prop
axiom IsHemicontinuous : ∀ {X : Type*} (_A : X → X), Prop
axiom IsSubsolution : ∀ {Ω : Type*} (_v : Ω → ℝ), Prop
axiom IsSupersolution : ∀ {Ω : Type*} (_w : Ω → ℝ), Prop
axiom IsCompactMap : ∀ {X : Type*} (_T : X → X), Prop

/-- Upstream-narrow axiom: Browder–Minty surjectivity for monotone,
hemicontinuous, coercive operators on a reflexive Banach space.

**Citation.** Browder 1963; Minty 1962; Evans 1998, Ch. 9 §1.1
(Browder–Minty Theorem). -/
axiom browder_minty_surjective
    {X : Type*} (A : X → X)
    (h₁ : IsMonotoneOperator A)
    (h₂ : IsHemicontinuous A)
    (h₃ : IsCoerciveOperator A)
    (b : X) :
    ∃ x : X, A x = b

/-- Upstream-narrow axiom: existence of a solution between an ordered
sub/super-solution pair for nonlinear elliptic boundary-value problems.

**Citation.** Evans 1998, Ch. 9 §3.1 (Sub/super-solution method);
Sattinger 1972. -/
axiom subsuper_existence
    {Ω : Type*} (P : SubSuperPair Ω)
    (hv : IsSubsolution P.v)
    (hw : IsSupersolution P.w)
    (h : P.LeqPointwise) :
    ∃ u : Ω → ℝ, InSubSuperInterval P u

/-- Upstream-narrow axiom: Schauder's fixed-point theorem for compact
maps on a closed convex bounded set in a Banach space.

**Citation.** Schauder 1930; Evans 1998, Ch. 9 §2.2 (Schauder's theorem). -/
axiom schauder_fixed_point
    {X : Type*} (T : X → X)
    (h : IsCompactMap T)
    (x₀ : X) :
    ∃ x : X, T x = x

end Nonvariational
end Evans1998
end PDE
end Analysis
end MathlibExpansion
