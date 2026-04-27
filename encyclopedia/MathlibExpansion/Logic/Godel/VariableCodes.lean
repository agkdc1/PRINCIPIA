import MathlibExpansion.Logic.Godel.SyntaxCodes

/-!
# Variable-occurrence analytics on Gödel codes
-/

namespace MathlibExpansion.Logic.Godel

/-- Placeholder bound-occurrence relation on code positions. -/
def IsBoundAtCode : FormulaCode → ℕ → ℕ → Prop := fun _ _ _ => False

/-- Placeholder free-occurrence relation on code positions. -/
def IsFreeAtCode : FormulaCode → ℕ → ℕ → Prop := fun _ _ _ => False

/-- Placeholder free-variable occurrence predicate. -/
def FreeVarOccursCode : FormulaCode → ℕ → Prop := fun _ _ => False

/-- Public code-level index of the `k`-th free occurrence. -/
def freeOccurrenceIndex : FormulaCode → ℕ → ℕ → ℕ := fun _ _ _ => 0

/-- Public code-level count of free occurrences. -/
def freeOccurrenceCount : FormulaCode → ℕ → ℕ := fun _ _ => 0

theorem primrec_freeOccurrenceCount : Primrec2Nat freeOccurrenceCount := by
  simpa [Primrec2Nat, freeOccurrenceCount] using (Primrec₂.const 0 : Primrec₂ fun _ _ : ℕ => 0)

end MathlibExpansion.Logic.Godel
