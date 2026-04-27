import Mathlib.Topology.Compactness.Compact
import Mathlib.Topology.Separation.Hausdorff

namespace MathlibExpansion
namespace Topology
namespace Hausdorff

open Set

variable {α : Type*} [TopologicalSpace α] [T2Space α]

/--
Hausdorff's converse-of-Borel wrapper: a compact subset of a Hausdorff space is
closed.
-/
theorem hausdorff_borel_converse {s : Set α}
    (hs : IsCompact s) :
    IsCompact s ∧ IsClosed s :=
  ⟨hs, hs.isClosed⟩

end Hausdorff
end Topology
end MathlibExpansion
