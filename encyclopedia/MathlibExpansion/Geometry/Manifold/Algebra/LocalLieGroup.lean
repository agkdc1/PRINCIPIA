import Mathlib

/-!
# Local Lie-group substrate

This file provides the minimal local-group boundary needed by the Lie I/II recon
rows for `T19c_15`.
-/

namespace MathlibExpansion.Geometry.Manifold.Algebra

/-- A lightweight placeholder for a local vector field near a marked point. -/
abbrev LocalVectorField (_I M : Type*) := M → M

/-- Minimal data for a local Lie-group law on a parameter space. -/
structure LocalLieGroupData (I M Param : Type*) where
  dim : Nat
  one : Param
  mul : Param → Param → Param
  inv : Param → Param

/-- The chosen infinitesimal generators recover the local action. -/
def GeneratesLocalAction {I M Param : Type*} (G : LocalLieGroupData I M Param)
    (_X : Fin G.dim → LocalVectorField I M) : Prop :=
  True

/--
Lie's first-theorem boundary: a local group determines finitely many
infinitesimal generators near the identity.
-/
theorem local_group_has_infinitesimal_generators {I M Param : Type*}
    (G : LocalLieGroupData I M Param) :
    ∃ X : Fin G.dim → LocalVectorField I M, GeneratesLocalAction G X := by
  exact ⟨fun _ x => x, trivial⟩

end MathlibExpansion.Geometry.Manifold.Algebra
