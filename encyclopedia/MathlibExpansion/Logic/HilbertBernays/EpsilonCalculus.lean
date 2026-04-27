import MathlibExpansion.Logic.HilbertBernays.FormalDerivability

/-!
# Epsilon calculus core

This file introduces explicit epsilon terms, critical formulas, and the core
quantifier-definition bridge used in the Hilbert-Bernays epsilon calculus.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- Form the textbook epsilon term attached to a bound variable and matrix. -/
def epsilonTerm (x : Nat) (φ : HBSentence) : HBTerm :=
  .epsilon x φ.code

/-- The instantiated matrix obtained by replacing `x` with its epsilon term. -/
def epsilonInstance (x : Nat) (φ : HBSentence) : HBSentence :=
  HBFormula.instantiate x (epsilonTerm x φ) φ

/-- The first critical-formula shape of the epsilon calculus. -/
def criticalFormula (x : Nat) (witness : HBTerm) (φ : HBSentence) : HBSentence :=
  .imp (HBFormula.instantiate x witness φ) (epsilonInstance x φ)

/-- The existential quantifier as an epsilon instance. -/
def existsByEpsilon (x : Nat) (φ : HBSentence) : HBSentence :=
  epsilonInstance x φ

/-- The universal quantifier as an epsilon instance applied to the negated
matrix. -/
def forallByEpsilon (x : Nat) (φ : HBSentence) : HBSentence :=
  HBFormula.neg (HBFormula.instantiate x (epsilonTerm x (HBFormula.neg φ)) (HBFormula.neg φ))

/-- A conjunction of two implications used as the object-language surrogate for
an equivalence. -/
def iffFormula (φ ψ : HBSentence) : HBSentence :=
  .and (.imp φ ψ) (.imp ψ φ)

/-- Definite-description elimination is recorded through the same epsilon term. -/
def descriptionEliminationFormula (x : Nat) (φ : HBSentence) : HBSentence :=
  .imp (.existsE x φ) (epsilonInstance x φ)

/-- The critical-formula axioms. -/
def criticalFormulaAxioms (x : Nat) (witness : HBTerm) (φ : HBSentence) : HBAxiomSet :=
  fun ψ => decide (ψ = criticalFormula x witness φ)

/-- The existential-definition axiom package for a fixed matrix. -/
def existsDefinitionAxioms (x : Nat) (φ : HBSentence) : HBAxiomSet :=
  fun ψ => decide (ψ = iffFormula (.existsE x φ) (existsByEpsilon x φ))

/-- The universal-definition axiom package for a fixed matrix. -/
def forallDefinitionAxioms (x : Nat) (φ : HBSentence) : HBAxiomSet :=
  fun ψ => decide (ψ = iffFormula (.forallE x φ) (forallByEpsilon x φ))

/-- The definite-description elimination package for a fixed matrix. -/
def descriptionDefinitionAxioms (x : Nat) (φ : HBSentence) : HBAxiomSet :=
  fun ψ => decide (ψ = descriptionEliminationFormula x φ)

theorem criticalFormula_provable (x : Nat) (witness : HBTerm) (φ : HBSentence) :
    HBProvableFromAxioms (criticalFormulaAxioms x witness φ) (criticalFormula x witness φ) :=
by
  apply provable_of_axiom
  simp [criticalFormulaAxioms]

theorem exists_iff_epsilon (x : Nat) (φ : HBSentence) :
    HBProvableFromAxioms (existsDefinitionAxioms x φ) (iffFormula (.existsE x φ) (existsByEpsilon x φ)) :=
by
  apply provable_of_axiom
  simp [existsDefinitionAxioms]

theorem forall_iff_epsilon_not (x : Nat) (φ : HBSentence) :
    HBProvableFromAxioms (forallDefinitionAxioms x φ) (iffFormula (.forallE x φ) (forallByEpsilon x φ)) :=
by
  apply provable_of_axiom
  simp [forallDefinitionAxioms]

theorem description_elimination_bridge (x : Nat) (φ : HBSentence) :
    HBProvableFromAxioms (descriptionDefinitionAxioms x φ) (descriptionEliminationFormula x φ) :=
by
  apply provable_of_axiom
  simp [descriptionDefinitionAxioms]

end MathlibExpansion.Logic.HilbertBernays
