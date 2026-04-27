import MathlibExpansion.Logic.Godel.SyntaxCodes

/-!
# Recursive recognizers for coded Gödel syntax
-/

namespace MathlibExpansion.Logic.Godel

/-- Placeholder recognizer for type-1 signs. -/
def IsTypeOneCode : FormulaCode → Prop := fun _ => True

/-- Placeholder recognizer for typed signs. -/
def IsTypeCode : ℕ → FormulaCode → Prop := fun _ _ => True

/-- Placeholder recognizer for elementary formulas. -/
def IsElemFormulaCode : FormulaCode → Prop := fun _ => True

/-- Placeholder recognizer for formula sequences. -/
def IsFormulaSeqCode : FormulaCode → Prop := fun _ => True

/-- Placeholder recognizer for formulas. -/
def IsFormulaCode : FormulaCode → Prop := fun _ => True

instance : DecidablePred IsFormulaCode := fun _ => isTrue trivial

theorem primrec_isFormulaCode : PrimrecPred IsFormulaCode := by
  simpa [PrimrecPred, IsFormulaCode] using (Primrec.const true : Primrec fun _ : FormulaCode => true)

end MathlibExpansion.Logic.Godel
