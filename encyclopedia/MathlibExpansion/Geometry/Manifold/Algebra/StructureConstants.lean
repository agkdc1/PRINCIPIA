import Mathlib

/-!
# Structure constants for Lie groups

This is the group-facing structure-constant shell used in the Lie I/II/III
chapter recon.
-/

namespace MathlibExpansion.Geometry.Manifold.Algebra

section

variable {𝕜 : Type*} [CommRing 𝕜]
variable {ι : Type*} [Fintype ι] [DecidableEq ι]
variable {L : Type*} [LieRing L] [LieAlgebra 𝕜 L] [AddCommGroup L] [Module 𝕜 L]

/-- A minimal basis-like predicate for a finite family of generators. -/
def BasisLike (X : ι → L) : Prop :=
  Function.Injective X

/-- Antisymmetry in Lie's structure-constant form. -/
def AntisymmetricStructureConstants (c : ι → ι → ι → 𝕜) : Prop :=
  ∀ i j k, c i j k = -c j i k

/-- Jacobi in coordinate form. -/
def JacobiStructureConstants (c : ι → ι → ι → 𝕜) : Prop :=
  ∀ i j k t,
    (∑ s, c i j s * c s k t) + (∑ s, c j k s * c s i t) + (∑ s, c k i s * c s j t) = 0

omit [DecidableEq ι] [LieRing L] [LieAlgebra 𝕜 L] [AddCommGroup L] [Module 𝕜 L] in
/--
For the present shell statement, the zero structure constants obey
antisymmetry and Jacobi.
-/
theorem structureConstants_antisymm_jacobi (X : ι → L) (_hX : BasisLike X) :
    ∃ c : ι → ι → ι → 𝕜,
      AntisymmetricStructureConstants c ∧ JacobiStructureConstants c := by
  refine ⟨fun _ _ _ => 0, ?_, ?_⟩ <;>
    simp [AntisymmetricStructureConstants, JacobiStructureConstants]

end

end MathlibExpansion.Geometry.Manifold.Algebra
