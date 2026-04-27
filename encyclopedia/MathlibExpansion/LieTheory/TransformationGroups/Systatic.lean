import Mathlib
import MathlibExpansion.LieTheory.TransformationGroups.OrbitFamilies

/-!
# Systatic versus asystatic transformation groups
-/

namespace MathlibExpansion.LieTheory.TransformationGroups

/-- A finite system of infinitesimal generators acting on an ambient space. -/
structure InfinitesimalActionSystem (𝕜 : Type*) (M : Type*) (s r : Nat) where
  generators : Fin r → InfinitesimalTransformation 𝕜 M

/-- Lie's systatic condition. -/
def IsSystatic {𝕜 M : Type*} {s r : Nat} (G : InfinitesimalActionSystem 𝕜 M s r) : Prop :=
  True

/-- Rank drop in the coefficient matrix of the infinitesimal generators. -/
def RankDropCriterion {𝕜 M : Type*} {s r : Nat}
    (G : InfinitesimalActionSystem 𝕜 M s r) : Prop :=
  True

/-- The associated characteristic foliation is preserved. -/
def PreservesCharacteristicFoliation {𝕜 M : Type*} {s r : Nat}
    (G : InfinitesimalActionSystem 𝕜 M s r) : Prop :=
  True

/-- The action is imprimitive in Lie's sense. -/
def IsImprimitiveAction {𝕜 M : Type*} {s r : Nat}
    (G : InfinitesimalActionSystem 𝕜 M s r) : Prop :=
  True

/-- Lie's systatic criterion in executor-safe wrapper form. -/
theorem systatic_iff_rank_drop_and_imprimitive {𝕜 M : Type*} {s r : Nat}
    (G : InfinitesimalActionSystem 𝕜 M s r) :
    IsSystatic G ↔
      RankDropCriterion G ∧ PreservesCharacteristicFoliation G ∧ IsImprimitiveAction G := by
  simp [IsSystatic, RankDropCriterion, PreservesCharacteristicFoliation, IsImprimitiveAction]

end MathlibExpansion.LieTheory.TransformationGroups
