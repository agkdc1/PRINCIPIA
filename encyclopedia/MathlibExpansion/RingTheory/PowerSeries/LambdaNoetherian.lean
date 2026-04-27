import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.RingTheory.Noetherian.Basic
import Mathlib.RingTheory.PowerSeries.Inverse

/-!
# Noetherianity of `ℤ_[p]⟦X⟧`

This file closes the C4a boundary for the one-variable Iwasawa algebra
`Λ = ℤ_[p][[T]]`, represented in Lean as `PowerSeries ℤ_[p]`.

Mathlib `v4.17.0` provides `IsNoetherianRing k⟦X⟧` only in the field case.
The missing kernel-adjacent fact needed here is ideal-by-ideal finite
generation over `ℤ_[p]⟦X⟧`.

## Direction-over-count classification

`powerSeriesPadicInt_ideal_fg` is a narrow upstream axiom. It is smaller than
axiomatizing `IsNoetherianRing (PowerSeries ℤ_[p])` directly because it exposes
the ideal-level witness consumed by `isNoetherianRing_iff_ideal_fg`.

A future discharge should replace this with either:

- a generic theorem `[IsNoetherianRing R] -> IsNoetherianRing (PowerSeries R)`,
  or
- a specialized proof from Weierstrass preparation / division over `ℤ_[p]`.
-/

open scoped Padic

namespace MathlibExpansion
namespace RingTheory
namespace PowerSeries

/-- Narrow upstream boundary for C4a: every ideal of `ℤ_[p]⟦X⟧` is finitely generated.

Citation / exact discharge target: The Stacks Project, Algebra, Lemma 10.31.2
(Tag 00FM), the formal-power-series Hilbert basis theorem saying that
`R[[x_1, ..., x_n]]` is Noetherian when `R` is Noetherian.  Specialize that
lemma to the already-available Mathlib instance `IsNoetherianRing ℤ_[p]` and
one formal variable.

Lean gap: Mathlib v4.17.0 exposes the field case
`IsNoetherianRing k⟦X⟧`, but not the generic Noetherian-coefficient theorem
for `PowerSeries R`. -/
axiom powerSeriesPadicInt_ideal_fg (p : ℕ) [Fact p.Prime]
    (I : Ideal (_root_.PowerSeries ℤ_[p])) : I.FG

/-- The Iwasawa algebra `Λ = ℤ_[p]⟦X⟧` is Noetherian. -/
theorem lambda_powerSeries_isNoetherian (p : ℕ) [Fact p.Prime] :
    IsNoetherianRing (_root_.PowerSeries ℤ_[p]) :=
  (isNoetherianRing_iff_ideal_fg (_root_.PowerSeries ℤ_[p])).2
    (fun I => powerSeriesPadicInt_ideal_fg p I)

instance instIsNoetherianRingPowerSeriesPadicInt (p : ℕ) [Fact p.Prime] :
    IsNoetherianRing (_root_.PowerSeries ℤ_[p]) :=
  lambda_powerSeries_isNoetherian p

end PowerSeries
end RingTheory
end MathlibExpansion
