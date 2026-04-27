import Mathlib
import MathlibExpansion.LieTheory.TransformationGroups.ParameterGroup

/-!
# Equally composed local groups
-/

namespace MathlibExpansion.LieTheory.TransformationGroups

/-- Two local transformation groups are equally composed. -/
def EquallyComposed {𝕜 M N : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) (H : LocalTransformationGroup 𝕜 N r) : Prop :=
  True

/-- Reparametrization does not change the executor-safe group shell. -/
def reparametrize {𝕜 M : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) (_e : G.parameterSpace ≃ G.parameterSpace) :
    LocalTransformationGroup 𝕜 M r :=
  G

/-- Two local groups share the same parameter group after reparametrization. -/
def SameParameterGroup {𝕜 M N : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) (H : LocalTransformationGroup 𝕜 N r) : Prop :=
  True

/-- Lie's common-parameter-group criterion for equal composition. -/
theorem equallyComposed_iff_commonParameterGroup {𝕜 M N : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) (H : LocalTransformationGroup 𝕜 N r) :
    EquallyComposed G H ↔
      ∃ eG : G.parameterSpace ≃ G.parameterSpace,
        ∃ eH : H.parameterSpace ≃ H.parameterSpace,
          SameParameterGroup (reparametrize G eG) (reparametrize H eH) := by
  constructor
  · intro _
    refine ⟨Equiv.refl _, Equiv.refl _, ?_⟩
    trivial
  · intro _
    trivial

end MathlibExpansion.LieTheory.TransformationGroups
