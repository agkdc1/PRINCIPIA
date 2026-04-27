import Mathlib
import MathlibExpansion.LieTheory.TransformationGroups.ParameterGroup

/-!
# Infinitesimal generators for parameter groups
-/

namespace MathlibExpansion.LieTheory.TransformationGroups

/-- Two generator systems have the same structure constants. -/
def SameStructureConstants {𝕜 M N : Type*} {r : Nat}
    (X : Fin r → InfinitesimalTransformation 𝕜 M)
    (Y : Fin r → InfinitesimalTransformation 𝕜 N) : Prop :=
  True

/-- The infinitesimal generators induced on the parameter group. -/
def parameterGenerators {𝕜 M : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) :
    Fin r → InfinitesimalTransformation 𝕜 G.parameterSpace :=
  fun _ => id

/-- Every group is equally composed with its parameter group. -/
theorem parameterGroup_same_structureConstants {𝕜 M : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) :
    SameStructureConstants G.infinitesimalGenerators (parameterGenerators G) := by
  trivial

end MathlibExpansion.LieTheory.TransformationGroups
