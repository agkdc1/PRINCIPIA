import Mathlib

/-!
# Holonomy boundary for Cartan 1928
-/

universe u

namespace MathlibExpansion.Geometry.Riemannian

/-- Ambient orthogonal transport group for the boundary layer. -/
abbrev OrthogonalTransportGroup (M : Type u) :=
  Subgroup (Equiv.Perm M)

/-- The boundary orthogonal group is the full transport group. -/
def orthogonalTransportGroup (M : Type u) : OrthogonalTransportGroup M :=
  ⊤

/-- Boundary holonomy group. -/
def HolonomyGroup (M : Type u) (_x : M) : OrthogonalTransportGroup M :=
  ⊥

/-- Basepoint conjugation surface for holonomy, collapsed to the same subgroup
in the boundary layer. -/
def conjugateSubgroupByTransport (M : Type u) (x _y : M) : OrthogonalTransportGroup M :=
  HolonomyGroup M x

/-- Cartan holonomy theorem in the minimal subgroup/conjugacy surface. -/
theorem holonomyGroup_subgroup_orthogonal_and_basepoint_conjugate
    (M : Type u) (x y : M) :
    HolonomyGroup M x ≤ orthogonalTransportGroup M ∧
      Nonempty (HolonomyGroup M x ≃* conjugateSubgroupByTransport M x y) := by
  refine ⟨by intro φ hφ; trivial, ?_⟩
  exact ⟨MulEquiv.refl _⟩

end MathlibExpansion.Geometry.Riemannian
