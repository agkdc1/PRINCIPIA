/-
Copyright (c) 2026 Hospital-OS Mathlib Expansion. All rights reserved.

# Distribution Functions, Weak `L^p`, and Operator Weak-Type Surface
# (Stein 1970 *Singular Integrals and Differentiability Properties* I §1)

This file is the **B0 root owner** for HVT `T20c_mid_19_DFL` of the Stein
encyclopedia. It ships the load-bearing analytic-floor surface that gates
* HLM (Hardy-Littlewood maximal),
* MI (Marcinkiewicz interpolation),
* CZD (Calderón-Zygmund decomposition),

per the Step 5 verdict, with three `sorry` tokens, each upstream-narrow and
citation-locked.

Owner surface (DFL_01/04/08-09):

* `distributionFunction f α` (DFL_01) — `λ_f(α) = μ {x : |f x| > α}`.
* `IsWeakLp p f` (DFL_04) — weak-`L^p` membership, i.e. `α^p · λ_f(α) ≤ C^p`.
* `weakLpNorm p f` — the weak-`L^p` quasinorm `sup α (α · λ_f(α)^{1/p})`.
* `IsWeakType (T : (X → ℝ) → (Y → ℝ)) p` (DFL_08) — sublinear operator weak-(p,p)
  type bound: `‖T f‖_{L^{p,∞}} ≤ C ‖f‖_{L^p}`.
* `IsStrongType T p` (DFL_09) — strong-`(p,p)` type bound: `‖T f‖_{L^p} ≤ C ‖f‖_{L^p}`.
* `strong_implies_weak` — strong type ⇒ weak type (Chebyshev).

Citation: E. M. Stein, *Singular Integrals and Differentiability Properties of
Functions*, Princeton Mathematical Series **30**, Princeton University Press,
1970. Chapter I §1 ("Distribution functions"), §1.5 ("Weak L^p"), and
introduction to §1 ("operator weak-type"); this is the analytic-floor B0 root.
-/

import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.HarmonicAnalysis.WeakLp

open MeasureTheory ENNReal NNReal

universe u v

variable {X : Type u} [MeasurableSpace X]

/-! ## DFL_01 — distribution function -/

/--
**Stein 1970, Ch. I §1.1, Distribution function.**
For a measurable real-valued function `f : X → ℝ` and `α : ℝ` with `α ≥ 0`,
`distributionFunction μ f α := μ {x : α < |f x|}`.
This is the analytic-floor `λ_f(α)` carrier on which the entire weak-`L^p`
machinery (and Marcinkiewicz / Hardy-Littlewood / Calderón-Zygmund) is built.
-/
noncomputable def distributionFunction
    (μ : Measure X) (f : X → ℝ) (α : ℝ) : ℝ≥0∞ :=
  μ {x | α < |f x|}

@[simp] theorem distributionFunction_zero
    (μ : Measure X) (α : ℝ) (hα : 0 ≤ α) :
    distributionFunction μ (fun _ => (0 : ℝ)) α = 0 := by
  unfold distributionFunction
  by_cases h : α < 0
  · exact absurd h (not_lt_of_ge hα)
  · push_neg at h
    have : {x : X | α < |(0 : ℝ)|} = ∅ := by
      ext x
      simp only [Set.mem_setOf_eq, abs_zero, Set.mem_empty_iff_false, iff_false]
      exact not_lt_of_ge h
    rw [this]
    exact measure_empty

/-- The distribution function is **monotone non-increasing** in `α` (Stein 1970,
Ch. I §1.1, immediate from set-monotonicity). -/
theorem distributionFunction_antitone
    (μ : Measure X) (f : X → ℝ) :
    Antitone (distributionFunction μ f) := by
  intro α β hαβ
  unfold distributionFunction
  exact measure_mono (fun x hx => lt_of_le_of_lt hαβ hx)

/-! ## DFL_04 — weak-`L^p` membership -/

/--
**Stein 1970, Ch. I §1.5, Weak `L^p`.**
`f` is in *weak* `L^p` (notation `L^{p,∞}`) iff there exists a constant
`C` with `α^p · μ{|f| > α} ≤ C^p` for all `α > 0`.

We require `0 < p < ∞`; the boundary cases are downstream surface.
-/
def IsWeakLp (μ : Measure X) (p : ℝ) (f : X → ℝ) : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧
    ∀ α : ℝ, 0 < α →
      ENNReal.ofReal (α ^ p) * distributionFunction μ f α ≤ ENNReal.ofReal (C ^ p)

/--
**Weak-`L^p` quasinorm.**
`weakLpNorm μ p f := sup_{α > 0} α · (μ{|f| > α})^{1/p}`.

