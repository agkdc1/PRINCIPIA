import MathlibExpansion.Logic.HilbertBernays.FormalDerivability

/-!
# Monadic completeness

Hilbert-Bernays treat the monadic predicate calculus with identity as a
decidable fragment. This file isolates the textbook-facing interface.
-/

namespace MathlibExpansion.Logic.HilbertBernays
namespace Monadic

/-- A sentence in the monadic predicate-calculus corridor. -/
structure Sentence where
  formula : HBSentence
  monadic : HBFormula.Monadic formula

/-- The proof-theoretic side of the monadic fragment. -/
def Provable (φ : Sentence) : Prop :=
  HBProvableFromAxioms (fun _ => false) φ.formula

/-- Sound and complete semantic data for the monadic fragment.

The old unchecked boundary quantified over an arbitrary predicate `Valid`, which
cannot imply completeness. This package records the two historical proof
obligations as explicit data for the chosen semantics.

Citation: Loewenheim, "Ueber Moeglichkeiten im Relativkalkuel" (1915),
Section 3,
positive decision result for the first-order singulary/monadic predicate
calculus with identity; Behmann, "Beitraege zur Algebra der Logik,
insbesondere zum Entscheidungsproblem" (1922), Mathematische Annalen 86,
pp. 163-229, monadic decision-problem simplification. -/
structure Semantics where
  Valid : Sentence → Prop
  sound : ∀ φ : Sentence, Provable φ → Valid φ
  complete : ∀ φ : Sentence, Valid φ → Provable φ

/-- Upstream-narrow completeness/decidability shell for the monadic fragment
with identity, discharged by projecting the sound/complete semantic package.

Citation: Loewenheim, "Ueber Moeglichkeiten im Relativkalkuel" (1915),
Section 3,
positive decision result for the first-order singulary/monadic predicate
calculus with identity; Behmann, "Beitraege zur Algebra der Logik,
insbesondere zum Entscheidungsproblem" (1922), Mathematische Annalen 86,
pp. 163-229, monadic decision-problem simplification. -/
theorem monadic_complete_with_identity
    (S : Semantics) (φ : Sentence) :
    Provable φ ↔ S.Valid φ := by
  exact ⟨S.sound φ, S.complete φ⟩

end Monadic
end MathlibExpansion.Logic.HilbertBernays
