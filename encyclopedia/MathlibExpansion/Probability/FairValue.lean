import Mathlib

/-!
# Fair value of a finite gamble

This is the clean B1 repair for Laplace's expectation-as-fair-value theorem.
-/

namespace MathlibExpansion
namespace Probability

open MeasureTheory

/-- The fair value of a finite gamble is its expectation under the underlying PMF. -/
noncomputable def fairValue {α : Type*} [MeasurableSpace α] [MeasurableSingletonClass α]
    (p : PMF α) (X : α → ℝ) : ℝ :=
  ∫ a, X a ∂p.toMeasure

theorem fairValue_eq_sum {α : Type*} [Fintype α] [MeasurableSpace α] [MeasurableSingletonClass α]
    (p : PMF α) (X : α → ℝ) :
    fairValue p X = ∑ a, (p a).toReal * X a := by
  simp [fairValue, PMF.integral_eq_sum, smul_eq_mul]

theorem expectedValue_eq_fair_price
    {α : Type*} [Fintype α] [MeasurableSpace α] [MeasurableSingletonClass α]
    (p : PMF α) (X : α → ℝ) :
    ∫ a, X a ∂p.toMeasure = ∑ a, (p a).toReal * X a := by
  simpa [fairValue] using fairValue_eq_sum p X

end Probability
end MathlibExpansion
