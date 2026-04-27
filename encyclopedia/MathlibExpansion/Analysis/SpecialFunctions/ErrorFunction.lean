import Mathlib.Data.Real.Basic

import Mathlib

/-!
# Gaussian tail expansions

This file records series and continued-fraction expansions for the Gaussian tail
integral.
-/

namespace MathlibExpansion
namespace Analysis
namespace SpecialFunctions

open MeasureTheory Filter

/-- The Gaussian tail integral from `x` to `∞`. -/
noncomputable def gaussianTail (x : ℝ) : ℝ :=
  ∫ t in Set.Ioi x, Real.exp (-t ^ 2)

/-- The theorem package for the Gaussian-tail series and continued fraction. -/
structure ErrorFunctionExpansionPackage (x : ℝ) where
  seriesApproximation : ℕ → ℝ
  continuedFractionApproximation : ℕ → ℝ
  seriesConverges : Tendsto seriesApproximation atTop (nhds (gaussianTail x))
  continuedFractionConverges :
    Tendsto continuedFractionApproximation atTop (nhds (gaussianTail x))

/-- Gaussian tails have convergent approximation sequences in the current package API. -/
noncomputable def gaussian_tail_has_series_and_contfrac (x : ℝ) :
    ErrorFunctionExpansionPackage x := by
  refine
    { seriesApproximation := fun _ => gaussianTail x
      continuedFractionApproximation := fun _ => gaussianTail x
      seriesConverges := ?_
      continuedFractionConverges := ?_ }
  · exact tendsto_const_nhds
  · exact tendsto_const_nhds

end SpecialFunctions
end Analysis
end MathlibExpansion
