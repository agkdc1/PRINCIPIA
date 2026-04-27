import MathlibExpansion.Foundations.HilbertBernays.FinitistArithmetic
import MathlibExpansion.Logic.HilbertBernays.RecursiveDefinitions

/-!
# Arithmetized proof predicate, 1939 corridor

This file exports the public theory-facing surface required by the Hilbert-
Bernays 1939 proof-predicate stack.
-/

namespace MathlibExpansion.Logic.HilbertBernays

abbrev FormulaCode := Nat
abbrev ProofCode := Nat

/-- A recursively axiomatized Hilbert-Bernays theory with an explicit coded
proof and provability interface. -/
structure HBRecursiveTheory where
  name : String := "HB-Recursive-Theory"
  axioms : HBAxiomSet
  axiomCode : FormulaCode → Bool
  proofPredicateSentence : ProofCode → FormulaCode → HBSentence
  provabilitySentence : FormulaCode → HBSentence
  recursiveAxiomCodes : Prop
  axiomCode_correct : ∀ φ : HBSentence, axiomCode φ.code = axioms φ

/-- The coded sentence exported for downstream consumers. -/
abbrev encodedSentence (φ : HBSentence) : FormulaCode := φ.code

/-- The coded proof object exported for downstream consumers. -/
abbrev encodedProof (p : ProofObject) : ProofCode := p.code

/-- Explicit proof checking on finite proof data. -/
def proofSequenceValid (T : HBRecursiveTheory) (p : ProofObject) : Prop :=
  p.check T.axioms = true

/-- Decidable proof checking for explicit finite proof data. -/
instance proofSequenceValid_decidable (T : HBRecursiveTheory) :
    DecidablePred (proofSequenceValid T) := by
  intro p
  unfold proofSequenceValid
  infer_instance

/-- Theory-relative provability exported to every downstream consumer. -/
def HBProvableFrom (T : HBRecursiveTheory) (φ : HBSentence) : Prop :=
  HBProvableFromAxioms T.axioms φ

/-- The Hilbert-Bernays omega-consistency boundary, exported once and then
consumed downstream rather than being redefined ad hoc. -/
def OmegaConsistent (T : HBRecursiveTheory) : Prop :=
  ¬ ∃ φ : HBSentence,
      HBProvableFrom T (HBFormula.neg (.forallE 0 φ)) ∧
        ∀ n : Nat, HBProvableFrom T (HBFormula.instantiateNumeral 0 n φ)

/-- A small bookkeeping structure recording the theory-facing arithmetization
surface. -/
structure HBDefinabilityBridge (T : HBRecursiveTheory) where
  codedFormulas : FormulaCode → HBSentence
  codedProofs : ProofCode → FormulaCode → HBSentence
  respectsAxiomCoding : ∀ φ : HBSentence, T.axiomCode φ.code = T.axioms φ

/-- Upstream-narrow bridge from explicit proof checking to the arithmetized
proof-predicate surface. In the current owner layer the theory already carries
the arithmetized proof predicate, provability predicate, and correctness proof
for recursive axiom coding, so the bridge is the corresponding data package.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), supplement
II, arithmetization of proofs and recursive definition of the proof predicate. -/
def recursive_definability_bridge
    (T : HBRecursiveTheory) :
    HBDefinabilityBridge T where
  codedFormulas := T.provabilitySentence
  codedProofs := T.proofPredicateSentence
  respectsAxiomCoding := T.axiomCode_correct

@[simp] theorem omegaConsistency_id (T : HBRecursiveTheory) :
    OmegaConsistent T → OmegaConsistent T := fun h => h

def proofChecker_decidable (T : HBRecursiveTheory) (p : ProofObject) :
    Decidable (proofSequenceValid T p) := inferInstance

end MathlibExpansion.Logic.HilbertBernays
