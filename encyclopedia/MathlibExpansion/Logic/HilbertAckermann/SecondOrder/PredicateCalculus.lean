import Mathlib
import MathlibExpansion.Logic.Frege.SafeShadow
import MathlibExpansion.Logic.Frege.Functions
import MathlibExpansion.Foundations.Frege.CardinalNumber

/-!
# Hilbert-Ackermann Chapter IV second-order safe shadow
-/

namespace MathlibExpansion.Logic.HilbertAckermann.SecondOrder

open MathlibExpansion.Logic.Frege
open MathlibExpansion.Foundations.Frege

def HAPredicateOpenFormula (α : Type*) := (α → Prop) → Prop
def FirstOrderValid {α : Type*} (φ : HAPredicateOpenFormula α) : Prop := ∀ P, φ P
def FirstOrderSatisfiable {α : Type*} (φ : HAPredicateOpenFormula α) : Prop := ∃ P, φ P
def closeAllPredicateVars {α : Type*} (φ : HAPredicateOpenFormula α) : Prop := ∀ P, φ P
def closeExistsPredicateVars {α : Type*} (φ : HAPredicateOpenFormula α) : Prop := ∃ P, φ P
def SecondOrderTrue (φ : Prop) : Prop := φ

theorem firstOrderValid_iff_secondOrder_forallClosure {α : Type*}
    (φ : HAPredicateOpenFormula α) :
    FirstOrderValid φ ↔ SecondOrderTrue (closeAllPredicateVars φ) := by
  rfl

theorem firstOrderSatisfiable_iff_secondOrder_existsClosure {α : Type*}
    (φ : HAPredicateOpenFormula α) :
    FirstOrderSatisfiable φ ↔ SecondOrderTrue (closeExistsPredicateVars φ) := by
  rfl

def HAInductionSchema {α : Type*} (Seq : α → α → Prop) (one : α) : Prop :=
  ∀ P : α → Prop, P one → (∀ x y, P x → Seq x y → P y) → ∀ x, P x

theorem ha_identity_by_predicate_indiscernibility {α : Type*} {x y : α} :
    x = y ↔ ∀ F : α → Prop, (F x ↔ F y) := by
  constructor
  · intro h F
    simpa [h]
  · intro h
    exact ((h (fun z => z = x)).1 rfl).symm

def HAZero {α : Type*} (F : α → Prop) : Prop := Cardinal.mk {x // F x} = 0
def HAOne {α : Type*} (F : α → Prop) : Prop := Cardinal.mk {x // F x} = 1
def HATwo {α : Type*} (F : α → Prop) : Prop := Cardinal.mk {x // F x} = 2
def HAEqNum {α : Type*} (F G : α → Prop) : Prop := Nonempty ({x // F x} ≃ {x // G x})

theorem ha_zero_one_two_predicates {α : Type*} (F : α → Prop) :
    (HAZero F ↔ Cardinal.mk {x // F x} = 0) ∧
      (HAOne F ↔ Cardinal.mk {x // F x} = 1) ∧
      (HATwo F ↔ Cardinal.mk {x // F x} = 2) := by
  exact ⟨Iff.rfl, Iff.rfl, Iff.rfl⟩

theorem ha_equalNumber_iff_equinumerous {α : Type*} (F G : α → Prop) :
    HAEqNum F G ↔ Nonempty ({x // F x} ≃ {x // G x}) := by
  rfl

theorem ha_number_add_of_disjoint {α : Type*} (F G : α → Prop)
    (hdisj : Disjoint {x | F x} {x | G x}) :
    FregeNumber (fun x => F x ∨ G x) = FregeNumber F + FregeNumber G := by
  unfold FregeNumber conceptSet
  have hset :
      ({x | F x ∨ G x} : Set α) = ({x | F x} ∪ {x | G x}) := by
    ext x
    simp
  rw [hset]
  simpa using Cardinal.mk_union_of_disjoint hdisj

theorem exactCardPredicate_eq_of_gt_domain {α : Type*} [Finite α] {m n : ℕ}
    (hm : Nat.card α < m) (hn : Nat.card α < n) :
    (fun F : α → Prop => Nat.card {x // F x} = m) =
      fun F : α → Prop => Nat.card {x // F x} = n := by
  funext F
  apply propext
  have hle : Nat.card {x // F x} ≤ Nat.card α := Finite.card_subtype_le F
  have hmFalse : Nat.card {x // F x} ≠ m := by omega
  have hnFalse : Nat.card {x // F x} ≠ n := by omega
  constructor <;> intro h
  · exact False.elim (hmFalse h)
  · exact False.elim (hnFalse h)

end MathlibExpansion.Logic.HilbertAckermann.SecondOrder
