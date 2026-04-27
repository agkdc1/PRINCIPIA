import Mathlib

/-!
# Chevalley topological group preliminaries

This file records the point-set group lemmas from the opening of Chevalley's
*Theory of Lie Groups I* that already exist in Mathlib's topological-group
infrastructure.
-/

open Set
open scoped Topology

namespace MathlibExpansion.LieGroups.Chevalley

section TopologicalGroup

variable (G : Type*) [TopologicalSpace G] [Group G] [IsTopologicalGroup G]

/-- The identity component is a closed subgroup. -/
theorem connectedComponent_one_isClosed :
    IsClosed (((Subgroup.connectedComponentOfOne G : Subgroup G) : Set G)) := by
  simpa [Subgroup.connectedComponentOfOne] using
    (isClosed_connectedComponent (x := (1 : G)))

/-- The identity component is normal. -/
theorem connectedComponent_one_normal :
    (Subgroup.connectedComponentOfOne G).Normal := by
  refine
    { conj_mem := ?_ }
  intro n hn g
  let c : G → G := fun x => g * x * g⁻¹
  have hc : Continuous c := (continuous_const.mul continuous_id).mul continuous_const
  have himage := Continuous.image_connectedComponent_subset hc (1 : G)
  have hmem : c n ∈ connectedComponent (c (1 : G)) := by
    exact himage <| mem_image_of_mem c hn
  simpa [c, mul_assoc] using hmem

/--
Every neighborhood of the identity in a locally compact Hausdorff group contains
a compact symmetric neighborhood of the identity.
-/
theorem exists_compact_symmetric_nhds_subset [T2Space G] [LocallyCompactSpace G] {U : Set G}
    (hU : U ∈ 𝓝 (1 : G)) :
    ∃ K : Set G, K ∈ 𝓝 (1 : G) ∧ IsCompact K ∧ K⁻¹ = K ∧ K ⊆ U := by
  rcases exists_closed_nhds_one_inv_eq_mul_subset (G := G) hU with
    ⟨V, hVnhds, hVclosed, hVsymm, hVmul⟩
  have hVsubset : V ⊆ U := by
    intro x hx
    have h1 : (1 : G) ∈ V := mem_of_mem_nhds hVnhds
    exact hVmul ⟨x, hx, 1, h1, by simp⟩
  rcases local_compact_nhds (x := (1 : G)) (n := V) hVnhds with
    ⟨K0, hK0nhds, hK0sub, hK0compact⟩
  let K : Set G := K0 ∩ K0⁻¹
  have hKnhds : K ∈ 𝓝 (1 : G) :=
    Filter.inter_mem hK0nhds (inv_mem_nhds_one G hK0nhds)
  have hKcompact : IsCompact K := by
    simpa [K] using hK0compact.inter hK0compact.inv
  have hKsymm : K⁻¹ = K := by
    ext x
    simp only [K, Set.mem_inv, Set.mem_inter_iff]
    constructor <;> intro hx <;> simpa using And.intro hx.2 hx.1
  refine ⟨K, hKnhds, hKcompact, hKsymm, ?_⟩
  intro x hx
  exact hVsubset (hK0sub hx.1)

end TopologicalGroup

end MathlibExpansion.LieGroups.Chevalley
