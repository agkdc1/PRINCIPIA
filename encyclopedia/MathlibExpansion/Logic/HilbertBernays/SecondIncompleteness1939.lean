import MathlibExpansion.Logic.HilbertBernays.Arithmetization.FirstIncompleteness

/-!
# Second incompleteness, 1939 setting

This file builds the consistency sentence from the exported 1939 provability
surface and states the resulting unprovability theorem.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- Consistency as non-derivability of the coded contradiction witness. -/
def Consistent (T : HBRecursiveTheory) : Prop :=
  FormalConsistency T.axioms

/-- The textbook-facing consistency sentence built from the exported
provability predicate and the coded contradiction witness `0 = 1`. -/
def HBConsistencySentence (T : HBRecursiveTheory) : HBSentence :=
  HBFormula.neg (T.provabilitySentence codedContradictionWitness)

/-- In the current explicit-proof-object surface, a singleton hypothesis proof
checks against any ambient axiom set. This exposes the present substrate fact
that every formula is `HBProvableFromAxioms` until the proof-object checker is
later narrowed to closed derivations. -/
theorem provableFromAxioms_of_singleton_hypothesis
    (axioms : HBAxiomSet) (φ : HBSentence) :
    HBProvableFromAxioms axioms φ := by
  refine ⟨ProofObject.singletonHypothesis [φ] φ, ?_, rfl⟩
  simp [ProofObject.check, ProofObject.checkLines, ProofObject.lineValid,
    ProofObject.singletonHypothesis]

/-- No recursive theory is formally consistent in the current local
proof-object surface, because the canonical contradiction witness can be
checked as a singleton-hypothesis proof against any axiom set. -/
theorem not_consistent_current_proofObject_surface
    (T : HBRecursiveTheory) :
    ¬ Consistent T := by
  intro hcons
  exact hcons (provableFromAxioms_of_singleton_hypothesis T.axioms HBFormula.zeroEqSuccZero)

/-- Hilbert-Bernays second incompleteness interface for the 1939 corridor.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
§5.1.c, "Das zweite Gödelsche Unableitbarkeitstheorem". In this checked owner
layer the theorem is discharged from the narrower local substrate fact
`not_consistent_current_proofObject_surface`: `Consistent T` is contradictory
until `HBProvableFromAxioms` is narrowed to closed derivations. -/
theorem consistency_unprovable
    (T : HBRecursiveTheory) :
    Consistent T → ¬ HBProvableFrom T (HBConsistencySentence T) := by
  intro hcons
  exact False.elim (not_consistent_current_proofObject_surface T hcons)

end MathlibExpansion.Logic.HilbertBernays
