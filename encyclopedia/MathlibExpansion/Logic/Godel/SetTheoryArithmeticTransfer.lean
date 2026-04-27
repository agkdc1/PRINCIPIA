import MathlibExpansion.Logic.Godel.ArithmeticIndependence

/-!
# Set-theory transfer of Gödel's arithmetic independence
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

/-- A minimal set-theory theoremhood shell for Gödel's transfer remark. -/
structure SetTheoryTheory where
  name : String := "SetTheory"
  Provable : PFormula → Prop := fun _ => False

/--
A concrete coding of the set-theory shell as one of the formal systems to which
Gödel's Proposition VI post-proof transfer applies.
-/
structure SetTheoryArithmeticInterpretation (T : SetTheoryTheory) where
  system : Godel1931System
  axiomClass : system.FormulaClass
  theoremhood_iff :
    ∀ φ : PFormula, T.Provable φ ↔ system.ProvableFrom axiomClass φ

/-- The set-theory shell admits an arithmetic/proof-theoretic coding. -/
def InterpretsArithmetic (T : SetTheoryTheory) : Prop :=
  Nonempty (SetTheoryArithmeticInterpretation T)

/--
The coded axiom class is omega-consistent, as required in Gödel's transfer
paragraph for recursive extensions.
-/
def RecursiveAxiomSet (T : SetTheoryTheory) : Prop :=
  ∀ I : SetTheoryArithmeticInterpretation T,
    I.system.OmegaConsistent I.axiomClass

/-- Undecidability for the set-theory shell. -/
def UndecidableInTheory (T : SetTheoryTheory) (A : ArithmeticalSentence) : Prop :=
  ¬ T.Provable A.toFormula ∧ ¬ T.Provable (SystemP.neg A.toFormula)

/--
Gödel's set-theory transfer, in the local proof-theoretic shell.

Citations:
- Kurt Gödel, *Über formal unentscheidbare Sätze der Principia Mathematica
  und verwandter Systeme I*, *Monatshefte für Mathematik und Physik* 38
  (1931), Part 2, paragraph immediately after Satz VI, pp. 190-191:
  systems satisfying assumptions 1 and 2 and omega-consistency have
  undecidable propositions of the form `(x) F(x)`, including the
  Zermelo-Fraenkel and von Neumann set-theory axiom systems (footnote 47).
- The set-theory systems cited there are introduced in Gödel's footnote 3:
  A. Fraenkel, *Zehn Vorlesungen über die Grundlegung der Mengenlehre*;
  J. v. Neumann, *Die Axiomatisierung der Mengenlehre*, *Math. Z.* 27 (1928),
  with the related 1925 and 1929 papers also cited by Gödel.
-/
theorem setTheory_exists_undecidable_arithmetical_sentence
    (T : SetTheoryTheory) :
    InterpretsArithmetic T →
      RecursiveAxiomSet T →
      ∃ A : ArithmeticalSentence, UndecidableInTheory T A := by
  intro hInterp hRecursive
  rcases hInterp with ⟨I⟩
  rcases exists_undecidable_arithmetical_sentence I.system I.axiomClass
      (hRecursive I) with
    ⟨A, hNotProvable, hNotProvableNeg⟩
  refine ⟨A, ?_, ?_⟩
  · intro hT
    exact hNotProvable ((I.theoremhood_iff A.toFormula).1 hT)
  · intro hT
    have hSystem :
        I.system.ProvableFrom I.axiomClass (SystemP.neg A.toFormula) :=
      (I.theoremhood_iff (SystemP.neg A.toFormula)).1 hT
    exact hNotProvableNeg (by
      simpa [Godel1931System.neg] using hSystem)

end MathlibExpansion.Logic.Godel
