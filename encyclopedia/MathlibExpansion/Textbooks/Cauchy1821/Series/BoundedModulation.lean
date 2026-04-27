import Mathlib

/-!
# Bounded modulation of absolutely convergent series

This module records the textbook-facing fact that bounded real coefficients do
not destroy convergence of an absolutely convergent real series.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Cauchy1821
namespace Series

/-- Multiplying an absolutely convergent real series by coefficients bounded in
absolute value by `1` preserves summability. -/
theorem summable_mul_of_summable_abs_of_abs_le_one {u c : ℕ → ℝ}
    (hu : Summable fun n => |u n|) (hc : ∀ n, |c n| ≤ 1) :
    Summable fun n => c n * u n := by
  refine Summable.of_norm_bounded (fun n => |u n|) hu ?_
  intro n
  calc
    ‖c n * u n‖ = |c n| * |u n| := by simp [abs_mul]
    _ ≤ 1 * |u n| := by
      exact mul_le_mul_of_nonneg_right (hc n) (abs_nonneg (u n))
    _ = |u n| := by ring

end Series
end Cauchy1821
end Textbooks
end MathlibExpansion
