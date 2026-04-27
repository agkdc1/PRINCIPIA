import Mathlib

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace ClosedGraph

open Filter Topology

variable {𝕜 E F G : Type*}
variable [NontriviallyNormedField 𝕜]

/--
Source: S. Banach, *Théorie des opérations linéaires* (1932), Ch. III §2, Théorème 7,
p. 54. Banach's sequential closed-graph theorem, specialized to the Banach-space linear-map form
available upstream as `LinearMap.continuous_of_seq_closed_graph`.
-/
theorem continuous_of_seq_closed_graph_fspace
    [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    [NormedAddCommGroup F] [NormedSpace 𝕜 F]
    [CompleteSpace E] [CompleteSpace F]
    (U : E →ₗ[𝕜] F)
    (hgraph : ∀ (u : ℕ → E) (x : E) (y : F),
      Tendsto u atTop (𝓝 x) →
      Tendsto (fun n => U (u n)) atTop (𝓝 y) →
      y = U x) :
    Continuous U := by
  simpa [Function.comp_def] using U.continuous_of_seq_closed_graph hgraph

/--
Source: S. Banach, *Théorie des opérations linéaires* (1932), Ch. III §2, Théorème 8,
p. 55. Banach's total-family postcomposition criterion. In this discharged Banach-space
specialization the testing family consists of continuous linear maps, so graph limits can be
tested in the Hausdorff codomain.
-/
theorem continuous_of_total_family_postcomp_fspace
    [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    [NormedAddCommGroup F] [NormedSpace 𝕜 F]
    [NormedAddCommGroup G] [NormedSpace 𝕜 G]
    [CompleteSpace E] [CompleteSpace F] [CompleteSpace G]
    (U : E →ₗ[𝕜] F) (T : Set (F →L[𝕜] G))
    (h_total : ∀ z : F, (∀ V, V ∈ T → V z = 0) → z = 0)
    (h_comp : ∀ V, V ∈ T → Continuous (fun x => V (U x))) :
    Continuous U := by
  refine continuous_of_seq_closed_graph_fspace (𝕜 := 𝕜) U ?_
  intro u x y hu hUy
  have hzero : y - U x = 0 := by
    apply h_total (y - U x)
    intro V hV
    have hVy : Tendsto (fun n => V (U (u n))) atTop (𝓝 (V y)) :=
      V.continuous.tendsto y |>.comp hUy
    have hVUx : Tendsto (fun n => V (U (u n))) atTop (𝓝 (V (U x))) :=
      (h_comp V hV).tendsto x |>.comp hu
    have hlim : V y = V (U x) := tendsto_nhds_unique hVy hVUx
    simp [map_sub, hlim]
  exact sub_eq_zero.mp hzero

/--
Source: S. Banach, *Théorie des opérations linéaires* (1932), Ch. III §2, Théorème 9,
p. 55. Banach's unique-solution family criterion. This Banach-space specialization reduces the
closed graph of the induced map to uniqueness after passing limits through continuous linear
families.
-/
theorem continuous_of_unique_solution_family_fspace
    {ι : Type*}
    [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    [NormedAddCommGroup F] [NormedSpace 𝕜 F]
    [NormedAddCommGroup G] [NormedSpace 𝕜 G]
    [CompleteSpace E] [CompleteSpace F] [CompleteSpace G]
    (U : E →ₗ[𝕜] F) (Us : ι → F →L[𝕜] G) (Vs : ι → E →L[𝕜] G)
    (hrel : ∀ x : E, ∀ i : ι, Us i (U x) = Vs i x)
    (huniq : ∀ x : E, ∀ y : F, (∀ i : ι, Us i y = Vs i x) → y = U x) :
    Continuous U := by
  refine continuous_of_seq_closed_graph_fspace (𝕜 := 𝕜) U ?_
  intro u x y hu hUy
  apply huniq x y
  intro i
  have hUs : Tendsto (fun n => Us i (U (u n))) atTop (𝓝 (Us i y)) :=
    (Us i).continuous.tendsto y |>.comp hUy
  have hVs : Tendsto (fun n => Vs i (u n)) atTop (𝓝 (Vs i x)) :=
    (Vs i).continuous.tendsto x |>.comp hu
  have hseq : (fun n => Us i (U (u n))) = fun n => Vs i (u n) := by
    funext n
    exact hrel (u n) i
  have hUs' : Tendsto (fun n => Vs i (u n)) atTop (𝓝 (Us i y)) := by
    simpa [hseq] using hUs
  exact tendsto_nhds_unique hUs' hVs

end ClosedGraph
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
