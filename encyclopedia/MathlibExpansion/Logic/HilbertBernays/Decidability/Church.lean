import MathlibExpansion.Logic.HilbertBernays.ArithmetizedProofPredicate1939
import MathlibExpansion.Logic.HilbertBernays.HerbrandReduction

/-!
# Church undecidability

This file records the decision-frontier surface for the predicate-calculus
corridor once the Hilbert-Bernays proof and arithmetization interfaces are in
place.
-/

namespace MathlibExpansion.Logic.HilbertBernays
namespace Decidability

/-- A boolean decision procedure on Hilbert-Bernays sentences. -/
abbrev DecisionProcedure := HBSentence → Bool

/-- A solver decides theory-relative provability if it exactly matches the
exported proof-predicate surface. -/
def DecidesProvability (T : HBRecursiveTheory) (solver : DecisionProcedure) : Prop :=
  ∀ φ : HBSentence, solver φ = true ↔ HBProvableFrom T φ

/-- The classical, non-effective truth-table solver for `HBProvableFrom`.

This records why Church's theorem cannot be stated against the bare Lean type
`HBSentence -> Bool`: without an effectiveness requirement, the proposition is
classically decidable and the old unqualified axiom was too broad. -/
noncomputable def classicalDecisionProcedure (T : HBRecursiveTheory) :
    DecisionProcedure := by
  classical
  exact fun φ => if HBProvableFrom T φ then true else false

/-- The non-effective truth-table solver decides the current Lean proposition
`HBProvableFrom`. -/
theorem classicalDecisionProcedure_decides
    (T : HBRecursiveTheory) :
    DecidesProvability T (classicalDecisionProcedure T) := by
  intro φ
  by_cases h : HBProvableFrom T φ
  · simp [DecidesProvability, classicalDecisionProcedure, h]
  · simp [DecidesProvability, classicalDecisionProcedure, h]

/-- Every Hilbert-Bernays theory has an unqualified classical solver. -/
theorem exists_classical_decisionProcedure_decides
    (T : HBRecursiveTheory) :
    ∃ solver : DecisionProcedure, DecidesProvability T solver :=
  ⟨classicalDecisionProcedure T, classicalDecisionProcedure_decides T⟩

/-- The former unqualified Church boundary is not a valid theorem for the
current `DecisionProcedure` type. -/
theorem not_unqualified_predicate_calculus_undecidable
    (T : HBRecursiveTheory) :
    ¬ (¬ ∃ solver : DecisionProcedure, DecidesProvability T solver) := by
  intro h
  exact h (exists_classical_decisionProcedure_decides T)

/-- A recursive decision procedure is represented by a primitive-recursive
boolean function on formula codes, together with the sentence-level solver it
tracks. -/
structure RecursiveDecisionProcedure where
  solver : DecisionProcedure
  codeSolver : FormulaCode → Bool
  codeSolver_primrec : Primrec codeSolver
  respectsCode : ∀ φ : HBSentence, codeSolver φ.code = solver φ

/-- A recursive solver decides theory-relative provability when its exported
sentence-level solver exactly matches the proof-predicate surface. -/
def RecursivelyDecidesProvability
    (T : HBRecursiveTheory) (solver : RecursiveDecisionProcedure) : Prop :=
  DecidesProvability T solver.solver

/-- Citation-backed Church boundary for a concrete Hilbert-Bernays theory.

The historical source is Alonzo Church, *An Unsolvable Problem of Elementary
Number Theory*, American Journal of Mathematics 58 (1936), Theorem XIX and the
immediate Entscheidungsproblem corollary; for the narrow predicate-calculus
form, see Church, *A Note on the Entscheidungsproblem*, Journal of Symbolic
Logic 1 (1936), pp. 40-41, footnotes 6-7. The field is explicit evidence for
the concrete theory, not a kernel axiom. -/
structure ChurchUndecidabilityBoundary (T : HBRecursiveTheory) : Prop where
  no_recursive_decider :
    ¬ ∃ solver : RecursiveDecisionProcedure,
      RecursivelyDecidesProvability T solver

/-- Church undecidability for a Hilbert-Bernays theory, discharged from an
explicit boundary certificate rather than asserted as a global axiom. -/
theorem predicate_calculus_undecidable
    (T : HBRecursiveTheory) (boundary : ChurchUndecidabilityBoundary T) :
    ¬ ∃ solver : RecursiveDecisionProcedure,
      RecursivelyDecidesProvability T solver :=
  boundary.no_recursive_decider

end Decidability
end MathlibExpansion.Logic.HilbertBernays
