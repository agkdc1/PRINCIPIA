import Mathlib.MeasureTheory.Integral.FundThmCalculus

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory
namespace FTC

/--
`PRD_02`: bounded exact derivatives give the textbook primitive-recovery
formula on compact intervals. This is the bounded-derivative specialization of
Rudin, *Real and Complex Analysis*, 3rd ed. (1987/2006), Theorem 7.21, as
formalized by Mathlib's `intervalIntegral.integral_deriv_eq_sub`.
-/
theorem primitive_eq_indefIntegral_of_bounded_deriv
    {F : ℝ → ℝ} {a b : ℝ}
    (hdiff : ∀ x ∈ Set.uIcc a b, DifferentiableAt ℝ F x)
    (hbounded : ∃ M, ∀ x ∈ Set.uIcc a b, ‖deriv F x‖ ≤ M) :
    ∀ x ∈ Set.uIcc a b, F x = F a + ∫ y in a..x, deriv F y := by
  rcases hbounded with ⟨M, hM⟩
  have hint : IntegrableOn (deriv F) (Set.uIcc a b) volume := by
    refine volume.integrableOn_of_bounded ?_ (aestronglyMeasurable_deriv F volume) (M := M) ?_
    · simp [Real.volume_interval]
    · filter_upwards [ae_restrict_mem measurableSet_uIcc] with x hx
      exact hM x hx
  intro x hx
  have hdiff_ax : ∀ y ∈ Set.uIcc a x, DifferentiableAt ℝ F y := by
    intro y hy
    exact hdiff y (Set.uIcc_subset_uIcc_left hx hy)
  have hint_ax : IntervalIntegrable (deriv F) volume a x :=
    (hint.mono_set (Set.uIcc_subset_uIcc_left hx)).intervalIntegrable
  have h :=
    intervalIntegral.integral_deriv_eq_sub (f := F) (a := a) (b := x) hdiff_ax hint_ax
  linarith

/--
`PRD_04` sharpened: pointwise derivative data recover the primitive once a
basepoint is fixed. This is the upstream-narrow FTC-2 form of Rudin, *Real and
Complex Analysis*, 3rd ed. (1987/2006), Theorem 7.21, as formalized by
Mathlib's `intervalIntegral.integral_eq_sub_of_hasDerivAt`.

The original continuity plus a.e. derivative identity formulation is not valid
without an absolute-continuity hypothesis; the Cantor function is the standard
counterexample.
-/
theorem primitive_eq_base_add_intervalIntegral_of_hasDerivAt
    {F f : ℝ → ℝ} {a b : ℝ}
    (hderiv : ∀ x ∈ Set.uIcc a b, HasDerivAt F (f x) x)
    (hint : IntervalIntegrable f volume a b) :
    ∀ x ∈ Set.uIcc a b, F x = F a + ∫ y in a..x, f y := by
  intro x hx
  have hderiv_ax : ∀ y ∈ Set.uIcc a x, HasDerivAt F (f y) y := by
    intro y hy
    exact hderiv y (Set.uIcc_subset_uIcc_left hx hy)
  have hint_ax : IntervalIntegrable f volume a x :=
    hint.mono_set (Set.uIcc_subset_uIcc_left hx)
  have h :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt (f := F) (f' := f)
      (a := a) (b := x) hderiv_ax hint_ax
  linarith

end FTC
end MeasureTheory
end MathlibExpansion
