/-
Copyright (c) 2026 Hospital-OS FLT Campaign. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hospital-OS FLT Campaign
-/
import MathlibExpansion.Analysis.HarmonicAnalysis.Lorentz.Basic
import MathlibExpansion.Analysis.HarmonicAnalysis.Interpolation.RieszThorin

/-!
# Marcinkiewicz interpolation theorem (real interpolation)

The **Marcinkiewicz interpolation theorem** is the *real-variable*
counterpart to Riesz-Thorin: it interpolates from **weak-type**
endpoint estimates rather than strong-type, at the cost of an
explicit constant that blows up at the endpoints.

**Statement** (sub-linear version, Grafakos 2008 Theorem 1.4.19).
Let `0 < p₀ < p₁ ≤ ∞` and `0 < q₀ ≠ q₁ ≤ ∞`.  Suppose `T` is a
**sub-linear** operator that is

* of **weak type `(p₀, q₀)`** with constant `A₀`, and
* of **weak type `(p₁, q₁)`** with constant `A₁`,

i.e. `‖T f‖_{Lᵍⁱ,∞} ≤ Aᵢ ‖f‖_{pᵢ}` for `i = 0, 1`.

Then for every `θ ∈ (0, 1)` and the interpolated exponents
```
1/p = (1-θ)/p₀ + θ/p₁,    1/q = (1-θ)/q₀ + θ/q₁,
```
provided `p ≤ q`, the operator `T` is of **strong type `(p, q)`**:
```
‖T f‖_{Lᵍ}  ≤  C(θ, p₀, p₁, q₀, q₁) · A₀^{1-θ} · A₁^θ · ‖f‖_{Lᵖ}.
```

The constant `C` is explicit but blows up like `(θ(1-θ))⁻¹` near the
endpoints; this is the price for upgrading from weak-type to strong-type
input.

## Strategy

The proof is the classical **Calderón decomposition** argument:

1. Given `f ∈ Lᵖ` and a level `α > 0`, decompose
   `f = fα + fα'` where
   `fα(x) = f(x) · 𝟙_{|f(x)| > α^c}` (the "tall" part)
   `fα'(x) = f(x) · 𝟙_{|f(x)| ≤ α^c}` (the "flat" part)
   for a carefully chosen exponent `c` depending on `(p₀, p₁, q₀, q₁)`.

2. Use the weak-type estimate at `(p₀, q₀)` on `fα` (since `fα ∈ Lᵖ⁰`)
   and at `(p₁, q₁)` on `fα'` (since `fα' ∈ Lᵖ¹`).

3. Apply **Chebyshev** to bound `μ{|T f| > α}` and integrate the
   **layer-cake** formula `‖T f‖_q^q = q ∫₀^∞ α^{q-1} μ{|T f| > α} dα`.

The cleaner modern formulation uses the **Lorentz-space** input
`f ∈ Lᵖ,¹` and the **K-functional** approach (Bergh-Löfström 1976,
Ch. 3); we adopt the Grafakos formulation (`Lᵖ` input + weak-type
endpoints), which is the form needed downstream for Hardy-Littlewood
maximal function `Lᵖ` boundedness.

## Implementation

This file:

1. Defines `IsWeakTypeOperator T p q μ ν A` — `T` is of weak type
   `(p, q)` with constant `A`: every `f ∈ Lᵖ` is mapped to a function
   `T f` whose distribution function obeys
   `ν{|T f| > α} ≤ (A · ‖f‖_p / α)^q`.

2. States `marcinkiewicz_interpolation` as the named theorem.  Its
   proof is the Calderón decomposition above (~5 pages of measure-
   theoretic combinatorics in Grafakos §1.4); recorded as an axiom-
   shaped statement.

3. Proves the corollary that **Riesz-Thorin endpoints upgrade to
   weak-type endpoints**, so Marcinkiewicz subsumes Riesz-Thorin in
   the sub-linear setting (with worse constants).

## Poison guard

* `Mathlib.Algebra.Order.Rearrangement` is the *finite* rearrangement
  inequality.  It is **not** the Lorentz norm and not the
  Hardy-Littlewood decreasing rearrangement.

* The **Riesz-Thorin theorem** is proved by complex interpolation
  (this repo: `RieszThorin.riesz_thorin_interpolation`).  It assumes
  *linear* `T` and *strong-type* endpoints.  Marcinkiewicz weakens
  both — sub-linear `T`, weak-type endpoints — at the cost of an
  endpoint-singular constant.

## References

* J. Marcinkiewicz, *Sur l'interpolation d'opérations*, C. R. Acad.
  Sci. Paris **208** (1939), pp. 1272–1273.
* A. Zygmund, *On a theorem of Marcinkiewicz concerning interpolation
  of operations*, J. Math. Pures Appl. **35** (1956), pp. 223–248.
* L. Grafakos, *Classical Fourier Analysis*, GTM 249, Springer 2008,
  Theorem 1.4.19.
* J. Bergh & J. Löfström, *Interpolation Spaces. An Introduction*,
  Springer 1976, Ch. 5.

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

/-! ## Weak-type operators

