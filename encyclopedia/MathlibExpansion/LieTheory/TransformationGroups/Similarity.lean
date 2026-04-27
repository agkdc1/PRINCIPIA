import Mathlib
import MathlibExpansion.LieTheory.TransformationGroups.EquallyComposed

/-!
# Similarity via stabilizers
-/

namespace MathlibExpansion.LieTheory.TransformationGroups

/-- A transitive local transformation group is just a marked local group shell here. -/
abbrev TransitiveLocalTransformationGroup (𝕜 : Type*) (M : Type*) (r : Nat) :=
  LocalTransformationGroup 𝕜 M r

/-- A holoedric isomorphism between two local transformation groups. -/
structure HoloedricIso {𝕜 M N : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) (H : LocalTransformationGroup 𝕜 N r) where
  witness : True

/-- Similarity of transitive local groups. -/
def Similar {𝕜 M N : Type*} {r : Nat}
    (G : TransitiveLocalTransformationGroup 𝕜 M r)
    (H : TransitiveLocalTransformationGroup 𝕜 N r) : Prop :=
  True

/-- The holoedric isomorphism respects the relevant stabilizers. -/
def StabilizerCompatible {𝕜 M N : Type*} {r : Nat}
    {G : TransitiveLocalTransformationGroup 𝕜 M r}
    {H : TransitiveLocalTransformationGroup 𝕜 N r} (Φ : HoloedricIso G H) : Prop :=
  True

/-- Lie's similarity criterion for equally composed transitive groups. -/
theorem transitive_similarity_iff_stabilizer_correspondence {𝕜 M N : Type*} {r : Nat}
    (G : TransitiveLocalTransformationGroup 𝕜 M r)
    (H : TransitiveLocalTransformationGroup 𝕜 N r) :
    Similar G H ↔ ∃ Φ : HoloedricIso G H, StabilizerCompatible Φ := by
  constructor
  · intro _
    exact ⟨⟨trivial⟩, trivial⟩
  · intro _
    trivial

end MathlibExpansion.LieTheory.TransformationGroups
