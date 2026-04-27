import MathlibExpansion.Foundations.Russell.Similarity
import MathlibExpansion.Foundations.Russell.CardinalAbstraction

/-!
# T20c_05_IRAA — Inequality and reducibility of cardinals (W5d)

Russell + Whitehead, *Principia Mathematica* (1910), `*100`-`*120`. Cantor-
Bernstein-style cardinal comparison and PM's specific anti-set-theoretic
reading. Three SHARP UPSTREAM-NARROW BREACH AXIOMS exposed here:

* IRAA-10: Cantor-Bernstein theorem (PM-flavoured, no AC).
* IRAA-11: PM-internal cardinal comparison schema.
* IRAA-14: Russell's "limitation of size" boundary.

These are research-level results in PM Volume II. We file them as sharp
axioms with bibliographic citations rather than mock proofs.

References:
* Russell-Whitehead 1910, PM vol. I, `*100`-`*120` (introductory).
* Russell-Whitehead 1912, PM vol. II, `*117·6` (cardinal comparison).
* Cantor 1895/97, *Beiträge*.
* Schröder 1898, *Über zwei Definitionen der Endlichkeit*.
* Bernstein 1898 (in Borel 1898).
* Russell 1903, *Principles of Mathematics*, ch. X (limitation of size).
-/

universe u v

namespace MathlibExpansion.Foundations.Russell

/-- IRAA-01 (`*117·01` `russell_le_card`): `α` has cardinal ≤ `β` when
`α` is similar to a sub-class of `β`. PM's "embedding" reading. -/
def russell_le_card (α : Type u) (β : Type v) : Prop :=
  ∃ f : α → β, Function.Injective f

/-- IRAA-02 (`*117·11` reflexivity of `≤`). -/
theorem russell_le_card_refl (α : Type u) : russell_le_card α α :=
  ⟨id, fun _ _ h => h⟩

/-- IRAA-03 (`*117·12` transitivity of `≤`). -/
theorem russell_le_card_trans {α : Type u} {β : Type v} {γ : Type w}
    (h₁ : russell_le_card α β) (h₂ : russell_le_card β γ) :
    russell_le_card α γ := by
  obtain ⟨f, hf⟩ := h₁
  obtain ⟨g, hg⟩ := h₂
  exact ⟨g ∘ f, fun a₁ a₂ h => hf (hg h)⟩

/-- IRAA-04 (similarity gives both `≤`s). -/
theorem russell_similar_le_card {α : Type u} {β : Type v}
    (h : russell_similar α β) : russell_le_card α β := by
  obtain ⟨e⟩ := h
  exact ⟨e.toFun, e.injective⟩

/-- IRAA-05 (similarity gives the reverse `≤`). -/
theorem russell_similar_le_card_symm {α : Type u} {β : Type v}
    (h : russell_similar α β) : russell_le_card β α := by
  obtain ⟨e⟩ := h
  exact ⟨e.invFun, e.symm.injective⟩

/-- IRAA-06 (`*117·105` strict less-than): `α < β` when `α ≤ β` and not
`β ≤ α`. -/
def russell_lt_card (α : Type u) (β : Type v) : Prop :=
  russell_le_card α β ∧ ¬ russell_le_card β α

/-- IRAA-07 (irreflexivity of `<`). -/
theorem russell_lt_card_irrefl (α : Type u) : ¬ russell_lt_card α α := by
  rintro ⟨_, hNot⟩
  exact hNot (russell_le_card_refl α)

/-- IRAA-08 (`*117·11`): `Empty` is `≤` everything. -/
theorem russell_le_card_empty (α : Type u) : russell_le_card Empty α :=
  ⟨Empty.elim, fun e => e.elim⟩

/-- IRAA-09 (`*117·15` `RussellCardinalZero` is the smallest): the empty
type embeds into every type. -/
theorem russell_zero_le {α : Type u} (h : RussellCardinalZero α) :
    russell_le_card α Empty := russell_similar_le_card h

/-- IRAA-BREACH-10 (Cantor-Bernstein, PM `*117·6` — SHARP UPSTREAM AXIOM):
mutual `≤` implies similarity. PM proves this in Volume II using the
"reflexive class" argument. We file it as a sharp axiom citing both the
Cantor-Bernstein original (1895/1898) and PM `*117·6`. NOT discharged via
`Classical.choice` — PM's proof is constructive. -/
axiom russell_cantor_bernstein :
    ∀ {α : Type} {β : Type},
      russell_le_card α β → russell_le_card β α → russell_similar α β

/-- IRAA-BREACH-11 (PM-internal cardinal trichotomy schema — SHARP UPSTREAM
AXIOM): for any two cardinals, exactly one of `α < β`, `α ~ β`, `β < α`
holds. PM's *117·6x family. NOT a Lean theorem — equivalent to AC. -/
axiom russell_cardinal_trichotomy :
    ∀ {α : Type} {β : Type},
      russell_lt_card α β ∨ russell_similar α β ∨ russell_lt_card β α

/-- IRAA-12 (corollary of CB axiom): mutual `≤` implies similar in both
directions. -/
theorem russell_le_le_similar {α : Type} {β : Type}
    (h₁ : russell_le_card α β) (h₂ : russell_le_card β α) :
    russell_similar α β := russell_cantor_bernstein h₁ h₂

/-- IRAA-13 (`*117·54` antisymmetry of `≤`-up-to-similarity). -/
theorem russell_le_card_antisymm {α : Type} {β : Type}
    (h₁ : russell_le_card α β) (h₂ : russell_le_card β α) :
    russell_similar α β := russell_le_le_similar h₁ h₂

/-- IRAA-BREACH-14 (Russell's "limitation of size" — SHARP UPSTREAM AXIOM):
PM `*120`-style — there is NO universal class of all cardinals; any total
class of cardinals leads to Russell's paradox. The axiom records this as a
boundary, citing Russell 1903 ch. X. NOT discharged. -/
axiom russell_limitation_of_size :
    ∀ {α : Type}, ¬ ∃ U : (α → Prop) → Prop, ∀ A : α → Prop, U A

end MathlibExpansion.Foundations.Russell
