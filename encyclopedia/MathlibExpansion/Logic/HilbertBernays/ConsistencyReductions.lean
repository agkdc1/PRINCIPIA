import MathlibExpansion.Logic.HilbertBernays.FormalDerivability

/-!
# Consistency reductions

This file isolates the reduction from the full classical arithmetic corridor to
the no-`tertium non datur` core used in the Hilbert-Bernays response lane.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- Classical arithmetic package for the consistency investigation. -/
structure HBClassicalArithmetic where
  axioms : HBAxiomSet

/-- Reduced no-EM arithmetic package for the consistency investigation. -/
structure HBNoEMArithmetic where
  axioms : HBAxiomSet

def DerivableInClassical (T : HBClassicalArithmetic) (φ : HBSentence) : Prop :=
  HBProvableFromAxioms T.axioms φ

def DerivableInNoEM (T : HBNoEMArithmetic) (φ : HBSentence) : Prop :=
  HBProvableFromAxioms T.axioms φ

/-- Certified reduction data from a full classical arithmetic package to a
chosen no-`tertium non datur` core.

The old unindexed boundary asserted this transfer for arbitrary unrelated
sets of axioms. This certificate is the narrowed owner-layer interface: the
proof-theoretic transformation is explicit data tied to the concrete pair of
packages.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Section 2, epsilon-substitution consistency method and the reduction of
classical contradiction proofs to the finitist/no-`tertium non datur` core. -/
structure HBNoEMCoreReduction (T : HBClassicalArithmetic) (T₀ : HBNoEMArithmetic) where
  maps_contradiction :
    DerivableInClassical T HBFormula.zeroEqSuccZero →
      DerivableInNoEM T₀ HBFormula.zeroEqSuccZero

/-- Contradiction reduction from a classical package to a no-EM core, projected
from explicit pair-indexed reduction data.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Section 2, epsilon-substitution consistency method and the reduction of
classical contradiction proofs to the finitist/no-`tertium non datur` core. -/
theorem contradiction_reduces_to_noEM_core
    (T : HBClassicalArithmetic) (T₀ : HBNoEMArithmetic)
    (R : HBNoEMCoreReduction T T₀) :
    DerivableInClassical T HBFormula.zeroEqSuccZero →
      DerivableInNoEM T₀ HBFormula.zeroEqSuccZero :=
  R.maps_contradiction

theorem classical_consistent_of_noEM_consistent
    (T : HBClassicalArithmetic) (T₀ : HBNoEMArithmetic)
    (hreduce :
      DerivableInClassical T HBFormula.zeroEqSuccZero →
        DerivableInNoEM T₀ HBFormula.zeroEqSuccZero)
    (hcons : FormalConsistency T₀.axioms) :
    FormalConsistency T.axioms := by
  intro hclassical
  exact hcons (hreduce hclassical)

/-- Consistency transfer for packages equipped with an explicit no-EM reduction
certificate. -/
theorem classical_consistent_of_noEM_core_consistent
    (T : HBClassicalArithmetic) (T₀ : HBNoEMArithmetic)
    (R : HBNoEMCoreReduction T T₀)
    (hcons : FormalConsistency T₀.axioms) :
    FormalConsistency T.axioms := by
  exact classical_consistent_of_noEM_consistent T T₀
    (contradiction_reduces_to_noEM_core T T₀ R) hcons

end MathlibExpansion.Logic.HilbertBernays
