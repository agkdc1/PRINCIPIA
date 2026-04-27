import Mathlib.Topology.Perfect

namespace MathlibExpansion
namespace Topology
namespace Connected

open Set

variable {α : Type*} [TopologicalSpace α] [T1Space α]

/-- A nontrivial connected set is dense-in-itself. -/
theorem IsConnected.preperfect_of_nontrivial {s : Set α}
    (hs : IsConnected s) (hnt : s.Nontrivial) :
    Preperfect s :=
  hs.isPreconnected.preperfect_of_nontrivial hnt

/-- A nontrivial closed connected set is perfect. -/
theorem IsConnected.perfect_of_nontrivial_closed {s : Set α}
    (hs : IsConnected s) (hcl : IsClosed s) (hnt : s.Nontrivial) :
    Perfect s :=
  ⟨hcl, hs.isPreconnected.preperfect_of_nontrivial hnt⟩

end Connected
end Topology
end MathlibExpansion
