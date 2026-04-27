import MathlibExpansion.Logic.Godel.SystemP.Axioms

/-!
# Propositional axioms for Gödel 1931 system `P`
-/

namespace MathlibExpansion.Logic.Godel.SystemP

private def p₁ : PFormula := eqFormula (.var (PVar.base 1)) (.var (PVar.base 1))
private def p₂ : PFormula := eqFormula (.var (PVar.base 2)) (.var (PVar.base 2))
private def p₃ : PFormula := eqFormula (.var (PVar.base 3)) (.var (PVar.base 3))

/-- Gödel's first disjunction-based propositional schema. -/
def propAxiom₁ : PFormula := imp (disj p₁ p₁) p₁

/-- Gödel's second disjunction-based propositional schema. -/
def propAxiom₂ : PFormula := imp p₁ (disj p₁ p₂)

/-- Gödel's third disjunction-based propositional schema. -/
def propAxiom₃ : PFormula := imp (disj p₁ p₂) (disj p₂ p₁)

/-- Gödel's fourth disjunction-based propositional schema. -/
def propAxiom₄ : PFormula :=
  imp (imp p₁ p₂) (imp (disj p₃ p₁) (disj p₃ p₂))

/-- Predicate naming the primitive propositional axioms of `P`. -/
def PPropAxiom : PFormula → Prop
  | φ => φ = propAxiom₁ ∨ φ = propAxiom₂ ∨ φ = propAxiom₃ ∨ φ = propAxiom₄

end MathlibExpansion.Logic.Godel.SystemP
