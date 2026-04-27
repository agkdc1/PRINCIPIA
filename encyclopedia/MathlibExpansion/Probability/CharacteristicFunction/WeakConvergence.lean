import MathlibExpansion.Probability.CharacteristicFunction.Continuity

/-!
# Weak convergence implies characteristic-function convergence

This file packages the direct half of Lévy's continuity theorem.
-/

namespace MathlibExpansion
namespace Probability
namespace CharacteristicFunction

open MeasureTheory Filter
open scoped Topology BoundedContinuousFunction

/-- Weak convergence of laws implies pointwise convergence of characteristic functions.

This is the direct half of Lévy's continuity theorem, proved here from Mathlib's
bounded-continuous-function characterization of weak convergence of probability
measures. -/
theorem tendsto_characteristicFunction_of_tendsto {ι : Type*} {L : Filter ι}
    {μs : ι → ProbabilityMeasure ℝ} {μ : ProbabilityMeasure ℝ}
    (hμ : Tendsto μs L (𝓝 μ)) (t : ℝ) :
    Tendsto (fun i ↦ characteristicFunction (μs i) t) L
      (𝓝 (characteristicFunction μ t)) := by
  let fC : ℝ →ᵇ ℂ :=
    BoundedContinuousFunction.ofNormedAddCommGroup
      (fun x : ℝ ↦ Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I))
      (by fun_prop) 1 (by
        intro x
        simp [Complex.norm_exp])
  let fRe : ℝ →ᵇ ℝ := Complex.reCLM.compLeftContinuousBounded ℝ fC
  let fIm : ℝ →ᵇ ℝ := Complex.imCLM.compLeftContinuousBounded ℝ fC
  have hRe :=
    (ProbabilityMeasure.tendsto_iff_forall_integral_tendsto.mp hμ) fRe
  have hIm :=
    (ProbabilityMeasure.tendsto_iff_forall_integral_tendsto.mp hμ) fIm
  have hReC :
      Tendsto
        (fun i ↦ ((∫ x, fRe x ∂(μs i : Measure ℝ) : ℝ) : ℂ)) L
        (𝓝 ((∫ x, fRe x ∂(μ : Measure ℝ) : ℝ) : ℂ)) :=
    Filter.tendsto_ofReal_iff.mpr hRe
  have hImC :
      Tendsto
        (fun i ↦ ((∫ x, fIm x ∂(μs i : Measure ℝ) : ℝ) : ℂ)) L
        (𝓝 ((∫ x, fIm x ∂(μ : Measure ℝ) : ℝ) : ℂ)) :=
    Filter.tendsto_ofReal_iff.mpr hIm
  have hParts :
      Tendsto
        (fun i ↦
          ((∫ x, fRe x ∂(μs i : Measure ℝ) : ℝ) : ℂ) +
            ((∫ x, fIm x ∂(μs i : Measure ℝ) : ℝ) : ℂ) * Complex.I) L
        (𝓝
          (((∫ x, fRe x ∂(μ : Measure ℝ) : ℝ) : ℂ) +
            ((∫ x, fIm x ∂(μ : Measure ℝ) : ℝ) : ℂ) * Complex.I)) :=
    hReC.add (hImC.mul_const Complex.I)
  have hChar (ν : ProbabilityMeasure ℝ) :
      ((∫ x, fRe x ∂(ν : Measure ℝ) : ℝ) : ℂ) +
          ((∫ x, fIm x ∂(ν : Measure ℝ) : ℝ) : ℂ) * Complex.I =
        characteristicFunction ν t := by
    have hInt :
        Integrable (fun x : ℝ ↦ Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I))
          (ν : Measure ℝ) := by
      simpa [fC] using
        (BoundedContinuousFunction.integrable (μ := (ν : Measure ℝ)) fC)
    simpa [characteristicFunction, fC, fRe, fIm] using
      (integral_re_add_im (𝕜 := ℂ) (μ := (ν : Measure ℝ)) hInt)
  simpa [hChar μ] using
    hParts.congr' (Eventually.of_forall fun i ↦ hChar (μs i))

end CharacteristicFunction
end Probability
end MathlibExpansion
