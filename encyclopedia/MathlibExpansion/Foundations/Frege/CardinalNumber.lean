import Mathlib.SetTheory.Cardinal.Basic
import MathlibExpansion.Logic.Frege.Functions

/-!
# Frege cardinal-number shadow

This file packages the safe Frege-facing cardinal layer on top of Mathlib's
existing `Cardinal` API.
-/

universe u

open MathlibExpansion.Logic.Frege

namespace MathlibExpansion.Foundations.Frege

/-- The number belonging to a concept, modeled safely as the cardinality of its
carrier set. -/
def FregeNumber {α : Type u} (F : FregeConcept α) : Cardinal := Cardinal.mk (conceptSet F)

/-- Frege's Hume-principle shadow: two concept-numbers agree exactly when the
corresponding carriers are equinumerous. -/
theorem fregeNumber_eq_iff_equinumerous {α : Type u} (F G : FregeConcept α) :
    FregeNumber F = FregeNumber G ↔ Nonempty (conceptSet F ≃ conceptSet G) := by
  simpa [FregeNumber] using
    (Cardinal.lift_mk_eq' :
      Cardinal.lift (Cardinal.mk (conceptSet F)) =
          Cardinal.lift (Cardinal.mk (conceptSet G)) ↔
        Nonempty (conceptSet F ≃ conceptSet G))

/-- Adjoining one fresh object raises the Frege number by one. -/
theorem fregeNumber_adjoinObject {α : Type u} (F : FregeConcept α) {a : α} (ha : ¬ F a) :
    FregeNumber (adjoinObject a F) = FregeNumber F + 1 := by
  have hset : conceptSet (adjoinObject a F) = insert a (conceptSet F) := by
    ext x
    simp [conceptSet, adjoinObject]
  unfold FregeNumber
  rw [hset]
  exact Cardinal.mk_insert (s := conceptSet F) (a := a) (by simpa [conceptSet] using ha)

end MathlibExpansion.Foundations.Frege
