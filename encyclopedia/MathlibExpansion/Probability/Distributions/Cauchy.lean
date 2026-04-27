import MathlibExpansion.Probability.CharacteristicFunction.Basic

/-!
# The real Cauchy family

This file provides the sibling-library owner for the real Cauchy laws, with the
distribution itself kept separate from later convolution and stable-law
consumers.
-/

namespace MathlibExpansion
namespace Probability
namespace Distributions

open MeasureTheory
open MathlibExpansion.Probability.CharacteristicFunction

/-- The classical real Cauchy density with location `x₀` and positive scale `γ`. -/
noncomputable def cauchyDensity (x₀ γ x : ℝ) : ℝ :=
  (γ / Real.pi) / (γ ^ 2 + (x - x₀) ^ 2)

/-- The Cauchy density as an `ENNReal` density for `Measure.withDensity`. -/
noncomputable def cauchyENNRealDensity (x₀ γ x : ℝ) : ENNReal :=
  ENNReal.ofReal (cauchyDensity x₀ γ x)

/-- The `ENNReal` Cauchy density is measurable. -/
theorem measurable_cauchyENNRealDensity (x₀ γ : ℝ) :
    Measurable (fun x : ℝ => cauchyENNRealDensity x₀ γ x) := by
  unfold cauchyENNRealDensity cauchyDensity
  fun_prop

/-- The Cauchy density is nonnegative for positive scale. -/
theorem cauchyDensity_nonneg (x₀ γ : ℝ) (hγ : 0 < γ) (x : ℝ) :
    0 ≤ cauchyDensity x₀ γ x := by
  unfold cauchyDensity
  positivity

