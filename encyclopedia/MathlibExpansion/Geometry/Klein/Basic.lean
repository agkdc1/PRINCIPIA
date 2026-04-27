import Mathlib.GroupTheory.GroupAction.Basic

/-!
# Basic Klein geometries

This file packages the minimal "space + transformation group + invariant
relations" surface needed for the Erlangen-programme queue.
-/

namespace MathlibExpansion.Geometry.Klein

open scoped Pointwise

variable (G : Type*) (X : Type*) [Group G] [MulAction G X]

/-- A minimal Klein geometry consists of a group action together with geometric
relations that are invariant under that action. -/
structure KleinGeometry where
  GeomRel : ∀ n : ℕ, (Fin n → X) → Prop
  invariant' : ∀ {n : ℕ} (g : G) (v : Fin n → X), GeomRel n v → GeomRel n (g • v)

namespace KleinGeometry

variable {G X} [Group G] [MulAction G X]

/-- Geometric relations are invariant under the acting group. -/
theorem invariant (K : KleinGeometry G X) {n : ℕ} (g : G) (v : Fin n → X)
    (hv : K.GeomRel n v) :
    K.GeomRel n (g • v) :=
  K.invariant' g v hv

end KleinGeometry

end MathlibExpansion.Geometry.Klein
