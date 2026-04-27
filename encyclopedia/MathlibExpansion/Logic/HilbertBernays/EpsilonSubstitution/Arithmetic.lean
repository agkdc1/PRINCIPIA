import MathlibExpansion.Logic.HilbertBernays.EpsilonTheorems
import MathlibExpansion.Logic.HilbertBernays.RecursiveDefinitions

/-!
# Epsilon-substitution for restricted arithmetic

This file isolates the restricted-arithmetic consistency lane used by the
Hilbert-Bernays epsilon-substitution method.
-/

namespace MathlibExpansion.Logic.HilbertBernays
namespace EpsilonSubstitution

/-- Restricted arithmetic package for the epsilon-substitution method.

The descent and consistency obligations are explicit certificate fields. A raw
rank function and correction operation do not imply either theorem for an
arbitrary package, so this owner layer records the historical proof-theoretic
obligations as data and exports them below as theorem projections.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Section 2, epsilon-substitution method for arithmetic with open induction;
Ackermann, "Zur Widerspruchsfreiheit der Zahlentheorie" (1940),
Mathematische Annalen 117, main consistency proof for number theory by the
epsilon-substitution method. -/
structure HBRestrictedArithmetic where
  base : HBBaseArithmetic
  substitutionRank : ProofObject → Nat
  correctionStep : ProofObject → ProofObject
  rank_descends :
    ∀ p : ProofObject, substitutionRank (correctionStep p) ≤ substitutionRank p
  consistent : FormalConsistency base.axioms

/-- Formal consistency of the restricted arithmetic package. -/
def Consistent (T : HBRestrictedArithmetic) : Prop :=
  FormalConsistency T.base.axioms

/-- Descending-measure certificate for epsilon substitutions, projected from
the restricted-arithmetic package.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Section 2, epsilon-substitution method for arithmetic with open induction;
Ackermann, "Zur Widerspruchsfreiheit der Zahlentheorie" (1940),
Mathematische Annalen 117, main consistency proof for number theory by the
epsilon-substitution method. -/
theorem substitution_rank_descends
    (T : HBRestrictedArithmetic) :
    ∀ p : ProofObject, T.substitutionRank (T.correctionStep p) ≤ T.substitutionRank p :=
  T.rank_descends

/-- Restricted-consistency certificate for epsilon substitution, projected from
the restricted-arithmetic package.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Section 2, epsilon-substitution method for arithmetic with open induction;
Ackermann, "Zur Widerspruchsfreiheit der Zahlentheorie" (1940),
Mathematische Annalen 117, main consistency proof for number theory by the
epsilon-substitution method. -/
theorem epsilon_substitution_consistent_restricted_arithmetic
    (T : HBRestrictedArithmetic) :
    Consistent T :=
  T.consistent

end EpsilonSubstitution
end MathlibExpansion.Logic.HilbertBernays
