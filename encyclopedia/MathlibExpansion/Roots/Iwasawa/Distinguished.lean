import MathlibExpansion.Roots.Iwasawa.Basic
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.RingTheory.LocalRing.Basic

/-!
# Distinguished polynomials over ℤ_p

A **distinguished polynomial** of degree `d` over `ℤ_p` is a monic polynomial
of degree `d` whose lower coefficients (at degree `< d`) all lie in `pℤ_p`.

These are the "tame" factors produced by the Weierstrass preparation theorem:
every nonzero `f ∈ ℤ_p[[T]]` factors (uniquely up to units) as `u · p^μ · D`.

## Blindspot B fix (degree_pos)

A degree-0 distinguished polynomial satisfies all conditions vacuously and
equals `1` (a unit).  Then `cyclicQuotient Λ 1 = 0`, silently dropping that
summand.  The `degree_pos` field prevents this: every `DistinguishedPolynomial`
has `natDegree ≥ 1`.

## No `carrier` field

`toPowerSeries` is a function, not a stored field.  Storing `carrier : PowerSeries ℤ_p`
alongside `poly` enables `⟨D, 0⟩` laundering where `carrier` is unrelated to
`poly`.  This is the exact poison pattern killed in the W9-R10 breach.

Ref: Washington, *Introduction to Cyclotomic Fields*, Thm 7.3.
-/

namespace MathlibExpansion
namespace Roots
namespace Iwasawa

open scoped Padic

/-- A distinguished polynomial over `ℤ_p`. -/
structure DistinguishedPolynomial (p : ℕ) [Fact p.Prime] where
  poly : Polynomial ℤ_[p]
  monic : poly.Monic
  lower_mem_maximal : ∀ i < poly.natDegree, poly.coeff i ∈ IsLocalRing.maximalIdeal ℤ_[p]
  degree_pos : 0 < poly.natDegree

namespace DistinguishedPolynomial

variable {p : ℕ} [Fact p.Prime]

@[simp] abbrev natDegree (D : DistinguishedPolynomial p) : ℕ := D.poly.natDegree

theorem natDegree_pos (D : DistinguishedPolynomial p) : 0 < D.natDegree := D.degree_pos

theorem leadingCoeff_eq_one (D : DistinguishedPolynomial p) : D.poly.leadingCoeff = 1 :=
  D.monic.leadingCoeff

theorem poly_ne_zero (D : DistinguishedPolynomial p) : D.poly ≠ 0 := D.monic.ne_zero

/-- Coercion to `PowerSeries ℤ_[p]` via coefficient extraction.

Implemented as a function, not a stored field — see module docstring. -/
noncomputable def toPowerSeries (D : DistinguishedPolynomial p) : PowerSeries ℤ_[p] :=
  PowerSeries.mk (fun n => D.poly.coeff n)

theorem toPowerSeries_coeff (D : DistinguishedPolynomial p) (n : ℕ) :
    PowerSeries.coeff ℤ_[p] n D.toPowerSeries = D.poly.coeff n := by
  simp [toPowerSeries, PowerSeries.coeff_mk]

theorem toPowerSeries_ne_zero (D : DistinguishedPolynomial p) : D.toPowerSeries ≠ 0 := by
  intro heq
  have hcoeff : D.poly.coeff D.poly.natDegree = 0 := by
    have h1 := toPowerSeries_coeff D D.poly.natDegree
    rw [heq, map_zero] at h1
    exact h1.symm
  have hm : D.poly.leadingCoeff = 1 := D.monic.leadingCoeff
  simp only [Polynomial.leadingCoeff, hcoeff, zero_ne_one] at hm

/-- Two distinguished polynomials are equal iff their underlying polynomials are equal. -/
theorem ext {D₁ D₂ : DistinguishedPolynomial p} (h : D₁.poly = D₂.poly) : D₁ = D₂ := by
  cases D₁; cases D₂; simp_all

/-- `toPowerSeries` is injective. -/
theorem toPowerSeries_injective :
    Function.Injective (toPowerSeries (p := p)) := by
  intro D₁ D₂ h
  apply ext; ext n
  have h1 := toPowerSeries_coeff D₁ n
  have h2 := toPowerSeries_coeff D₂ n
  rw [h] at h1
  exact h1.symm.trans h2

end DistinguishedPolynomial

end Iwasawa
end Roots
end MathlibExpansion
