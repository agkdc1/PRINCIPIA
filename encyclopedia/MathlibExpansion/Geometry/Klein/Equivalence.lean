import MathlibExpansion.Geometry.Klein.Basic

/-!
# Equivariant equivalence for Klein geometries

An equivariant equivalence of group actions transports invariant relations from
one action to the other.
-/

namespace MathlibExpansion.Geometry.Klein

open scoped Pointwise

variable {G H X Y : Type*}
variable [Group G] [Group H] [MulAction G X] [MulAction H Y]

/-- An equivalence of acted-on spaces compatible with a group isomorphism. -/
structure EquivariantEquiv (φ : G ≃* H) where
  toEquiv : X ≃ Y
  map_smul' : ∀ (g : G) (x : X), toEquiv (g • x) = φ g • toEquiv x

namespace EquivariantEquiv

variable {φ : G ≃* H}

@[simp]
theorem map_smul (e : EquivariantEquiv (X := X) (Y := Y) φ) (g : G) (x : X) :
    e.toEquiv (g • x) = φ g • e.toEquiv x :=
  e.map_smul' g x

@[simp]
theorem symm_map_smul (e : EquivariantEquiv (X := X) (Y := Y) φ) (h : H) (y : Y) :
    e.toEquiv.symm (h • y) = φ.symm h • e.toEquiv.symm y := by
  apply e.toEquiv.injective
  simpa using e.map_smul (φ.symm h) (e.toEquiv.symm y)

end EquivariantEquiv

namespace KleinGeometry

variable {φ : G ≃* H}

/-- Transport a Klein geometry across an equivariant equivalence. -/
def transport (K : KleinGeometry G X) (e : EquivariantEquiv (X := X) (Y := Y) φ) :
    KleinGeometry H Y where
  GeomRel n v := K.GeomRel n (fun i => e.toEquiv.symm (v i))
  invariant' := by
    intro n h v hv
    have hbase :
        K.GeomRel n (φ.symm h • fun i => e.toEquiv.symm (v i)) :=
      K.invariant (g := φ.symm h) _ hv
    simpa [Pi.smul_apply, EquivariantEquiv.symm_map_smul] using hbase

@[simp]
theorem transport_geomRel_iff (K : KleinGeometry G X)
    (e : EquivariantEquiv (X := X) (Y := Y) φ) (n : ℕ) (v : Fin n → Y) :
    (K.transport e).GeomRel n v ↔ K.GeomRel n (fun i => e.toEquiv.symm (v i)) :=
  Iff.rfl

end KleinGeometry

/-- Equivariantly equivalent actions define the same geometric relations after
transport along the equivalence. -/
theorem equivariant_equiv_preserves_geometry
    {φ : G ≃* H} (K : KleinGeometry G X)
    (e : EquivariantEquiv (X := X) (Y := Y) φ) (n : ℕ) (v : Fin n → Y) :
    (K.transport e).GeomRel n v ↔ K.GeomRel n (fun i => e.toEquiv.symm (v i)) :=
  K.transport_geomRel_iff e n v

end MathlibExpansion.Geometry.Klein
