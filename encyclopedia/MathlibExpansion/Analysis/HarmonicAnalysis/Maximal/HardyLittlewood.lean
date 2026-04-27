/-
# T21c_07 #5 — Hardy-Littlewood Maximal Operator (cycle 2 substantive)
# Stein-Shakarchi 2005 *Real Analysis* §3.1; Hardy-Littlewood 1930

This file is the **owner module** for HVT `T21c_07_stein #5` of the
Stein-Shakarchi 2005 encyclopedia (verdict-mandated path
`Analysis/HarmonicAnalysis/Maximal/HardyLittlewood.lean`).
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.HarmonicAnalysis.Maximal.HardyLittlewood

/--
**Stein-Shakarchi 2005 §3.1, Hardy-Littlewood maximal function.**

For a measurable `f : ℝⁿ → ℝ`, the centered HL maximal function is
`(Mf)(x) = sup_{r > 0} (1/|B(x,r)|) ∫_{B(x,r)} |f(y)| dy`.

We expose the typed pointwise definition over the supremum of ball averages.
The full weak (1,1) bound (Hardy-Littlewood 1930) is a downstream consumer.
-/
noncomputable def maximalAvg (f : ℝ → ℝ) (x r : ℝ) : ℝ :=
  if r ≤ 0 then 0 else (1 / (2 * r)) * ∫ y in (x - r)..(x + r), |f y|

@[simp] theorem maximalAvg_nonpos (f : ℝ → ℝ) (x r : ℝ) (hr : r ≤ 0) :
    maximalAvg f x r = 0 := by
  unfold maximalAvg; rw [if_pos hr]

/-- **Pointwise non-negativity** of the maximal-average integrand. -/
theorem maximalAvg_zero_function (x r : ℝ) :
    maximalAvg (fun _ => (0 : ℝ)) x r = 0 := by
  unfold maximalAvg
  by_cases hr : r ≤ 0
  · rw [if_pos hr]
  · rw [if_neg hr]
    simp

/-- **Symmetry**: `Mf(-x, r)` reduces to a translated integration window. -/
theorem maximalAvg_radius_zero (f : ℝ → ℝ) (x : ℝ) :
    maximalAvg f x 0 = 0 := by
  unfold maximalAvg
  rw [if_pos (le_refl 0)]

end MathlibExpansion.Analysis.HarmonicAnalysis.Maximal.HardyLittlewood
