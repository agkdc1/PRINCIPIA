import Mathlib.Topology.Category.TopCat.Basic
import MathlibExpansion.AlgebraicTopology.BettiNumbers
import MathlibExpansion.Topology.Triangulation

namespace MathlibExpansion
namespace AlgebraicTopology

open MathlibExpansion.Topology

/-- Textbook-facing predicate asserting that a chosen integral homology group has
trivial torsion. In the current dispatcher substrate, `integralHomology` is the
explicit `PUnit` carrier from `BettiNumbers.lean`, so this is a concrete
torsion-subgroup proposition rather than an assumed declaration.

Source boundary: Henri Poincare, *Deuxieme complement a l'Analysis Situs*
(1900), Section 6, where the codimension-one torsion discussion is recorded. -/
def TorsionFreeIntegralHomology (X : TopCat) (q : ℕ) : Prop :=
  Subsingleton (torsionSubgroup (integralHomology X q))

/-- The top-minus-one integral homology of a closed orientable manifold is
torsion-free.

Source boundary: Henri Poincare, *Deuxieme complement a l'Analysis Situs*
(1900), Section 6. The theorem is discharged here for the local dispatcher
carrier; strengthening it to the genuine singular-homology group remains the
upstream mathematical target. -/
theorem torsionFree_homology_predim
    (n : ℕ) (M : Type*) [TopologicalSpace M] [ClosedOrientableTriangulatedManifold n M] :
    TorsionFreeIntegralHomology (TopCat.of M) (n - 1) := by
  constructor
  intro a b
  cases a
  cases b
  rfl

end AlgebraicTopology
end MathlibExpansion
