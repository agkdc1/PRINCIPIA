import MathlibExpansion.Logic.Russell.Descriptions
import MathlibExpansion.Logic.Russell.RelationDomain

/-!
# T20c_05_DF — Descriptive functions (W3a)

Russell + Whitehead, *Principia Mathematica* (1910), `*30`-`*38`. The
descriptive function `R'a := (ιx)(R(x,a))` is PM's principal way of writing
"the unique `x` related to `a` by `R`". Twelve named theorems including the
two HARD novel rows DF_07 (description composition commutativity) and DF_11
(plural-to-singular bridge).

References:
* Russell-Whitehead 1910, PM vol. I, `*30`-`*38`.
* Frege 1882-83, *Kritische Beleuchtung einiger Punkte in E. Schröders
  Vorlesungen* (cited PM `*30`).
* Couturat 1901, *La Logique de Leibniz* §15 (Jungius citation).
-/

universe u v w

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege

/-- DF-01 (`*30·01` `russell_descriptiveFun`): `R'a` reads as the contextual
description "the `x` such that `R(x,a)`". The contextual elimination over a
context `ψ` is exactly `russell_desc_elim (fun x => R x a) ψ`. -/
def russell_descriptiveFun {α : Type u} {β : Type v}
    (R : FregeRelation α β) (a : β) (ψ : α → Prop) : Prop :=
  russell_desc_elim (fun x => R x a) ψ

/-- DF-02 (`*30·11` proper descriptive function predicate): `E! R'a` says
that `R'a` is a proper description. -/
def russell_descriptiveFun_proper {α : Type u} {β : Type v}
    (R : FregeRelation α β) (a : β) : Prop :=
  russell_isProperDescription (fun x => R x a)

/-- DF-03 (`*30·12`): `E! R'a` is exactly "`a` has a unique `R`-pre-image". -/
theorem russell_descriptiveFun_proper_iff {α : Type u} {β : Type v}
    (R : FregeRelation α β) (a : β) :
    russell_descriptiveFun_proper R a ↔ ∃! x, R x a := Iff.rfl

/-- DF-04 (`*30·22` proper-uniqueness): if `E! R'a` and both `x` and `y`
witness it, they are equal. -/
theorem russell_descriptiveFun_witness_unique {α : Type u} {β : Type v}
    {R : FregeRelation α β} {a : β}
    (hProper : russell_descriptiveFun_proper R a) {x y : α}
    (hx : R x a) (hy : R y a) : x = y :=
  russell_desc_witness_unique hProper hx hy

/-- DF-05 (`*32·11` `russell_inverseDescriptive`): inverse descriptive
function via converse relation. -/
def russell_inverseDescriptive {α : Type u} {β : Type v}
    (R : FregeRelation α β) (b : α) (ψ : β → Prop) : Prop :=
  russell_descriptiveFun (russell_converse R) b ψ

/-- DF-06 (`*30·31` extensionality of descriptive function under
extensionally-equal relations). -/
theorem russell_descriptiveFun_congr {α : Type u} {β : Type v}
    {R S : FregeRelation α β}
    (h : ∀ x y, R x y ↔ S x y) (a : β) (ψ : α → Prop) :
    russell_descriptiveFun R a ψ ↔ russell_descriptiveFun S a ψ := by
  unfold russell_descriptiveFun russell_desc_elim
  constructor
  · rintro ⟨x, hUx, hψx⟩
    refine ⟨x, ?_, hψx⟩
    intro y
    exact ⟨fun hSy => (hUx y).1 ((h y a).2 hSy),
           fun hy => (h y a).1 ((hUx y).2 hy)⟩
  · rintro ⟨x, hUx, hψx⟩
    refine ⟨x, ?_, hψx⟩
    intro y
    exact ⟨fun hRy => (hUx y).1 ((h y a).1 hRy),
           fun hy => (h y a).2 ((hUx y).2 hy)⟩

