import MathlibExpansion.Logic.HilbertBernays.ProofObjects

/-!
# Formal derivability

This file states formal consistency in terms of explicit finite derivations and
exports the reusable proof relation consumed by the other Hilbert-Bernays
modules.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- Provability from a decidable object-language axiom set. -/
def HBProvableFromAxioms (axioms : HBAxiomSet) (φ : HBSentence) : Prop :=
  ∃ p : ProofObject, p.check axioms = true ∧ p.lastConclusion = some φ

/-- A derivation of contradiction is an explicit proof object ending in `0 = 1`. -/
def DerivationOfContradiction (axioms : HBAxiomSet) : Prop :=
  HBProvableFromAxioms axioms HBFormula.zeroEqSuccZero

/-- Textbook-facing formal consistency over explicit derivations. -/
def FormalConsistency (axioms : HBAxiomSet) : Prop :=
  ¬ DerivationOfContradiction axioms

/-- Turn a finite list of hypotheses into a decidable axiom set. -/
def axiomsOfList (Γ : List HBFormula) : HBAxiomSet := fun φ => Γ.contains φ

/-- Union of two decidable axiom sets. -/
def unionAxioms (A B : HBAxiomSet) : HBAxiomSet := fun φ => A φ || B φ

theorem provable_of_axiom {axioms : HBAxiomSet} {φ : HBSentence}
    (hφ : axioms φ = true) :
    HBProvableFromAxioms axioms φ := by
  refine ⟨ProofObject.singletonAxiom φ, ?_, rfl⟩
  simpa using ProofObject.check_singletonAxiom hφ

theorem provable_of_hypothesis {Γ : List HBFormula} {φ : HBSentence}
    (hφ : φ ∈ Γ) :
    HBProvableFromAxioms (axiomsOfList Γ) φ := by
  refine ⟨ProofObject.singletonHypothesis Γ φ, ?_, rfl⟩
  simpa [axiomsOfList] using ProofObject.check_singletonHypothesis hφ

@[simp] theorem formalConsistency_iff_not_provable_contradiction
    (axioms : HBAxiomSet) :
    FormalConsistency axioms ↔ ¬ HBProvableFromAxioms axioms HBFormula.zeroEqSuccZero :=
  Iff.rfl

end MathlibExpansion.Logic.HilbertBernays
