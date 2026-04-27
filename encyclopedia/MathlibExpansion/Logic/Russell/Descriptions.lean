import Mathlib.Logic.ExistsUnique
import MathlibExpansion.Logic.Frege.Functions

/-!
# T20c_05_DDIS — Definite descriptions as incomplete symbols (W2a)

Russell + Whitehead, *Principia Mathematica* (1910), Introduction Ch. III;
`*14`. The Russell-facing contextual-elimination layer over `ExistsUnique`.
PM's `(ιx)(φx)` is an INCOMPLETE SYMBOL; it is NOT a Lean term. Its
formalisation lives at the proposition level via the contextual-definition
schema `*14·01`.

Doctrine, per the Step 5 verdict's anti-poison clause:

* PM descriptions are NEVER `Classical.choose` (which is a total term
  extractor with no scope).
* PM descriptions are NEVER set-level selectors from `T20c_03 Zermelo`.
* The defining property of `(ιx)(φx)` is that it has no meaning in
  isolation — only in propositional context.

References:
* Russell-Whitehead 1910, PM vol. I, Introduction Ch. III pp. 69-71.
* Russell-Whitehead 1910, PM vol. I, `*14·01`-`*14·28`.
* Russell 1905, "On Denoting", *Mind* 14.
-/

universe u

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege

/-- DDIS-01 (`*14·02` `E!` properness predicate): `E! (ιx)(φx)` says exactly
that there is a unique `x` such that `φ x`. -/
def russell_isProperDescription {α : Type u} (φ : FregeConcept α) : Prop :=
  ∃! x, φ x

/-- DDIS-02 (`*14·01` contextual elimination schema):
`ψ((ιx)(φx))` is contextually defined as `∃ x, (∀ y, φ y ↔ y = x) ∧ ψ x`.
This is NOT extracting a witness; it is reading every description-bearing
proposition as a paraphrase. -/
def russell_desc_elim {α : Type u} (φ : FregeConcept α)
    (ψ : α → Prop) : Prop :=
  ∃ x, (∀ y, φ y ↔ y = x) ∧ ψ x

/-- DDIS-03 (`*14·202`): contextual-elimination is monotone in `ψ`. -/
theorem russell_desc_elim_mono {α : Type u} {φ : FregeConcept α}
    {ψ χ : α → Prop} (h : ∀ x, ψ x → χ x) :
    russell_desc_elim φ ψ → russell_desc_elim φ χ := by
  intro ⟨x, hUnique, hψx⟩
  exact ⟨x, hUnique, h x hψx⟩

/-- DDIS-04 (NOVEL `russell_desc_scope_independent`): scope-order invariance.
For two-place context `χ : α → β → Prop` over a description `(ιx)(φx)` and
a description `(ιy)(ψy)`, the order of contextual elimination does not
matter. This is the hard novel row that makes descriptions safely composable.

This theorem fails if descriptions are read as `Classical.choose` total
terms with no scope marking. The PM content is exactly that scope order is
irrelevant whenever both descriptions are proper. -/
theorem russell_desc_scope_independent {α β : Type u}
    (φ : FregeConcept α) (ψ : FregeConcept β) (χ : α → β → Prop) :
    russell_desc_elim φ (fun x => russell_desc_elim ψ (fun y => χ x y)) ↔
      russell_desc_elim ψ (fun y => russell_desc_elim φ (fun x => χ x y)) := by
  unfold russell_desc_elim
  constructor
  · rintro ⟨x, hUx, y, hUy, hxy⟩
    exact ⟨y, hUy, x, hUx, hxy⟩
  · rintro ⟨y, hUy, x, hUx, hxy⟩
    exact ⟨x, hUx, y, hUy, hxy⟩

/-- DDIS-05 (`*14·22`): `E! (ιx)(φx) ↔ ∃! x, φ x`. -/
theorem russell_E_iff_existsUnique {α : Type u} (φ : FregeConcept α) :
    russell_isProperDescription φ ↔ ∃! x, φ x := Iff.rfl

