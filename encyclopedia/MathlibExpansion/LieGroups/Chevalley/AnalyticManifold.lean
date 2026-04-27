import Mathlib

/-!
# Chevalley analytic manifold substrate

This file packages the existing analytic-manifold and Lie-group structure on
open subsets of Banach algebras, with the units and general linear group as the
primary concrete carriers.
-/

open scoped Manifold ContDiff

noncomputable section

namespace MathlibExpansion.LieGroups.Chevalley

section Bridge

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
variable {H : Type*} [TopologicalSpace H]
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
variable {I : ModelWithCorners 𝕜 E H}
variable {M : Type*} [TopologicalSpace M] [ChartedSpace H M]

/--
Directly upgrade the legacy `AnalyticManifold` carrier to the modern analytic-manifold core
`IsManifold I ω`.
-/
instance analyticManifold_toIsManifoldOmega [AnalyticManifold I M] : IsManifold I ω M where
  compatible hf hg := by
    let cm : AnalyticManifold I M := inferInstance
    exact ⟨(cm.compatible hf hg).1.contDiffOn I.uniqueDiffOn_preimage_source,
      (cm.compatible hg hf).1.contDiffOn I.uniqueDiffOn_preimage_source⟩

end Bridge

/--
An analytic Lie group in the Chevalley sense: an analytic atlas together with a
`C^ω` Lie-group structure. In the concrete singleton-chart cases below, the
group operations are analytic in ambient coordinates and hence smooth of order
`ω`.
-/
class AnalyticLieGroup
    {𝕜 : Type*} [NontriviallyNormedField 𝕜]
    {H : Type*} [TopologicalSpace H]
    {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    (I : ModelWithCorners 𝕜 E H) (G : Type*)
    [Group G] [TopologicalSpace G] [ChartedSpace H G] : Prop where
  analyticManifold : AnalyticManifold I G
  lieGroup : LieGroup I ω G

attribute [instance] AnalyticLieGroup.analyticManifold AnalyticLieGroup.lieGroup

namespace Units

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
variable {R : Type*} [NormedRing R] [NormedAlgebra 𝕜 R] [CompleteSpace R]

instance analyticManifold : AnalyticManifold 𝓘(𝕜, R) Rˣ := by
  letI := Units.isOpenEmbedding_val.singleton_hasGroupoid (analyticGroupoid 𝓘(𝕜, R))
  exact {}

instance analyticLieGroup : AnalyticLieGroup 𝓘(𝕜, R) Rˣ := by
  exact ⟨inferInstance, inferInstance⟩

/-- The singleton ambient chart at the identity has full source. -/
theorem chartAt_one_source :
    (chartAt R (1 : Rˣ)).source = Set.univ :=
  Units.chartAt_source

/-- In the singleton ambient chart, evaluation is just coercion to the algebra. -/
theorem chartAt_one_apply (u : Rˣ) :
    chartAt R (1 : Rˣ) u = (u : R) :=
  Units.chartAt_apply

/-- Multiplication on `Rˣ`, read in ambient algebra coordinates, is analytic/smooth of order `ω`. -/
theorem contMDiff_mul_val :
    ContMDiff (𝓘(𝕜, R).prod 𝓘(𝕜, R)) 𝓘(𝕜, R) ω
      (fun p : Rˣ × Rˣ => ((p.1 * p.2 : Rˣ) : R)) := by
  simpa using
    ((Units.contMDiff_val (𝕜 := 𝕜) (R := R) (n := ω)).comp
      ((contMDiff_fst : ContMDiff (𝓘(𝕜, R).prod 𝓘(𝕜, R)) 𝓘(𝕜, R) ω
          fun p : Rˣ × Rˣ => p.1).mul
        (contMDiff_snd : ContMDiff (𝓘(𝕜, R).prod 𝓘(𝕜, R)) 𝓘(𝕜, R) ω
          fun p : Rˣ × Rˣ => p.2)))

/-- Inversion on `Rˣ`, read in ambient algebra coordinates, is analytic/smooth of order `ω`. -/
theorem contMDiff_inv_val :
    ContMDiff 𝓘(𝕜, R) 𝓘(𝕜, R) ω (fun u : Rˣ => ((u⁻¹ : Rˣ) : R)) := by
  simpa using
    (Units.contMDiff_val (𝕜 := 𝕜) (R := R) (n := ω)).comp
      (contMDiff_id.inv : ContMDiff 𝓘(𝕜, R) 𝓘(𝕜, R) ω fun u : Rˣ => u⁻¹)

end Units

section GeneralLinear

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
variable {V : Type*} [NormedAddCommGroup V] [NormedSpace 𝕜 V] [CompleteSpace V]

/-- Chevalley's concrete matrix-model carrier for `GL(V)`. -/
abbrev GeneralLinearGroup := (V →L[𝕜] V)ˣ

instance generalLinearAnalyticLieGroup :
    AnalyticLieGroup 𝓘(𝕜, V →L[𝕜] V) (GeneralLinearGroup (𝕜 := 𝕜) (V := V)) := by
  exact ⟨inferInstance, inferInstance⟩

end GeneralLinear

end MathlibExpansion.LieGroups.Chevalley
