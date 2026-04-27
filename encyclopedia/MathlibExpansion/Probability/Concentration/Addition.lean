import MathlibExpansion.Probability.Concentration.Basic
import MathlibExpansion.Probability.MeasureConvolution.IndepSum

/-!
# Concentration under independent addition

This file records the anti-concentration monotonicity theorem for independent
sums.
-/

namespace MathlibExpansion
namespace Probability
namespace Concentration

open MeasureTheory
open MathlibExpansion.Probability.MeasureConvolution

private theorem intervalMass_le_concentrationFunction
    (μ : ProbabilityMeasure ℝ) (h x : ℝ) :
    (((μ : Measure ℝ) (Set.Icc x (x + h))).toReal) ≤ concentrationFunction μ h := by
  unfold concentrationFunction
  refine le_csSup ?_ (Set.mem_range_self x)
  refine ⟨1, ?_⟩
  rintro z ⟨y, rfl⟩
  exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one

private theorem concentrationFunction_nonneg (μ : ProbabilityMeasure ℝ) (h : ℝ) :
    0 ≤ concentrationFunction μ h := by
  calc
    0 ≤ (((μ : Measure ℝ) (Set.Icc 0 (0 + h))).toReal) := ENNReal.toReal_nonneg
    _ ≤ concentrationFunction μ h := intervalMass_le_concentrationFunction μ h 0

/-- Interval-mass form of Levy's anti-concentration theorem for independent addition.

For every interval of length `h`, the independent-sum law has mass bounded by the
left summand's concentration function.

Source: Paul Levy, *Theorie de l'addition des variables aleatoires*, 2nd ed.
1954, Chapter 4, "L'augmentation de la dispersion", main unnumbered theorem;
tracked locally as `T20c_14` / `CFLI_03`. -/
theorem concentrationFunction_indepSumLaw_intervalMass_le_left
    (μ ν : ProbabilityMeasure ℝ) (h x : ℝ) :
    (((indepSumLaw μ ν : Measure ℝ) (Set.Icc x (x + h))).toReal) ≤
      concentrationFunction μ h := by
  let addMap : ℝ × ℝ → ℝ := fun p ↦ p.1 + p.2
  have hmeas : Measurable addMap := measurable_fst.add measurable_snd
  have hset : MeasurableSet (Set.Icc x (x + h)) := measurableSet_Icc
  have hpre_meas : MeasurableSet (addMap ⁻¹' Set.Icc x (x + h)) := hset.preimage hmeas
  have hfiber :
      ∀ y : ℝ, {a : ℝ | (a, y) ∈ addMap ⁻¹' Set.Icc x (x + h)} =
        Set.Icc (x - y) (x + h - y) := by
    intro y
    ext a
    simp only [Set.mem_setOf_eq, Set.mem_preimage, Set.mem_Icc]
    dsimp [addMap]
    constructor
    · intro ha
      constructor <;> linarith
    · intro ha
      constructor <;> linarith
  have hmeasure_eq :
      (indepSumLaw μ ν : Measure ℝ) (Set.Icc x (x + h)) =
        ∫⁻ y, (μ : Measure ℝ) (Set.Icc (x - y) (x + h - y)) ∂(ν : Measure ℝ) := by
    rw [indepSumLaw, ProbabilityMeasure.toMeasure_map]
    rw [Measure.map_apply hmeas hset]
    rw [ProbabilityMeasure.toMeasure_prod]
    rw [Measure.prod_apply_symm hpre_meas]
    change (∫⁻ y, (μ : Measure ℝ)
        {a : ℝ | (a, y) ∈ addMap ⁻¹' Set.Icc x (x + h)} ∂(ν : Measure ℝ)) =
      ∫⁻ y, (μ : Measure ℝ) (Set.Icc (x - y) (x + h - y)) ∂(ν : Measure ℝ)
    simp_rw [hfiber]
  have hcf_nonneg : 0 ≤ concentrationFunction μ h :=
    concentrationFunction_nonneg μ h
  have hpoint :
      ∀ y : ℝ, (μ : Measure ℝ) (Set.Icc (x - y) (x + h - y)) ≤
        ENNReal.ofReal (concentrationFunction μ h) := by
    intro y
    refine (ENNReal.le_ofReal_iff_toReal_le (measure_ne_top _ _) hcf_nonneg).2 ?_
    simpa [sub_eq_add_neg, add_assoc, add_left_comm, add_comm] using
      (intervalMass_le_concentrationFunction μ h (x - y))
  have hintegral_le :
      (∫⁻ y, (μ : Measure ℝ) (Set.Icc (x - y) (x + h - y)) ∂(ν : Measure ℝ)) ≤
        ∫⁻ _ : ℝ, ENNReal.ofReal (concentrationFunction μ h) ∂(ν : Measure ℝ) :=
    lintegral_mono hpoint
  have hmeasure_le :
      (indepSumLaw μ ν : Measure ℝ) (Set.Icc x (x + h)) ≤
        ENNReal.ofReal (concentrationFunction μ h) := by
    rw [hmeasure_eq]
    simpa using hintegral_le
  calc
    (((indepSumLaw μ ν : Measure ℝ) (Set.Icc x (x + h))).toReal) ≤
        (ENNReal.ofReal (concentrationFunction μ h)).toReal :=
      ENNReal.toReal_mono ENNReal.ofReal_ne_top hmeasure_le
    _ = concentrationFunction μ h := ENNReal.toReal_ofReal hcf_nonneg

/-- Independent addition cannot increase concentration on the left factor. -/
theorem concentrationFunction_indepSumLaw_le_left (μ ν : ProbabilityMeasure ℝ) (h : ℝ) :
    concentrationFunction (indepSumLaw μ ν) h ≤ concentrationFunction μ h := by
  unfold concentrationFunction
  exact csSup_le (Set.range_nonempty _) (by
    rintro z ⟨x, rfl⟩
    exact concentrationFunction_indepSumLaw_intervalMass_le_left μ ν h x)

private theorem indepSumLaw_comm (μ ν : ProbabilityMeasure ℝ) :
    indepSumLaw μ ν = indepSumLaw ν μ := by
  apply ProbabilityMeasure.toMeasure_injective
  simpa [indepSumLaw, MeasureTheory.Measure.conv, ProbabilityMeasure.toMeasure_map] using
    (MeasureTheory.Measure.conv_comm (μ : Measure ℝ) (ν : Measure ℝ))

/-- Symmetric right-factor version of the same anti-concentration inequality. -/
theorem concentrationFunction_indepSumLaw_le_right (μ ν : ProbabilityMeasure ℝ) (h : ℝ) :
    concentrationFunction (indepSumLaw μ ν) h ≤ concentrationFunction ν h := by
  rw [indepSumLaw_comm μ ν]
  exact concentrationFunction_indepSumLaw_le_left ν μ h

end Concentration
end Probability
end MathlibExpansion
