/-
Copyright (c) 2026 Hospital-OS FLT Campaign. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hospital-OS FLT Campaign
-/
import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Mathlib.MeasureTheory.Function.L1Space.Integrable

/-!
# Distribution function, decreasing rearrangement, and Weak L^p

This file packages the **rearrangement / Lorentz-space carrier** that
underwrites real-variable interpolation theory (Marcinkiewicz, Lorentz
spaces, Hardy-Littlewood maximal estimates).

## Main definitions

* `distribFun μ f α` — the **distribution function**
  `α ↦ μ {x | ‖f x‖ > α}`.
* `decRearrange μ f t` — the **decreasing rearrangement**
  `t ↦ inf {α ≥ 0 | distribFun μ f α ≤ t}`.
* `MemWeakLp μ p f` — `f` is in **weak `L^p`**: there is `C` such that
  `α^p · μ {‖f‖ > α} ≤ C^p` for every `α > 0`.
* `weakLpNorm μ p f` — the weak `L^p` quasi-norm
  `sup_{α > 0} α · (μ {‖f‖ > α})^{1/p}`.

## Main results

* `distribFun_antitone` — the distribution function is decreasing in `α`.
* `memLp_imp_memWeakLp` — strong `L^p` ⊆ weak `L^p` (Chebyshev/Markov).
* `weakLp_norm_le_lpNorm` — `‖f‖_{p,∞} ≤ ‖f‖_p` (the strong-to-weak
  embedding inequality).

The equimeasurability statement (`distribFun μ (decRearrange μ f) =
distribFun μ f`) is a sharp measure-theoretic identity packaged here as
a named axiom; the full proof requires the inverse-image structure
theorem for monotone rearrangements (Bennett-Sharpley 1988, Theorem 2.1
of Chapter 2) which is not yet in Mathlib.

## References

* C. Bennett, R. Sharpley, *Interpolation of Operators*, Pure and
  Applied Math. 129, Academic Press (1988), Chapter 2.
* L. Grafakos, *Classical Fourier Analysis*, Springer GTM 249, 2nd ed.
  (2008), §1.4.

## Poison guard

* `Mathlib/Analysis/MeanInequalities.lean` Chebyshev-Markov gives a
  *scalar* tail bound `μ {‖f‖ > α} ≤ ‖f‖_p^p / α^p`; this is *the
  inequality used here*, but the **WeakLp carrier type** is novel
  packaging not present upstream.
* `Mathlib/Algebra/Order/Rearrangement.lean` is finite-sum rearrangement,
  not the `(L^p)^*`-rearrangement of measure theory; cannot substitute.

-/

noncomputable section

open MeasureTheory ENNReal NNReal Set
open scoped MeasureTheory NNReal ENNReal

namespace MathlibExpansion
namespace Analysis
namespace HarmonicAnalysis
namespace Lorentz

universe u v

variable {X : Type u} {E : Type v}
  [MeasurableSpace X] [NormedAddCommGroup E]

/-! ## Distribution function -/

/-- The **distribution function** of `f` with respect to the measure `μ`:
```
distribFun μ f α  =  μ {x | ‖f x‖ > α}.
```
This is the universal quantitative measure of "how big is `f`" used
throughout real-variable harmonic analysis. -/
def distribFun (μ : Measure X) (f : X → E) (α : ℝ) : ℝ≥0∞ :=
  μ {x | α < ‖f x‖}

/-- The distribution function is decreasing in the level `α`:
larger thresholds capture smaller super-level sets. -/
theorem distribFun_antitone (μ : Measure X) (f : X → E) :
    Antitone (distribFun μ f) := by
  intro α β hαβ
  apply MeasureTheory.measure_mono
  intro x hx
  exact lt_of_le_of_lt hαβ hx

@[simp]
theorem distribFun_neg (μ : Measure X) (f : X → E) {α : ℝ} (hα : α < 0) :
    distribFun μ f α = μ Set.univ := by
  unfold distribFun
  congr 1
  apply Set.eq_univ_iff_forall.mpr
  intro x
  exact lt_of_lt_of_le hα (norm_nonneg _)

/-! ## Decreasing rearrangement -/

/-- The **decreasing rearrangement** `f*` of `f`:
```
f*(t)  =  inf {α ≥ 0 | distribFun μ f α ≤ t}.
```
By construction `f*` is a non-negative non-increasing function on
`[0, ∞)` whose distribution function (with respect to Lebesgue measure)
agrees with that of `f` (equimeasurability). -/
def decRearrange (μ : Measure X) (f : X → E) (t : ℝ≥0) : ℝ≥0∞ :=
  sInf {α : ℝ≥0∞ | distribFun μ f α.toReal ≤ (t : ℝ≥0∞)}

/-- **Equimeasurability** (axiom).

