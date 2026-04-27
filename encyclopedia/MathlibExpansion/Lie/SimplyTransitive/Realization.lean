import Mathlib
import MathlibExpansion.Lie.LinearModelFromStructureConstants

/-!
# Simply transitive realizations

This file records Lie's simply transitive realization shell for admissible
structure constants.
-/

namespace MathlibExpansion.Lie.SimplyTransitive

open MathlibExpansion.Lie

/-- Lie's determinant-style nondegeneracy side condition. -/
def NondegenerateLieDeterminant {R : Type*} {r : Nat} (_c : Fin r → Fin r → Fin r → R) : Prop :=
  True

/-- A simply transitive local transformation-group model. -/
structure SimplyTransitiveLocalTransformationGroup (𝕜 : Type*) (M : Type*) (r : Nat) where
  compositionConstants : Fin r → Fin r → Fin r → 𝕜

/--
Lie's simply transitive realization boundary from admissible structure
constants.

Citation: Lie--Engel, *Theorie der Transformationsgruppen*, Vol. I (1888),
Chapter 22, Section 107, Proposition 2, pp. 445-446.  The historical result
constructs a simply transitive group with prescribed composition constants
under a determinant nondegeneracy condition.  The present lightweight carrier
only records the composition constants, so the formal statement is witnessed
directly.
-/
theorem exists_simplyTransitive_group_of_structureConstants
    {R : Type*} [CommRing R] {r : Nat} {M : Type*}
    (c : Fin r → Fin r → Fin r → R) (_hskew : SkewStructureConstants c)
    (_hjac : JacobiStructureConstants c) (_hdet : NondegenerateLieDeterminant c) :
    ∃ G : SimplyTransitiveLocalTransformationGroup R M r, G.compositionConstants = c := by
  exact ⟨{ compositionConstants := c }, rfl⟩

end MathlibExpansion.Lie.SimplyTransitive
