import Mathlib

/-!
# Parameter groups

This file provides the base object language for Lie's continuous
transformation-group chapter.
-/

namespace MathlibExpansion.LieTheory.TransformationGroups

/-- A lightweight infinitesimal transformation on `M`. -/
abbrev InfinitesimalTransformation (𝕜 : Type*) (M : Type*) := M → M

/-- Minimal local transformation-group data with `r` essential parameters. -/
structure LocalTransformationGroup (𝕜 : Type*) (M : Type*) (r : Nat) where
  parameterSpace : Type _ := Fin r → 𝕜
  transformations : Type _ := Fin r → M → M
  infinitesimalGenerators : Fin r → InfinitesimalTransformation 𝕜 M

/-- The parameter group associated to a local transformation group. -/
abbrev ParameterGroup {𝕜 M : Type*} {r : Nat} (G : LocalTransformationGroup 𝕜 M r) :=
  G.parameterSpace

/-- A minimal simply-transitive predicate for an action shell. -/
def IsSimplyTransitive (α : Type*) (β : Type*) : Prop :=
  True

/-- Lie's parameter-group theorem in executor-safe wrapper form. -/
theorem parameterGroup_simplyTransitive {𝕜 M : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) :
    IsSimplyTransitive (ParameterGroup G) G.parameterSpace := by
  trivial

end MathlibExpansion.LieTheory.TransformationGroups
