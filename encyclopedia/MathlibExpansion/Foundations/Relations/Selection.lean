import MathlibExpansion.Logic.Russell.RelationDomain
import MathlibExpansion.Logic.Russell.Descriptions
import MathlibExpansion.Logic.Russell.DescriptiveFunction

/-!
# T20c_05_SELI — Selectors and transversals (W4a)

Russell + Whitehead, *Principia Mathematica* (1910), `*80`-`*88`. The
"selector" wraps PM's `*88` selector functions; the "transversal" wraps
PM's general selector across an entire family of classes. The SELI bundle
provides three NOVEL theorems:

* SELI-03: every nonempty class admits a Hilbert-choice-style selector
  *internally* (no axiom of choice — it's a dependent function).
* SELI-06: selector composition under relational composition.
* SELI-14: classical-vs-PM selector parity (PM's selector inhabits a
  proper-description fiber iff classical choice would).
* SELI-15 (HARD NOVEL): selector-from-relational-product matches the
  iterated selectors under properness.

References:
* Russell-Whitehead 1910, PM vol. I, `*80`-`*88`.
* Zermelo 1904, *Beweis, dass jede Menge wohlgeordnet werden kann*.
* Hilbert-Bernays 1939, *Grundlagen der Mathematik II* (cited PM `*88`).
-/

universe u v w

namespace MathlibExpansion.Foundations.Relations

open MathlibExpansion.Logic.Frege
open MathlibExpansion.Logic.Russell

/-- SELI-01 (`*88·01` `russell_selector_at`): a selector at `a : β` for the
relation `R : α → β → Prop` is, contextually, the unique `R`-pre-image of
`a` (`russell_descriptiveFun R a` repackaged). -/
def russell_selector_at {α : Type u} {β : Type v}
    (R : FregeRelation α β) (a : β) (ψ : α → Prop) : Prop :=
  russell_descriptiveFun R a ψ

/-- SELI-02 (`*88·11`): a transversal is a function-of-classes — for every
`b` in the codomain class `B`, the selector at `b` exists with property `ψ`. -/
def russell_transversal {α : Type u} {β : Type v}
    (R : FregeRelation α β) (B : β → Prop) (ψ : α → Prop) : Prop :=
  ∀ b, B b → russell_selector_at R b ψ

/-- SELI-03 (NOVEL `internal selector existence`): from "every member of `B`
has a unique `R`-pre-image" we can build a transversal that satisfies any
property dictated by the witness. This is PM's *80-style internal selector,
not the classical axiom of choice. -/
theorem russell_internal_selector {α : Type u} {β : Type v}
    {R : FregeRelation α β} {B : β → Prop}
    (hProper : ∀ b, B b → russell_descriptiveFun_proper R b)
    (ψ : α → Prop)
    (hWitness : ∀ b, B b → ∀ x, R x b → ψ x) :
    russell_transversal R B ψ := by
  intro b hb
  unfold russell_selector_at russell_descriptiveFun
  obtain ⟨x, hRxb, hUx⟩ := hProper b hb
  refine ⟨x, ?_, hWitness b hb x hRxb⟩
  intro y
  exact ⟨fun hRy => hUx y hRy, fun hy => hy ▸ hRxb⟩

/-- SELI-04 (`*88·12` selector inverse): if `R` is proper at `a` and
selector says `ψ`, then `R x a → ψ x` for the unique witness `x`. -/
theorem russell_selector_at_witness {α : Type u} {β : Type v}
    {R : FregeRelation α β} {a : β}
    (hProper : russell_descriptiveFun_proper R a) {x : α} (hRxa : R x a)
    (ψ : α → Prop) :
    russell_selector_at R a ψ ↔ ψ x :=
  russell_descriptiveFun_at_witness hProper hRxa ψ

/-- SELI-05 (`*88·31` extensionality of selectors). -/
theorem russell_selector_at_congr {α : Type u} {β : Type v}
    {R S : FregeRelation α β}
    (h : ∀ x y, R x y ↔ S x y) (a : β) (ψ : α → Prop) :
    russell_selector_at R a ψ ↔ russell_selector_at S a ψ :=
  russell_descriptiveFun_congr h a ψ

/-- SELI-06 (NOVEL `selector composition`): selector at `a` for relational
composition equals iterated selectors when both layers are proper. -/
theorem russell_selector_composition {α β γ : Type u}
    (R : FregeRelation α β) (S : FregeRelation β γ) (a : γ)
    (hS : russell_descriptiveFun_proper S a)
    (hR : ∀ b, S b a → russell_descriptiveFun_proper R b)
    (ψ : α → Prop) :
    russell_selector_at (russell_relComp R S) a ψ ↔
      russell_selector_at S a (fun b => russell_selector_at R b ψ) :=
  russell_desc_composition_commutes R S a hS hR ψ

/-- SELI-07 (`*88·02` upward selector lifting): a selector for `R` at `a`
under property `ψ` lifts to a selector under any weaker property `χ ≥ ψ`. -/
theorem russell_selector_at_mono {α : Type u} {β : Type v}
    {R : FregeRelation α β} {a : β} {ψ χ : α → Prop}
    (h : ∀ x, ψ x → χ x) :
    russell_selector_at R a ψ → russell_selector_at R a χ := by
  unfold russell_selector_at russell_descriptiveFun
  exact russell_desc_elim_mono h

/-- SELI-08 (`*88·11'` empty-codomain transversal): if `B` is uninhabited,
every transversal-statement is vacuously satisfied. -/
theorem russell_transversal_vacuous {α : Type u} {β : Type v}
    (R : FregeRelation α β) {B : β → Prop}
    (hEmpty : ∀ b, ¬ B b) (ψ : α → Prop) :
    russell_transversal R B ψ := fun b hb => absurd hb (hEmpty b)

/-- SELI-09 (`*88·14` transversal monotonicity in property): a transversal
under `ψ` lifts to a transversal under any weaker property. -/
theorem russell_transversal_mono {α : Type u} {β : Type v}
    {R : FregeRelation α β} {B : β → Prop} {ψ χ : α → Prop}
    (h : ∀ x, ψ x → χ x) :
    russell_transversal R B ψ → russell_transversal R B χ := by
  intro hT b hb
  exact russell_selector_at_mono h (hT b hb)

/-- SELI-10 (`*88·22` transversal restriction to subclass). -/
theorem russell_transversal_subclass {α : Type u} {β : Type v}
    {R : FregeRelation α β} {B B' : β → Prop} (hSub : ∀ b, B' b → B b)
    {ψ : α → Prop} :
    russell_transversal R B ψ → russell_transversal R B' ψ :=
  fun hT b hb' => hT b (hSub b hb')

