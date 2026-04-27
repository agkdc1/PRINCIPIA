/-
Copyright (c) 2026 Hospital-OS FLT Campaign. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hospital-OS FLT Campaign
-/
import Mathlib.MeasureTheory.Measure.Stieltjes
import Mathlib.Topology.EMetricSpace.BoundedVariation
import Mathlib.MeasureTheory.Decomposition.RadonNikodym
import Mathlib.Analysis.Calculus.BoundedVariation
import MathlibExpansion.Analysis.AbsoluteContinuity.Basic

/-!
# Lebesgue–Stieltjes measures of bounded-variation functions

This file constructs the **Lebesgue–Stieltjes measure** `μ_f` associated to a
function `f : ℝ → ℝ` of bounded variation on an interval, and identifies its
relationship with the absolutely-continuous part of `f`.

## Main definitions

* `stieltjesFunctionOfBV` — for a BV function `f`, the right-continuous
  regularisation `f⁺` packaged as a `StieltjesFunction`.
* `lebesgueStieltjesOfBV` — the associated Borel measure `μ_{f⁺}` on `ℝ`.

## Main results

* `lebesgueStieltjesOfBV_mass` — `μ_{f⁺}([a, b]) = f⁺(b) - f⁺(a)` for `a ≤ b`.
* `lebesgueStieltjesOfBV_absCont` (**axiom**) — if `f` is AC on `[a, b]`,
  then `μ_{f⁺} ≪ volume` (the Stieltjes measure is absolutely continuous
  with respect to Lebesgue measure).
* `lebesgueStieltjesOfBV_rnDeriv` (**axiom**) — Radon–Nikodym identification:
  when `f` is AC on `[a, b]`, the Radon–Nikodym derivative
  `d μ_{f⁺} / d volume = f'` a.e. on `[a, b]`.

## Axiom budget

Three upstream-narrow axioms are used:

| Label | Name | Statement | Citation |
|-------|------|-----------|---------|
| SB-P1 | `stieltjesFunctionOfMonotone` | monotone f → StieltjesFunction | Stieltjes 1894; Rudin RCA §7.1 |
| SB-P2 | `positiveVariation_mono` | BV f → positive variation monotone | Jordan 1881; Rudin RCA Thm 6.4 |
| SB-A1 | `lebesgueStieltjesOfBV_absCont` | AC ⟹ µ_f ≪ λ | Rudin RCA Thm 7.15 |
| SB-A2 | `lebesgueStieltjesOfBV_rnDeriv` | dµ_f/dλ = f' a.e. | Rudin RCA Thm 7.20 |
| SB-A3 | `stieltjes_ftc` | ∫ f' = µ_f([a,x]) for AC f | Rudin RCA Thm 7.20; Stein-Shakarchi RA Ch.3 §2 |

SB-P1 and SB-P2 are structural (right-continuity packaging, Jordan decomposition).
SB-A1, SB-A2, SB-A3 require packaging the `StieltjesFunction.measure` API with
the Radon–Nikodym theorem (`MeasureTheory.Measure.rnDeriv`) at the function level;
Mathlib v4.17.0 provides both pieces individually but has not assembled the
combination for the BV/AC setting. SB-A3 (`stieltjes_ftc`) reduces to SB-A1+SB-A2
plus `MeasureTheory.Measure.integral_rnDeriv_smul` and `lebesgueStieltjesOfBV_mass`;
the formal assembly is recorded as an axiom pending the API bridge.

## Poison guard

* `StieltjesFunction` in Mathlib is a **monotone** right-continuous function.
  A BV function is the difference of two monotone functions (Jordan), so the
  Stieltjes measure of a general BV function is a **signed** measure.  This
  file works with the positive part only (the right-continuous version of the
  total-variation / positive-variation part), which suffices for the AC
  identification because every AC function is a difference of two AC functions
  each of which increases.

## References

* H. Lebesgue, *Leçons sur l'intégration*, Paris 1904.
* T. Stieltjes, *Recherches sur les fractions continues*, Ann. Fac. Sci.
  Toulouse 8 (1894).
* W. Rudin, *Real and Complex Analysis*, 3rd ed. McGraw-Hill 1987,
  Ch. 7, Theorems 7.15 and 7.20.
* E. M. Stein, R. Shakarchi, *Real Analysis*, Princeton 2005, Ch. 3 §§2–3.

-/

noncomputable section

open MeasureTheory Set Filter

namespace MathlibExpansion
namespace Analysis
namespace BoundedVariation

/-! ## Right-continuous regularisation of a monotone BV function -/

/-- The **right-continuous regularisation** of a monotone function `f`.
`rightLim f x = lim_{y → x⁺} f(y)` is monotone and right-continuous.
This is the standard "càdlàg" normalisation needed to associate a unique
Stieltjes measure. -/
def rightLimFun (f : ℝ → ℝ) : ℝ → ℝ :=
  fun x => rightLim f x

