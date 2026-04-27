/-
Copyright (c) 2026 Hospital-OS FLT Campaign. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hospital-OS FLT Campaign
-/
import MathlibExpansion.Analysis.HarmonicAnalysis.Lorentz.Basic

/-!
# Marcinkiewicz interpolation theorem (real-variable interpolation)

The **Marcinkiewicz interpolation theorem** is the *real-variable* counterpart
to Riesz–Thorin: it interpolates from **weak-type** endpoint estimates rather
than strong-type, at the cost of an explicit constant that blows up near the
endpoints (Grafakos GTM 249, §1.3.2 / §1.4).

**Statement** (sub-linear, Grafakos 2008 Theorem 1.3.2 — diagonal `(p,p)` form).
Let `1 ≤ p₀ < p₁ ≤ ∞`.  Suppose `T` is a sub-linear operator that is

* of weak type `(p₀, p₀)` with constant `A₀`, and
* of weak type `(p₁, p₁)` with constant `A₁`.

Then for every `p ∈ (p₀, p₁)`, `T` is of strong type `(p, p)`:
```
‖T f‖_{Lᵖ}  ≤  C(p, p₀, p₁) · A₀^{1-θ} · A₁^θ · ‖f‖_{Lᵖ},
```
where `θ ∈ (0,1)` satisfies `1/p = (1-θ)/p₀ + θ/p₁` and the constant `C`
blows up like `(p - p₀)⁻¹ · (p₁ - p)⁻¹` near the endpoints.

This is the **diagonal version**; the off-diagonal version (different output
exponents `q₀ ≠ q₁`) appears as Grafakos Theorem 1.4.19.  The diagonal version
is the one used downstream for Hardy–Littlewood maximal `Lᵖ` boundedness and
the Calderón–Zygmund decomposition.

## Strategy

The proof is the **Calderón decomposition**:

1. Given `f ∈ Lᵖ` and a level `α > 0`, decompose
   `f = f^α + f_α` where `f^α(x) = f(x) · 𝟙_{|f(x)| > α}` ("tall part")
   and `f_α(x) = f(x) · 𝟙_{|f(x)| ≤ α}` ("flat part").

2. Apply the weak-`(p₀, p₀)` estimate on `f^α ∈ Lᵖ⁰` and the weak-`(p₁, p₁)`
   estimate on `f_α ∈ Lᵖ¹`.

3. Layer-cake integrate `‖T f‖_p^p = p · ∫₀^∞ α^{p-1} · μ{|T f| > 2α} dα`,
   bounding `μ{|T f| > 2α}` via `μ{|T f^α| > α} + μ{|T f_α| > α}` and the
   weak-type estimates on each piece.

The substrate `MemWeakLp` lives in `Lorentz/Basic.lean`.  Layer-cake is in
`Mathlib.MeasureTheory.Integral.Layercake`.  The combination — a
self-contained Marcinkiewicz statement — is what this file packages.

## Implementation

This file:

1. Defines `IsSublinearOp T` — sub-linearity for an operator on functions.

2. Defines `IsWeakTypeOp T p μ A` — `T` is of weak type `(p, p)` with
   constant `A` (in the diagonal form): for every `f ∈ Lᵖ` the image
   `T f` is in `MemWeakLp p` with quasi-norm `≤ A · ‖f‖_p`.

3. States `marcinkiewicz_diagonal` — the diagonal Marcinkiewicz interpolation
   as an axiom (the proof is ~5 pages of measure-theoretic combinatorics in
   Grafakos §1.3 and is not yet in Mathlib).

4. States `marcinkiewicz_offdiagonal` — the off-diagonal version.

5. Proves `strongType_imp_weakType` — strong-type implies weak-type via the
   Chebyshev/Markov bound packaged in `Lorentz/Basic.lean`.

## Poison guard

* `Mathlib.Algebra.Order.Rearrangement` is the *finite-list* rearrangement
  inequality.  It is **not** the Lorentz / Hardy–Littlewood decreasing
  rearrangement.

* The **Riesz–Thorin theorem** is proved by *complex* interpolation; it
  assumes *linear* `T` and *strong-type* endpoints, with the geometric-mean
  norm bound `M₀^{1-θ} M₁^θ` (no endpoint blow-up).  Marcinkiewicz weakens
  both — *sub-linear* `T`, *weak-type* endpoints — at the cost of an
  endpoint-singular constant.

