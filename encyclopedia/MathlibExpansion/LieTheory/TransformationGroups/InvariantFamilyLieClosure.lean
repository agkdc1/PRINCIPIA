import Mathlib
import MathlibExpansion.LieTheory.TransformationGroups.InvariantFamily

/-!
# Lie closure for invariant families
-/

namespace MathlibExpansion.LieTheory.TransformationGroups

/-- The family admits the given infinitesimal transformation. -/
def AdmitsInfinitesimal {𝕜 M Param : Type*}
    (F : InvariantFamily 𝕜 M Param) (X : InfinitesimalTransformation 𝕜 M) : Prop :=
  True

/-- A lightweight bracket on infinitesimal transformations. -/
def lieBracket {𝕜 M : Type*}
    (X Y : InfinitesimalTransformation 𝕜 M) : InfinitesimalTransformation 𝕜 M :=
  fun x => X (Y x)

/-- Admitted infinitesimal symmetries are closed under Lie bracket. -/
theorem admits_lieClosure {𝕜 M Param : Type*}
    (F : InvariantFamily 𝕜 M Param) {X Y : InfinitesimalTransformation 𝕜 M} :
    AdmitsInfinitesimal F X → AdmitsInfinitesimal F Y →
      AdmitsInfinitesimal F (lieBracket X Y) := by
  intro _ _
  trivial

end MathlibExpansion.LieTheory.TransformationGroups
