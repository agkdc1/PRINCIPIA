import MathlibExpansion.Logic.Frege.Functions

/-!
# T20c_05_RCIS — Class-bounded quantifiers (W1c part 2)

Russell + Whitehead, *Principia Mathematica* (1910), `*20·07`-`*20·22`.
PM's "for all classes" / "for some class" quantifiers are contextually
expanded over `conceptSet`-bounded predicates.

References:
* Russell-Whitehead 1910, PM vol. I, `*20·07`-`*20·22`.
-/

universe u v

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege

/-- RCIS-06 (`*20·07` `russell_class_forall`): "for every class `α` such that
`Φ α`, `Ψ α` holds" expanded contextually. -/
def russell_class_forall {α : Type u}
    (Φ Ψ : FregeConcept α → Prop) : Prop :=
  ∀ F : FregeConcept α, Φ F → Ψ F

/-- RCIS-07 (`*20·08` `russell_class_exists`): "there exists a class `α` with
both `Φ α` and `Ψ α`" expanded contextually. -/
def russell_class_exists {α : Type u}
    (Φ Ψ : FregeConcept α → Prop) : Prop :=
  ∃ F : FregeConcept α, Φ F ∧ Ψ F

/-- RCIS-08: class-quantifier instantiation. Wrapper. -/
theorem russell_class_forall_elim {α : Type u}
    {Φ Ψ : FregeConcept α → Prop} (h : russell_class_forall Φ Ψ)
    (F : FregeConcept α) (hΦ : Φ F) : Ψ F :=
  h F hΦ

/-- RCIS-08′: class-existential introduction. Wrapper. -/
theorem russell_class_exists_intro {α : Type u}
    {Φ Ψ : FregeConcept α → Prop}
    (F : FregeConcept α) (hΦ : Φ F) (hΨ : Ψ F) :
    russell_class_exists Φ Ψ :=
  ⟨F, hΦ, hΨ⟩

end MathlibExpansion.Logic.Russell
