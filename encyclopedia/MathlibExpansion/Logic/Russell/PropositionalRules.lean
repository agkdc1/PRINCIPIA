import MathlibExpansion.Logic.Frege.SafeShadow

/-!
# T20c_05_RPD — Russell propositional-rule wrappers (F2)

Russell + Whitehead, *Principia Mathematica* (1910), `*1`-`*5`. PM's
propositional calculus is mathematically subsumed by Lean's `Prop`, but PM's
proof-presentation discipline (judgmental modus ponens, real-variable rule,
exportation/importation names) is not surfaced anywhere in Mathlib. This file
adds the named PM-facing wrappers.

Quarantine: PM's elementary-proposition syntax (`*1·01` primitive `~ p ∨ q`
matrix) is NOT formalised here; that lives in the elementary-proposition
syntax quarantine block of `RamifiedTypes.lean`.
-/

universe u

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege

/-- RPD-02 (`*1·1`): judgmental modus ponens. PM's assertion-stroke
`⊢ p ⊃ q, ⊢ p ⟹ ⊢ q` — Russell-facing wrapper for the inference rule. -/
theorem russell_modus_ponens {p q : Prop} (h₁ : p → q) (h₂ : p) : q := h₁ h₂

/-- RPD-03 (`*1·11`): schematic real-variable modus ponens at the unary level.
Wrapper around `frege_forall_fun_elim` at `Logic/Frege/SafeShadow.lean:26`. -/
theorem russell_real_variable_mp {α : Type u} {Φ : FregeConcept α → Prop}
    (h : ∀ F, Φ F) (G : FregeConcept α) : Φ G :=
  frege_forall_fun_elim h G

/-- RPD-04 (`*2·02`): conjunction introduction. PM-facing name. -/
theorem russell_and_intro {p q : Prop} (hp : p) (hq : q) : p ∧ q := ⟨hp, hq⟩

/-- RPD-05 (`*3·26`): left projection. -/
theorem russell_and_left {p q : Prop} (h : p ∧ q) : p := h.1

/-- RPD-06 (`*3·27`): right projection. -/
theorem russell_and_right {p q : Prop} (h : p ∧ q) : q := h.2

/-- RPD-07 (`*4·1`): permutation / commutativity of conjunction. -/
theorem russell_and_comm {p q : Prop} : p ∧ q ↔ q ∧ p := And.comm

/-- RPD-08 (`*4·2`): equivalence is symmetric. -/
theorem russell_iff_symm {p q : Prop} (h : p ↔ q) : q ↔ p := h.symm

/-- RPD-09 (`*4·22`): equivalence is transitive. -/
theorem russell_iff_trans {p q r : Prop} (h₁ : p ↔ q) (h₂ : q ↔ r) : p ↔ r :=
  h₁.trans h₂

/-- RPD-13 (`*4·76`-`*5·44` exportation/importation). PM-facing exportation
shell over `Imp.swap` at `Mathlib/Logic/Basic.lean`. -/
theorem russell_exportation {p q r : Prop} (h : p ∧ q → r) : p → q → r :=
  fun hp hq => h ⟨hp, hq⟩

theorem russell_importation {p q r : Prop} (h : p → q → r) : p ∧ q → r :=
  fun ⟨hp, hq⟩ => h hp hq

/-!
RPD-15 (elementary-proposition syntax) is intentionally left as a quarantine
note. PM's primitive matrix `~ p ∨ q` cannot be honestly identified with
Lean's `Prop`-level connectives without a separate ramified-syntax layer.
That belongs in `RamifiedTypes.lean`, not here.
-/

end MathlibExpansion.Logic.Russell
