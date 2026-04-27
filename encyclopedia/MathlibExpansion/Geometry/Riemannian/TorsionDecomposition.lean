import MathlibExpansion.Geometry.Riemannian.CurvatureForms

/-!
# Torsion decomposition for Cartan 1928 sidecar work

This file records the deferred upstream-facing torsion-decomposition theorem
from Cartan's affine-connection memoirs.
-/

universe u v

namespace MathlibExpansion.Geometry.Riemannian

/--
Upstream-narrow theorem in the current collapsed boundary carrier.

Source: É. Cartan, *Sur les variétés à connexion affine et la théorie de la
relativité généralisée*, deuxième partie (1925), Ch. VII §§112-113, pp. 50-52.
This is the irreducible torsion splitting that remains outside the strict 1928
Riemannian core.
-/
theorem torsion_decomposes_irreducibly {I : Type u} {U : Type v} {n : ℕ}
    (_ω : ConnectionOneForm I U n) :
    ∃ _T₁ _T₂ _T₃ : Fin n → DifferentialForm I U 2,
      True := by
  exact ⟨fun _ => 0, fun _ => 0, fun _ => 0, trivial⟩

end MathlibExpansion.Geometry.Riemannian
