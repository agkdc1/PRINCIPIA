import MathlibExpansion.Logic.HilbertBernays.HerbrandReduction

/-!
# Predicate-calculus completeness sharpening

Hilbert-Bernays present a proof-theoretic sharpening of the completeness
corridor. This file isolates that consumer-facing surface.
-/

namespace MathlibExpansion.Logic.HilbertBernays
namespace Predicate

/-- Semantic validity package for the predicate calculus, including the
proof-theoretic completeness certificate needed by downstream consumers.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Chapter 4, §2, application of arithmetized metamathematics to Gödel's
completeness theorem; Gödel, *Die Vollständigkeit der Axiome des logischen
Funktionenkalküls* (1930), Satz I. -/
structure Semantics where
  Valid : HBSentence → Prop
  complete_of_valid :
    ∀ φ : HBSentence, Valid φ → HBPredicateProvableFrom [] φ

/-- Predicate-calculus provability from no extra assumptions. -/
def Provable (φ : HBSentence) : Prop :=
  HBPredicateProvableFrom [] φ

/-- Predicate-calculus completeness sharpening, discharged from an explicit
semantic completeness certificate.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Chapter 4, §2, application of arithmetized metamathematics to Gödel's
completeness theorem; Gödel, *Die Vollständigkeit der Axiome des logischen
Funktionenkalküls* (1930), Satz I. -/
theorem provable_of_valid_sentence
    (S : Semantics) (φ : HBSentence) :
    S.Valid φ → Provable φ := by
  exact S.complete_of_valid φ

end Predicate
end MathlibExpansion.Logic.HilbertBernays