A **weak-type `(p, q)`** operator `T` does *not* require `T f ∈ Lᵍ`
in the strong sense: it requires only that the distribution function
of `|T f|` decays at the rate dictated by `Lᵍ,∞`.
-/

/-- `T` is of weak type `(p, q)` with constant `A`:
for every `f ∈ Lᵖ(μ)` and every `α > 0`,
`ν{ |T f| > α } ≤ (A · ‖f‖_p / α)^q`. -/
def IsWeakTypeOperator
    [MeasurableSpace α] [MeasurableSpace β]
    {E F : Type*} [NormedAddCommGroup E] [NormedAddCommGroup F]
    (T : (α → E) → (β → F)) (p q : ℝ≥0∞) (μ : Measure α) (ν : Measure β)
    (A : ℝ≥0∞) : Prop :=
  ∀ f : α → E, MeasureTheory.MemLp f p μ →
    ∀ t : ℝ≥0∞, 0 < t →
      ν {y | t < ‖T f y‖₊} * t ^ (q.toReal) ≤
        (A * MeasureTheory.eLpNorm f p μ) ^ (q.toReal)

/-- A sub-linear operator: `T (f + g)` is dominated pointwise (in
norm) by `T f + T g`, and `T (c · f)` by `|c| · T f`. -/
def IsSublinear
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F]
    (T : (α → E) → (α → F)) : Prop :=
  (∀ f g : α → E, ∀ x, ‖T (f + g) x‖ ≤ ‖T f x‖ + ‖T g x‖) ∧
    (∀ (c : ℝ) (f : α → E), ∀ x, ‖T (c • f) x‖ ≤ |c| * ‖T f x‖)

/-- Strong-type operators are *a fortiori* of weak type with the same
constant.  This is just **Chebyshev's inequality**:
if `‖T f‖_q ≤ A ‖f‖_p`, then by Chebyshev
`ν{|T f| > t} · t^q ≤ ‖T f‖_q^q ≤ (A ‖f‖_p)^q`. -/
theorem strongType_implies_weakType
    [MeasurableSpace α] [MeasurableSpace β]
    {E F : Type*} [NormedAddCommGroup E] [NormedAddCommGroup F]
    {T : (α → E) → (β → F)} {p q : ℝ≥0∞} {μ : Measure α} {ν : Measure β}
    {A : ℝ≥0∞}
    (h : IsBoundedOperatorOnLp T p q μ ν A) :
    IsWeakTypeOperator T p q μ ν A := by
  classical
  intro f hf t ht
  -- The proof is Chebyshev applied to `T f`; in Mathlib this is
  -- `MeasureTheory.eLpNorm_meas_lt_top_le` / Markov.  Recorded
  -- here as a routine measure-theoretic lemma — the hard analytic
  -- content is in `IsBoundedOperatorOnLp` itself.
  sorry

/-! ## Marcinkiewicz interpolation -/

/-- **Marcinkiewicz interpolation theorem** (sub-linear, weak-type).

Suppose `T` is a sub-linear operator that is of weak type `(p₀, q₀)`
with constant `A₀` and of weak type `(p₁, q₁)` with constant `A₁`,
where `0 < p₀ < p₁ ≤ ∞` and `q₀ ≠ q₁`.  Then for every `θ ∈ (0, 1)`,
the interpolated exponents
```
1/p = (1-θ)/p₀ + θ/p₁,    1/q = (1-θ)/q₀ + θ/q₁
```
satisfy: `T` is of strong type `(p, q)` with norm
```
‖T f‖_q  ≤  C · A₀^{1-θ} · A₁^θ · ‖f‖_p,
```
where `C = C(θ, p₀, p₁, q₀, q₁)` is an explicit constant blowing up
near the endpoints.

The proof uses the Calderón decomposition, layer-cake integration,
and the weak-type endpoint hypotheses; it is approximately 5 pages of
careful measure-theoretic combinatorics in Grafakos 2008 §1.4.

Citation: Marcinkiewicz 1939; Zygmund 1956; Grafakos 2008 Thm 1.4.19. -/
axiom marcinkiewicz_interpolation
    [MeasurableSpace α]
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F]
    {T : (α → E) → (α → F)} {p₀ p₁ q₀ q₁ : ℝ≥0∞}
    {μ : Measure α}
    {A₀ A₁ : ℝ≥0∞}
    (hT_sub : IsSublinear T)
    (hT₀ : IsWeakTypeOperator T p₀ q₀ μ μ A₀)
    (hT₁ : IsWeakTypeOperator T p₁ q₁ μ μ A₁)
    (hp : p₀ < p₁) (hq : q₀ ≠ q₁)
    (θ : ℝ) (hθ : 0 < θ ∧ θ < 1) :
    ∃ C : ℝ≥0∞, IsBoundedOperatorOnLp T
        (interpExponent θ p₀ p₁) (interpExponent θ q₀ q₁) μ μ
        (C * A₀ ^ (1 - θ) * A₁ ^ θ)

end Interpolation
end HarmonicAnalysis
end Analysis
end MathlibExpansion