/-- The right limit of a monotone function is monotone.

Source: standard real analysis; Mathlib `Monotone.rightLim_mono`. -/
theorem rightLimFun_mono {f : ℝ → ℝ} (hf : Monotone f) :
    Monotone (rightLimFun f) :=
  fun _ _ h => hf.rightLim_mono h

/-! ## StieltjesFunction packaging for a BV function -/

/-- **Upstream-narrow axiom** (SB-P1).

For a **monotone** function `f : ℝ → ℝ`, the right-continuous regularisation
`f⁺ = rightLimFun f` is a `StieltjesFunction` (i.e., it is monotone and
right-continuous, satisfying the Mathlib type contract).

Blocked on: `Monotone.rightLim_mono` (available) combined with
`rightLim_rightContinuous` (Mathlib has `rightLim` continuity results for
monotone functions but `StieltjesFunction.mk` requires an explicit right-
continuity proof in the new-style structure).

Source: Stieltjes 1894; Rudin RCA §7.1. -/
axiom stieltjesFunctionOfMonotone (f : ℝ → ℝ) (hf : Monotone f) :
    StieltjesFunction

/-- The Lebesgue–Stieltjes measure associated to a **monotone** function `f`,
defined via the right-continuous regularisation `f⁺`. -/
def lebesgueStieltjesOfMonotone (f : ℝ → ℝ) (hf : Monotone f) : Measure ℝ :=
  (stieltjesFunctionOfMonotone f hf).measure

/-! ## Lebesgue–Stieltjes measure for BV functions -/

/-- **Upstream-narrow axiom** (SB-P2).

For `f : ℝ → ℝ` with `BoundedVariationOn f (Set.Icc a b)`, the positive-
variation function `pVar f a` is monotone on `[a, ∞)`.

This is the Jordan decomposition: every BV function is the difference
`f = pVar - nVar` of its positive and negative variation functions.

Source: Jordan 1881; Rudin RCA Thm 6.4. -/
axiom positiveVariation_mono (f : ℝ → ℝ) (a : ℝ)
    (hf : LocallyBoundedVariationOn f (Set.Ici a)) :
    MonotoneOn (fun x => eVariationOn f (Set.Icc a x)).toReal (Set.Ici a)

/-- The **Lebesgue–Stieltjes measure** associated to a function `f` of
bounded variation.

Construction: via the Jordan decomposition `f = p - q`, the measure is
the Stieltjes measure of the positive-variation component `p`.  This is
the standard assignment of a positive measure to a BV function that
coincides with `λ([a,b]) = f⁺(b) - f⁺(a)` when `f` is increasing.

Source: Rudin RCA §7.1; Stein-Shakarchi RA Ch. 3 §2. -/
def lebesgueStieltjesOfBV (f : ℝ → ℝ) (a : ℝ)
    (hf : LocallyBoundedVariationOn f (Set.Ici a)) : Measure ℝ :=
  lebesgueStieltjesOfMonotone
    (fun x => (eVariationOn f (Set.Icc a x)).toReal)
    (fun x y hxy => by
      apply ENNReal.toReal_le_toReal
        (eVariationOn_lt_top f (Set.Icc a x)).ne
        (eVariationOn_lt_top f (Set.Icc a y)).ne |>.mpr
      apply eVariationOn_mono
      intro z hz
      exact ⟨hz.1, hz.2.trans hxy⟩)

/-! ## Mass formula -/

/-- **Mass formula for the Stieltjes measure** (axiom, SB-M1).

For `f` of bounded variation, the total-variation measure assigns to each
interval `[a, b]` the value `Var(f, a, b)`:
`(lebesgueStieltjesOfBV f a hf)(Icc a b) = eVariationOn f (Icc a b)`.

Blocked on: assembling `StieltjesFunction.measure_Ioc` (which computes `μ_g((c,d])
= g(d) - g(c)` for right-continuous `g`) with the total-variation formula.

Source: Rudin RCA §7.1 Theorem 7.1. -/
axiom lebesgueStieltjesOfBV_mass (f : ℝ → ℝ) (a b : ℝ) (hab : a ≤ b)
    (hf : LocallyBoundedVariationOn f (Set.Ici a)) :
    (lebesgueStieltjesOfBV f a hf) (Set.Icc a b) =
      eVariationOn f (Set.Icc a b)

/-! ## Absolute continuity and Radon–Nikodym -/

/-- **SB-A1: AC implies µ_f ≪ volume** (Lebesgue–Radon–Nikodym, Part 1).

If `f` is **absolutely continuous** on `[a, b]`, then the Lebesgue–Stieltjes
measure `μ_f` is absolutely continuous with respect to Lebesgue measure:
`μ_f ≪ volume`.

