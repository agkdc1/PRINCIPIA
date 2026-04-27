import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.SpecialFunctions.WeierstrassPathological.Basic

/-!
# Explicit bracketing points for the Weierstrass construction

This file records the explicit left/right points used as the first geometric
shell in the pathological-function lane.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace SpecialFunctions
namespace WeierstrassPathological

/-- The left bracketing point used in the first oscillation shell. -/
def leftBracket (a : ℕ) (x₀ : ℝ) (m : ℕ) : ℝ :=
  x₀ - 1 / ((a : ℝ) ^ (m + 1))

/-- The right bracketing point used in the first oscillation shell. -/
def rightBracket (a : ℕ) (x₀ : ℝ) (m : ℕ) : ℝ :=
  x₀ + 1 / ((a : ℝ) ^ (m + 1))

theorem leftBracket_lt (a : ℕ) (x₀ : ℝ) (m : ℕ) (ha1 : 1 < a) :
    leftBracket a x₀ m < x₀ := by
  have hpow : 0 < ((a : ℝ) ^ (m + 1)) := by
    positivity
  have hdiv : 0 < 1 / ((a : ℝ) ^ (m + 1)) := one_div_pos.mpr hpow
  simpa [leftBracket] using sub_lt_self x₀ hdiv

theorem lt_rightBracket (a : ℕ) (x₀ : ℝ) (m : ℕ) (ha1 : 1 < a) :
    x₀ < rightBracket a x₀ m := by
  have hpow : 0 < ((a : ℝ) ^ (m + 1)) := by
    positivity
  have hdiv : 0 < 1 / ((a : ℝ) ^ (m + 1)) := one_div_pos.mpr hpow
  simpa [rightBracket] using lt_add_of_pos_right x₀ hdiv

/-- A concrete bracketing-point witness for the first Weierstrass oscillation
layer.  At this boundary, choosing `α = 0` already yields the required left and
right points with the textbook denominator scale `a^{m+1}`. -/
theorem exists_weierstrass_bracketing_points (a : ℕ) (ha1 : 1 < a) (_haodd : Odd a)
    (x₀ : ℝ) (m : ℕ) :
    ∃ α : ℤ,
      let x' : ℝ := x₀ - (1 + (2 : ℝ) * α) / ((a : ℝ) ^ (m + 1))
      let x'' : ℝ := x₀ + (1 - (2 : ℝ) * α) / ((a : ℝ) ^ (m + 1))
      x' < x₀ ∧ x₀ < x'' := by
  refine ⟨0, ?_⟩
  dsimp
  constructor
  · have hpow : 0 < ((a : ℝ) ^ (m + 1)) := by
      positivity
    have hdiv : 0 < 1 / ((a : ℝ) ^ (m + 1)) := one_div_pos.mpr hpow
    simpa using sub_lt_self x₀ hdiv
  · have hpow : 0 < ((a : ℝ) ^ (m + 1)) := by
      positivity
    have hdiv : 0 < 1 / ((a : ℝ) ^ (m + 1)) := one_div_pos.mpr hpow
    simpa using lt_add_of_pos_right x₀ hdiv

end WeierstrassPathological
end SpecialFunctions
end Analysis
end MathlibExpansion
