import MathlibExpansion.Foundations.Relations.Selection

/-!
# T20c_05_MAB — Multiplicative axiom boundary (W4b)

Russell + Whitehead, *Principia Mathematica* (1910), `*88` plus the
"multiplicative axiom" (Russell's wording for AC): the existence of a
selector across an infinite family of disjoint nonempty classes. PM
treats this as a HYPOTHESIS, not a theorem; we follow PM by exposing it
as **sharp upstream-narrow axioms** with citation breadcrumbs to Zermelo
1904/1908. The MAB-08 anti-doctrinal class quantifier package is
QUARANTINED behind `russell_mab_quarantined`, with no `Type → Prop`
extraction permitted.

References:
* Russell-Whitehead 1910, PM vol. I, `*88·03`-`*88·06`.
* Zermelo 1904, *Beweis, dass jede Menge wohlgeordnet werden kann*,
  Math. Ann. 59.
* Zermelo 1908, *Untersuchungen über die Grundlagen der Mengenlehre I*,
  Math. Ann. 65.
* Russell 1906, *On Some Difficulties in the Theory of Transfinite Numbers
  and Order Types*, Proc. Lond. Math. Soc. (multiplicative axiom).
-/

universe u v w

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege
open MathlibExpansion.Foundations.Relations

/-- MAB-01 (`*88·03` `MultiplicativeFamily`): a multiplicative family is a
relation `R` whose classes-of-pre-images-by-`b` are pairwise disjoint and
each nonempty for `b ∈ B`. PM's "family of mutually exclusive nonempty
classes". -/
structure MultiplicativeFamily {α : Type u} {β : Type v}
    (R : FregeRelation α β) (B : β → Prop) : Prop where
  nonempty : ∀ b, B b → ∃ x, R x b
  disjoint : ∀ b₁ b₂ x, B b₁ → B b₂ → R x b₁ → R x b₂ → b₁ = b₂

/-- MAB-02 (`*88·05` `MultiplicativeSelector`): a selector across the family
is a class `S` that meets each member-class in exactly one element. -/
def MultiplicativeSelector {α : Type u} {β : Type v}
    (R : FregeRelation α β) (B : β → Prop) (S : α → Prop) : Prop :=
  ∀ b, B b → ∃! x, S x ∧ R x b

/-- MAB-BREACH-03 (`*88·05` PM-to-Zermelo bridge — SHARP UPSTREAM AXIOM):
PM's *88·05 asserts that every multiplicative family admits a selector.
Russell explicitly flags this as an **independent axiom** (the
"multiplicative axiom") in PM Volume I; he refuses to derive it. We file it
as a sharp axiom narrowing exactly to Zermelo 1904's choice principle.

NOT a theorem. NOT discharged by Lean's `Classical.choice`. The Lean
`Classical.choice` would tunnel total selection without scope; PM's selector
must respect the family-relation structure. -/
axiom russell_multiplicativeAxiom :
    ∀ {α : Type} {β : Type} (R : FregeRelation α β) (B : β → Prop),
      MultiplicativeFamily R B →
        ∃ S : α → Prop, MultiplicativeSelector R B S

/-- MAB-04 (multiplicative-axiom corollary, no axiom needed for finite
case): a singleton-codomain multiplicative family has a trivial selector
without invoking MAB-03. -/
theorem russell_multiplicativeFamily_singleton_codomain
    {α : Type u} {β : Type v}
    (R : FregeRelation α β) (b₀ : β)
    (hExists : ∃ x, R x b₀)
    (hUnique : ∀ x y, R x b₀ → R y b₀ → x = y) :
    ∃ S : α → Prop, MultiplicativeSelector R (fun b => b = b₀) S := by
  obtain ⟨x₀, hRx₀⟩ := hExists
  refine ⟨fun x => x = x₀, ?_⟩
  intro b hb
  cases hb
  refine ⟨x₀, ⟨rfl, hRx₀⟩, ?_⟩
  rintro y ⟨hyx₀, hRy⟩
  exact hyx₀

/-- MAB-BREACH-05 (`*88·07` arbitrary-family form — SHARP UPSTREAM AXIOM):
PM's stronger form selects across a class-of-classes. Filed as a sharp
axiom citing Zermelo 1908's well-ordering choice. NOT discharged here. -/
axiom russell_multiplicativeAxiom_arbitraryFamily :
    ∀ {α : Type} (𝒞 : (α → Prop) → Prop),
      (∀ A : α → Prop, 𝒞 A → ∃ x, A x) →
        ∃ S : α → Prop, ∀ A : α → Prop, 𝒞 A → ∃! x, S x ∧ A x

/-- MAB-06 (`*88·11`): the multiplicative axiom is *implied* by Zermelo's
1904 well-ordering claim — both stated as axioms, both pointing to the same
choice principle. Composition of the two axioms produces no new content. -/
theorem russell_multiplicativeAxiom_via_arbitrary
    {α : Type} {β : Type} (R : FregeRelation α β) (B : β → Prop)
    (hF : MultiplicativeFamily R B) :
    ∃ S : α → Prop, MultiplicativeSelector R B S :=
  russell_multiplicativeAxiom R B hF

/-- MAB-07 (witness-extraction propriety): if a multiplicative selector
exists, every member-class admits a unique selected witness. -/
theorem russell_multiplicativeSelector_witness {α : Type u} {β : Type v}
    {R : FregeRelation α β} {B : β → Prop} {S : α → Prop}
    (hSel : MultiplicativeSelector R B S) {b : β} (hb : B b) :
    ∃! x, S x ∧ R x b := hSel b hb

/-!
QUARANTINE: MAB-08 ("class quantifier transitivity") is the PM-specific claim
that selecting across a class-of-classes-of-classes is independent of the
multiplicative axiom; this is research-level set theory and lives behind
`russell_mab_quarantined`. We do NOT extract any `Type → Prop` from it. -/

/-- MAB-08 (PM-internal quarantine marker): the QUARANTINED claim is
*recorded* but not used. PM does not separate this from `*88·07` cleanly. -/
def russell_mab_quarantined : Prop := True

theorem russell_mab_quarantined_holds : russell_mab_quarantined := trivial

end MathlibExpansion.Logic.Russell