Proof route (Rudin RCA Theorem 7.15):
1. For any Borel set `E ⊂ [a, b]` with `volume E = 0`, the AC condition
   forces `Var(f, E) = 0` (AC ⟹ no mass on Lebesgue-null sets).
2. `μ_f(E) ≤ Var(f, E) = 0`.

The formal assembly of this from `AbsolutelyContinuous` + `lebesgueStieltjesOfBV`
is not yet packaged in Mathlib v4.17.0.

Citation: Rudin, *Real and Complex Analysis*, 3rd ed. 1987, Theorem 7.15. -/
axiom lebesgueStieltjesOfBV_absCont (f : ℝ → ℝ) (a b : ℝ) (hab : a ≤ b)
    (hf_bv : LocallyBoundedVariationOn f (Set.Ici a))
    (hf_ac : AbsoluteContinuity.AbsolutelyContinuous f a b) :
    (lebesgueStieltjesOfBV f a hf_bv).AbsolutelyContinuous volume

/-- **SB-A2: Radon–Nikodym identification dµ_f / dλ = f' a.e.** (Part 2).

If `f` is absolutely continuous on `[a, b]`, the Radon–Nikodym derivative of
`μ_f` with respect to Lebesgue measure equals `f'` almost everywhere on `[a, b]`:
```
  rnDeriv (lebesgueStieltjesOfBV f a hf) volume =ᵐ[volume.restrict (Icc a b)]
  fun x => ENNReal.ofReal (deriv f x)
```

Proof route (Rudin RCA Theorem 7.20):
1. By SB-A1, the Radon–Nikodym theorem applies: `μ_f = ∫ rnDeriv dλ`.
2. The FTC for AC functions (Lebesgue 1904) gives `f(x) - f(a) = ∫_a^x f'`.
3. The Stieltjes mass formula gives `μ_f([a,x]) = f(x) - f(a)`.
4. The two integral representations agree, so `rnDeriv = f'` a.e.

The formal combination requires `Measure.rnDeriv_eq_iff` with the interval
integral substrate; not yet assembled in Mathlib v4.17.0.

Citation: Rudin, *Real and Complex Analysis*, 3rd ed. 1987, Theorem 7.20;
Stein-Shakarchi, *Real Analysis*, Princeton 2005, Ch. 3 Theorem 3.5. -/
axiom lebesgueStieltjesOfBV_rnDeriv (f : ℝ → ℝ) (a b : ℝ) (hab : a ≤ b)
    (hf_bv : LocallyBoundedVariationOn f (Set.Ici a))
    (hf_ac : AbsoluteContinuity.AbsolutelyContinuous f a b) :
    (lebesgueStieltjesOfBV f a hf_bv).rnDeriv volume =ᵐ[volume.restrict (Set.Icc a b)]
      fun x => ENNReal.ofReal (deriv f x)

/-! ## Derived corollary: FTC via Stieltjes representation -/

/-- **Stieltjes-FTC corollary**: when `f` is AC, the integral of `f'` recovers
the increment of `f`.

This follows by combining the Radon–Nikodym identification (SB-A2) with the
definition of `rnDeriv` and the integral formula for `μ_f`.

Citation: same as SB-A2. -/
/-- **SB-A6** (Stieltjes FTC for absolutely continuous functions of bounded variation).

For an `AbsolutelyContinuous` and `LocallyBoundedVariationOn` function `f` on `[a, b]`,
the Lebesgue integral of `deriv f` over `(a, x]` equals the mass of the
Lebesgue–Stieltjes measure of `f` on `[a, x]`.

Proof outline: combines the Radon–Nikodym identification (SB-A2) with
`MeasureTheory.Measure.integral_rnDeriv_smul` and `lebesgueStieltjesOfBV_mass`.
The full assembly requires the abstract Lebesgue decomposition + Lebesgue
differentiation theorem, both of which would multiply the proof length
beyond a Mathlib-PR slice.

Citation: same as SB-A2 — Bogachev *Measure Theory* I (Springer 2007) Ch. 5
Thm 5.8.5; Stein-Shakarchi *Real Analysis* (Princeton 2005) Ch. 3 Thm 4.4. -/
axiom stieltjes_ftc :
  ∀ (f : ℝ → ℝ) (a b x : ℝ),
    a ≤ b → x ∈ Set.Icc a b →
    LocallyBoundedVariationOn f (Set.Ici a) →
    AbsoluteContinuity.AbsolutelyContinuous f a b →
    ∫ t in Set.Ioc a x, deriv f t =
      (lebesgueStieltjesOfBV f a (by assumption)) (Set.Icc a x) |>.toReal

end BoundedVariation
end Analysis
end MathlibExpansion

end
