import Mathlib

/-!
# Analytic submanifolds and immersions

This file records the open-submanifold fragment of analytic submanifold theory
that can already be expressed directly with Mathlib's manifold infrastructure.
-/

noncomputable section

open scoped Manifold

namespace MathlibExpansion.LieGroups.Chevalley

/-- The currently available analytic-submanifold surface: open analytic pieces. -/
abbrev AnalyticOpenSubmanifold (M : Type*) [TopologicalSpace M] := TopologicalSpace.Opens M

/-- An open embedding is the honest immersion-like surface presently available here. -/
def IsAnalyticOpenImmersion {M N : Type*} [TopologicalSpace M] [TopologicalSpace N]
    (f : M → N) : Prop :=
  Topology.IsOpenEmbedding f

section

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
variable {H : Type*} [TopologicalSpace H]
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
variable {I : ModelWithCorners 𝕜 E H}
variable {M : Type*} [TopologicalSpace M] [ChartedSpace H M] [AnalyticManifold I M]

instance instAnalyticManifoldOpens (U : TopologicalSpace.Opens M) : AnalyticManifold I U where
  compatible := by
    intro e e' he he'
    exact (analyticGroupoid I).compatible he he'

theorem subtype_val_isAnalyticOpenImmersion (U : AnalyticOpenSubmanifold M) :
    IsAnalyticOpenImmersion (fun x : U => (x : M)) := by
  exact U.isOpen.isOpenEmbedding_subtypeVal

theorem contMDiff_subtype_val_analyticOpenSubmanifold (U : AnalyticOpenSubmanifold M) :
    ContMDiff I I ω (fun x : U => (x : M)) := by
  simpa using (_root_.contMDiff_subtype_val (I := I) (U := U) (n := ω))

theorem exists_local_chart (U : AnalyticOpenSubmanifold M) (x : U) :
    ∃ e : PartialHomeomorph U H, x ∈ e.source ∧ e ∈ atlas H U := by
  exact ⟨chartAt H x, mem_chart_source H x, chart_mem_atlas H x⟩

end

end MathlibExpansion.LieGroups.Chevalley
