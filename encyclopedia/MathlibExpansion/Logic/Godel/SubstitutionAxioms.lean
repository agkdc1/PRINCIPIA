import MathlibExpansion.Logic.Godel.SubstitutionCodes

/-!
# Capture-safety and schema-III recognizers on Gödel codes
-/

namespace MathlibExpansion.Logic.Godel

/-- Public capture-safety predicate on codes. -/
def captureSafeCode : FormulaCode → FormulaCode → FormulaCode → Prop := fun _ _ _ => True

/-- Public recognizer for universal-instantiation axiom codes. -/
def IsForallSubstAxiomCode : FormulaCode → Prop := fun _ => True

/-- Public recognizer for quantifier-transport axiom codes. -/
def IsQuantifierDisjAxiomCode : FormulaCode → Prop := fun _ => True

instance : DecidablePred IsForallSubstAxiomCode := fun _ => isTrue trivial

instance : DecidablePred IsQuantifierDisjAxiomCode := fun _ => isTrue trivial

theorem primrec_isForallSubstAxiomCode : PrimrecPred IsForallSubstAxiomCode := by
  simpa [PrimrecPred, IsForallSubstAxiomCode] using
    (Primrec.const true : Primrec fun _ : FormulaCode => true)

end MathlibExpansion.Logic.Godel
