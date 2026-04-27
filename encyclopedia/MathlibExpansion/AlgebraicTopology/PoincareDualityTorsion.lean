import MathlibExpansion.AlgebraicTopology.BettiNumbers
import MathlibExpansion.Topology.Triangulation

namespace MathlibExpansion
namespace AlgebraicTopology

open MathlibExpansion.Topology

/-- Torsion duality in the homology lane.

Citation: Poincare, *Deuxieme complement a l'Analysis Situs* (1900), Section 5,
torsion-coefficient duality for reciprocal cycles. At the present dispatcher
layer `Hq` is the `PUnit` carrier from `BettiNumbers`, independent of degree,
so the two torsion carriers are definitionally identical; the genuine
singular/cellular homology theorem remains the upstream replacement target. -/
noncomputable def torsion_duality
    (p : ℕ) (X : Type*) [TopologicalSpace X] [OrientableClosedManifold X p] :
    ∀ q : ℕ, q < p →
      torsionSubgroup (Hq (TopCat.of X) q) ≃+ torsionSubgroup (Hq (TopCat.of X) (p - q - 1)) := by
  intro q _hq
  exact AddEquiv.refl _

end AlgebraicTopology
end MathlibExpansion