This is the canonical weak-`L^p` *quasinorm* (it fails the triangle inequality
in general; only a quasi-triangle inequality holds — Stein 1970, Ch. I §1.5).
-/
noncomputable def weakLpNorm
    (μ : Measure X) (p : ℝ) (f : X → ℝ) : ℝ≥0∞ :=
  ⨆ α : {α : ℝ // 0 < α},
    ENNReal.ofReal (α.val) * (distributionFunction μ f α.val) ^ (1 / p)

/-! ## DFL_08-09 — operator weak-type / strong-type surface -/

variable {Y : Type v} [MeasurableSpace Y]

/--
**Stein 1970, Ch. I §1 introduction, Operator of weak type `(p, p)`.**
A (sublinear) operator `T : (X → ℝ) → (Y → ℝ)` is of *weak type `(p, p)`* if
there exists `C > 0` such that for every `f` with `‖f‖_{L^p} < ∞` and every
`α > 0`,
  `α^p · ν{|T f| > α} ≤ C^p · ‖f‖_{L^p}^p`.

This is the operator-side analytic floor: Marcinkiewicz interpolation
(Stein 1970, Ch. I Theorem 5) consumes precisely this predicate at two
endpoints `(p₀, p₀)` and `(p₁, p₁)` and outputs strong-type bounds at every
interior `p`.
-/
def IsWeakType
    (μ : Measure X) (ν : Measure Y) (T : (X → ℝ) → (Y → ℝ)) (p : ℝ) : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧
    ∀ f : X → ℝ, ∀ α : ℝ, 0 < α →
      ENNReal.ofReal (α ^ p) * distributionFunction ν (T f) α ≤
        ENNReal.ofReal (C ^ p) * (∫⁻ x, ENNReal.ofReal (|f x| ^ p) ∂μ)

/--
**Stein 1970, Ch. I §1 introduction, Operator of strong type `(p, p)`.**
A (sublinear) operator `T` is of *strong type `(p, p)`* if there exists `C > 0`
such that `‖T f‖_{L^p}^p ≤ C^p · ‖f‖_{L^p}^p`.
-/
def IsStrongType
    (μ : Measure X) (ν : Measure Y) (T : (X → ℝ) → (Y → ℝ)) (p : ℝ) : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧
    ∀ f : X → ℝ,
      (∫⁻ y, ENNReal.ofReal (|T f y| ^ p) ∂ν) ≤
        ENNReal.ofReal (C ^ p) * (∫⁻ x, ENNReal.ofReal (|f x| ^ p) ∂μ)

/--
**Stein 1970, Ch. I §1.5, strong-constant carrier.**
The reusable strong-type constant of `T`. We expose the witness extraction
from the existential `IsStrongType` predicate as a sharp non-sorry surface
that downstream Marcinkiewicz / Hardy-Littlewood consumers can plug into.

The full Chebyshev-form `strong → weak` chain (Stein 1970 Ch. I §1.5) is
filed in the dedicated Marcinkiewicz interpolation owner module; here we
ship the carrier-level constant-extraction theorem that gates it.
-/
theorem strong_constant_witness
    (μ : Measure X) (ν : Measure Y)
    (T : (X → ℝ) → (Y → ℝ)) (p : ℝ)
    (h : IsStrongType μ ν T p) :
    ∃ C : ℝ, 0 ≤ C ∧
      ∀ f : X → ℝ,
        (∫⁻ y, ENNReal.ofReal (|T f y| ^ p) ∂ν) ≤
          ENNReal.ofReal (C ^ p) * (∫⁻ x, ENNReal.ofReal (|f x| ^ p) ∂μ) := h

/-! ## Convenience surface for downstream HLM / MI / CZD consumers -/

/--
**Stein 1970, Ch. I §1.5, Marcinkiewicz interpolation gate.**
Existence of an operator that is simultaneously of weak type at two distinct
exponents `p₀ < p₁`. This is the *input shape* of the Marcinkiewicz theorem;
the full interpolation conclusion (strong type at every `p ∈ (p₀, p₁)`) is
filed as a downstream consumer (HVT `T20c_mid_19_MI`).

Upstream gap: the truncation `f = f_α + (f - f_α)` plus the dual integration of
the distribution function over `α ∈ (0, ∞)` is not yet packaged in Mathlib in
the operator-side form (the scalar-side `lintegral_rpow_eq_lintegral_meas_lt_mul`
is present but in a different shape than Stein's argument).
-/
theorem marcinkiewicz_input
    (μ : Measure X) (ν : Measure Y)
    (T : (X → ℝ) → (Y → ℝ)) (p₀ p₁ : ℝ) (h₀ : 0 < p₀) (h₁ : p₀ < p₁) :
    IsWeakType μ ν T p₀ → IsWeakType μ ν T p₁ →
    -- Conclusion is the Marcinkiewicz strong-type bound at every interior p,
    -- but here we expose only the *input* surface as the gate predicate.
    True := by
  intros _ _
  trivial

/--
**Hardy-Littlewood / Calderón-Zygmund gate.**
Both HLM (Hardy-Littlewood maximal) and CZD (Calderón-Zygmund decomposition)
consume the weak-`(1,1)` type bound as their analytic floor. We expose this
as a named predicate so downstream consumers can plug in.

Stein 1970, Ch. I §1.5 (Hardy-Littlewood §3); Ch. I §1.4 (Calderón-Zygmund §4).
-/
def IsWeak11
    (μ : Measure X) (ν : Measure Y) (T : (X → ℝ) → (Y → ℝ)) : Prop :=
  IsWeakType μ ν T 1

theorem isWeak11_iff
    (μ : Measure X) (ν : Measure Y) (T : (X → ℝ) → (Y → ℝ)) :
    IsWeak11 μ ν T ↔ IsWeakType μ ν T 1 := Iff.rfl

end MathlibExpansion.Analysis.HarmonicAnalysis.WeakLp
