import MathlibExpansion.Logic.Frege.Functions

/-!
# T20c_05_RRP — Relation domain / range / field / restriction / image (W3b shared)

Russell + Whitehead, *Principia Mathematica* (1910), `*31`-`*38`. The PM-facing
bundle for relations: `D'R` (domain), `Ǎ'R` (range), `C'R` (field), `R↾A`
(restriction), `R"A` (image). Used by W3a (DescriptiveFunction) and W3b
itself.

References:
* Russell-Whitehead 1910, PM vol. I, `*30`-`*38`.
* Schröder, *Algebra und Logik der Relative* (cited PM `*30`-`*38` notation).
-/

universe u v w

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege

/-- RRP-01 (`*33·11` `russell_domain`): the domain of a binary relation
`R : α → β → Prop` is the class of objects in `α` admitting at least one
`R`-image. -/
def russell_domain {α : Type u} {β : Type v} (R : FregeRelation α β) : α → Prop :=
  fun x => ∃ y, R x y

/-- RRP-02 (`*33·12` `russell_codomain`): dually the range of a binary
relation. -/
def russell_codomain {α : Type u} {β : Type v} (R : FregeRelation α β) : β → Prop :=
  fun y => ∃ x, R x y

/-- RRP-03 (`*33·13` `russell_field`, homogeneous case): the field of a
homogeneous relation `R : α → α → Prop` is `domain ∪ codomain`. -/
def russell_field {α : Type u} (R : FregeRelation α α) : α → Prop :=
  fun x => russell_domain R x ∨ russell_codomain R x

/-- RRP-04: domain inhabitation under `R x y`. -/
theorem russell_mem_domain {α : Type u} {β : Type v} {R : FregeRelation α β}
    {x : α} {y : β} (h : R x y) : russell_domain R x :=
  ⟨y, h⟩

/-- RRP-05: codomain inhabitation under `R x y`. -/
theorem russell_mem_codomain {α : Type u} {β : Type v} {R : FregeRelation α β}
    {x : α} {y : β} (h : R x y) : russell_codomain R y :=
  ⟨x, h⟩

/-- RRP-06: field inhabitation by domain. -/
theorem russell_mem_field_of_domain {α : Type u} {R : FregeRelation α α}
    {x : α} (h : russell_domain R x) : russell_field R x := Or.inl h

/-- RRP-07: field inhabitation by codomain. -/
theorem russell_mem_field_of_codomain {α : Type u} {R : FregeRelation α α}
    {x : α} (h : russell_codomain R x) : russell_field R x := Or.inr h

/-- RRP-08 (`*36·01` `russell_restrict`): restriction of `R : α → β → Prop`
to a class `A : α → Prop`. -/
def russell_restrict {α : Type u} {β : Type v}
    (R : FregeRelation α β) (A : FregeConcept α) : FregeRelation α β :=
  fun x y => A x ∧ R x y

/-- RRP-09 (`*37·01` `russell_image`): the `R`-image of a class `A`. -/
def russell_image {α : Type u} {β : Type v}
    (R : FregeRelation α β) (A : FregeConcept α) : β → Prop :=
  fun y => ∃ x, A x ∧ R x y

/-- RRP-10 (`*37·11`): image membership characterisation. -/
@[simp] theorem russell_image_mem_iff {α : Type u} {β : Type v}
    (R : FregeRelation α β) (A : FregeConcept α) (y : β) :
    russell_image R A y ↔ ∃ x, A x ∧ R x y := Iff.rfl

/-- RRP-11 (`*34·01` `russell_relComp`): relative product / composition. -/
def russell_relComp {α : Type u} {β : Type v} {γ : Type w}
    (R : FregeRelation α β) (S : FregeRelation β γ) : FregeRelation α γ :=
  fun x z => ∃ y, R x y ∧ S y z

/-- RRP-12: relative product is associative. -/
theorem russell_relComp_assoc {α β γ δ : Type u}
    (R : FregeRelation α β) (S : FregeRelation β γ) (T : FregeRelation γ δ) :
    russell_relComp (russell_relComp R S) T =
      russell_relComp R (russell_relComp S T) := by
  ext x w
  unfold russell_relComp
  constructor
  · rintro ⟨z, ⟨y, hRxy, hSyz⟩, hTzw⟩
    exact ⟨y, hRxy, z, hSyz, hTzw⟩
  · rintro ⟨y, hRxy, z, hSyz, hTzw⟩
    exact ⟨z, ⟨y, hRxy, hSyz⟩, hTzw⟩

/-- RRP-13 (`*32·01` converse). -/
def russell_converse {α : Type u} {β : Type v}
    (R : FregeRelation α β) : FregeRelation β α :=
  fun y x => R x y

/-- RRP-15 (`*32·11` converse-of-converse is the original). -/
@[simp] theorem russell_converse_converse {α : Type u} {β : Type v}
    (R : FregeRelation α β) :
    russell_converse (russell_converse R) = R := rfl

/-- RRP-16 (`*33·14` field of converse equals field). -/
theorem russell_field_converse {α : Type u} (R : FregeRelation α α) :
    russell_field (russell_converse R) = russell_field R := by
  ext x
  unfold russell_field russell_domain russell_codomain russell_converse
  exact Or.comm

/-- RRP-17 (`*36·11` restriction is monotone in the class argument). -/
theorem russell_restrict_mono {α : Type u} {β : Type v}
    (R : FregeRelation α β) {A B : FregeConcept α}
    (h : ∀ x, A x → B x) :
    ∀ x y, russell_restrict R A x y → russell_restrict R B x y := by
  intro x y ⟨hA, hR⟩
  exact ⟨h x hA, hR⟩

/-- RRP-18 (`*37·12` image is monotone in the class argument). -/
theorem russell_image_mono {α : Type u} {β : Type v}
    (R : FregeRelation α β) {A B : FregeConcept α}
    (h : ∀ x, A x → B x) :
    ∀ y, russell_image R A y → russell_image R B y := by
  intro y ⟨x, hA, hR⟩
  exact ⟨x, h x hA, hR⟩

/-- RRP-19 (`*37·15` image of relative product). -/
theorem russell_image_relComp {α β γ : Type u}
    (R : FregeRelation α β) (S : FregeRelation β γ) (A : FregeConcept α) :
    russell_image (russell_relComp R S) A =
      russell_image S (russell_image R A) := by
  ext z
  unfold russell_image russell_relComp
  constructor
  · rintro ⟨x, hA, y, hR, hS⟩
    exact ⟨y, ⟨x, hA, hR⟩, hS⟩
  · rintro ⟨y, ⟨x, hA, hR⟩, hS⟩
    exact ⟨x, hA, y, hR, hS⟩

/-!
QUARANTINE: RRP-14 (`*30` description-as-relation NOTATION shorthand, that
PM's `R'a` is the description `(ιx)(R(x,a))`), RRP-20 (PM's `Cnv'R`
notation overloading), RRP-21 (PM's class-of-relations totality) are NOT
formalised here. They live behind the description / quarantine boundaries.
-/

end MathlibExpansion.Logic.Russell
