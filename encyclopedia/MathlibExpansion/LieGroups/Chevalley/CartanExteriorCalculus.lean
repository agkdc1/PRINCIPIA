import Mathlib

/-!
# Cartan exterior calculus and invariant integration

This file records the invariant-integration operator on a group and its basic
left/right invariance identities.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion.LieGroups.Chevalley

section

variable {G : Type*} [Group G] [TopologicalSpace G] [MeasurableSpace G] [BorelSpace G]
variable [MeasurableMul G]
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- The invariant integral functional attached to a measure on a group. -/
def invariantIntegral (μ : Measure G) (f : G → E) : E :=
  ∫ x, f x ∂μ

@[simp] theorem invariantIntegral_eq_integral (μ : Measure G) (f : G → E) :
    invariantIntegral μ f = ∫ x, f x ∂μ :=
  rfl

theorem invariantIntegral_mul_left {μ : Measure G} [Measure.IsMulLeftInvariant μ]
    (f : G → E) (g : G) :
    invariantIntegral μ (fun x => f (g * x)) = invariantIntegral μ f := by
  simpa [invariantIntegral] using
    MeasureTheory.integral_mul_left_eq_self (μ := μ) (f := f) g

theorem invariantIntegral_mul_right {μ : Measure G} [Measure.IsMulRightInvariant μ]
    (f : G → E) (g : G) :
    invariantIntegral μ (fun x => f (x * g)) = invariantIntegral μ f := by
  simpa [invariantIntegral] using
    MeasureTheory.integral_mul_right_eq_self (μ := μ) (f := f) g

end

end MathlibExpansion.LieGroups.Chevalley
