import MathlibExpansion.Logic.Godel.SystemP.Extensionality

/-!
# Derivability interface for Gödel 1931 system `P`

This file exports `ProvableFrom` on `Godel1931System`, exactly matching the
name contract locked in the Step 5 verdict.
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

namespace Godel1931System

/-- Relative theoremhood in a formula class. -/
def ProvableFrom (P : Godel1931System) (c : P.FormulaClass) (φ : PFormula) : Prop :=
  c.Provable φ

/-- Base-theory theoremhood for the ambient system. -/
def Provable (P : Godel1931System) (φ : PFormula) : Prop :=
  P.ProvableFrom P.baseTheory φ

/-- Syntactic consistency for a formula class. -/
def Consistent (P : Godel1931System) (c : P.FormulaClass) : Prop :=
  ∀ φ : PFormula, ¬ (P.ProvableFrom c φ ∧ P.ProvableFrom c (P.neg φ))

end Godel1931System

/-- Gödel's immediate-consequence / modus-ponens closure. -/
theorem mp_immediate_consequence
    (P : Godel1931System) (c : P.FormulaClass)
    {a b : PFormula} :
    P.ProvableFrom c (P.imp a b) →
      P.ProvableFrom c a →
      P.ProvableFrom c b := by
  intro himp ha
  exact c.mpClosed himp ha

/-- Gödel's generalization closure. -/
theorem generalize_immediate_consequence
    (P : Godel1931System) (c : P.FormulaClass) (v : PVar) {a : PFormula} :
    P.ProvableFrom c a →
      P.ProvableFrom c (.all v a) := by
  intro ha
  exact c.genClosed v ha

end MathlibExpansion.Logic.Godel
