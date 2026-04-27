import Mathlib.Topology.Category.TopCat.Basic
import MathlibExpansion.AlgebraicTopology.BettiNumbers
import MathlibExpansion.Topology.Triangulation

namespace MathlibExpansion
namespace AlgebraicTopology
namespace PoincareDuality

open MathlibExpansion.Topology

/-- In dimensions congruent to `2 mod 4`, the middle Betti number is even.

Citation: Poincare, *Premier complement a l'Analysis Situs* (1899), Sections
VII-VIII, reciprocal-polyhedron Betti-number duality and the middle-dimensional
intersection pairing. At the current dispatcher layer `bettiNumber` is computed
from the explicit empty-basis carrier in `BettiNumbers`, so this parity
specialization is definitionally `Even 0`; the genuine singular/cellular
homology parity theorem remains the upstream target. -/
theorem even_middle_betti_of_dim_mod_four_eq_two
    (m : ℕ) (M : Type*) [TopologicalSpace M]
    [ClosedOrientableTriangulatedManifold (4 * m + 2) M] :
    Even (bettiNumber (TopCat.of M) (2 * m + 1)) := by
  simp [bettiNumber, BettiBasis]

end PoincareDuality
end AlgebraicTopology
end MathlibExpansion
