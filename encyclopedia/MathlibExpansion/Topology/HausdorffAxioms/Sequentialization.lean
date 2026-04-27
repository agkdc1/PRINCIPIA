import Mathlib.Order.Filter.AtTopBot.CountablyGenerated
import Mathlib.Topology.Bases
import Mathlib.Topology.Sequences

namespace MathlibExpansion
namespace Topology
namespace HausdorffAxioms

open Filter Set

variable {X : Type*} [TopologicalSpace X] [FirstCountableTopology X]

/--
If `x` is an accumulation point of `B`, then there is a sequence in `B`
converging to `x`.
-/
theorem exists_seq_tendsto_of_accPt {B : Set X} {x : X} (hx : AccPt x (𝓟 B)) :
    ∃ u : ℕ → X, (∀ n, u n ∈ B) ∧ Tendsto u atTop (nhds x) := by
  rw [accPt_iff_frequently] at hx
  rcases Filter.exists_seq_forall_of_frequently hx with ⟨u, hu_tendsto, hu_mem⟩
  exact ⟨u, fun n => (hu_mem n).2, hu_tendsto⟩

/--
In a first-countable space, membership in the closure of `B` is equivalent to
being the limit of a sequence contained in `B`.
-/
theorem mem_closure_iff_exists_seq_tendsto {B : Set X} {x : X} :
    x ∈ closure B ↔ ∃ u : ℕ → X, (∀ n, u n ∈ B) ∧ Tendsto u atTop (nhds x) := by
  simpa using mem_closure_iff_seq_limit (s := B) (a := x)

/--
If `x` is a cluster point of a sequence in a first-countable space, then some
subsequence converges to `x`.
-/
theorem exists_subseq_tendsto_of_mapClusterPt {u : ℕ → X} {x : X}
    (hx : MapClusterPt x atTop u) :
    ∃ ψ : ℕ → ℕ, StrictMono ψ ∧ Tendsto (u ∘ ψ) atTop (nhds x) :=
  Filter.subseq_tendsto_of_neBot hx

end HausdorffAxioms
end Topology
end MathlibExpansion
