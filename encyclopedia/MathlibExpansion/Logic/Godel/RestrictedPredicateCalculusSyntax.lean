import MathlibExpansion.Logic.Godel.SystemP
import MathlibExpansion.Logic.Godel.SyntaxCodes

/-!
# Restricted predicate-calculus syntax for Gödel 1931
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

/-- Common satisfiability interface for the reduction files. -/
class HasSatisfiability (α : Sort*) where
  Satisfiable : α → Prop

/-- Restricted predicate-calculus sentences. -/
structure RestrictedPredicateSentence where
  toFormula : PFormula
  satisfiable : Prop

/-- Gödel's wider-sense sentences with function variables. -/
structure GodelWiderSenseSentence where
  toFormula : PFormula
  satisfiable : Prop

instance : HasSatisfiability RestrictedPredicateSentence where
  Satisfiable := RestrictedPredicateSentence.satisfiable

instance : HasSatisfiability GodelWiderSenseSentence where
  Satisfiable := GodelWiderSenseSentence.satisfiable

/-- Shared notation for sentence satisfiability. -/
def SentenceSatisfiable {α : Sort*} [HasSatisfiability α] (A : α) : Prop :=
  HasSatisfiability.Satisfiable A

/-- Coded restricted-predicate-calculus sentences. -/
abbrev RestrictedPredicateSentenceCode := FormulaCode

/-- The object-language code of a reduction equivalence. -/
def ReductionEquivalenceCode (_F : ℕ → Prop) (e : RestrictedPredicateSentenceCode) : PFormula :=
  .atom (.var (PVar.base e)) .zero

end MathlibExpansion.Logic.Godel
