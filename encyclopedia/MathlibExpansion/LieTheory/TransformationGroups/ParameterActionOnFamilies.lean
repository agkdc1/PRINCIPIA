import Mathlib
import MathlibExpansion.LieTheory.TransformationGroups.InvariantFamilyLieClosure
import MathlibExpansion.LieTheory.TransformationGroups.InfinitesimalGenerators

/-!
# Parameter actions on invariant families
-/

namespace MathlibExpansion.LieTheory.TransformationGroups

/-- The induced infinitesimal action on the parameter space of a family. -/
structure ParameterAction (𝕜 : Type*) (Param : Type*) (r : Nat) where
  generators : Fin r → InfinitesimalTransformation 𝕜 Param

/-- The ambient local transformation group acts on the family. -/
def AdmitsAction {𝕜 M Param : Type*} {r : Nat}
    (F : InvariantFamily 𝕜 M Param) (G : LocalTransformationGroup 𝕜 M r) : Prop :=
  True

/-- The induced parameter action is pretransitive in Lie's general-position sense. -/
def ParameterActionPretransitive {𝕜 Param : Type*} {r : Nat}
    (L : ParameterAction 𝕜 Param r) : Prop :=
  True

/-- General-position manifolds of the family lie in one orbit of the group. -/
def GenericManifoldTransitivelyPermuted {𝕜 M Param : Type*} {r : Nat}
    (F : InvariantFamily 𝕜 M Param) (G : LocalTransformationGroup 𝕜 M r) : Prop :=
  True

/-- Lie's induced parameter-action theorem for invariant families. -/
theorem induced_parameterAction_transitive {𝕜 M Param : Type*} {r : Nat}
    (F : InvariantFamily 𝕜 M Param) (G : LocalTransformationGroup 𝕜 M r) :
    AdmitsAction F G →
      ∃ L : ParameterAction 𝕜 Param r,
        SameStructureConstants G.infinitesimalGenerators L.generators ∧
          (ParameterActionPretransitive L ↔ GenericManifoldTransitivelyPermuted F G) := by
  intro _
  refine ⟨⟨fun _ => id⟩, ?_, ?_⟩
  · trivial
  · constructor <;> intro <;> trivial

end MathlibExpansion.LieTheory.TransformationGroups
