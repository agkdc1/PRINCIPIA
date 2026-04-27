import Mathlib.Topology.Connected.Basic
import Mathlib.Topology.Instances.Real.Defs
import Mathlib.Topology.MetricSpace.Pseudo.Constructions
import Mathlib.Topology.Order.IntermediateValue

namespace MathlibExpansion
namespace Topology
namespace Metric

open Set

variable {α : Type*} [PseudoMetricSpace α]

/--
In a connected metric set, every intermediate distance from a chosen basepoint
is realized by some point of the set.
-/
theorem IsConnected.exists_mem_eq_dist {s : Set α} (hs : IsConnected s) {a b : α}
    (ha : a ∈ s) (hb : b ∈ s) {r : ℝ} (hr : r ∈ Set.Icc 0 (dist a b)) :
    ∃ x ∈ s, dist a x = r := by
  have hr' : r ∈ Set.Icc (dist a a) (dist a b) := by simpa using hr
  have himage : r ∈ (fun x => dist a x) '' s :=
    hs.isPreconnected.intermediate_value ha hb (continuous_const.dist continuous_id).continuousOn hr'
  rcases himage with ⟨x, hx_s, hx_r⟩
  exact ⟨x, hx_s, hx_r⟩

end Metric
end Topology
end MathlibExpansion
