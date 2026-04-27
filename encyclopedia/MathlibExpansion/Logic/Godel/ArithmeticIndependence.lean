import MathlibExpansion.Logic.Godel.ArithmeticalDefinability
import MathlibExpansion.Logic.Godel.FirstIncompletenessOmega
import MathlibExpansion.Logic.Godel.PeanoRecursiveTheory

/-!
# Undecidable arithmetical sentences for Gödel 1931
-/

namespace MathlibExpansion.Logic.Godel

/-- A sentence is undecidable in `P` when neither it nor its negation is provable. -/
def UndecidableIn (P : Godel1931System) (A : ArithmeticalSentence) : Prop :=
  ¬ P.ProvableFrom P.baseTheory A.toFormula ∧
    ¬ P.ProvableFrom P.baseTheory (P.neg A.toFormula)

structure ArithmeticIndependencePackage (P : Godel1931System) where
  recursiveForallAsArithmetic :
    ∀ {F : ℕ → Prop} [DecidablePred F] (_hF : PrimrecPred F),
      ∃ A : ArithmeticalSentence,
        EquivalentToRecursiveUniversal F A ∧
        P.ProvableFrom P.baseTheory (recursiveUniversalFormula F)
  existsUndecidableArithmetic :
    ∀ (c : P.FormulaClass), P.OmegaConsistent c →
      ∃ A : ArithmeticalSentence,
        ¬ P.ProvableFrom c A.toFormula ∧
        ¬ P.ProvableFrom c (P.neg A.toFormula)
  peanoUndecidableArithmetic :
    PeanoRecursiveTheory1931.OmegaConsistent PeanoRecursiveTheory1931.baseTheory →
      ∃ A : ArithmeticalSentence, UndecidableIn PeanoRecursiveTheory1931 A

/--
Upstream-narrow boundary: Godel 1931, *Ueber formal unentscheidbare Saetze
der Principia Mathematica und verwandter Systeme I*, Monatshefte 38 (1931),
Section 3, Satz VII and the immediate corollary before Satz VIII, pp. 192-193.

Exact discharge target: replace the current placeholder
`recursiveUniversalFormula` with the arithmetized universal closure produced by
Satz VII, then prove in system `P` the formal equivalence for each fixed
primitive-recursive predicate `F`.
-/
axiom systemP_proves_recursiveUniversalFormula
    (P : Godel1931System) {F : ℕ → Prop} [DecidablePred F] (hF : PrimrecPred F) :
    P.ProvableFrom P.baseTheory (recursiveUniversalFormula F)

/--
The arithmetic-independence package is assembled from the narrower local
boundaries: the arithmetical-definability package supplies the recursive
universal sentence, the remaining provability bridge is isolated above, and the
undecidable arithmetical sentence comes from the local omega-consistency form of
Godel's first incompleteness package.
-/
def arithmeticIndependencePackage
    (P : Godel1931System) : ArithmeticIndependencePackage P where
  recursiveForallAsArithmetic := by
    intro F _ hF
    rcases recursive_forall_equiv_arithmetical_sentence P hF with ⟨A, hA⟩
    exact ⟨A, hA, systemP_proves_recursiveUniversalFormula P hF⟩
  existsUndecidableArithmetic := by
    intro c hω
    rcases exists_godel_sentence_of_decisionalDefinite P c hω trivial with ⟨r, hr⟩
    let A : ArithmeticalSentence :=
      { toFormula := P.universalClosure r.toClassSign
        Holds := True }
    exact ⟨A, by simpa [A] using hr⟩
  peanoUndecidableArithmetic := by
    intro hω
    rcases exists_godel_sentence_of_decisionalDefinite
        PeanoRecursiveTheory1931 PeanoRecursiveTheory1931.baseTheory hω trivial with
      ⟨r, hr⟩
    let A : ArithmeticalSentence :=
      { toFormula := PeanoRecursiveTheory1931.universalClosure r.toClassSign
        Holds := True }
    exact ⟨A, by simpa [A, UndecidableIn] using hr⟩

theorem exists_arithmetical_sentence_equiv_recursive_forall
    (P : Godel1931System) {F : ℕ → Prop} [DecidablePred F] (hF : PrimrecPred F) :
    ∃ A : ArithmeticalSentence,
      EquivalentToRecursiveUniversal F A ∧
      P.ProvableFrom P.baseTheory (recursiveUniversalFormula F) :=
  (arithmeticIndependencePackage P).recursiveForallAsArithmetic hF

theorem exists_undecidable_arithmetical_sentence
    (P : Godel1931System) (c : P.FormulaClass) :
    P.OmegaConsistent c →
      ∃ A : ArithmeticalSentence,
        ¬ P.ProvableFrom c A.toFormula ∧
        ¬ P.ProvableFrom c (P.neg A.toFormula) :=
  (arithmeticIndependencePackage P).existsUndecidableArithmetic c

theorem peanoRecursiveTheory_exists_undecidable_arithmetical_sentence :
    PeanoRecursiveTheory1931.OmegaConsistent PeanoRecursiveTheory1931.baseTheory →
      ∃ A : ArithmeticalSentence, UndecidableIn PeanoRecursiveTheory1931 A :=
  (arithmeticIndependencePackage PeanoRecursiveTheory1931).peanoUndecidableArithmetic

end MathlibExpansion.Logic.Godel