/-- The Cauchy density is integrable for positive scale. -/
theorem integrable_cauchyDensity (x₀ γ : ℝ) (hγ : 0 < γ) :
    Integrable (cauchyDensity x₀ γ) := by
  let hfun : ℝ → ℝ := fun y => (1 / Real.pi) * (1 + y ^ 2)⁻¹
  have hh : Integrable hfun := integrable_inv_one_add_sq.const_mul (1 / Real.pi)
  have hbase : Integrable (fun x : ℝ => hfun ((x - x₀) * γ⁻¹)) :=
    (hh.comp_mul_right' (inv_ne_zero hγ.ne')).comp_sub_right x₀
  have hcomp : Integrable (fun x : ℝ => γ⁻¹ * hfun ((x - x₀) * γ⁻¹)) := by
    simpa only [smul_eq_mul] using hbase.const_mul γ⁻¹
  refine hcomp.congr ?_
  filter_upwards with x
  unfold cauchyDensity
  simp only [hfun]
  have hden : γ ^ 2 + (x - x₀) ^ 2 ≠ 0 := by
    nlinarith [sq_pos_of_ne_zero hγ.ne', sq_nonneg (x - x₀)]
  have hden' : 1 + ((x - x₀) * γ⁻¹) ^ 2 ≠ 0 := by
    nlinarith [sq_nonneg ((x - x₀) * γ⁻¹)]
  field_simp [hγ.ne', hden, hden']
  ring_nf

/-- The real Cauchy density integrates to one. -/
theorem integral_cauchyDensity_eq_one (x₀ γ : ℝ) (hγ : 0 < γ) :
    ∫ x, cauchyDensity x₀ γ x = 1 := by
  let hfun : ℝ → ℝ := fun y => (1 / Real.pi) * (1 + y ^ 2)⁻¹
  have htranslate :
      (∫ x, cauchyDensity x₀ γ x) =
        ∫ x, (γ / Real.pi) / (γ ^ 2 + x ^ 2) := by
    unfold cauchyDensity
    rw [integral_sub_right_eq_self (μ := volume)
      (f := fun x : ℝ => (γ / Real.pi) / (γ ^ 2 + x ^ 2)) x₀]
  have hpoint : (fun x : ℝ => (γ / Real.pi) / (γ ^ 2 + x ^ 2)) =
      fun x : ℝ => γ⁻¹ * hfun (x * γ⁻¹) := by
    funext x
    simp only [hfun]
    have hden : γ ^ 2 + x ^ 2 ≠ 0 := by
      nlinarith [sq_pos_of_ne_zero hγ.ne', sq_nonneg x]
    have hden' : 1 + (x * γ⁻¹) ^ 2 ≠ 0 := by
      nlinarith [sq_nonneg (x * γ⁻¹)]
    field_simp [hγ.ne', hden, hden']
    ring_nf
  calc
    ∫ x, cauchyDensity x₀ γ x
        = ∫ x, (γ / Real.pi) / (γ ^ 2 + x ^ 2) := htranslate
    _ = ∫ x, γ⁻¹ * hfun (x * γ⁻¹) := by rw [hpoint]
    _ = γ⁻¹ * (∫ x, hfun (x * γ⁻¹)) := by rw [integral_mul_left]
    _ = γ⁻¹ * (|γ| * ∫ y, hfun y) := by
      rw [Measure.integral_comp_inv_mul_right hfun γ]
      rfl
    _ = γ⁻¹ * (γ * ∫ y, hfun y) := by rw [abs_of_pos hγ]
    _ = ∫ y, hfun y := by field_simp [hγ.ne']
    _ = 1 := by
      simp only [hfun, integral_mul_left, integral_univ_inv_one_add_sq]
      field_simp [Real.pi_pos.ne']

/-- The `ENNReal` Cauchy density has total mass one. -/
theorem lintegral_cauchyENNRealDensity_eq_one (x₀ γ : ℝ) (hγ : 0 < γ) :
    ∫⁻ x, cauchyENNRealDensity x₀ γ x = 1 := by
  unfold cauchyENNRealDensity
  rw [← ofReal_integral_eq_lintegral_ofReal
    (integrable_cauchyDensity x₀ γ hγ)
    (ae_of_all _ (cauchyDensity_nonneg x₀ γ hγ))]
  rw [integral_cauchyDensity_eq_one x₀ γ hγ, ENNReal.ofReal_one]

/--
The Cauchy density gives a probability measure.

This is discharged from Mathlib's improper-integral theorem
`integral_univ_inv_one_add_sq`.
-/
theorem isProbabilityMeasure_cauchyENNRealDensity (x₀ γ : ℝ) (hγ : 0 < γ) :
    IsProbabilityMeasure (volume.withDensity (fun x => cauchyENNRealDensity x₀ γ x)) where
  measure_univ := by
    rw [withDensity_apply _ MeasurableSet.univ]
    simpa using lintegral_cauchyENNRealDensity_eq_one x₀ γ hγ

/-- The probability-law carrier of the real Cauchy family. -/
noncomputable def cauchyMeasure (x₀ γ : ℝ) (hγ : 0 < γ) : ProbabilityMeasure ℝ :=
  ⟨volume.withDensity (fun x => cauchyENNRealDensity x₀ γ x),
    isProbabilityMeasure_cauchyENNRealDensity x₀ γ hγ⟩

/-- The basic ownership package for the real Cauchy family. -/
structure CauchyLawPackage (x₀ γ : ℝ) where
  law : ProbabilityMeasure ℝ
  density_formula :
    ∀ x : ℝ, cauchyDensity x₀ γ x = (γ / Real.pi) / (γ ^ 2 + (x - x₀) ^ 2)
  law_eq_withDensity :
    (law : Measure ℝ) = volume.withDensity (fun x => cauchyENNRealDensity x₀ γ x)

/-- Law-level owner for the real Cauchy family with explicit location and positive scale. -/
noncomputable def cauchyLawPackage (x₀ γ : ℝ) (hγ : 0 < γ) : CauchyLawPackage x₀ γ where
  law := cauchyMeasure x₀ γ hγ
  density_formula := by
    intro x
    rfl
  law_eq_withDensity := by
    rfl

/-- Density-level affine transport calculation for the Cauchy family. -/
theorem cauchyDensity_affine_inv (x₀ γ a b : ℝ) (hγ : 0 < γ) (ha : 0 < a) (x : ℝ) :
    |a⁻¹| * cauchyDensity x₀ γ (a⁻¹ * (x - b)) =
      cauchyDensity (a * x₀ + b) (a * γ) x := by
  unfold cauchyDensity
  have ha_ne : a ≠ 0 := ha.ne'
  have hγ_ne : γ ≠ 0 := hγ.ne'
  have hden₁ : γ ^ 2 + (a⁻¹ * (x - b) - x₀) ^ 2 ≠ 0 := by
    nlinarith [sq_pos_of_ne_zero hγ_ne, sq_nonneg (a⁻¹ * (x - b) - x₀)]
  have hden₂ : (a * γ) ^ 2 + (x - (a * x₀ + b)) ^ 2 ≠ 0 := by
    have : a * γ ≠ 0 := mul_ne_zero ha_ne hγ_ne
    nlinarith [sq_pos_of_ne_zero this, sq_nonneg (x - (a * x₀ + b))]
  rw [abs_of_pos (inv_pos.mpr ha)]
  field_simp [ha_ne, hγ_ne, hden₁, hden₂]
  ring

/-- Affine transport within the Cauchy family. -/
theorem cauchy_affine_transport (x₀ γ a b : ℝ) (hγ : 0 < γ) (ha : 0 < a) :
    (cauchyMeasure x₀ γ hγ).map (measurable_affineMap a b).aemeasurable =
      cauchyMeasure (a * x₀ + b) (a * γ) (mul_pos ha hγ) := by
  apply ProbabilityMeasure.toMeasure_injective
  change (volume.withDensity (fun x => cauchyENNRealDensity x₀ γ x)).map (affineMap a b) =
    volume.withDensity (fun x => cauchyENNRealDensity (a * x₀ + b) (a * γ) x)
  let eHome : ℝ ≃ₜ ℝ := ((Homeomorph.mulLeft₀ a ha.ne').trans (Homeomorph.addRight b)).symm
  let e : ℝ ≃ᵐ ℝ := eHome.toMeasurableEquiv
  have he_symm : (e.symm : ℝ → ℝ) = affineMap a b := by
    funext x
    simp [e, eHome, affineMap, Homeomorph.addRight, Homeomorph.mulLeft₀]
  rw [← he_symm]
  ext s hs
  calc
    ((volume.withDensity (fun x => cauchyENNRealDensity x₀ γ x)).map e.symm) s
        = ENNReal.ofReal
            (∫ x in s, |a⁻¹| * cauchyDensity x₀ γ (e x)) := by
          unfold cauchyENNRealDensity
          rw [MeasurableEquiv.withDensity_ofReal_map_symm_apply_eq_integral_abs_deriv_mul'
            (f := e) (f' := fun _ => a⁻¹) (g := cauchyDensity x₀ γ) hs
            (fun x => by
              simpa [e, eHome, Homeomorph.addRight, Homeomorph.mulLeft₀, sub_eq_add_neg]
                using ((hasDerivAt_id x).sub_const b).const_mul a⁻¹)
            (ae_of_all _ (cauchyDensity_nonneg x₀ γ hγ))
            (integrable_cauchyDensity x₀ γ hγ)]
    _ = ENNReal.ofReal
            (∫ x in s, |a⁻¹| * cauchyDensity x₀ γ (a⁻¹ * (x - b))) := by
          congr 1
    _ = ENNReal.ofReal (∫ x in s, cauchyDensity (a * x₀ + b) (a * γ) x) := by
          congr 1
          apply integral_congr_ae
          filter_upwards with x
          exact cauchyDensity_affine_inv x₀ γ a b hγ ha x
    _ = ∫⁻ x in s, cauchyENNRealDensity (a * x₀ + b) (a * γ) x := by
          unfold cauchyENNRealDensity
          rw [ofReal_integral_eq_lintegral_ofReal
            ((integrable_cauchyDensity (a * x₀ + b) (a * γ) (mul_pos ha hγ)).restrict)
            (ae_of_all _ (cauchyDensity_nonneg (a * x₀ + b) (a * γ) (mul_pos ha hγ)))]
    _ = (volume.withDensity (fun x => cauchyENNRealDensity (a * x₀ + b) (a * γ) x)) s := by
          rw [withDensity_apply _ hs]

/--
Narrow upstream Fourier-transform boundary for the standard Cauchy law.

Source anchor: Paul Lévy, "Théorie des erreurs. La loi de Gauss et les lois
exceptionnelles", *Bulletin de la Société Mathématique de France* 52 (1924),
§10, explicit `a = 1` Cauchy-law characteristic-function computation; reused
in Lévy, *Calcul des probabilités* (1925), Part II, Chapter 2, subsection
"Autre exemple. La loi de Cauchy".
-/
axiom characteristicFunction_standardCauchyMeasure (t : ℝ) :
    characteristicFunction (cauchyMeasure 0 1 zero_lt_one) t =
      Complex.exp ((-(|t|) : ℝ) : ℂ)

/--
Explicit characteristic function of a Cauchy law.

The general location-scale formula is discharged from the standard centered
Fourier-transform boundary and `cauchy_affine_transport`.
-/
theorem characteristicFunction_cauchyMeasure (x₀ γ : ℝ) (hγ : 0 < γ) (t : ℝ) :
    characteristicFunction (cauchyMeasure x₀ γ hγ) t =
      Complex.exp (((x₀ * t : ℝ) : ℂ) * Complex.I - (γ * |t| : ℝ)) := by
  have hsame :
      cauchyMeasure x₀ γ hγ =
        cauchyMeasure (γ * 0 + x₀) (γ * 1) (mul_pos hγ zero_lt_one) := by
    apply ProbabilityMeasure.toMeasure_injective
    simp [cauchyMeasure]
  rw [hsame]
  rw [← cauchy_affine_transport (x₀ := 0) (γ := 1) (a := γ) (b := x₀) zero_lt_one hγ]
  rw [characteristicFunction_map_affine]
  rw [characteristicFunction_standardCauchyMeasure]
  rw [← Complex.exp_add]
  congr 1
  have habs : |γ * t| = γ * |t| := by
    rw [abs_mul, abs_of_pos hγ]
  simp only [habs, zero_mul, zero_add, one_mul, Complex.ofReal_neg, sub_eq_add_neg]
  ring_nf

end Distributions
end Probability
end MathlibExpansion
