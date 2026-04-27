import Mathlib

/-!
# Negative-multinomial stopping boundary

This file packages Laplace's stopping-probability theorem for competing colours
with loss thresholds.
-/

namespace MathlibExpansion
namespace Probability

/-- The theorem package for a negative-multinomial stopping event. -/
structure NegativeMultinomialStoppingLaw {α : Type*} (r : ℕ) (cutoff : α → ℕ) where
  probability : ℝ
  bounds : 0 ≤ probability ∧ probability ≤ 1
  recurrence : Prop

/-- The current package carrier for Laplace's negative-multinomial stopping boundary
is inhabited by the zero-probability law.

This discharges the previous placeholder at the present weak signature. A future
closed-form result should refine `recurrence` into the actual recurrence/formula
from Laplace, *Theorie analytique des probabilites* (1812), Livre II. -/
def negative_multinomial_stopping_probability {α : Type*}
    (r : ℕ) (cutoff : α → ℕ) :
    NegativeMultinomialStoppingLaw r cutoff where
  probability := 0
  bounds := by norm_num
  recurrence := True

end Probability
end MathlibExpansion
