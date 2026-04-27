import MathlibExpansion.Probability.CharacteristicFunction.Basic

/-!
# Absolute-continuous inversion

This file packages the inverse-Fourier density boundary for absolutely
continuous laws whose characteristic functions are integrable.
-/

namespace MathlibExpansion
namespace Probability
namespace CharacteristicFunction

open MeasureTheory

/-- Candidate inverse-Fourier density attached to an integrable characteristic function. -/
noncomputable def inverseFourierDensityCandidate (μ : ProbabilityMeasure ℝ) : ℝ → ℝ :=
  fun x ↦ ((2 * Real.pi)⁻¹ : ℝ) *
    (∫ t : ℝ, Complex.exp (-(Complex.I * ((t * x : ℝ) : ℂ))) *
      characteristicFunction μ t).re

/--
The inverse-Fourier formula is an integrable density for any real probability
law whose characteristic function is integrable.

Source boundary: Christian Dobler, "A short proof of Levy's continuity theorem
without using tightness", *Statistics & Probability Letters* 185 (2022),
109438, Theorem 1.2, specialized to dimension `d = 1`.
-/
axiom integrable_inverseFourierDensityCandidate_and_measure_eq_withDensity
    (μ : ProbabilityMeasure ℝ) (hφ : Integrable (characteristicFunction μ)) :
    Integrable (inverseFourierDensityCandidate μ) ∧
      (μ : Measure ℝ) =
        volume.withDensity (fun x ↦ ENNReal.ofReal (inverseFourierDensityCandidate μ x))

/-- Integrable characteristic functions yield absolutely continuous probability laws. -/
theorem exists_density_eq_inverseFourier_of_integrable_characteristicFunction
    (μ : ProbabilityMeasure ℝ) (hφ : Integrable (characteristicFunction μ)) :
    ∃ f : ℝ → ℝ, Integrable f ∧
      (μ : Measure ℝ) = volume.withDensity (fun x ↦ ENNReal.ofReal (f x)) ∧
      f = inverseFourierDensityCandidate μ := by
  refine ⟨inverseFourierDensityCandidate μ, ?_, ?_, rfl⟩
  · exact (integrable_inverseFourierDensityCandidate_and_measure_eq_withDensity μ hφ).1
  · exact (integrable_inverseFourierDensityCandidate_and_measure_eq_withDensity μ hφ).2

end CharacteristicFunction
end Probability
end MathlibExpansion