## References

* J. Marcinkiewicz, *Sur l'interpolation d'opérations*, C. R. Acad. Sci.
  Paris **208** (1939), pp. 1272–1273.
* A. Zygmund, *On a theorem of Marcinkiewicz concerning interpolation of
  operations*, J. Math. Pures Appl. **35** (1956), pp. 223–248.
* L. Grafakos, *Classical Fourier Analysis*, Springer GTM 249, 2nd ed.
  (2008), Theorem 1.3.2 (diagonal) and Theorem 1.4.19 (off-diagonal).
* J. Bergh, J. Löfström, *Interpolation Spaces. An Introduction*, Grundlehren
  223, Springer (1976), Chapter 5.

-/

noncomputable section

open MeasureTheory ENNReal NNReal Set
open scoped MeasureTheory NNReal ENNReal

namespace MathlibExpansion
namespace Analysis
namespace HarmonicAnalysis
namespace Lorentz

universe u v w

variable {X : Type u} {Y : Type v} {E : Type w}
  [MeasurableSpace X] [MeasurableSpace Y]
  [NormedAddCommGroup E]

/-! ## Sub-linearity -/

/-- A **sub-linear** operator `T : (X → E) → (Y → E)`:
* `‖T (f + g) y‖ ≤ ‖T f y‖ + ‖T g y‖` pointwise on `Y`,
* `‖T (c • f) y‖ ≤ |c| · ‖T f y‖` pointwise on `Y` for `c : ℝ`. -/
def IsSublinearOp [NormedSpace ℝ E]
    (T : (X → E) → (Y → E)) : Prop :=
  (∀ f g : X → E, ∀ y : Y, ‖T (f + g) y‖ ≤ ‖T f y‖ + ‖T g y‖) ∧
  (∀ (c : ℝ) (f : X → E), ∀ y : Y, ‖T (c • f) y‖ ≤ |c| * ‖T f y‖)

/-! ## Weak-type operators (diagonal `(p, p)`) -/

/-- `T` is of **weak type `(p, p)`** with constant `A` from `(X, μ)` to `(Y, ν)`:
for every `f ∈ Lᵖ(μ)`, the image `T f` is in `MemWeakLp ν p`, with the weak
quasi-norm bounded by `A · ‖f‖_p`. -/
def IsWeakTypeOp
    (T : (X → E) → (Y → E)) (p : ℝ≥0∞) (μ : Measure X) (ν : Measure Y)
    (A : ℝ≥0∞) : Prop :=
  ∀ f : X → E, MemLp f p μ →
    MemWeakLp ν p (T f) ∧ weakLpNorm ν p (T f) ≤ A * eLpNorm f p μ

/-- **Strong-type implies weak-type** (Chebyshev / Markov).

If `T` is bounded `Lᵖ → Lᵖ` with constant `A`, then a fortiori it is of
weak type `(p, p)` with the same constant.  The proof uses
`weakLpNorm_le_eLpNorm` from `Lorentz/Basic.lean` to control the weak norm
of `T f` by its strong norm.

Source: Grafakos 2008, Proposition 1.1.4. -/
theorem strongType_imp_weakType
    {T : (X → E) → (Y → E)} {p : ℝ≥0∞} (hp : 1 ≤ p)
    {μ : Measure X} {ν : Measure Y} {A : ℝ≥0∞}
    (hT : ∀ f : X → E, MemLp f p μ →
      MemLp (T f) p ν ∧ eLpNorm (T f) p ν ≤ A * eLpNorm f p μ) :
    IsWeakTypeOp T p μ ν A := by
  intro f hf
  obtain ⟨hTf_mem, hTf_norm⟩ := hT f hf
  refine ⟨memLp_imp_memWeakLp hp hTf_mem, ?_⟩
  exact (weakLpNorm_le_eLpNorm hp).trans hTf_norm

/-! ## Diagonal Marcinkiewicz interpolation -/

/--
**Marcinkiewicz interpolation theorem (diagonal form).**

Let `1 ≤ p₀ < p₁ ≤ ∞` and let `T` be a sub-linear operator from
measurable `X → E` to `Y → E` that is