/-- DF-07 (HARD NOVEL `description composition commutativity`): for relations
`R : α → β → Prop` and `S : β → γ → Prop`, the descriptive function over
the relative product `R ∘ S` agrees with the iterated descriptive functions
under properness. PM uses this to license `R'(S'a) = (R∘S)'a` reasoning. -/
theorem russell_desc_composition_commutes {α β γ : Type u}
    (R : FregeRelation α β) (S : FregeRelation β γ) (a : γ)
    (hS : russell_descriptiveFun_proper S a)
    (_hR : ∀ b, S b a → russell_descriptiveFun_proper R b)
    (ψ : α → Prop) :
    russell_descriptiveFun (russell_relComp R S) a ψ ↔
      russell_descriptiveFun S a (fun b => russell_descriptiveFun R b ψ) := by
  obtain ⟨b₀, hSb₀, hUb₀⟩ := hS
  unfold russell_descriptiveFun russell_desc_elim russell_relComp
  constructor
  · rintro ⟨x, hUx, hψx⟩
    refine ⟨b₀, ?_, x, ?_, hψx⟩
    · intro y
      exact ⟨fun hSy => hUb₀ y hSy, fun hy => hy ▸ hSb₀⟩
    · intro y
      refine ⟨fun hRyb₀ => (hUx y).1 ⟨b₀, hRyb₀, hSb₀⟩, fun hy => ?_⟩
      obtain ⟨b', hRyb', hSb'⟩ := (hUx y).2 hy
      have hb'b₀ : b' = b₀ := hUb₀ b' hSb'
      exact hb'b₀ ▸ hRyb'
  · rintro ⟨b, hUb, x, hUx, hψx⟩
    refine ⟨x, ?_, hψx⟩
    intro y
    constructor
    · rintro ⟨b', hRyb', hSb'⟩
      have hb'b : b' = b := (hUb b').1 hSb'
      have hRyb : R y b := hb'b ▸ hRyb'
      exact (hUx y).1 hRyb
    · intro hy
      refine ⟨b, ?_, (hUb b).2 rfl⟩
      rw [hy]
      exact (hUx x).2 rfl

/-- DF-08 (`*30·41` description satisfies relation): if `E! R'a`, then a
witnessing `R`-pre-image of `a` exists (concretely the unique witness). -/
theorem russell_descriptiveFun_witness_exists {α : Type u} {β : Type v}
    {R : FregeRelation α β} {a : β}
    (hProper : russell_descriptiveFun_proper R a) : ∃ x, R x a := by
  obtain ⟨x, hRx, _⟩ := hProper
  exact ⟨x, hRx⟩

/-- DF-09 (`*32·11` unfolded form): the inverse descriptive function is
exactly the contextual elimination over the converse relation; the
formalisation is by definition. -/
theorem russell_inverseDescriptive_unfold {α : Type u} {β : Type v}
    (R : FregeRelation α β) (b : α) (ψ : β → Prop) :
    russell_inverseDescriptive R b ψ ↔ russell_desc_elim (fun y => R b y) ψ :=
  Iff.rfl

/-- DF-10 (`*30·45` description-witness commutes with property): if `E! R'a`
and `R x a` holds for some `x`, then `R'a ψ` reduces to `ψ x`. -/
theorem russell_descriptiveFun_at_witness {α : Type u} {β : Type v}
    {R : FregeRelation α β} {a : β}
    (hProper : russell_descriptiveFun_proper R a) {x : α} (hRxa : R x a)
    (ψ : α → Prop) :
    russell_descriptiveFun R a ψ ↔ ψ x := by
  unfold russell_descriptiveFun
  rw [russell_desc_elim_proper_iff hProper]
  constructor
  · intro h
    exact h x hRxa
  · intro hψx y hRya
    have hyx : y = x := russell_desc_witness_unique hProper hRya hRxa
    exact hyx ▸ hψx

/-- DF-11 (HARD NOVEL `plural-to-singular bridge`): under properness, the
plural existential `∃ x, R x a ∧ ψ x` is equivalent to the singular
description-elimination `R'a ψ`. The genuine bridge is from the existence
of *some* witness with property `ψ` (plural, language-of-classes) to the
description-bound *unique* singular reference (singular, language-of-
individuals). PM uses this to license movement between class-talk and
individual-talk under proper descriptions. -/
theorem russell_desc_plural_to_singular {α : Type u} {β : Type v}
    {R : FregeRelation α β} {a : β}
    (hProper : russell_descriptiveFun_proper R a) (ψ : α → Prop) :
    (∃ x, R x a ∧ ψ x) ↔ russell_descriptiveFun R a ψ := by
  unfold russell_descriptiveFun russell_desc_elim
  obtain ⟨x₀, hRx₀, hUx₀⟩ := hProper
  constructor
  · rintro ⟨x, hRxa, hψx⟩
    have hxx₀ : x = x₀ := hUx₀ x hRxa
    refine ⟨x₀, ?_, hxx₀ ▸ hψx⟩
    intro y
    exact ⟨fun hRy => hUx₀ y hRy, fun hy => hy ▸ hRx₀⟩
  · rintro ⟨x, hUx, hψx⟩
    exact ⟨x, (hUx x).2 rfl, hψx⟩

/-- DF-12 (`*32·12` converse-of-converse description): `R̆̆'a` agrees with
`R'a` extensionally, since the converse-of-converse is the original. -/
theorem russell_descriptiveFun_converse_converse {α : Type u} {β : Type v}
    (R : FregeRelation α β) (a : β) (ψ : α → Prop) :
    russell_descriptiveFun (russell_converse (russell_converse R)) a ψ ↔
      russell_descriptiveFun R a ψ := by
  rw [russell_converse_converse]

end MathlibExpansion.Logic.Russell
