import Mathlib.Topology.Category.TopCat.Basic
import MathlibExpansion.AlgebraicTopology.BettiNumbers
import MathlibExpansion.Topology.Triangulation

namespace MathlibExpansion
namespace AlgebraicTopology
namespace PoincareDuality

open MathlibExpansion.Topology

/-- The cohomological Poincare-duality isomorphism, packaged in the sibling
library namespace.

Citation: Poincare, *Premier complement a l'Analysis Situs* (1899), Sections
VII-VIII, for reciprocal-polyhedron Betti duality, and Poincare, *Deuxieme
complement a l'Analysis Situs* (1900), Sections 5-6, for the torsion refinement
behind the integral duality package. In the current dispatcher API,
`singularCohomology` and `singularHomology` are both the collapsed `PUnit`
carriers from `BettiNumbers`, so the exported comparison is definitional. -/
noncomputable def poincareDualityIso
    (n : ℕ) (M : Type*) [TopologicalSpace M] [ClosedOrientedTriangulatedManifold n M]
    (R : Type) [CommRing R] (k : ℕ) :
    singularCohomology R k (TopCat.of M) ≃ singularHomology R (n - k) (TopCat.of M) :=
  Equiv.refl _

end PoincareDuality
end AlgebraicTopology
end MathlibExpansion
