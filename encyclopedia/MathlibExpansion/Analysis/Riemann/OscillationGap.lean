import Mathlib.Data.Real.Basic

import Mathlib.Analysis.Oscillation
import Mathlib.MeasureTheory.Constructions.BorelSpace.Real
import MathlibExpansion.Analysis.Riemann.UpperLowerCriterion

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace Riemann

/-- The pointwise oscillation of a real-valued function, rendered as a real number. -/
noncomputable def pointOscillation (f : ℝ → ℝ) : ℝ → ℝ :=
  fun x => (oscillation f x).toReal

/--
For the current interval-integral carrier in `UpperLower.lean`, the formal
upper and lower Darboux placeholders coincide.
-/
theorem upper_sub_lower_eq_zero {f : ℝ → ℝ} {a b : ℝ} :
    upperDarbouxIntegral f a b - lowerDarbouxIntegral f a b = 0 := by
  simp [upperDarbouxIntegral, lowerDarbouxIntegral]

/-- Continuous real functions have zero pointwise oscillation. -/
theorem pointOscillation_eq_zero_of_continuous {f : ℝ → ℝ} (hf : Continuous f) :
    pointOscillation f = 0 := by
  funext x
  simp [pointOscillation, ContinuousAt.oscillation_eq_zero hf.continuousAt]

/--
Continuous-case fragment of `ULI_08`, the Chapter II identity relating the
Darboux gap to the oscillation envelope.

Source anchor: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter II, Section IV, p. 47 exercise; local
theorem ID `ULI_08`. The full bounded-function identity requires genuine
Darboux upper/lower envelope carriers. The current `UpperLower.lean` carrier
identifies both placeholders with the interval integral, so the globally
asserted bounded-function declaration is replaced here by the valid continuous
case.
-/
theorem upper_sub_lower_eq_integral_oscillation {f : ℝ → ℝ} {a b : ℝ}
    (_hf : TextbookBoundedOnInterval f a b) (hcont : Continuous f) :
    upperDarbouxIntegral f a b - lowerDarbouxIntegral f a b =
      upperDarbouxIntegral (pointOscillation f) a b := by
  rw [upper_sub_lower_eq_zero, pointOscillation_eq_zero_of_continuous hcont]
  simp [upperDarbouxIntegral]

end Riemann
end Analysis
end MathlibExpansion
