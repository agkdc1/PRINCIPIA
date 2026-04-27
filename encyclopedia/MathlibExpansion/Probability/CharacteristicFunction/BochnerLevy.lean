import MathlibExpansion.Probability.CharacteristicFunction.Basic

/-!
# Bochner-Lévy existence boundary

This file isolates the existence theorem that reconstructs a probability law
from a pointwise characteristic-function limit which is continuous at the
origin.
-/

namespace MathlibExpansion
namespace Probability
namespace CharacteristicFunction

open MeasureTheory Filter
open scoped Topology

/-- Predicate asserting that a complex-valued function on `ℝ` is a probability characteristic
function. -/
def IsProbabilityCharacteristicFunction (φ : ℝ → ℂ) : Prop :=
  ∃ μ : ProbabilityMeasure ℝ, ∀ t : ℝ, characteristicFunction μ t = φ t

/-- The characteristic function attached to a law satisfies
`IsProbabilityCharacteristicFunction`. -/
theorem isProbabilityCharacteristicFunction_characteristicFunction (μ : ProbabilityMeasure ℝ) :
    IsProbabilityCharacteristicFunction (characteristicFunction μ) := by
  exact ⟨μ, fun _ ↦ rfl⟩

/-- A probability characteristic function is normalized at the origin. -/
theorem IsProbabilityCharacteristicFunction.map_zero {φ : ℝ → ℂ}
    (hφ : IsProbabilityCharacteristicFunction φ) : φ 0 = 1 := by
  rcases hφ with ⟨μ, hμ⟩
  rw [← hμ 0, characteristicFunction_zero]

/-- Law-sequence form of Lévy's continuity theorem: continuity at the origin for a pointwise
limit of characteristic functions forces existence of an underlying probability law.

Exact theorem-shape source: Rick Durrett, *Probability: Theory and Examples*, 4th ed.
(2010), Theorem 3.3.6(ii), continuity theorem. Exact paper proof reference: Christian
Döbler, "A short proof of Lévy's continuity theorem without using tightness",
*Statistics & Probability Letters* 185 (2022), 109438, Theorem 1.1. Historical source
spine: Paul Lévy, *Calcul des probabilités* (1925), Part II, Chapter 4,
`Réciproque du théorème précédent`. -/
axiom exists_probabilityMeasure_of_pointwise_characteristicFunction_limit_from_laws
    {μs : ℕ → ProbabilityMeasure ℝ} {φ : ℝ → ℂ}
    (hlim : ∀ t : ℝ, Tendsto (fun n ↦ characteristicFunction (μs n) t) atTop (𝓝 (φ t)))
    (hcont0 : ContinuousAt φ 0) :
    ∃ μ : ProbabilityMeasure ℝ, ∀ t : ℝ, characteristicFunction μ t = φ t

/-- Continuity at the origin for a pointwise limit of characteristic functions forces existence of
an underlying probability law. This wrapper reduces the function-level statement to the narrower
law-sequence form. -/
theorem exists_probabilityMeasure_of_pointwise_characteristicFunction_limit
    {φs : ℕ → ℝ → ℂ} {φ : ℝ → ℂ}
    (hφs : ∀ n, IsProbabilityCharacteristicFunction (φs n))
    (hlim : ∀ t : ℝ, Tendsto (fun n ↦ φs n t) atTop (𝓝 (φ t)))
    (hcont0 : ContinuousAt φ 0) :
    ∃ μ : ProbabilityMeasure ℝ, ∀ t : ℝ, characteristicFunction μ t = φ t := by
  classical
  let μs : ℕ → ProbabilityMeasure ℝ := fun n ↦ Classical.choose (hφs n)
  have hμs : ∀ n t, characteristicFunction (μs n) t = φs n t := fun n ↦
    Classical.choose_spec (hφs n)
  exact exists_probabilityMeasure_of_pointwise_characteristicFunction_limit_from_laws
    (μs := μs)
    (φ := φ)
    (by
      intro t
      have hseq : (fun n ↦ characteristicFunction (μs n) t) = (fun n ↦ φs n t) := by
        funext n
        exact hμs n t
      simpa [hseq] using hlim t)
    hcont0

end CharacteristicFunction
end Probability
end MathlibExpansion
