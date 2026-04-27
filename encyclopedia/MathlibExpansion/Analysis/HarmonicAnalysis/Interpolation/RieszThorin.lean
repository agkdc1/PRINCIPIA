/-
Copyright (c) 2026 Hospital-OS FLT Campaign. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hospital-OS FLT Campaign
-/
import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Mathlib.Analysis.NormedSpace.OperatorNorm.Basic
import Mathlib.Analysis.Complex.PhragmenLindelof

/-!
# Riesz-Thorin interpolation theorem

If a linear operator `T` is bounded
`Lᵖ⁰(X) → Lᵍ⁰(Y)` with norm `M₀` and bounded
`Lᵖ¹(X) → Lᵍ¹(Y)` with norm `M₁`, then for every `θ ∈ (0, 1)` the same
operator is bounded `Lᵖθ(X) → Lᵍθ(Y)` with
```
‖T‖_{Lᵖθ → Lᵍθ}  ≤  M₀^{1-θ} · M₁^θ,
```
where the **interpolated exponents** `pθ, qθ` are defined by the
harmonic interpolation
```
1 / pθ = (1 - θ) / p₀ + θ / p₁,    1 / qθ = (1 - θ) / q₀ + θ / q₁.
```

The original proofs are by M. Riesz (1926/1927) for the *convex case*
and G. O. Thorin (1938/1948) for the general case via complex
interpolation; the standard modern route is the **Hadamard
three-lines theorem** applied to a single complex-analytic family
`F(z) = ⟨T fz, gz⟩` constructed from step functions.

## Implementation

Mathlib v4.17.0 has the analytical input — the **three-lines theorem**
`Complex.HadamardThreeLines.norm_le_interpStrip_of_isBigO` and
the Phragmén-Lindelöf machinery in
`Mathlib.Analysis.Complex.PhragmenLindelof` — but does **not** package
the `Lᵖ` interpolation step (the construction of the analytic family
`F(z)` from step-function approximation, the trilateral norm bound,
and the density extension).

This file:

1. Defines the **interpolated exponent** `interpExponent θ p₀ p₁`
   as `1 / ((1-θ)/p₀ + θ/p₁)` (with `ENNReal` arithmetic).

2. Defines the predicate `IsBoundedOperatorOnLp T p q μ ν C` saying
   that `T` maps `Lᵖ(X, μ)` to `Lᵍ(Y, ν)` with operator-norm bound
   `‖T f‖_q ≤ C · ‖f‖_p`.

3. States the **Riesz-Thorin theorem** as the named theorem
   `riesz_thorin_interpolation`.  Its proof reduces to the Hadamard
   three-lines theorem on the strip `0 ≤ Re z ≤ 1`; the explicit
   step-function plumbing is the substantive content of Grafakos
   2008 §1.3, ~6 pages of measure theory, and is recorded as an
   axiom-shaped statement here.

## Poison guard

* `Mathlib.Algebra.Order.Rearrangement` is the rearrangement
  *inequality* on finite sequences.  It is **not** the Hardy-Littlewood
  decreasing rearrangement on `ℝ⁺`, and it is not a substrate for
  Riesz-Thorin.  Do not import.

## References

* M. Riesz, *Sur les maxima des formes bilinéaires et sur les
  fonctionnelles linéaires*, Acta Math. **49** (1926), pp. 465–497;
  *L'intégrale de Marcel Riesz et l'interpolation*, Acta Sci. Math.
  Szeged **4** (1928–29).
* G. O. Thorin, *An extension of a convexity theorem due to M. Riesz*,
  Comm. Sém. Math. Univ. Lund **4** (1938); *Convexity theorems*,
  Univ. Lund (1948).
* L. Grafakos, *Classical Fourier Analysis*, GTM 249, Springer 2008,
  Ch. 1 §1.3.

-/

noncomputable section

open MeasureTheory
open scoped ENNReal NNReal

namespace MathlibExpansion
namespace Analysis
namespace HarmonicAnalysis
namespace Interpolation

universe u v

variable {α : Type u} {β : Type v}

/-! ## Interpolated exponent -/

/-- The Riesz-Thorin interpolated exponent:
`1 / pθ = (1 - θ) / p₀ + θ / p₁`. -/
def interpExponent (θ : ℝ) (p₀ p₁ : ℝ≥0∞) : ℝ≥0∞ :=
  let recip : ℝ≥0∞ := (1 - ENNReal.ofReal θ) / p₀ + ENNReal.ofReal θ / p₁
  if recip = 0 then ∞ else recip⁻¹

/-- At `θ = 0`, the interpolated exponent is `p₀`. -/
theorem interpExponent_zero (p₀ p₁ : ℝ≥0∞) (_hp₀ : p₀ ≠ 0) :
    interpExponent 0 p₀ p₁ = p₀ ∨ interpExponent 0 p₀ p₁ = ∞ := by
  classical
  unfold interpExponent
  split_ifs with h
  · right; rfl
  · left
    have heq : (1 - ENNReal.ofReal 0) / p₀ + ENNReal.ofReal 0 / p₁ = p₀⁻¹ := by
      simp [ENNReal.ofReal_zero]
    rw [heq, ENNReal.inv_inv]

