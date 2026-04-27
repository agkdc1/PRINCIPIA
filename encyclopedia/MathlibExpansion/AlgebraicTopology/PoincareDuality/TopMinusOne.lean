import Mathlib.Topology.Category.TopCat.Basic
import MathlibExpansion.AlgebraicTopology.TopHomologyTorsionFree
import MathlibExpansion.Topology.Triangulation

namespace MathlibExpansion
namespace AlgebraicTopology
namespace PoincareDuality

open MathlibExpansion.Topology

/-- The top-minus-one integral homology group of a closed orientable manifold is
torsion-free.

Citation: Henri Poincare, *Deuxieme complement a l'Analysis Situs* (1900),
Section 6. This wrapper is discharged by the local dispatcher theorem
`torsionFree_homology_predim`. -/
theorem integral_homology_top_minus_one_torsion_free
    (n : ℕ) (M : Type*) [TopologicalSpace M] [ClosedOrientableTriangulatedManifold n M] :
    TorsionFreeIntegralHomology (TopCat.of M) (n - 1) :=
  torsionFree_homology_predim n M

end PoincareDuality
end AlgebraicTopology
end MathlibExpansion
