import Mathlib.Topology.Connected.Clopen
import Mathlib.Topology.Separation.Regular
import MathlibExpansion.Topology.Metric.ChainConnected

namespace MathlibExpansion
namespace Topology
namespace Connected

/--
The quasicomponent of `x`: the intersection of all clopen neighbourhoods of `x`.

Historical source: Kuratowski, *Topologie II* (1950), Ch. V, Section 41,
quasicomponents as intersections of simultaneously closed and open
neighbourhoods; Hausdorff, *Grundzuege der Mengenlehre* (1914), Kap. VIII,
Section 6, pp. 301--303, for the compact metric comparison with components and
`0`-components.
-/
def quasicomponent {α : Type*} [TopologicalSpace α] (x : α) : Set α :=
  ⋂ Z : { Z : Set α // IsClopen Z ∧ x ∈ Z }, (Z : Set α)

/--
The definition of `quasicomponent` unfolds to the textbook clopen-neighbourhood
intersection.
-/
theorem quasicomponent_eq_iInter_isClopen {α : Type*} [TopologicalSpace α] (x : α) :
    quasicomponent x = ⋂ Z : { Z : Set α // IsClopen Z ∧ x ∈ Z }, (Z : Set α) :=
  rfl

/--
Every connected component is contained in the corresponding quasicomponent.

This is Mathlib's `connectedComponent_subset_iInter_isClopen` restated for the
textbook-facing carrier.
-/
theorem connectedComponent_subset_quasicomponent {α : Type*} [TopologicalSpace α] (x : α) :
    connectedComponent x ⊆ quasicomponent x := by
  simpa [quasicomponent] using (connectedComponent_subset_iInter_isClopen (x := x))

/--
In a compact Hausdorff space, connected components and quasicomponents coincide.

Historical source: Kuratowski, *Topologie II* (1950), Ch. V, Section 41;
formal owner in Mathlib is `connectedComponent_eq_iInter_isClopen`.
-/
theorem connectedComponent_eq_quasicomponent
    {α : Type*} [TopologicalSpace α] [T2Space α] [CompactSpace α] (x : α) :
    connectedComponent x = quasicomponent x := by
  simpa [quasicomponent] using (connectedComponent_eq_iInter_isClopen x)

/--
Compact-metric coincidence of components, quasicomponents, and `0`-components.

Historical source: Hausdorff, *Grundzuege der Mengenlehre* (1914), Kap. VIII,
Section 6, p. 303, compact closed metric sets: components, quasicomponents, and
`0`-components coincide. The present wrapper is the ambient compact-metric
version used by the expansion: Mathlib supplies the compact-T2
component/quasicomponent equality, and
`MathlibExpansion.Topology.Metric.zeroComponent` is definitionally
`connectedComponent`.
-/
theorem connectedComponent_eq_quasicomponent_eq_zeroComponent
    {α : Type*} [PseudoMetricSpace α] [CompactSpace α] [T2Space α]
    {s : Set α} (hs : IsClosed s) {x : α} (hx : x ∈ s) :
    connectedComponent x = quasicomponent x ∧
      quasicomponent x = MathlibExpansion.Topology.Metric.zeroComponent x := by
  have _hs : IsClosed s := hs
  have _hx : x ∈ s := hx
  constructor
  · exact connectedComponent_eq_quasicomponent x
  · simpa [MathlibExpansion.Topology.Metric.zeroComponent] using
      (connectedComponent_eq_quasicomponent (x := x)).symm

end Connected
end Topology
end MathlibExpansion
