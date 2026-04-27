import MathlibExpansion.Probability.CharacteristicFunction.WeakConvergence
import MathlibExpansion.Probability.CharacteristicFunction.BochnerLevy

/-!
# Lévy continuity theorem

This file packages the full one-dimensional Lévy continuity theorem from a
narrow weak-convergence boundary and the Bochner-Lévy existence boundary.
-/

namespace MathlibExpansion
namespace Probability
namespace CharacteristicFunction

open MeasureTheory Filter
open scoped Topology

/-- The hard direction of Lévy continuity once the candidate limit law is already fixed.

Source boundary: Christian Döbler, "A short proof of Lévy's continuity theorem
without using tightness", *Statistics & Probability Letters* 185 (2022), 109438,
Theorem 1.1, implication (ii) ⇒ (i), specialized to dimension `d = 1` and
to probability measures on `ℝ`. -/
axiom tendsto_of_tendsto_characteristicFunction
    {μs : ℕ → ProbabilityMeasure ℝ} {μ : ProbabilityMeasure ℝ}
    (hlim : ∀ t : ℝ,
      Tendsto (fun n ↦ characteristicFunction (μs n) t) atTop
        (𝓝 (characteristicFunction μ t))) :
    Tendsto μs atTop (𝓝 μ)

/-- Full Lévy continuity theorem on the real line.

Source boundary: Christian Döbler, "A short proof of Lévy's continuity theorem
without using tightness", *Statistics & Probability Letters* 185 (2022), 109438,
Theorem 1.1, specialized to dimension `d = 1`; the existence half is routed
through `exists_probabilityMeasure_of_pointwise_characteristicFunction_limit`. -/
theorem levy_continuity_theorem {μs : ℕ → ProbabilityMeasure ℝ} {φ : ℝ → ℂ}
    (hlim : ∀ t : ℝ, Tendsto (fun n ↦ characteristicFunction (μs n) t) atTop (𝓝 (φ t)))
    (hcont0 : ContinuousAt φ 0) :
    ∃ μ : ProbabilityMeasure ℝ,
      (∀ t : ℝ, characteristicFunction μ t = φ t) ∧ Tendsto μs atTop (𝓝 μ) := by
  rcases exists_probabilityMeasure_of_pointwise_characteristicFunction_limit
      (φs := fun n t ↦ characteristicFunction (μs n) t)
      (φ := φ)
      (by
        intro n
        exact isProbabilityCharacteristicFunction_characteristicFunction (μs n))
      hlim hcont0 with ⟨μ, hμ⟩
  refine ⟨μ, hμ, ?_⟩
  apply tendsto_of_tendsto_characteristicFunction
  intro t
  simpa [hμ t] using hlim t

end CharacteristicFunction
end Probability
end MathlibExpansion