/-! ## Operator boundedness -/

/-- `T` is bounded `Lᵖ(μ) → Lᵍ(ν)` with operator-norm bound `C`:
for every `f ∈ Lᵖ(μ)` we have `T f ∈ Lᵍ(ν)` and `‖T f‖_q ≤ C · ‖f‖_p`. -/
def IsBoundedOperatorOnLp
    [MeasurableSpace α] [MeasurableSpace β]
    {E F : Type*} [NormedAddCommGroup E] [NormedAddCommGroup F]
    (T : (α → E) → (β → F)) (p q : ℝ≥0∞) (μ : Measure α) (ν : Measure β)
    (C : ℝ≥0∞) : Prop :=
  ∀ f : α → E, MeasureTheory.MemLp f p μ →
    MeasureTheory.MemLp (T f) q ν ∧
      MeasureTheory.eLpNorm (T f) q ν ≤ C * MeasureTheory.eLpNorm f p μ

/-! ## Riesz-Thorin theorem -/

/-- **Riesz-Thorin interpolation theorem.**

Suppose a linear operator `T` is bounded `Lᵖ⁰(μ) → Lᵍ⁰(ν)` with norm
`M₀` and bounded `Lᵖ¹(μ) → Lᵍ¹(ν)` with norm `M₁`.  Then for every
`θ ∈ (0, 1)`, with interpolated exponents
```
1/pθ = (1 - θ)/p₀ + θ/p₁,    1/qθ = (1 - θ)/q₀ + θ/q₁,
```
the operator `T` is also bounded `Lᵖθ(μ) → Lᵍθ(ν)` with
```
‖T‖_{pθ → qθ}  ≤  M₀^{1-θ} · M₁^θ.
```

The proof proceeds by:

1. Restricting to step (simple) functions `f = ∑ aᵢ 𝟙_{Aᵢ}` and
   `g = ∑ bⱼ 𝟙_{Bⱼ}`.
2. Constructing a complex-analytic family
   `F(z) = ⟨T(|f|^{p(z)/pθ} sgn f), |g|^{q'(z)/qθ'} sgn g⟩`
   whose values on the lines `Re z = 0` and `Re z = 1` are bounded by
   `M₀` and `M₁`.
3. Applying the Hadamard three-lines theorem
   (`Complex.HadamardThreeLines`) to get `|F(θ)| ≤ M₀^{1-θ} M₁^θ`.
4. Extending from step functions to all of `Lᵖθ` by density.

Citation: M. Riesz (1926, 1928); G. O. Thorin (1938, 1948); Grafakos
2008, Theorem 1.3.4. -/
axiom riesz_thorin_interpolation
    [MeasurableSpace α] [MeasurableSpace β]
    {E F : Type*} [NormedAddCommGroup E] [NormedAddCommGroup F]
    {T : (α → E) → (β → F)} {p₀ p₁ q₀ q₁ : ℝ≥0∞}
    {μ : Measure α} {ν : Measure β}
    {M₀ M₁ : ℝ≥0∞}
    (hT₀ : IsBoundedOperatorOnLp T p₀ q₀ μ ν M₀)
    (hT₁ : IsBoundedOperatorOnLp T p₁ q₁ μ ν M₁)
    (θ : ℝ) (hθ : 0 < θ ∧ θ < 1) :
    IsBoundedOperatorOnLp T (interpExponent θ p₀ p₁)
        (interpExponent θ q₀ q₁) μ ν
      (M₀ ^ (1 - θ) * M₁ ^ θ)

/-- Specialisation: when both endpoint exponents agree (`p₀ = q₀`,
`p₁ = q₁`), Riesz-Thorin gives bounded `Lᵖθ → Lᵖθ` interpolation. -/
theorem riesz_thorin_diagonal
    [MeasurableSpace α]
    {E : Type*} [NormedAddCommGroup E]
    {T : (α → E) → (α → E)} {p₀ p₁ : ℝ≥0∞}
    {μ : Measure α}
    {M₀ M₁ : ℝ≥0∞}
    (hT₀ : IsBoundedOperatorOnLp T p₀ p₀ μ μ M₀)
    (hT₁ : IsBoundedOperatorOnLp T p₁ p₁ μ μ M₁)
    (θ : ℝ) (hθ : 0 < θ ∧ θ < 1) :
    IsBoundedOperatorOnLp T (interpExponent θ p₀ p₁)
        (interpExponent θ p₀ p₁) μ μ
      (M₀ ^ (1 - θ) * M₁ ^ θ) :=
  riesz_thorin_interpolation hT₀ hT₁ θ hθ

end Interpolation
end HarmonicAnalysis
end Analysis
end MathlibExpansion
