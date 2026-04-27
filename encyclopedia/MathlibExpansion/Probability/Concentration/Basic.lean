import Mathlib

/-!
# Concentration and dispersion functions

This file introduces the basic small-ball / dispersion owners for real
probability laws.
-/

namespace MathlibExpansion
namespace Probability
namespace Concentration

open MeasureTheory

/-- Lévy's concentration function: maximal mass of a closed interval of given length. -/
noncomputable def concentrationFunction (μ : ProbabilityMeasure ℝ) (h : ℝ) : ℝ :=
  sSup (Set.range fun x : ℝ ↦ (((μ : Measure ℝ) (Set.Icc x (x + h))).toReal))

/-- The inverse dispersion profile attached to the concentration function. -/
noncomputable def dispersionFunction (μ : ProbabilityMeasure ℝ) (p : Set.Icc (0 : ℝ) 1) : ℝ :=
  sInf {h : ℝ | p.1 ≤ concentrationFunction μ h}

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

private theorem concentrationFunction_le_one (μ : ProbabilityMeasure ℝ) (h : ℝ) :
    concentrationFunction μ h ≤ 1 := by
  unfold concentrationFunction
  refine csSup_le (Set.range_nonempty _) ?_
  rintro z ⟨x, rfl⟩
  exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one

private theorem concentrationFunction_mono (μ : ProbabilityMeasure ℝ) :
    Monotone (concentrationFunction μ) := by
  intro h₁ h₂ hh
  unfold concentrationFunction
  refine csSup_le (Set.range_nonempty _) ?_
  rintro z ⟨x, rfl⟩
  have hfinite : ((μ : Measure ℝ) (Set.Icc x (x + h₂))) ≠ ⊤ :=
    measure_ne_top (μ : Measure ℝ) (Set.Icc x (x + h₂))
  refine (ENNReal.toReal_mono hfinite ?_).trans ?_
  · exact measure_mono (Set.Icc_subset_Icc le_rfl (add_le_add_left hh x))
  · refine le_csSup ?_ (Set.mem_range_self x)
    refine ⟨1, ?_⟩
    rintro z ⟨y, rfl⟩
    exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one

/-- The basic concentration-function API. -/
theorem concentrationFunction_basic (μ : ProbabilityMeasure ℝ) :
    concentrationFunction μ 0 ≥ 0 ∧
      (∀ h : ℝ, concentrationFunction μ h ≤ 1) ∧
      Monotone (concentrationFunction μ) := by
  exact ⟨concentrationFunction_nonneg μ 0, concentrationFunction_le_one μ,
    concentrationFunction_mono μ⟩

end Concentration
end Probability
end MathlibExpansion
