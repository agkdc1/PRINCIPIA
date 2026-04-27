import MathlibExpansion.Probability.Laws.AbstractSets

/-!
# Density-level convolution wrappers

This file packages the direct density-convolution boundary for absolutely
continuous laws.
-/

namespace MathlibExpansion
namespace Probability
namespace MeasureConvolution

open MeasureTheory
open scoped ENNReal

/-- The direct convolution formula for nonnegative extended-real densities. -/
noncomputable def convolutionDensity (f g : ℝ → ℝ≥0∞) (x : ℝ) : ℝ≥0∞ :=
  ∫⁻ t, f t * g (x - t)

private theorem prod_withDensity_eq_withDensity_prod
    (f g : ℝ → ℝ≥0∞) (hf : AEMeasurable f volume) (hg : AEMeasurable g volume)
    (hμ : IsProbabilityMeasure (volume.withDensity f))
    (hν : IsProbabilityMeasure (volume.withDensity g)) :
    (volume.withDensity f).prod (volume.withDensity g) =
      (volume.prod volume).withDensity (fun z : ℝ × ℝ => f z.1 * g z.2) := by
  haveI : IsProbabilityMeasure (volume.withDensity f) := hμ
  haveI : IsProbabilityMeasure (volume.withDensity g) := hν
  refine Measure.prod_eq (μ := volume.withDensity f) (ν := volume.withDensity g) ?_
  intro s t hs ht
  rw [withDensity_apply _ (hs.prod ht), ← Measure.prod_restrict,
    lintegral_prod_mul hf.restrict hg.restrict, withDensity_apply _ hs,
    withDensity_apply _ ht]

/-- Pushing the product density through addition gives the pointwise density convolution. -/
private theorem map_add_withDensity_prod_eq_withDensity_lintegral
    (f g : ℝ → ℝ≥0∞) (hf : AEMeasurable f volume) (hg : AEMeasurable g volume) :
    Measure.map (fun z : ℝ × ℝ => z.1 + z.2)
      ((volume.prod volume).withDensity (fun z : ℝ × ℝ => f z.1 * g z.2)) =
        volume.withDensity (convolutionDensity f g) := by
  refine Measure.ext fun s hs => ?_
  have h_add : Measurable (fun z : ℝ × ℝ => z.1 + z.2) := measurable_fst.add measurable_snd
  rw [Measure.map_apply h_add hs, withDensity_apply _ hs, withDensity_apply _ (h_add hs)]
  let T : ℝ × ℝ → ℝ × ℝ := fun z => (z.1 + z.2, z.1)
  let k : ℝ × ℝ → ℝ≥0∞ := fun z => f z.2 * g (z.1 - z.2)
  have hT : MeasurePreserving T (volume.prod volume) (volume.prod volume) := by
    simpa [T, Function.comp_def, add_comm] using
      (measurePreserving_add_prod (volume : Measure ℝ) (volume : Measure ℝ)).comp
        (Measure.measurePreserving_swap (μ := volume) (ν := volume))
  have hk : AEMeasurable k (volume.prod volume) := by
    simpa [k, Function.comp_def] using
      hf.snd.mul
        (hg.comp_quasiMeasurePreserving
          (quasiMeasurePreserving_sub (volume : Measure ℝ) (volume : Measure ℝ)))
  have hk_ind : AEMeasurable ((s ×ˢ Set.univ).indicator k) (volume.prod volume) :=
    hk.indicator (hs.prod MeasurableSet.univ)
  have hshear :
      ∫⁻ (a : ℝ × ℝ), ((s ×ˢ Set.univ).indicator k) (T a) ∂volume.prod volume =
        ∫⁻ (b : ℝ × ℝ), ((s ×ˢ Set.univ).indicator k) b ∂volume.prod volume := by
    have hk_ind_map :
        AEMeasurable ((s ×ˢ Set.univ).indicator k)
          (Measure.map T (volume.prod volume)) := by
      simpa [hT.map_eq] using hk_ind
    have hmap := lintegral_map' hk_ind_map hT.aemeasurable
    simpa [hT.map_eq] using hmap.symm
  calc
    ∫⁻ (a : ℝ × ℝ) in (fun z : ℝ × ℝ => z.1 + z.2) ⁻¹' s,
        f a.1 * g a.2 ∂volume.prod volume
        = ∫⁻ (a : ℝ × ℝ), ((s ×ˢ Set.univ).indicator k) (T a) ∂volume.prod volume := by
          rw [← lintegral_indicator (h_add hs)]
          apply lintegral_congr
          intro a
          by_cases ha : a.1 + a.2 ∈ s
          · simp [T, k, ha, sub_eq_add_neg, add_assoc, add_left_comm, add_comm]
          · simp [T, k, ha, sub_eq_add_neg, add_assoc, add_left_comm, add_comm]
    _ = ∫⁻ (b : ℝ × ℝ), ((s ×ˢ Set.univ).indicator k) b ∂volume.prod volume := hshear
    _ = ∫⁻ (b : ℝ × ℝ) in s ×ˢ Set.univ, k b ∂volume.prod volume := by
      rw [lintegral_indicator (hs.prod MeasurableSet.univ)]
    _ = ∫⁻ (a : ℝ) in s, convolutionDensity f g a ∂volume := by
      rw [← Measure.prod_restrict (μ := volume) (ν := volume) s Set.univ,
        Measure.restrict_univ]
      have hk_restrict : AEMeasurable k ((volume.restrict s).prod volume) := by
        have hle :
            ((volume.restrict s : Measure ℝ).prod (volume : Measure ℝ)) ≤
              ((volume : Measure ℝ).prod (volume : Measure ℝ)) := by
          calc
            ((volume.restrict s : Measure ℝ).prod (volume : Measure ℝ))
                = ((volume : Measure ℝ).prod (volume : Measure ℝ)).restrict
                    (s ×ˢ Set.univ) := by
                  simpa using
                    (Measure.prod_restrict (μ := (volume : Measure ℝ))
                      (ν := (volume : Measure ℝ)) s Set.univ)
            _ ≤ ((volume : Measure ℝ).prod (volume : Measure ℝ)) :=
                  Measure.restrict_le_self
        exact hk.mono_measure hle
      rw [lintegral_prod k hk_restrict]
      simp [k, convolutionDensity]

/-- Density-level wrapper for convolution of absolutely continuous probability laws. -/
theorem conv_withDensity_eq_withDensity_convolution
    (f g : ℝ → ℝ≥0∞) (hf : AEMeasurable f volume) (hg : AEMeasurable g volume)
    (hμ : IsProbabilityMeasure (volume.withDensity f))
    (hν : IsProbabilityMeasure (volume.withDensity g)) :
    Measure.conv (volume.withDensity f) (volume.withDensity g) =
      volume.withDensity (convolutionDensity f g) := by
  change Measure.map (fun z : ℝ × ℝ => z.1 + z.2)
      ((volume.withDensity f).prod (volume.withDensity g)) =
    volume.withDensity (convolutionDensity f g)
  rw [prod_withDensity_eq_withDensity_prod f g hf hg hμ hν]
  exact map_add_withDensity_prod_eq_withDensity_lintegral f g hf hg

end MeasureConvolution
end Probability
end MathlibExpansion
