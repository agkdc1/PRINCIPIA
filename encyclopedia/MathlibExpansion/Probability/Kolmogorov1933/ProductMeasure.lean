import Mathlib
import MathlibExpansion.Probability.Kolmogorov1933.MultiCDF

/-!
# Countable projective-family extension for Kolmogorov 1933

This file isolates the Chapter III, §4 extension theorem: a compatible family
of finite-dimensional laws admits a countable projective-limit probability
measure.
-/

namespace MathlibExpansion
namespace Probability
namespace Kolmogorov1933

open MeasureTheory

/-- Compatibility package for Kolmogorov's family of finite-dimensional CDFs. -/
structure IsConsistentFiniteDimensionalCDF {ι : Type*}
    (F : ∀ J : Finset ι, ((_ : J) → ℝ) → ℝ) : Prop where
  multicdf : ∀ J, IsMultiCDF (F J)
  projective_compatible :
    ∀ (I J : Finset ι) (hJI : J ⊆ I),
      (realizeMultiCDF (F J) (multicdf J)).measure =
        ((realizeMultiCDF (F I) (multicdf I)).measure).map
          (Finset.restrict₂ (π := fun _ : ι => ℝ) hJI)

/-- The finite-dimensional measure extracted from the `J`-coordinate CDF. -/
noncomputable def finiteDimensionalLaw {ι : Type*}
    (F : ∀ J : Finset ι, ((_ : J) → ℝ) → ℝ)
    (hF : IsConsistentFiniteDimensionalCDF F) :
    ∀ J : Finset ι, Measure ((_ : J) → ℝ) :=
  fun J => (realizeMultiCDF (F J) (hF.multicdf J)).measure

/-- The finite-dimensional laws extracted from a consistent CDF family form a projective
measure family in Mathlib's sense. -/
theorem finiteDimensionalLaw_isProjectiveMeasureFamily {ι : Type*}
    (F : ∀ J : Finset ι, ((_ : J) → ℝ) → ℝ)
    (hF : IsConsistentFiniteDimensionalCDF F) :
    IsProjectiveMeasureFamily (α := fun _ : ι => ℝ) (finiteDimensionalLaw F hF) := by
  intro I J hJI
  simpa [finiteDimensionalLaw] using hF.projective_compatible I J hJI

/-- Extension package for the countable projective-family theorem. -/
structure ConsistentFiniteDimensionalCDFExtension {ι : Type*} [Countable ι]
    (F : ∀ J : Finset ι, ((_ : J) → ℝ) → ℝ) (hF : IsConsistentFiniteDimensionalCDF F) where
  measure : Measure ((_ : ι) → ℝ)
  isProbabilityMeasure : IsProbabilityMeasure measure
  isProjectiveLimit :
    IsProjectiveLimit (α := fun _ : ι => ℝ) measure (finiteDimensionalLaw F hF)

attribute [instance] ConsistentFiniteDimensionalCDFExtension.isProbabilityMeasure

/-- Narrow upstream boundary for the countable Kolmogorov extension theorem for a projective
probability family.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter III, §4, Hauptsatz, pp. 27-28; citation parent C. Carathéodory,
*Vorlesungen über reelle Funktionen* (1918). -/
axiom exists_projectiveLimit_of_countable_projective_probability_family {ι : Type*} [Countable ι]
    {α : ι → Type*} [∀ i, MeasurableSpace (α i)]
    (P : ∀ J : Finset ι, Measure (∀ j : J, α j))
    [∀ J, IsProbabilityMeasure (P J)]
    (hP : IsProjectiveMeasureFamily P) :
    ∃ μ : Measure (∀ i, α i), IsProjectiveLimit μ P

noncomputable def extendConsistentFiniteDimensionalCDF {ι : Type*} [Countable ι]
    (F : ∀ J : Finset ι, ((_ : J) → ℝ) → ℝ)
    (hF : IsConsistentFiniteDimensionalCDF F) :
    ConsistentFiniteDimensionalCDFExtension F hF := by
  have hP : IsProjectiveMeasureFamily (α := fun _ : ι => ℝ) (finiteDimensionalLaw F hF) :=
    finiteDimensionalLaw_isProjectiveMeasureFamily F hF
  haveI : ∀ J : Finset ι, IsProbabilityMeasure (finiteDimensionalLaw F hF J) := fun J => by
    dsimp [finiteDimensionalLaw]
    infer_instance
  let hExists :=
    exists_projectiveLimit_of_countable_projective_probability_family
      (ι := ι) (α := fun _ : ι => ℝ) (P := finiteDimensionalLaw F hF) hP
  let μ := Classical.choose hExists
  have hμ : IsProjectiveLimit (α := fun _ : ι => ℝ) μ (finiteDimensionalLaw F hF) :=
    Classical.choose_spec hExists
  exact
    { measure := μ
      isProbabilityMeasure := hμ.isProbabilityMeasure
      isProjectiveLimit := hμ }

theorem exists_probabilityMeasure_of_consistentFiniteDimensionalCDF {ι : Type*} [Countable ι]
    (F : ∀ J : Finset ι, ((_ : J) → ℝ) → ℝ)
    (hF : IsConsistentFiniteDimensionalCDF F) :
    ∃ μ : Measure ((_ : ι) → ℝ), IsProbabilityMeasure μ ∧
      IsProjectiveLimit (α := fun _ : ι => ℝ) μ (finiteDimensionalLaw F hF) := by
  let data := extendConsistentFiniteDimensionalCDF F hF
  exact ⟨data.measure, data.isProbabilityMeasure, data.isProjectiveLimit⟩

end Kolmogorov1933
end Probability
end MathlibExpansion