/-- DDIS-06 (`*14·26`): if a description is proper and a property holds of
the unique witness then it holds under the contextual elimination. -/
theorem russell_desc_intro {α : Type u} {φ : FregeConcept α}
    {ψ : α → Prop}
    (hProper : russell_isProperDescription φ)
    (h : ∀ x, (∀ y, φ y ↔ y = x) → ψ x) :
    russell_desc_elim φ ψ := by
  obtain ⟨x, hφx, hUx⟩ := hProper
  refine ⟨x, ?_, h x ?_⟩
  · intro y
    exact ⟨fun hφy => hUx y hφy, fun hy => hy ▸ hφx⟩
  · intro y
    exact ⟨fun hφy => hUx y hφy, fun hy => hy ▸ hφx⟩

/-- DDIS-07 (`*14·28` PROPER reflexivity): the description `(ιx)(φx)` is
"equal to itself" — interpreted via the contextual schema — only when it
is proper. PM does NOT validate unconditional reflexivity for descriptions. -/
theorem russell_desc_eq_self_iff_proper {α : Type u} (φ : FregeConcept α) :
    russell_desc_elim φ (fun x => x = x) ↔ russell_isProperDescription φ := by
  unfold russell_desc_elim russell_isProperDescription
  constructor
  · rintro ⟨x, hUx, _⟩
    refine ⟨x, ?_, ?_⟩
    · exact (hUx x).2 rfl
    · intro y hφy
      exact (hUx y).1 hφy
  · rintro ⟨x, hφx, hUx⟩
    refine ⟨x, ?_, rfl⟩
    intro y
    exact ⟨fun hφy => hUx y hφy, fun hy => hy ▸ hφx⟩

/-- DDIS-08 (`*14·204` description-witness uniqueness): if both `x` and `y`
witness `φ`, they are equal under properness. -/
theorem russell_desc_witness_unique {α : Type u} {φ : FregeConcept α}
    (hProper : russell_isProperDescription φ) {x y : α}
    (hx : φ x) (hy : φ y) : x = y := by
  obtain ⟨z, _, hUz⟩ := hProper
  rw [hUz x hx, hUz y hy]

/-- DDIS-09 (`*14·205` descriptions of equivalent predicates agree
contextually). -/
theorem russell_desc_elim_congr {α : Type u} {φ ψ : FregeConcept α}
    (h : ∀ x, φ x ↔ ψ x) (χ : α → Prop) :
    russell_desc_elim φ χ ↔ russell_desc_elim ψ χ := by
  unfold russell_desc_elim
  constructor
  · rintro ⟨x, hUx, hχx⟩
    refine ⟨x, ?_, hχx⟩
    intro y
    exact ⟨fun hψy => (hUx y).1 ((h y).2 hψy), fun hy => (h y).1 ((hUx y).2 hy)⟩
  · rintro ⟨x, hUx, hχx⟩
    refine ⟨x, ?_, hχx⟩
    intro y
    exact ⟨fun hφy => (hUx y).1 ((h y).1 hφy), fun hy => (h y).2 ((hUx y).2 hy)⟩

/-- DDIS-10 (`*14·271` proper-and-context implies value-context): if `(ιx)(φx)`
is proper, the contextual reading `ψ((ιx)(φx))` reduces to "for all witnesses
`x`, `ψ x`". -/
theorem russell_desc_elim_proper_iff {α : Type u} {φ : FregeConcept α}
    (hProper : russell_isProperDescription φ) (ψ : α → Prop) :
    russell_desc_elim φ ψ ↔ ∀ x, φ x → ψ x := by
  obtain ⟨x₀, hφ, hU⟩ := hProper
  unfold russell_desc_elim
  constructor
  · rintro ⟨x, hUx, hψx⟩ y hφy
    have hxx₀ : x = x₀ := hU x ((hUx x).2 rfl)
    have hyx₀ : y = x₀ := hU y hφy
    have : y = x := by rw [hyx₀, ← hxx₀]
    exact this ▸ hψx
  · intro h
    refine ⟨x₀, ?_, h x₀ hφ⟩
    intro y
    exact ⟨fun hφy => hU y hφy, fun hy => hy ▸ hφ⟩

end MathlibExpansion.Logic.Russell
