import Mathlib

/-!
# Haar measure bridge

This file exposes the invariant-integration API that connects Lie-group work to
Mathlib's Haar measure machinery.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion.LieGroups.Chevalley

section

variable {G : Type*} [Group G] [TopologicalSpace G] [MeasurableSpace G] [BorelSpace G]
variable [LocallyCompactSpace G] [MeasurableMul G] [MeasurableInv G]
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

theorem integral_left_translate_eq_self {μ : Measure G} [Measure.IsMulLeftInvariant μ]
    (f : G → E) (g : G) :
    (∫ x, f (g * x) ∂μ) = ∫ x, f x ∂μ := by
  simpa using MeasureTheory.integral_mul_left_eq_self (μ := μ) (f := f) g

theorem integrable_comp_left_translate {μ : Measure G} [Measure.IsMulLeftInvariant μ]
    {f : G → E} (hf : Integrable f μ) (g : G) :
    Integrable (fun x => f (g * x)) μ := by
  simpa using hf.comp_mul_left g

theorem normalizedHaar_unique_on_compact [IsTopologicalGroup G] [CompactSpace G]
    (μ ν : Measure G)
    [Measure.IsHaarMeasure μ] [Measure.IsHaarMeasure ν]
    [IsProbabilityMeasure μ] [IsProbabilityMeasure ν] :
    μ = ν := by
  simpa using Measure.isHaarMeasure_eq_of_isProbabilityMeasure (μ' := μ) (μ := ν)

theorem compact_probabilityHaar_isMulRightInvariant [IsTopologicalGroup G] [CompactSpace G]
    (μ : Measure G) [Measure.IsHaarMeasure μ] [IsProbabilityMeasure μ] :
    Measure.IsMulRightInvariant μ := by
  constructor
  intro g
  letI : IsProbabilityMeasure (Measure.map (fun x => x * g) μ) := by
    refine ⟨?_⟩
    rw [Measure.map_apply (measurable_mul_const g) MeasurableSet.univ]
    simp
  exact Measure.isHaarMeasure_eq_of_isProbabilityMeasure
    (μ' := Measure.map (fun x => x * g) μ) (μ := μ)

theorem finiteDimensional_lieGroup_locallyCompact
    {H : Type*} [TopologicalSpace H]
    {E' : Type*} [NormedAddCommGroup E'] [NormedSpace ℝ E'] [FiniteDimensional ℝ E']
    {I : ModelWithCorners ℝ E' H}
    {M : Type*} [TopologicalSpace M] [ChartedSpace H M] :
    LocallyCompactSpace M := by
  letI : LocallyCompactSpace E' := inferInstance
  letI : LocallyCompactSpace H := I.locallyCompactSpace
  exact ChartedSpace.locallyCompactSpace H M

end

end MathlibExpansion.LieGroups.Chevalley
