import MathlibExpansion.Probability.MeasureConvolution.IndepSum

/-!
# Characteristic functions of sums of independent random variables

This file records the random-variable formulation of characteristic-function
multiplicativity.
-/

namespace MathlibExpansion
namespace Probability
namespace CharacteristicFunction

open MeasureTheory

/-- For independent real random variables, the characteristic function of the sum is the product
of the marginal characteristic functions. -/
theorem characteristicFunction_add_of_indepFun {Ω : Type*} [MeasurableSpace Ω]
    (μ : ProbabilityMeasure Ω) (X Y : Ω → ℝ)
    (hX : AEMeasurable X (μ : Measure Ω)) (hY : AEMeasurable Y (μ : Measure Ω))
    (hXY : ProbabilityTheory.IndepFun X Y (μ : Measure Ω)) (t : ℝ) :
    characteristicFunction (lawOf μ (fun ω ↦ X ω + Y ω) (hX.add hY)) t =
      characteristicFunction (lawOf μ X hX) t * characteristicFunction (lawOf μ Y hY) t := by
  rw [MathlibExpansion.Probability.MeasureConvolution.lawOf_add_eq_indepSumLaw μ X Y hX hY hXY]
  rw [characteristicFunction, MathlibExpansion.Probability.MeasureConvolution.indepSumLaw,
    ProbabilityMeasure.toMeasure_map]
  rw [integral_map (measurable_fst.add measurable_snd).aemeasurable]
  · calc
      ∫ z : ℝ × ℝ, Complex.exp ((t : ℂ) * ((z.1 + z.2 : ℝ) : ℂ) * Complex.I)
          ∂((lawOf μ X hX : Measure ℝ).prod (lawOf μ Y hY : Measure ℝ))
          = ∫ z : ℝ × ℝ, Complex.exp ((t : ℂ) * (z.1 : ℂ) * Complex.I) *
              Complex.exp ((t : ℂ) * (z.2 : ℂ) * Complex.I)
              ∂((lawOf μ X hX : Measure ℝ).prod (lawOf μ Y hY : Measure ℝ)) := by
            apply integral_congr_ae
            filter_upwards with z
            rw [← Complex.exp_add]
            congr 1
            norm_num
            ring
      _ = (∫ x, Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I)
            ∂(lawOf μ X hX : Measure ℝ)) *
          ∫ y, Complex.exp ((t : ℂ) * (y : ℂ) * Complex.I)
            ∂(lawOf μ Y hY : Measure ℝ) := by
            simpa using
              (MeasureTheory.integral_prod_mul
                (μ := (lawOf μ X hX : Measure ℝ))
                (ν := (lawOf μ Y hY : Measure ℝ))
                (f := fun x : ℝ => Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I))
                (g := fun y : ℝ => Complex.exp ((t : ℂ) * (y : ℂ) * Complex.I)))
  · exact AEMeasurable.aestronglyMeasurable (by fun_prop)

end CharacteristicFunction
end Probability
end MathlibExpansion
