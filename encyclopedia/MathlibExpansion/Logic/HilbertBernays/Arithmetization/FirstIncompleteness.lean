import MathlibExpansion.Logic.HilbertBernays.IncompletenessPrelude

/-!
# First incompleteness, 1939 setting

This file consumes the exported `OmegaConsistent` boundary from the 1939
proof-predicate owner surface.
-/

namespace MathlibExpansion.Logic.HilbertBernays
namespace Arithmetization

/-- A sentence is undecidable in `T` if neither it nor its negation is
provable from `T`. -/
def UndecidableIn (T : HBRecursiveTheory) (φ : HBSentence) : Prop :=
  ¬ HBProvableFrom T φ ∧ ¬ HBProvableFrom T (HBFormula.neg φ)

/-- Proof-consistency for the first-incompleteness corridor: no explicit
Hilbert-Bernays proof object derives the canonical contradiction witness. -/
def ProofConsistent (T : HBRecursiveTheory) : Prop :=
  FormalConsistency T.axioms

/-- A fixed local proxy for the diagonal matrix used by the Hilbert-Bernays
first-incompleteness boundary.  The real discharge target is to replace this
proxy by the arithmetized fixed point exported by the proof-predicate stack. -/
def HBGoedelMatrix (_T : HBRecursiveTheory) : HBSentence :=
  HBFormula.relation 1939 [HBTerm.var 0]

/-- The local Hilbert-Bernays Gödel sentence proxy. -/
def HBGoedelSentence (T : HBRecursiveTheory) : HBSentence :=
  HBFormula.forallE 0 (HBGoedelMatrix T)

/--
Upstream-narrow boundary, Kurt Gödel, 1931, *Ueber formal unentscheidbare
Saetze der Principia Mathematica und verwandter Systeme I*, Part 2,
Proposition VI, proof clause 1, as consumed by Hilbert-Bernays, *Grundlagen
der Mathematik* II (1939), Vol. II, §5.1.b, "Das erste Gödelsche
Unableitbarkeitstheorem": omega-consistency specializes to the
proof-consistency premise needed to block derivability of the constructed
Gödel sentence.
-/
axiom proofConsistent_of_omegaConsistent
    (T : HBRecursiveTheory) :
    SharpDelimitation T → RepresentsRecursiveArithmetic T → OmegaConsistent T →
      ProofConsistent T

/--
Upstream-narrow boundary, Kurt Gödel, 1931, *Ueber formal unentscheidbare
Saetze der Principia Mathematica und verwandter Systeme I*, Part 2,
Proposition VI, proof clause 1, as consumed by Hilbert-Bernays, *Grundlagen
der Mathematik* II (1939), Vol. II, §5.1.b, "Das erste Gödelsche
Unableitbarkeitstheorem": the checked tree does not yet prove that the
constructed Hilbert-Bernays Gödel sentence is unprovable from the local
arithmetized proof-predicate surface under proof-consistency.
-/
axiom hb_godel_sentence_not_provable_of_consistent
    (T : HBRecursiveTheory) :
    SharpDelimitation T → RepresentsRecursiveArithmetic T → ProofConsistent T →
      ¬ HBProvableFrom T (HBGoedelSentence T)

/--
Upstream-narrow boundary, Kurt Gödel, 1931, *Ueber formal unentscheidbare
Saetze der Principia Mathematica und verwandter Systeme I*, Part 2,
Proposition VI, proof clause 2, as consumed by Hilbert-Bernays, *Grundlagen
der Mathematik* II (1939), Vol. II, §5.1.b, "Das erste Gödelsche
Unableitbarkeitstheorem": the checked tree does not yet prove that
omega-consistency blocks derivability of the negated Hilbert-Bernays Gödel
sentence on the local arithmetized proof-predicate surface.
-/
axiom hb_neg_godel_sentence_not_provable_of_omegaConsistent
    (T : HBRecursiveTheory) :
    SharpDelimitation T → RepresentsRecursiveArithmetic T → OmegaConsistent T →
      ¬ HBProvableFrom T (HBFormula.neg (HBGoedelSentence T))

/-- First incompleteness in the strengthened 1939 Hilbert-Bernays interface,
assembled from the narrowed Gödel-sentence nonprovability boundaries. -/
theorem exists_undecidable_sentence_of_omegaConsistent
    (T : HBRecursiveTheory) :
    SharpDelimitation T → RepresentsRecursiveArithmetic T → OmegaConsistent T →
      ∃ φ : HBSentence, UndecidableIn T φ := by
  intro hsharp hrep hω
  refine ⟨HBGoedelSentence T, ?_, ?_⟩
  · exact hb_godel_sentence_not_provable_of_consistent T hsharp hrep
      (proofConsistent_of_omegaConsistent T hsharp hrep hω)
  · exact hb_neg_godel_sentence_not_provable_of_omegaConsistent T hsharp hrep hω

end Arithmetization
end MathlibExpansion.Logic.HilbertBernays
