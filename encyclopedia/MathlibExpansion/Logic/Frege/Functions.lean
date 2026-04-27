import Mathlib.Data.Set.Defs

/-!
# Frege concept and relation primitives

This leaf module names the typed higher-order carriers used by the Frege-facing
files in this namespace. The only bridge to `Set` is `conceptSet`.
-/

universe u v

namespace MathlibExpansion.Logic.Frege

/-- A Fregean unary concept on a typed carrier. -/
abbrev FregeConcept (α : Type u) := α → Prop

/-- A Fregean binary relation on typed carriers. -/
abbrev FregeRelation (α : Type u) (β : Type v) := α → β → Prop

/-- The unique owner-boundary bridge from a Frege concept to an ordinary set. -/
def conceptSet {α : Type u} (F : FregeConcept α) : Set α := {x | F x}

@[simp] theorem mem_conceptSet {α : Type u} (F : FregeConcept α) (x : α) :
    x ∈ conceptSet F ↔ F x := Iff.rfl

/-- Adjoin one explicit object to a concept. -/
def adjoinObject {α : Type u} (a : α) (F : FregeConcept α) : FregeConcept α :=
  fun x => x = a ∨ F x

@[simp] theorem adjoinObject_apply {α : Type u} (a : α) (F : FregeConcept α) (x : α) :
    adjoinObject a F x ↔ x = a ∨ F x := Iff.rfl

end MathlibExpansion.Logic.Frege
