import MathlibExpansion.Topology.HausdorffAxioms.NeighborhoodSeparation

namespace MathlibExpansion
namespace Encyclopedia
namespace T20c_07

/--
Historical defer ledger for Hausdorff 1914, *Grundzuege der Mengenlehre*,
Kap. VII, SS 2, p. 217, formula (6): the intersection of all neighborhoods of
a point is exactly that point.
-/
theorem sInter_nhds_eq_singleton_historical
    {X : Type*} [TopologicalSpace X] [T2Space X] (x : X) :
    Set.sInter {s : Set X | s ∈ nhds x} = ({x} : Set X) := by
  simpa using MathlibExpansion.Topology.HausdorffAxioms.sInter_nhds_eq_singleton (X := X) x

end T20c_07
end Encyclopedia
end MathlibExpansion