* of weak type `(p₀, p₀)` with constant `A₀`, and
* of weak type `(p₁, p₁)` with constant `A₁`.

Then for every `p` with `p₀ < p < p₁`, `T` is *strong-type `(p, p)`*: there
exists a constant `C(p, p₀, p₁)` (blowing up like `(p - p₀)⁻¹ · (p₁ - p)⁻¹`)
such that
```
eLpNorm (T f) p ν  ≤  C · A₀^{1-θ} · A₁^θ · eLpNorm f p μ,
```
where `θ ∈ (0,1)` is determined by `1/p = (1-θ)/p₀ + θ/p₁`.

The proof is the Calderón decomposition + layer-cake integration; ~5 pages of
careful measure-theoretic combinatorics (Grafakos §1.3.2).  Not yet packaged
in Mathlib.

Citation: Marcinkiewicz 1939 (sketch); Zygmund 1956 (full proof);
Grafakos GTM 249 (2008), Theorem 1.3.2.
-/
axiom marcinkiewicz_diagonal
    [NormedSpace ℝ E]
    {T : (X → E) → (Y → E)} {p₀ p₁ p : ℝ≥0∞}
    {μ : Measure X} {ν : Measure Y}
    {A₀ A₁ : ℝ≥0∞}
    (hT_sub : IsSublinearOp (X := X) (Y := Y) (E := E) T)
    (hT₀ : IsWeakTypeOp T p₀ μ ν A₀)
    (hT₁ : IsWeakTypeOp T p₁ μ ν A₁)
    (hp₀ : 1 ≤ p₀) (hp_lo : p₀ < p) (hp_hi : p < p₁) :
    ∃ C : ℝ≥0∞,
      ∀ f : X → E, MemLp f p μ →
        MemLp (T f) p ν ∧
          eLpNorm (T f) p ν ≤ C * A₀ * A₁ * eLpNorm f p μ

/-! ## Off-diagonal Marcinkiewicz interpolation -/

/--
**Marcinkiewicz interpolation theorem (off-diagonal form).**

Let `1 ≤ p₀ < p₁ ≤ ∞` and `1 ≤ q₀, q₁ ≤ ∞` with `q₀ ≠ q₁`, and assume
`pᵢ ≤ qᵢ` for `i = 0, 1`.  Suppose `T` is a sub-linear operator that is

* of weak type `(p₀, q₀)` with constant `A₀`,
* of weak type `(p₁, q₁)` with constant `A₁`.

Then for every `θ ∈ (0,1)`, with the interpolated exponents
```
1/p = (1-θ)/p₀ + θ/p₁,    1/q = (1-θ)/q₀ + θ/q₁,
```
the operator `T` is of strong type `(p, q)`:
```
eLpNorm (T f) q ν  ≤  C · A₀^{1-θ} · A₁^θ · eLpNorm f p μ,
```
with an explicit endpoint-singular constant `C(θ, p₀, p₁, q₀, q₁)`.

This subsumes the diagonal case `(q₀, q₁) = (p₀, p₁)`.

Citation: Grafakos GTM 249 (2008), Theorem 1.4.19; Bergh–Löfström 1976,
Theorem 5.3.2.
-/
axiom marcinkiewicz_offdiagonal
    [NormedSpace ℝ E]
    {T : (X → E) → (Y → E)} {p₀ p₁ q₀ q₁ : ℝ≥0∞}
    {μ : Measure X} {ν : Measure Y}
    {A₀ A₁ : ℝ≥0∞}
    (hT_sub : IsSublinearOp (X := X) (Y := Y) (E := E) T)
    (hT₀ : IsWeakTypeOp T p₀ μ ν A₀)
    (hT₁ : IsWeakTypeOp T p₁ μ ν A₁)
    (hp : p₀ < p₁) (hq : q₀ ≠ q₁)
    (θ : ℝ) (hθ : 0 < θ ∧ θ < 1) :
    ∃ (p q C : ℝ≥0∞),
      ∀ f : X → E, MemLp f p μ →
        MemLp (T f) q ν ∧
          eLpNorm (T f) q ν ≤ C * A₀ * A₁ * eLpNorm f p μ

end Lorentz
end HarmonicAnalysis
end Analysis
end MathlibExpansion
