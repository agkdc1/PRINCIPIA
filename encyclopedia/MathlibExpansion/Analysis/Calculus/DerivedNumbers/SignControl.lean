import Mathlib.Data.Real.Basic

import Mathlib.Analysis.Calculus.LocalExtr.Rolle
import Mathlib.Topology.Order.LeftRight
import MathlibExpansion.Analysis.Calculus.DerivedNumbers

noncomputable section

open Filter Set
open scoped Topology

namespace MathlibExpansion
namespace Analysis
namespace Calculus
namespace DerivedNumbers

/--
`DNB_04` / `DNB_02` upstream Dini mean-value boundary for right lower derived
numbers.

Citation: Henri Lebesgue, *Leçons sur l'intégration et la recherche des
fonctions primitives* (1904), Ch. V, § II, pp. 70-72, unnumbered
mean-value/Rolle theorem for derived numbers following the sign-control
discussion on pp. 68-69.
-/
axiom exists_lowerRightDerived_lt_of_secantSlope_lt {f : ℝ → ℝ} {a b r : ℝ}
    (hab : a < b) (hcont : ContinuousOn f (Set.Icc a b))
    (hr : slope f a b < r) :
    ∃ c ∈ Set.Ioo a b, lowerRightDerived f c < (r : EReal)

/--
`DNB_02`: nonnegative lower right derived numbers force monotonicity.

Citation: Henri Lebesgue, *Leçons sur l'intégration et la recherche des
fonctions primitives* (1904), Ch. V, § II, pp. 68-69, unnumbered
sign-control theorem for derived numbers.  The proof here reduces the
sign-control statement to the narrower Dini mean-value boundary
`exists_lowerRightDerived_lt_of_secantSlope_lt`.
-/
theorem monotoneOn_of_nonneg_lowerRightDerived {f : ℝ → ℝ} {a b : ℝ}
    (hcont : ContinuousOn f (Set.Icc a b))
    (hD : ∀ x ∈ Set.Icc a b, 0 ≤ lowerRightDerived f x) :
    MonotoneOn f (Set.Icc a b) := by
  intro x hx y hy hxy
  by_cases h_eq : x = y
  · subst y
    rfl
  have hlt : x < y := lt_of_le_of_ne hxy h_eq
  by_contra hnot
  have hfy : f y < f x := lt_of_not_ge hnot
  have hslope : slope f x y < 0 := by
    rw [slope_def_field]
    exact div_neg_of_neg_of_pos (sub_neg.mpr hfy) (sub_pos.mpr hlt)
  have hcontxy : ContinuousOn f (Set.Icc x y) :=
    hcont.mono fun z hz => ⟨hx.1.trans hz.1, hz.2.trans hy.2⟩
  rcases exists_lowerRightDerived_lt_of_secantSlope_lt hlt hcontxy hslope with
    ⟨c, hc, hcD⟩
  have hcIcc : c ∈ Set.Icc a b := ⟨hx.1.trans hc.1.le, hc.2.le.trans hy.2⟩
  exact not_lt_of_ge (hD c hcIcc) hcD

/--
If the left secant slopes are eventually nonpositive and the right secant
slopes are eventually nonnegative, then the base point is a local minimum.
This is the slope-level form that the non-strict one-point derived-number
statement was trying to use.
-/
theorem isLocalMin_of_eventually_leftRightSlope_sign {f : ℝ → ℝ} {x : ℝ}
    (hleft : ∀ᶠ z in 𝓝[<] x, slope f x z ≤ 0)
    (hright : ∀ᶠ z in 𝓝[>] x, 0 ≤ slope f x z) :
    IsLocalMin f x := by
  have hleftValue : ∀ᶠ z in 𝓝[<] x, f x ≤ f z := by
    filter_upwards [hleft, self_mem_nhdsWithin] with z hz hzlt
    have hzx : z - x ≤ 0 := sub_nonpos.mpr hzlt.le
    have hprod : 0 ≤ (z - x) * slope f x z :=
      mul_nonneg_of_nonpos_of_nonpos hzx hz
    have hslope_id : (z - x) * slope f x z = f z - f x := by
      simpa [smul_eq_mul, vsub_eq_sub] using sub_smul_slope f x z
    exact sub_nonneg.mp (by simpa [hslope_id] using hprod)
  have hrightValue : ∀ᶠ z in 𝓝[>] x, f x ≤ f z := by
    filter_upwards [hright, self_mem_nhdsWithin] with z hz hxlt
    have hxz : 0 ≤ z - x := sub_nonneg.mpr hxlt.le
    have hprod : 0 ≤ (z - x) * slope f x z := mul_nonneg hxz hz
    have hslope_id : (z - x) * slope f x z = f z - f x := by
      simpa [smul_eq_mul, vsub_eq_sub] using sub_smul_slope f x z
    exact sub_nonneg.mp (by simpa [hslope_id] using hprod)
  have hpunc : ∀ᶠ z in 𝓝[≠] x, f x ≤ f z := by
    rw [punctured_nhds_eq_nhdsWithin_sup_nhdsWithin]
    exact eventually_sup.mpr ⟨hleftValue, hrightValue⟩
  have hpoint : ∀ᶠ z in pure x, f x ≤ f z := by
    simp
  simpa [IsLocalMin, IsMinFilter, nhdsWithin_compl_singleton_sup_pure] using
    (eventually_sup.mpr ⟨hpunc, hpoint⟩)

/--
Strict opposite-sign one-sided derived data force a local minimum.

This is the valid derived-number version available from the current
limsup/liminf API. The former non-strict statement is intentionally not retained:
non-strict pointwise Dini signs do not by themselves force neighboring values
to lie above `f x`.
-/
theorem isLocalMin_of_strict_leftRightDerived_sign {f : ℝ → ℝ} {x : ℝ}
    (hleft : upperLeftDerived f x < 0) (hright : 0 < lowerRightDerived f x) :
    IsLocalMin f x := by
  refine isLocalMin_of_eventually_leftRightSlope_sign ?_ ?_
  · have h :=
      eventually_lt_of_limsup_lt
        (f := 𝓝[<] x) (u := fun z : ℝ => erealSlope f x z) hleft
    filter_upwards [h] with z hz
    exact le_of_lt (EReal.coe_lt_coe_iff.mp hz)
  · have h :=
      eventually_lt_of_lt_liminf
        (f := 𝓝[>] x) (u := fun z : ℝ => erealSlope f x z) hright
    filter_upwards [h] with z hz
    exact le_of_lt (EReal.coe_lt_coe_iff.mp hz)

end DerivedNumbers
end Calculus
end Analysis
end MathlibExpansion
