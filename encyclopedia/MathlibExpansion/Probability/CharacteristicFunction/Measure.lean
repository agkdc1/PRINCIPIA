import MathlibExpansion.Probability.CharacteristicFunction.Basic
import MathlibExpansion.Probability.MeasureConvolution.IndepSum

/-!
# Characteristic functions and convolution laws

This file packages the law-first multiplicativity theorem.
-/

namespace MathlibExpansion
namespace Probability
namespace CharacteristicFunction

open MeasureTheory
open MathlibExpansion.Probability.MeasureConvolution

/-- The characteristic function of an independent-sum law is the product of the factors. -/
theorem characteristicFunction_indepSumLaw (μ ν : ProbabilityMeasure ℝ) (t : ℝ) :
    characteristicFunction (indepSumLaw μ ν) t =
      characteristicFunction μ t * characteristicFunction ν t := by
  rw [characteristicFunction, indepSumLaw, ProbabilityMeasure.toMeasure_map]
  rw [integral_map (measurable_fst.add measurable_snd).aemeasurable]
  · calc
      ∫ z : ℝ × ℝ, Complex.exp ((t : ℂ) * ((z.1 + z.2 : ℝ) : ℂ) * Complex.I)
          ∂((μ : Measure ℝ).prod (ν : Measure ℝ))
          = ∫ z : ℝ × ℝ, Complex.exp ((t : ℂ) * (z.1 : ℂ) * Complex.I) *
              Complex.exp ((t : ℂ) * (z.2 : ℂ) * Complex.I)
              ∂((μ : Measure ℝ).prod (ν : Measure ℝ)) := by
            apply integral_congr_ae
            filter_upwards with z
            rw [← Complex.exp_add]
            congr 1
            norm_num
            ring
      _ = (∫ x, Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I) ∂(μ : Measure ℝ)) *
          ∫ y, Complex.exp ((t : ℂ) * (y : ℂ) * Complex.I) ∂(ν : Measure ℝ) := by
            simpa using
              (MeasureTheory.integral_prod_mul
                (μ := (μ : Measure ℝ)) (ν := (ν : Measure ℝ))
                (f := fun x : ℝ => Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I))
                (g := fun y : ℝ => Complex.exp ((t : ℂ) * (y : ℂ) * Complex.I)))
      _ = characteristicFunction μ t * characteristicFunction ν t := by
            rw [characteristicFunction, characteristicFunction]
  · exact AEMeasurable.aestronglyMeasurable (by fun_prop)

end CharacteristicFunction
end Probability
end MathlibExpansion
