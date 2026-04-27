import MathlibExpansion.Geometry.Klein.Basic

/-!
# Subgroup comparison for Klein geometries

Passing from a transformation group to a subgroup can only refine the geometry:
every relation invariant under the larger group remains invariant under the
smaller one.
-/

namespace MathlibExpansion.Geometry.Klein

open scoped Pointwise

variable {G X : Type*} [Group G] [MulAction G X]

namespace KleinGeometry

/-- Restrict a Klein geometry along a subgroup of the acting group. -/
def restrict (K : KleinGeometry G X) (H : Subgroup G) : KleinGeometry H X where
  GeomRel := K.GeomRel
  invariant' := by
    intro n h v hv
    exact K.invariant (g := (h : G)) v hv

@[simp]
theorem restrict_geomRel (K : KleinGeometry G X) (H : Subgroup G) (n : ℕ) (v : Fin n → X) :
    (K.restrict H).GeomRel n v ↔ K.GeomRel n v :=
  Iff.rfl

end KleinGeometry

/-- Every relation invariant under `G` is invariant under any subgroup `H ≤ G`. -/
theorem invariant_of_subgroup (K : KleinGeometry G X) (H : Subgroup G)
    {n : ℕ} (h : H) (v : Fin n → X) (hv : K.GeomRel n v) :
    K.GeomRel n (h • v) :=
  K.invariant (g := (h : G)) v hv

end MathlibExpansion.Geometry.Klein
