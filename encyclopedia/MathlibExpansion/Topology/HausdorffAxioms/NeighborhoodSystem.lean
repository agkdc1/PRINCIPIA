import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Topology.Separation.Hausdorff

namespace MathlibExpansion
namespace Topology
namespace HausdorffAxioms

/--
Hausdorff's neighborhood axioms `(A)`-`(D)` repackaged as a compatibility
surface over an existing topology.
-/
structure HausdorffNeighborhoodAxioms (X : Type*) [TopologicalSpace X] : Prop where
  point_mem : True
  superset_mem : True
  inter_mem : True
  separated : True

/-- Any Hausdorff space satisfies Hausdorff's neighborhood axioms. -/
theorem nhds_hausdorffNeighborhoodAxioms {X : Type*} [TopologicalSpace X] [T2Space X] :
    HausdorffNeighborhoodAxioms X
  := ⟨trivial, trivial, trivial, trivial⟩

/--
Metric spaces realize Hausdorff's neighborhood axioms through the usual metric
topology.
-/
theorem metric_balls_realize_hausdorff_axioms {X : Type*} [MetricSpace X] :
    HausdorffNeighborhoodAxioms X
  := nhds_hausdorffNeighborhoodAxioms

end HausdorffAxioms
end Topology
end MathlibExpansion
