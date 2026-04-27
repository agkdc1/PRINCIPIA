import MathlibExpansion.Logic.Godel.ProofSequence

/-!
# Proof relation and provability predicate on codes
-/

namespace MathlibExpansion.Logic.Godel

/-- `proof B formula`: the proof code ends with the coded formula. -/
def ProvesCode (proof formula : FormulaCode) : Prop :=
  IsProofSequenceCode proof ∧ lastLineCode proof = formula

/-- `Bew(formula)`: some proof code ends with `formula`. -/
def ProvableCode (formula : FormulaCode) : Prop := ∃ proof : FormulaCode, ProvesCode proof formula

/-- Public synonym used by the later diagonal files. -/
abbrev ProofIn := ProvesCode

/-- Public synonym used by the later diagonal files. -/
abbrev ProvableIn := ProvableCode

end MathlibExpansion.Logic.Godel
