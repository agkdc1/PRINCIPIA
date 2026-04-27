import MathlibExpansion.AlgebraicTopology.BettiNumbers
import MathlibExpansion.Topology.Triangulation

namespace MathlibExpansion
namespace AlgebraicTopology
namespace PoincareDuality

open MathlibExpansion.Topology

/-- Integral torsion duality for closed orientable triangulated manifolds.

Citation: Poincare, *Deuxieme complement a l'Analysis Situs* (1900), Section 5,
torsion-coefficient duality for reciprocal cycles. At the present dispatcher
layer `integralHomology` is the `PUnit` carrier from `BettiNumbers`, independent
of degree, so the two torsion carriers are definitionally identical; the genuine
singular/cellular homology theorem remains the upstream replacement target. -/
noncomputable def poincare_torsion_duality
    (n : ℕ) (M : Type*) [TopologicalSpace M] [ClosedOrientableTriangulatedManifold n M]
    (k : ℕ) :
    torsionSubgroup (integralHomology (TopCat.of M) k) ≃+
      torsionSubgroup (integralHomology (TopCat.of M) (n - k - 1)) :=
  AddEquiv.refl _

end PoincareDuality
end AlgebraicTopology
end MathlibExpansion
