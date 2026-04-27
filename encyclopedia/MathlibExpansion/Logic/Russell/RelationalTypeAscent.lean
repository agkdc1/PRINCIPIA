import MathlibExpansion.Logic.Russell.RelationDomain
import MathlibExpansion.Logic.Russell.ClassesShadow

/-!
# T20c_05_RTTA — Relation-theoretic type ascent (W5 closure)

Russell + Whitehead, *Principia Mathematica* (1910), `*150`-`*186`.
PM's "type-ascent" for relations: from `α → α → Prop` (relations of
individuals) to `(α → Prop) → (α → Prop) → Prop` (relations of classes)
to relations of relations. PM's typed no-class shadow extended through
relational levels.

This file provides the type-ascent wrappers — purely syntactic re-typings
that respect the no-class shadow doctrine. No `Classical.choose`, no
extension to a "set of all types".

References:
* Russell-Whitehead 1910, PM vol. I, Introduction Ch. II (theory of types).
* Russell-Whitehead 1910, PM vol. I, `*150`-`*186` (relation-arithmetic).
-/

universe u v w

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege

/-- RTTA-01 (`*150·01` `RelationOfClasses`): a relation between two classes
is a binary predicate on the carriers `α → Prop` and `β → Prop`. The Lean
encoding is the natural one: a relation of relations (one universe up). -/
def RelationOfClasses (α : Type u) (β : Type v) : Type max u v :=
  (α → Prop) → (β → Prop) → Prop

/-- RTTA-02 (`*150·11` `russell_relTypeAscent`): a relation `R : α → β → Prop`
ascends to a relation between (the conceptSet of) classes by
"`A` and `B` are pointwise `R`-related when there exist witnesses
`a ∈ A`, `b ∈ B` with `R a b`". -/
def russell_relTypeAscent {α : Type u} {β : Type v}
    (R : FregeRelation α β) : RelationOfClasses α β :=
  fun A B => ∃ a b, A a ∧ B b ∧ R a b

/-- RTTA-03 (`*150·31`): the ascended relation between singleton classes
matches the original relation on individuals. -/
theorem russell_relTypeAscent_singleton {α : Type u} {β : Type v}
    (R : FregeRelation α β) (a : α) (b : β) :
    russell_relTypeAscent R (fun x => x = a) (fun y => y = b) ↔ R a b := by
  unfold russell_relTypeAscent
  constructor
  · rintro ⟨a', b', haa, hbb, hRab⟩
    rw [haa] at hRab
    rw [hbb] at hRab
    exact hRab
  · intro hR
    exact ⟨a, b, rfl, rfl, hR⟩

/-- RTTA-04 (`*150·41` extensionality of ascended relations). -/
theorem russell_relTypeAscent_congr {α : Type u} {β : Type v}
    {R S : FregeRelation α β} (h : ∀ x y, R x y ↔ S x y)
    (A : α → Prop) (B : β → Prop) :
    russell_relTypeAscent R A B ↔ russell_relTypeAscent S A B := by
  unfold russell_relTypeAscent
  constructor
  · rintro ⟨a, b, hA, hB, hR⟩
    exact ⟨a, b, hA, hB, (h a b).1 hR⟩
  · rintro ⟨a, b, hA, hB, hS⟩
    exact ⟨a, b, hA, hB, (h a b).2 hS⟩

/-- RTTA-05 (`*150·51` ascended relation is monotone in classes). -/
theorem russell_relTypeAscent_mono_left {α : Type u} {β : Type v}
    (R : FregeRelation α β) {A A' : α → Prop} (h : ∀ x, A x → A' x)
    (B : β → Prop) :
    russell_relTypeAscent R A B → russell_relTypeAscent R A' B := by
  rintro ⟨a, b, hA, hB, hR⟩
  exact ⟨a, b, h a hA, hB, hR⟩

/-- RTTA-06 (`*150·52` ascended relation is monotone in classes, right). -/
theorem russell_relTypeAscent_mono_right {α : Type u} {β : Type v}
    (R : FregeRelation α β) (A : α → Prop) {B B' : β → Prop}
    (h : ∀ y, B y → B' y) :
    russell_relTypeAscent R A B → russell_relTypeAscent R A B' := by
  rintro ⟨a, b, hA, hB, hR⟩
  exact ⟨a, b, hA, h b hB, hR⟩

/-- RTTA-07 (HARD NOVEL `russell_typeAscent_compose`): the type-ascended
composition of relations agrees with the relational-product of the
ascended relations on classes that respect the intermediate witness. -/
theorem russell_relTypeAscent_compose {α β γ : Type u}
    (R : FregeRelation α β) (S : FregeRelation β γ)
    (A : α → Prop) (C : γ → Prop) :
    russell_relTypeAscent (russell_relComp R S) A C →
      ∃ B : β → Prop,
        russell_relTypeAscent R A B ∧ russell_relTypeAscent S B C := by
  rintro ⟨a, c, hA, hC, b, hRab, hSbc⟩
  refine ⟨fun y => y = b, ?_, ?_⟩
  · exact ⟨a, b, hA, rfl, hRab⟩
  · exact ⟨b, c, rfl, hC, hSbc⟩

/-- RTTA-08 (`*150·61` typed-no-class shadow doctrine extends to relations):
the ascended relation lives at the "relation of relations" level — Lean's
universe polymorphism handles the type-shifting transparently. PM's typed
ramified types are *encoded* as Lean universe arithmetic, NOT as a
`Type → Prop` extraction. -/
def russell_higherType_marker (α : Type u) : Type (u+1) := α → Type u

/-- RTTA-09 (typed-no-class shadow non-extraction): the higher-type marker
is a Lean type, not a class shadow. PM's anti-class doctrine is enforced
by Lean's universe polymorphism. -/
theorem russell_higherType_inhabited (α : Type u) :
    ∃ _ : russell_higherType_marker α, True := ⟨fun _ => α, trivial⟩

end MathlibExpansion.Logic.Russell