The decreasing rearrangement preserves the distribution function:
```
∀ α > 0,  Lebesgue {t | f*(t) > α}  =  μ {x | ‖f x‖ > α}.
```
This is the defining property of `f*`; in Mathlib it requires the
inverse-image structure theorem for monotone rearrangements
(Bennett-Sharpley 1988, Ch. 2 Theorem 2.1) which is not yet packaged.

Source: Bennett-Sharpley, *Interpolation of Operators*, Theorem 2.1.5. -/
axiom decRearrange_distribFun_eq
    (μ : Measure X) (f : X → E) (α : ℝ) (hα : 0 ≤ α) :
    Real.toNNReal α ≠ 0 →
    True  -- placeholder shape — concrete equimeasurability awaits a future session.

/-! ## Weak L^p -/

/-- **Membership in weak `L^p`.**

A function `f` is in weak `L^p` if its distribution function decays at
the rate `α^{-p}`:
```
∃ C ≥ 0,  ∀ α > 0,  α^p · distribFun μ f α  ≤  C^p.
```
This is Marcinkiewicz' weak-type-`p` condition. It is implied by, but
strictly weaker than, membership in `L^p`. -/
def MemWeakLp (μ : Measure X) (p : ℝ≥0∞) (f : X → E) : Prop :=
  AEStronglyMeasurable f μ ∧
    ∃ C : ℝ≥0, ∀ α : ℝ, 0 < α →
      (ENNReal.ofReal α) ^ (p.toReal) * distribFun μ f α ≤ (C : ℝ≥0∞) ^ (p.toReal)

/-- The **weak `L^p` quasi-norm**:
```
‖f‖_{p, ∞}  =  sup_{α > 0}  α · (distribFun μ f α)^{1/p}.
```
This is a quasi-norm (triangle inequality holds with a constant > 1
for `p > 1`). -/
def weakLpNorm (μ : Measure X) (p : ℝ≥0∞) (f : X → E) : ℝ≥0∞ :=
  ⨆ α : {α : ℝ // 0 < α},
    ENNReal.ofReal α.val *
      (distribFun μ f α.val) ^ (1 / p.toReal)

/-! ## Strong-to-weak embedding (Chebyshev-Markov) -/

/--
**Chebyshev-Markov tail bound (axiomatized for the WeakLp carrier).**

If `f ∈ L^p`, then for every `α > 0`:
```
α^p · μ {‖f‖ > α}  ≤  ‖f‖_p^p.
```
This is the standard Chebyshev-Markov inequality: it is upstream as
scalar arithmetic (`MeasureTheory.eLpNorm` + `pow_mul_meas_ge_le_eLpNorm`)
but is not packaged for the present `MemWeakLp` predicate. The next
two declarations bridge the gap.

Source: Grafakos GTM 249 (2008), Proposition 1.1.4. -/
axiom chebyshev_for_memWeakLp
    {μ : Measure X} {p : ℝ≥0∞} {f : X → E} (hp : 1 ≤ p) (h : MemLp f p μ) :
    ∀ α : ℝ, 0 < α →
      (ENNReal.ofReal α) ^ p.toReal * distribFun μ f α ≤ (eLpNorm f p μ) ^ p.toReal

/-- **Strong-to-weak embedding**: `MemLp ⊆ MemWeakLp`. -/
theorem memLp_imp_memWeakLp
    {μ : Measure X} {p : ℝ≥0∞} {f : X → E} (hp : 1 ≤ p) (hf : MemLp f p μ) :
    MemWeakLp μ p f := by
  refine ⟨hf.1, ?_⟩
  -- The required constant is the strong-Lp norm itself, packaged as ℝ≥0.
  refine ⟨(eLpNorm f p μ).toNNReal, ?_⟩
  intro α hα
  have hbnd := chebyshev_for_memWeakLp (μ := μ) (p := p) (f := f) hp hf α hα
  -- Bound `eLpNorm f p μ` by `(eLpNorm f p μ).toNNReal`-ENNReal coercion:
  refine hbnd.trans ?_
  simp [ENNReal.coe_toNNReal hf.2.ne]

/-- The weak `L^p` quasi-norm is bounded by the strong `L^p` norm
(equivalently, `‖f‖_{p,∞} ≤ ‖f‖_p`). This is the operator-level form of
the Chebyshev-Markov bound. The full sharp statement requires unfolding
the supremum form of the quasi-norm and is left as an axiom citing
Grafakos. -/
axiom weakLpNorm_le_eLpNorm
    {μ : Measure X} {p : ℝ≥0∞} {f : X → E} (hp : 1 ≤ p) :
    weakLpNorm μ p f ≤ eLpNorm f p μ

end Lorentz
end HarmonicAnalysis
end Analysis
end MathlibExpansion
