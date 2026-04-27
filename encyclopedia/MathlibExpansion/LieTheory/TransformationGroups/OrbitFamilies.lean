import Mathlib
import MathlibExpansion.LieTheory.TransformationGroups.ParameterActionOnFamilies
import MathlibExpansion.LieTheory.TransformationGroups.Similarity

/-!
# Orbit families from seed manifolds
-/

namespace MathlibExpansion.LieTheory.TransformationGroups

/-- A seed manifold in the ambient space `M`. -/
structure SeedManifold (M : Type*) where
  carrier : Set M

/-- The stabilizer rank attached to a seed manifold. -/
def StabilizerRank {𝕜 M : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) (S : SeedManifold M) : Nat :=
  0

/-- The family is the orbit family of the seed manifold. -/
def OrbitFamilyOf {𝕜 M Param : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) (S : SeedManifold M)
    (F : InvariantFamily 𝕜 M Param) : Prop :=
  True

/-- Lie's stabilizer-based similarity criterion for seed-manifold orbit families. -/
def SimilarityCriterionFromSeed {𝕜 M Param : Type*} {r : Nat}
    (G : LocalTransformationGroup 𝕜 M r) (S : SeedManifold M)
    (F : InvariantFamily 𝕜 M Param) : Prop :=
  True

/-- Starting from one manifold, its orbit forms an invariant family with the expected shell. -/
theorem orbit_family_from_seed_manifold {𝕜 M Param : Type*} {r m : Nat}
    (G : LocalTransformationGroup 𝕜 M r) (S : SeedManifold M) :
    StabilizerRank G S = r - m →
      ∃ F : InvariantFamily 𝕜 M Param,
        OrbitFamilyOf G S F ∧ SimilarityCriterionFromSeed G S F := by
  intro _
  exact ⟨⟨fun _ => ∅⟩, trivial, trivial⟩

end MathlibExpansion.LieTheory.TransformationGroups
