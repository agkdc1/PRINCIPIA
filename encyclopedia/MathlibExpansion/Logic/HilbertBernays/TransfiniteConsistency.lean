import MathlibExpansion.Logic.HilbertBernays.ConsistencyReductions
import MathlibExpansion.Logic.HilbertBernays.EpsilonSubstitution.Arithmetic
import MathlibExpansion.Logic.HilbertBernays.FormalizabilityBarrier
import MathlibExpansion.SetTheory.Ordinal.EpsilonZero

/-!
# Transfinite consistency

This file packages the special transfinite-induction corridor consumed by the
Hilbert-Bernays response lane.
-/

namespace MathlibExpansion.Logic.HilbertBernays

open MathlibExpansion.SetTheory.Ordinal

/-- Predicate form of transfinite induction over the Gentzen notation system. -/
def TIBelowEpsilonZero : Prop :=
  ∀ P : GentzenNotation → Prop,
    (∀ a : GentzenNotation, (∀ b : GentzenNotation, GentzenLess b a → P b) → P a) →
      ∀ a : GentzenNotation, P a

theorem transfinite_induction_available : TIBelowEpsilonZero := by
  intro P hstep a
  exact gentzenNotation_wf.induction a (fun x ih => hstep x (fun y hy => ih y hy))

/-- A reduction step in the Gentzen-style descent argument. -/
structure GentzenReductionStep where
  before : ProofObject
  after : ProofObject
  measureBefore : GentzenNotation
  measureAfter : GentzenNotation
  decreases : GentzenLess measureAfter measureBefore

/-- Gentzen-style transfinite consistency data for a concrete no-EM arithmetic
core.

The old boundary asserted consistency for an arbitrary full classical package
from transfinite induction alone. The narrowed owner-layer interface records
the historically nontrivial proof-theoretic descent as certificate data tied to
one selected no-EM core; the full-classical transfer is handled separately by
`HBNoEMCoreReduction`.

Citation: Gentzen, "Die Widerspruchsfreiheit der reinen Zahlentheorie" (1936),
Mathematische Annalen 112, consistency proof by transfinite induction below
epsilon-zero; Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Section 2, reduction of arithmetic consistency to the no-`tertium non datur`
core. -/
structure HBNoEMTransfiniteConsistency (T₀ : HBNoEMArithmetic) where
  core_consistent :
    TIBelowEpsilonZero → FormalConsistency T₀.axioms

/-- No-EM core consistency from a package-indexed Gentzen transfinite
consistency certificate.

Citation: Gentzen, "Die Widerspruchsfreiheit der reinen Zahlentheorie" (1936),
Mathematische Annalen 112, consistency proof by transfinite induction below
epsilon-zero. -/
theorem noEM_consistent_of_transfinite_induction
    (T₀ : HBNoEMArithmetic) (G : HBNoEMTransfiniteConsistency T₀) :
    TIBelowEpsilonZero → FormalConsistency T₀.axioms :=
  G.core_consistent

/-- Full classical arithmetic consistency from explicit no-EM reduction data
and a package-indexed Gentzen transfinite-consistency certificate.

Citation: Gentzen, "Die Widerspruchsfreiheit der reinen Zahlentheorie" (1936),
Mathematische Annalen 112, consistency proof by transfinite induction below
epsilon-zero; Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Section 2, reduction of arithmetic consistency to the no-`tertium non datur`
core. -/
theorem consistent_of_transfinite_induction
    (T : HBClassicalArithmetic) (T₀ : HBNoEMArithmetic)
    (R : HBNoEMCoreReduction T T₀) (G : HBNoEMTransfiniteConsistency T₀) :
    TIBelowEpsilonZero → FormalConsistency T.axioms := by
  intro hTI
  exact classical_consistent_of_noEM_core_consistent T T₀ R
    (noEM_consistent_of_transfinite_induction T₀ G hTI)

end MathlibExpansion.Logic.HilbertBernays