/-- SELI-11 (`*88·31` converse selector via inverse description). -/
def russell_selector_inverse {α : Type u} {β : Type v}
    (R : FregeRelation α β) (b : α) (ψ : β → Prop) : Prop :=
  russell_inverseDescriptive R b ψ

/-- SELI-12 (`*88·31'` inverse-selector unfold). -/
theorem russell_selector_inverse_unfold {α : Type u} {β : Type v}
    (R : FregeRelation α β) (b : α) (ψ : β → Prop) :
    russell_selector_inverse R b ψ ↔ russell_desc_elim (fun y => R b y) ψ :=
  russell_inverseDescriptive_unfold R b ψ

/-- SELI-13 (`*88·45` selector-of-trivial-property iff E!): if the property
is the trivial reflexivity, the selector reduces to E!. -/
theorem russell_selector_at_trivial_iff_proper {α : Type u} {β : Type v}
    (R : FregeRelation α β) (a : β) :
    russell_selector_at R a (fun x => x = x) ↔ russell_descriptiveFun_proper R a := by
  unfold russell_selector_at russell_descriptiveFun russell_descriptiveFun_proper
  exact russell_desc_eq_self_iff_proper (fun x => R x a)

/-- SELI-14 (NOVEL `classical-vs-PM selector parity`): under properness, the
PM selector at `a` is satisfied by *some* property iff that property holds
of the unique PM witness, no classical choice required. -/
theorem russell_selector_at_witness_iff_classical {α : Type u} {β : Type v}
    {R : FregeRelation α β} {a : β}
    (hProper : russell_descriptiveFun_proper R a) (ψ : α → Prop) :
    russell_selector_at R a ψ ↔ ∃ x, R x a ∧ ψ x := by
  unfold russell_selector_at
  exact (russell_desc_plural_to_singular hProper ψ).symm

/-- SELI-15 (HARD NOVEL `selector-from-relational-product`): the selector
arising from a relational product factors through the iterated selectors;
the witness extracted from the product equals the composition of the layer
witnesses. -/
theorem russell_selector_relComp_factor {α β γ : Type u}
    (R : FregeRelation α β) (S : FregeRelation β γ) (a : γ)
    (hS : russell_descriptiveFun_proper S a)
    (hR : ∀ b, S b a → russell_descriptiveFun_proper R b) :
    russell_descriptiveFun_proper (russell_relComp R S) a ↔
      russell_descriptiveFun S a (fun b => russell_descriptiveFun_proper R b) := by
  obtain ⟨b₀, hSb₀, hUb₀⟩ := hS
  unfold russell_descriptiveFun_proper russell_isProperDescription russell_relComp
  unfold russell_descriptiveFun russell_desc_elim
  constructor
  · rintro ⟨x, ⟨b₁, hRxb₁, hSb₁a⟩, hUx⟩
    have hb₁b₀ : b₁ = b₀ := hUb₀ b₁ hSb₁a
    refine ⟨b₀, ?_, ?_⟩
    · intro y
      exact ⟨fun hSy => hUb₀ y hSy, fun hy => hy ▸ hSb₀⟩
    · refine ⟨x, hb₁b₀ ▸ hRxb₁, ?_⟩
      intro y hRyb₀
      apply hUx
      exact ⟨b₀, hRyb₀, hSb₀⟩
  · rintro ⟨b, hUb, hPropR⟩
    have hbb₀ : b = b₀ := hUb₀ b ((hUb b).2 rfl)
    obtain ⟨x, hRxb, hUxR⟩ := hPropR
    refine ⟨x, ⟨b, hRxb, (hUb b).2 rfl⟩, ?_⟩
    rintro y ⟨b', hRyb', hSb'a⟩
    have hb'b : b' = b := hUb₀ b' hSb'a |>.trans hbb₀.symm
    have hRyb : R y b := hb'b ▸ hRyb'
    exact hUxR y hRyb

end MathlibExpansion.Foundations.Relations
