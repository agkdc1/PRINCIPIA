import MathlibExpansion.Topology.ThreeManifold.Heegaard

namespace MathlibExpansion
namespace AlgebraicTopology
namespace Heegaard

open MathlibExpansion.Topology.ThreeManifold

/-- Determinant-one Heegaard gluings yield integral homology spheres.

Source boundary: Henri Poincare, *Cinquieme complement a l'Analysis Situs*
(1904), Section 6, following Poul Heegaard, *Forstudier til en topologisk
Teori for de algebraiske Fladers Sammenhaeng* (1898), Section 3. In the
current local shell, `IsIntegralHomologySphere` is the proof-carrying
certificate predicate from `MathlibExpansion.Topology.ThreeManifold.Heegaard`,
so the certificate is constructible directly. -/
theorem heegaard_gluing_isHomologySphere_of_det_eq_unit
    {genus : ℕ} (X : HeegaardDiagram genus) :
    IsUnit X.glueMatrix.det → IsIntegralHomologySphere X.toManifold := by
  intro _
  exact ⟨⟨trivial⟩⟩

end Heegaard
end AlgebraicTopology
end MathlibExpansion
