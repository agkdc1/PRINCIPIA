import MathlibExpansion.Logic.HilbertBernays.EpsilonTheorems

/-!
# Herbrand reduction

This file packages the Herbrand-facing proof-transformation corridor isolated by
the Hilbert-Bernays recon.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- A prenex sentence in the Herbrand corridor. -/
structure HBPrenexSentence where
  sentence : HBSentence

/-- An instance of the matrix in Herbrand normal form. -/
structure HBHerbrandInstance (A : HBPrenexSentence) where
  formula : HBSentence

/-- An instance of the original matrix before Herbrand normalization. -/
structure HBOriginalMatrixInstance (A : HBPrenexSentence) where
  formula : HBSentence

/-- An open axiom in the finite-shadow axiomatics application. -/
structure HBOpenAxiom where
  formula : HBSentence

/-- A finite disjunction of formulas. -/
def disjoin : List HBSentence → HBSentence
  | [] => .falsum
  | [φ] => φ
  | φ :: ψ :: rest => .or φ (disjoin (ψ :: rest))

/-- The finite-shadow quasi-tautology notion isolated by Hilbert-Bernays. -/
structure HBQuasiTautologyWitness (φ : HBSentence) where
  propositionalShadow : List Bool

def HBIsQuasiTautology (φ : HBSentence) : Prop :=
  Nonempty (HBQuasiTautologyWitness φ)

def HBInconsistent (T : List HBOpenAxiom) : Prop :=
  DerivationOfContradiction (axiomsOfList (T.map HBOpenAxiom.formula))

/-- Sound and complete Herbrand-normal-form reduction data for a prenex
sentence. This is the narrowed owner-layer boundary: the extraction and
reconstruction maps are explicit data, not a kernel axiom.

Citation: Herbrand, *Recherches sur la theorie de la demonstration* (1930),
Chapter 5, Herbrand theorem; Hilbert-Bernays, *Grundlagen der Mathematik* II
(1939), Vol. II, §3.3, "Der Herbrandsche Satz", clause (1). -/
structure HBHerbrandClause1Reduction (A : HBPrenexSentence) where
  complete :
    HBPredicateProvableFrom [] A.sentence →
      ∃ Δ : Finset (HBHerbrandInstance A),
        HBIsQuasiTautology (disjoin ((fun δ => δ.formula) <$> Δ.toList))
  sound :
    (∃ Δ : Finset (HBHerbrandInstance A),
        HBIsQuasiTautology (disjoin ((fun δ => δ.formula) <$> Δ.toList))) →
      HBPredicateProvableFrom [] A.sentence

/-- Herbrand theorem, normal-form clause, discharged from explicit reduction
data.

Citation: Herbrand, *Recherches sur la theorie de la demonstration* (1930),
Chapter 5, Herbrand theorem; Hilbert-Bernays, *Grundlagen der Mathematik* II
(1939), Vol. II, §3.3, "Der Herbrandsche Satz", clause (1). -/
theorem hb_herbrand_clause1
    (A : HBPrenexSentence) (R : HBHerbrandClause1Reduction A) :
    HBPredicateProvableFrom [] A.sentence ↔
      ∃ Δ : Finset (HBHerbrandInstance A),
        HBIsQuasiTautology (disjoin ((fun δ => δ.formula) <$> Δ.toList)) := by
  exact ⟨R.complete, R.sound⟩

/-- Sound and complete original-matrix Herbrand reduction data for a prenex
sentence. This separates the historical matrix reconstruction obligation from
the exported equivalence theorem.

Citation: Herbrand, *Recherches sur la theorie de la demonstration* (1930),
Chapter 5, Herbrand theorem; Hilbert-Bernays, *Grundlagen der Mathematik* II
(1939), Vol. II, §3.3, "Der Herbrandsche Satz", clause (2). -/
structure HBHerbrandClause2Reduction (A : HBPrenexSentence) where
  complete :
    HBPredicateProvableFrom [] A.sentence →
      ∃ Δ : Finset (HBOriginalMatrixInstance A),
        HBIsQuasiTautology (disjoin ((fun δ => δ.formula) <$> Δ.toList))
  sound :
    (∃ Δ : Finset (HBOriginalMatrixInstance A),
        HBIsQuasiTautology (disjoin ((fun δ => δ.formula) <$> Δ.toList))) →
      HBPredicateProvableFrom [] A.sentence

/-- Herbrand theorem, original-matrix clause, discharged from explicit
reduction data.

Citation: Herbrand, *Recherches sur la theorie de la demonstration* (1930),
Chapter 5, Herbrand theorem; Hilbert-Bernays, *Grundlagen der Mathematik* II
(1939), Vol. II, §3.3, "Der Herbrandsche Satz", clause (2). -/
theorem hb_herbrand_clause2
    (A : HBPrenexSentence) (R : HBHerbrandClause2Reduction A) :
    HBPredicateProvableFrom [] A.sentence ↔
      ∃ Δ : Finset (HBOriginalMatrixInstance A),
        HBIsQuasiTautology (disjoin ((fun δ => δ.formula) <$> Δ.toList)) := by
  exact ⟨R.complete, R.sound⟩

/-- Sound and complete finite quasi-refutation reduction data for an open
theory. The certificate is indexed by the concrete finite open-axiom list, so
the theorem below no longer asserts the Herbrand axiomatics application for an
arbitrary skeletal list without the missing proof transformation.

Citation: Herbrand, *Recherches sur la theorie de la demonstration* (1930),
Chapter 5, applications of the Herbrand theorem; Hilbert-Bernays,
*Grundlagen der Mathematik* II (1939), Vol. II, §3.4, refutability criteria
for the pure predicate calculus and axiomatics applications. -/
structure HBOpenTheoryFiniteRefutationReduction (T : List HBOpenAxiom) where
  complete :
    HBInconsistent T →
      ∃ Δ : Finset HBOpenAxiom,
        HBIsQuasiTautology (disjoin ((fun δ => HBFormula.neg δ.formula) <$> Δ.toList))
  sound :
    (∃ Δ : Finset HBOpenAxiom,
        HBIsQuasiTautology (disjoin ((fun δ => HBFormula.neg δ.formula) <$> Δ.toList))) →
      HBInconsistent T

/-- Herbrand finite quasi-refutation criterion for open theories, discharged
from explicit theory-indexed reduction data.

Citation: Herbrand, *Recherches sur la theorie de la demonstration* (1930),
Chapter 5, applications of the Herbrand theorem; Hilbert-Bernays,
*Grundlagen der Mathematik* II (1939), Vol. II, §3.4, refutability criteria
for the pure predicate calculus and axiomatics applications. -/
theorem hb_openTheory_inconsistent_iff_finite_quasiRefutation
    (T : List HBOpenAxiom) (R : HBOpenTheoryFiniteRefutationReduction T) :
    HBInconsistent T ↔
      ∃ Δ : Finset HBOpenAxiom,
        HBIsQuasiTautology (disjoin ((fun δ => HBFormula.neg δ.formula) <$> Δ.toList)) := by
  exact ⟨R.complete, R.sound⟩

end MathlibExpansion.Logic.HilbertBernays
