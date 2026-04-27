import MathlibExpansion.Probability.CharacteristicFunction.Basic

/-!
# Independent sums and convolution laws

This file packages the law-of-an-independent-sum theorem at the probability-law
boundary.
-/

namespace MathlibExpansion
namespace Probability
namespace MeasureConvolution

open MeasureTheory
open MathlibExpansion.Probability.CharacteristicFunction

/-- The probability law of the sum of two independent real laws. -/
noncomputable def indepSumLaw (μ ν : ProbabilityMeasure ℝ) : ProbabilityMeasure ℝ :=
  (μ.prod ν).map (measurable_fst.add measurable_snd).aemeasurable

/-- For independent random variables, the law of `X + Y` is the independent-sum law of the
marginal laws. -/
theorem lawOf_add_eq_indepSumLaw {Ω : Type*} [MeasurableSpace Ω] (μ : ProbabilityMeasure Ω)
    (X Y : Ω → ℝ) (hX : AEMeasurable X (μ : Measure Ω)) (hY : AEMeasurable Y (μ : Measure Ω))
    (hXY : ProbabilityTheory.IndepFun X Y (μ : Measure Ω)) :
    lawOf μ (fun ω => X ω + Y ω) (hX.add hY) = indepSumLaw (lawOf μ X hX) (lawOf μ Y hY) := by
  apply Subtype.ext
  have hprod :
      (μ : Measure Ω).map (fun ω => (X ω, Y ω)) =
        ((μ : Measure Ω).map X).prod ((μ : Measure Ω).map Y) :=
    (ProbabilityTheory.indepFun_iff_map_prod_eq_prod_map_map hX hY).1 hXY
  simp only [lawOf, indepSumLaw]
  change Measure.map (fun ω => X ω + Y ω) (μ : Measure Ω) =
    Measure.map (fun p : ℝ × ℝ => p.1 + p.2)
      (((μ : Measure Ω).map X).prod ((μ : Measure Ω).map Y))
  rw [← hprod]
  exact (AEMeasurable.map_map_of_aemeasurable
    (μ := (μ : Measure Ω))
    (f := fun ω => (X ω, Y ω))
    (g := fun p : ℝ × ℝ => p.1 + p.2)
    (measurable_fst.add measurable_snd).aemeasurable
    (hX.prod_mk hY)).symm

/-- First-moment additivity at the independent-sum law boundary. -/
theorem integral_id_indepSumLaw (μ ν : ProbabilityMeasure ℝ)
    (hμ : Integrable (fun x : ℝ => x) (μ : Measure ℝ))
    (hν : Integrable (fun x : ℝ => x) (ν : Measure ℝ)) :
    ∫ x, x ∂(indepSumLaw μ ν : Measure ℝ) =
      (∫ x, x ∂(μ : Measure ℝ)) + ∫ y, y ∂(ν : Measure ℝ) := by
  rw [indepSumLaw, ProbabilityMeasure.toMeasure_map]
  rw [integral_map (measurable_fst.add measurable_snd).aemeasurable]
  · change ∫ z : ℝ × ℝ, z.1 + z.2 ∂((μ : Measure ℝ).prod (ν : Measure ℝ)) =
        (∫ x, x ∂(μ : Measure ℝ)) + ∫ y, y ∂(ν : Measure ℝ)
    have hfst : Integrable (fun z : ℝ × ℝ => z.1) ((μ : Measure ℝ).prod (ν : Measure ℝ)) := by
      have hmap :
          Measure.map Prod.fst ((μ : Measure ℝ).prod (ν : Measure ℝ)) = (μ : Measure ℝ) := by
        simp
      have hleft :
          Integrable (fun x : ℝ => x)
            (Measure.map Prod.fst ((μ : Measure ℝ).prod (ν : Measure ℝ))) := by
        simpa [hmap] using hμ
      simpa [Function.comp_def] using
        (integrable_map_measure
          (μ := ((μ : Measure ℝ).prod (ν : Measure ℝ)))
          (f := Prod.fst)
          (g := fun x : ℝ => x)
          aestronglyMeasurable_id
          measurable_fst.aemeasurable).1 hleft
    have hsnd : Integrable (fun z : ℝ × ℝ => z.2) ((μ : Measure ℝ).prod (ν : Measure ℝ)) := by
      have hmap :
          Measure.map Prod.snd ((μ : Measure ℝ).prod (ν : Measure ℝ)) = (ν : Measure ℝ) := by
        simp
      have hleft :
          Integrable (fun y : ℝ => y)
            (Measure.map Prod.snd ((μ : Measure ℝ).prod (ν : Measure ℝ))) := by
        simpa [hmap] using hν
      simpa [Function.comp_def] using
        (integrable_map_measure
          (μ := ((μ : Measure ℝ).prod (ν : Measure ℝ)))
          (f := Prod.snd)
          (g := fun y : ℝ => y)
          aestronglyMeasurable_id
          measurable_snd.aemeasurable).1 hleft
    rw [integral_add hfst hsnd]
    rw [MeasureTheory.integral_fun_fst
      (μ := (μ : Measure ℝ)) (ν := (ν : Measure ℝ)) (f := fun x : ℝ => x)]
    rw [MeasureTheory.integral_fun_snd
      (μ := (μ : Measure ℝ)) (ν := (ν : Measure ℝ)) (f := fun y : ℝ => y)]
    simp
  · exact aestronglyMeasurable_id

end MeasureConvolution
end Probability
end MathlibExpansion
