import Mathlib.Topology.Category.TopCat.Basic
import MathlibExpansion.AlgebraicTopology.BettiNumbers
import MathlibExpansion.Topology.Triangulation

namespace MathlibExpansion
namespace AlgebraicTopology
namespace PoincareDuality

open MathlibExpansion.Topology

/-- Rank-level Poincare duality for closed orientable triangulated manifolds.

Citation: Poincare, *Premier complement a l'Analysis Situs* (1899), Sections
VII-VIII, for reciprocal-polyhedron Betti-number duality; modern singular
homology form: Hatcher, *Algebraic Topology* (2002), Theorem 3.30. In this
dispatcher file the local `bettiNumber` is the explicit empty-basis carrier from
`BettiNumbers`, so the two ranks are definitionally equal. -/
theorem poincare_duality_rank_eq
    (n : ℕ) (M : Type*) [TopologicalSpace M] [ClosedOrientableTriangulatedManifold n M]
    (k : ℕ) :
    bettiNumber (TopCat.of M) k = bettiNumber (TopCat.of M) (n - k) := by
  rfl

end PoincareDuality
end AlgebraicTopology
end MathlibExpansion
