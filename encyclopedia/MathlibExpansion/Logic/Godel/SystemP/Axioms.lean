import MathlibExpansion.Logic.Godel.SystemP.Equality

/-!
# Arithmetic axiom schemata for Gödel 1931 system `P`

This file records the Chapter 2 arithmetic base sentences as concrete formulas
of the local `P` syntax.
-/

namespace MathlibExpansion.Logic.Godel.SystemP

/-- A fixed equality-symbol placeholder used to name equality formulas. -/
def eqSymbol : PString :=
  .var { pType := .succ (.succ .base), idx := 0 }

/-- The object-language equality formula on strings. -/
def eqFormula (x y : PString) : PFormula :=
  .atom eqSymbol (.pair x y)

/-- Gödel's arithmetic axiom saying `0` is not a successor. -/
def axiomI1 : PFormula :=
  neg (eqFormula (.succ (.var (PVar.base 1))) .zero)

/-- Gödel's arithmetic axiom saying successor is injective. -/
def axiomI2 : PFormula :=
  imp (eqFormula (.succ (.var (PVar.base 1))) (.succ (.var (PVar.base 2))))
    (eqFormula (.var (PVar.base 1)) (.var (PVar.base 2)))

/-- A lightweight induction-schema placeholder in the local syntax. -/
def inductionAxiom : PFormula :=
  imp (eqFormula (.var (PVar.base 1)) .zero)
    (.all (PVar.base 1) (eqFormula (.var (PVar.base 1)) (.var (PVar.base 1))))

/-- Public predicate naming the arithmetic base axioms of `P`. -/
def ArithmeticAxiom : PFormula → Prop
  | φ => φ = axiomI1 ∨ φ = axiomI2 ∨ φ = inductionAxiom

end MathlibExpansion.Logic.Godel.SystemP
