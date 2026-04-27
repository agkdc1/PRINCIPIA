import Mathlib.Topology.MetricSpace.Completion
import Mathlib.Topology.Sequences

namespace MathlibExpansion
namespace Topology
namespace Metric

open Set
open Filter
open scoped Topology

/--
Hausdorff's total-boundedness subsequence extraction theorem: every sequence
in a totally bounded pseudometric set has a Cauchy subsequence.
-/
theorem exists_cauchySubseq_of_totallyBounded
    {α : Type*} [PseudoMetricSpace α] {s : Set α} {u : ℕ → α}
    (hu : ∀ n, u n ∈ s) (hs : TotallyBounded s) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧ CauchySeq (u ∘ φ) := by
  let e : α → UniformSpace.Completion α := fun x => x
  have hs_image : TotallyBounded (e '' s) :=
    hs.image (UniformSpace.Completion.uniformContinuous_coe α)
  have hcompact : IsCompact (closure (e '' s)) :=
    isCompact_of_totallyBounded_isClosed hs_image.closure isClosed_closure
  have hu_closure : ∀ n, e (u n) ∈ closure (e '' s) := by
    intro n
    exact subset_closure ⟨u n, hu n, rfl⟩
  rcases hcompact.tendsto_subseq hu_closure with ⟨a, _ha, φ, hφ, hlim⟩
  refine ⟨φ, hφ, ?_⟩
  have hcompletion : CauchySeq ((fun n => e (u n)) ∘ φ) :=
    hlim.cauchySeq
  rw [CauchySeq] at hcompletion ⊢
  exact ((UniformSpace.Completion.isUniformInducing_coe α).cauchy_map_iff
    (F := map (u ∘ φ) atTop)).1 (by
      simpa [e, Filter.map_map, Function.comp_def] using hcompletion)

end Metric
end Topology
end MathlibExpansion
