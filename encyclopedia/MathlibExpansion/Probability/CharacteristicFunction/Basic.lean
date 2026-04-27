import Mathlib

/-!
# Law-level characteristic functions

This file introduces the law-first characteristic-function owner required by
the Lévy characteristic-function corridor.
-/

namespace MathlibExpansion
namespace Probability
namespace CharacteristicFunction

open MeasureTheory ProbabilityTheory

/-- The characteristic function of a real probability law. -/
noncomputable def characteristicFunction (μ : ProbabilityMeasure ℝ) (t : ℝ) : ℂ :=
  ∫ x, Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I) ∂(μ : Measure ℝ)

/-- The law of a real-valued random variable under a probability measure. -/
noncomputable def lawOf {Ω : Type*} [MeasurableSpace Ω] (μ : ProbabilityMeasure Ω)
    (X : Ω → ℝ) (hX : AEMeasurable X (μ : Measure Ω)) : ProbabilityMeasure ℝ :=
  μ.map hX

/-- The affine map `x ↦ a * x + b`. -/
def affineMap (a b : ℝ) (x : ℝ) : ℝ :=
  a * x + b

/-- Measurability of the affine map used by the law-level characteristic-function API. -/
theorem measurable_affineMap (a b : ℝ) : Measurable (affineMap a b) := by
  simpa [affineMap] using (measurable_const.mul measurable_id).add measurable_const

/-- Imaginary-axis bridge from `complexMGF` to the law-first characteristic function. -/
theorem characteristicFunction_map_eq_complexMGF {Ω : Type*} [MeasurableSpace Ω]
    (μ : ProbabilityMeasure Ω) (X : Ω → ℝ) (hX : AEMeasurable X (μ : Measure Ω)) (t : ℝ) :
    characteristicFunction (lawOf μ X hX) t =
      ProbabilityTheory.complexMGF X (μ : Measure Ω) (Complex.I * (t : ℂ)) := by
  rw [characteristicFunction, lawOf, ProbabilityTheory.complexMGF]
  rw [ProbabilityMeasure.toMeasure_map]
  rw [integral_map hX]
  · apply integral_congr_ae
    filter_upwards with ω
    congr 1
    ring
  · exact AEMeasurable.aestronglyMeasurable (by fun_prop)

/-- Normalization at the origin. -/
theorem characteristicFunction_zero (μ : ProbabilityMeasure ℝ) :
    characteristicFunction μ 0 = 1 := by
  simp [characteristicFunction]

/-- Characteristic functions are uniformly bounded by `1` in norm. -/
theorem norm_characteristicFunction_le_one (μ : ProbabilityMeasure ℝ) (t : ℝ) :
    ‖characteristicFunction μ t‖ ≤ 1 := by
  calc
    ‖characteristicFunction μ t‖
        ≤ ∫ x, ‖Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I)‖ ∂(μ : Measure ℝ) := by
          simpa [characteristicFunction] using
            (norm_integral_le_integral_norm
              (μ := (μ : Measure ℝ))
              (f := fun x : ℝ => Complex.exp ((t : ℂ) * (x : ℂ) * Complex.I)))
    _ = 1 := by
      simp [Complex.norm_exp]

/-- Affine transport of laws becomes phase/argument transport of characteristic functions. -/
theorem characteristicFunction_map_affine (μ : ProbabilityMeasure ℝ) (a b t : ℝ) :
    characteristicFunction (μ.map (measurable_affineMap a b).aemeasurable) t =
      Complex.exp (Complex.I * ((t * b : ℝ) : ℂ)) * characteristicFunction μ (a * t) := by
  rw [characteristicFunction]
  rw [ProbabilityMeasure.toMeasure_map]
  rw [integral_map (measurable_affineMap a b).aemeasurable]
  · calc
      ∫ x, Complex.exp ((t : ℂ) * (affineMap a b x : ℂ) * Complex.I) ∂(μ : Measure ℝ)
          = ∫ x, Complex.exp (Complex.I * ((t * b : ℝ) : ℂ)) *
              Complex.exp (((a * t : ℝ) : ℂ) * (x : ℂ) * Complex.I) ∂(μ : Measure ℝ) := by
            apply integral_congr_ae
            filter_upwards with x
            rw [← Complex.exp_add]
            congr 1
            simp [affineMap]
            ring
      _ = Complex.exp (Complex.I * ((t * b : ℝ) : ℂ)) *
          ∫ x, Complex.exp (((a * t : ℝ) : ℂ) * (x : ℂ) * Complex.I) ∂(μ : Measure ℝ) := by
            rw [integral_mul_left]
      _ = Complex.exp (Complex.I * ((t * b : ℝ) : ℂ)) * characteristicFunction μ (a * t) := by
            rw [characteristicFunction]
  · exact AEMeasurable.aestronglyMeasurable (by fun_prop)

end CharacteristicFunction
end Probability
end MathlibExpansion
