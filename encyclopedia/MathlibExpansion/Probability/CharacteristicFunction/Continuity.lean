import MathlibExpansion.Probability.CharacteristicFunction.Basic

/-!
# Continuity of characteristic functions

This file isolates the single-law continuity theorem needed before the later
Lévy continuity theorem.
-/

namespace MathlibExpansion
namespace Probability
namespace CharacteristicFunction

open MeasureTheory ProbabilityTheory Filter
open scoped Topology

/-- Every law-level characteristic function is continuous. -/
theorem continuous_characteristicFunction (μ : ProbabilityMeasure ℝ) :
    Continuous (characteristicFunction μ) := by
  rw [continuous_iff_continuousAt]
  intro t₀
  simpa [characteristicFunction] using
    (MeasureTheory.tendsto_integral_filter_of_norm_le_const
      (μ := (μ : Measure ℝ))
      (F := fun t x : ℝ => Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I))
      (f := fun x : ℝ => Complex.exp ((t₀ : ℂ) * (x : ℂ) * Complex.I))
      (l := 𝓝 t₀)
      (h_meas := by
        filter_upwards with t
        exact Continuous.aestronglyMeasurable (by fun_prop))
      (h_bound := by
        refine ⟨1, ?_⟩
        filter_upwards with t
        filter_upwards with x
        simp [Complex.norm_exp])
      (h_lim := by
        filter_upwards with x
        exact Continuous.tendsto (by fun_prop) t₀))

end CharacteristicFunction
end Probability
end MathlibExpansion
