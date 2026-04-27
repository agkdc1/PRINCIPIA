import Mathlib.Topology.DerivedSet

namespace MathlibExpansion
namespace Topology
namespace HausdorffAxioms

open Filter Set

variable {X : Type*} [TopologicalSpace X]

/-- Hausdorff's contact-point set `Aₐ`, packaged as modern closure. -/
abbrev contactSet (A : Set X) : Set X :=
  closure A

/-- Hausdorff's derived set `A_b`, packaged as modern accumulation points. -/
abbrev derivedSet (A : Set X) : Set X :=
  { x | AccPt x (𝓟 A) }

/-- Isolated points of `A`, i.e. the complement of the derived set inside `A`. -/
abbrev isolatedPoints (A : Set X) : Set X :=
  A \ derivedSet A

/-- Hausdorff's decomposition `Aₐ = A ∪ A_b`. -/
theorem closure_eq_self_union_derivedSet (A : Set X) :
    closure A = A ∪ derivedSet A := by
  ext x
  simp [derivedSet, mem_closure_iff_clusterPt, clusterPt_principal]

/-- Alias using the accumulation-point wording from the recon report. -/
theorem closure_eq_self_union_accPts (A : Set X) :
    closure A = A ∪ { x | AccPt x (𝓟 A) } :=
  closure_eq_self_union_derivedSet A

end HausdorffAxioms
end Topology
end MathlibExpansion
