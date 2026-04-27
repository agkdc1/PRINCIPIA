import MathlibExpansion.Logic.Frege.Functions

/-!
# T20c_05_IDEI — Identity as extensional indiscernibility (W1b)

Russell + Whitehead, *Principia Mathematica* (1910), `*13`. PM-facing wrappers
over Lean's `Eq` plus three novel rows (IDEI_08/09/10) that establish
identity-fiber elimination — directly consumed by `*14` descriptions.

References:
* Russell-Whitehead 1910, PM vol. I, `*13·01`-`*13·22`, pp. 168-179.
* Russell-Whitehead 1910, PM vol. I, Introduction Ch. III pp. 59-60
  (Leibniz identity-of-indiscernibles commentary).
* Leibniz, *Discours de Métaphysique* §IX (historical antecedent for IDEI_01,
  quarantine-only).
-/

universe u

namespace MathlibExpansion.Textbooks.Principia1910

open MathlibExpansion.Logic.Frege

/-- IDEI-02 (`*13·15` reflexivity): `a = a`. -/
theorem russell_eq_refl {α : Type u} (a : α) : a = a := rfl

/-- IDEI-03 (`*13·16` symmetry): `a = b → b = a`. -/
theorem russell_eq_symm {α : Type u} {a b : α} (h : a = b) : b = a := h.symm

/-- IDEI-04 (`*13·17` transitivity): `a = b ∧ b = c → a = c`. -/
theorem russell_eq_trans {α : Type u} {a b c : α} (h₁ : a = b) (h₂ : b = c) :
    a = c := h₁.trans h₂

/-- IDEI-05 (`*13·12` substitution under unary predicate). -/
theorem russell_eq_subst {α : Type u} {a b : α} (P : FregeConcept α)
    (h : a = b) (ha : P a) : P b :=
  h ▸ ha

/-- IDEI-06 (`*13·13` general substitution). -/
theorem russell_eq_subst_iff {α : Type u} {a b : α} (P : FregeConcept α)
    (h : a = b) : P a ↔ P b := by
  rw [h]

/-- IDEI-07 (`*13·22` chained substitution). -/
theorem russell_eq_chained {α : Type u} {a b c : α} {P : FregeConcept α}
    (h₁ : a = b) (h₂ : b = c) (h : P a) : P c :=
  h₂ ▸ h₁ ▸ h

/-- IDEI-08 (NOVEL `russell_identity_fiber_of`): given `a = b`, the identity
fiber predicate `fun x => x = a` is satisfied at `b`. This is the carrier
fact for `*14` description equality reasoning. -/
theorem russell_identity_fiber_of {α : Type u} {a b : α} (h : a = b) :
    (fun x => x = a) b := by
  show b = a
  exact h.symm

/-- IDEI-09 (NOVEL `russell_fiber_elim`): if every unary predicate that holds
at `a` also holds at `b`, then `a = b`. The Leibniz substitutivity-implies-
identity direction. -/
theorem russell_fiber_elim {α : Type u} {a b : α}
    (h : ∀ P : α → Prop, P a → P b) : a = b := by
  exact h (fun x => a = x) rfl

/-- IDEI-10 (NOVEL `russell_indiscernibility_iff`): the Leibniz
characterization. `a = b ↔ ∀ P, P a ↔ P b`. Directly consumed by `*14`
description equality. -/
theorem russell_indiscernibility_iff {α : Type u} {a b : α} :
    a = b ↔ ∀ P : α → Prop, P a ↔ P b := by
  constructor
  · intro h P
    exact ⟨fun ha => h ▸ ha, fun hb => h.symm ▸ hb⟩
  · intro h
    exact (h (fun x => a = x)).1 rfl

/-!
QUARANTINE: IDEI-01 (identity as a definitional primitive in PM's ramified
ontology, distinct from the Leibniz extensional reading) is intentionally
NOT formalised here. PM Introduction Ch. III pp. 59-60 explicitly distances
itself from Leibniz's metaphysical primitive identity, and the formal
content `*13` actually delivers is the extensional indiscernibility above.
-/

end MathlibExpansion.Textbooks.Principia1910
