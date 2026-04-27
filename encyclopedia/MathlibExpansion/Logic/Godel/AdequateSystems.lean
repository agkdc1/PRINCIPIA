import MathlibExpansion.Logic.Godel.FirstIncompletenessOmega

/-!
# Adequate formal systems consuming Gödel's first incompleteness bridge
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

/--
Godel's "adequate system" shell for the 1931 transfer remark, narrowed to a
concrete `Godel1931System` theory.
-/
structure AdequateFormalSystem where
  P : Godel1931System := defaultGodel1931System
  theory : P.FormulaClass := P.baseTheory
  recursiveAxiomsAndRules : Prop := True
  representsRecursiveRelations : Prop := True

namespace AdequateFormalSystem

/-- Sentences of the narrowed adequate-system shell are formulas of system `P`. -/
abbrev Sentence (_T : AdequateFormalSystem) : Type :=
  PFormula

/-- Provability in the selected theory. -/
def Provable (T : AdequateFormalSystem) : T.Sentence → Prop :=
  T.P.ProvableFrom T.theory

/-- Object-language negation. -/
def neg (T : AdequateFormalSystem) : T.Sentence → T.Sentence :=
  T.P.neg

/-- Universal closures of decision-definite class strings. -/
def IsRecursiveUniversalArithmeticSentence (T : AdequateFormalSystem)
    (φ : T.Sentence) : Prop :=
  ∃ r : T.P.DecisionalDefiniteClassString, φ = T.P.universalClosure r.toClassSign

/-- The selected theory has a recursive axiom/rule presentation. -/
def RecursiveAxiomsAndRules (T : AdequateFormalSystem) : Prop :=
  T.recursiveAxiomsAndRules

/-- The selected theory represents the recursive relations needed by Godel 1931. -/
def RepresentsRecursiveRelations (T : AdequateFormalSystem) : Prop :=
  T.representsRecursiveRelations

/-- Omega-consistency of the selected theory. -/
def OmegaConsistent (T : AdequateFormalSystem) : Prop :=
  T.P.OmegaConsistent T.theory

end AdequateFormalSystem

structure AdequateSystemsPackage where
  firstIncompletenessForAdequateSystem :
    ∀ (T : AdequateFormalSystem),
      T.RecursiveAxiomsAndRules →
      T.RepresentsRecursiveRelations →
      T.OmegaConsistent →
        ∃ φ : T.Sentence,
          T.IsRecursiveUniversalArithmeticSentence φ ∧
          ¬ T.Provable φ ∧ ¬ T.Provable (T.neg φ)

/--
Godel 1931, *Ueber formal unentscheidbare Saetze der Principia Mathematica
und verwandter Systeme I*, Proposition VI: the local adequate-system facade is
obtained by routing to the omega-consistency first-incompleteness package for
the selected `Godel1931System` theory.
-/
theorem adequateSystemsPackage : AdequateSystemsPackage where
  firstIncompletenessForAdequateSystem := by
    intro T _hRec _hRep hOmega
    rcases exists_godel_sentence_of_decisionalDefinite T.P T.theory hOmega trivial with
      ⟨r, hr⟩
    refine ⟨T.P.universalClosure r.toClassSign, ?_, ?_, ?_⟩
    · exact ⟨r, rfl⟩
    · simpa [AdequateFormalSystem.Provable] using hr.1
    · simpa [AdequateFormalSystem.Provable, AdequateFormalSystem.neg] using hr.2

theorem first_incompleteness_for_any_adequate_system
    (T : AdequateFormalSystem) :
    T.RecursiveAxiomsAndRules →
      T.RepresentsRecursiveRelations →
      T.OmegaConsistent →
        ∃ φ : T.Sentence,
          T.IsRecursiveUniversalArithmeticSentence φ ∧
          ¬ T.Provable φ ∧ ¬ T.Provable (T.neg φ) :=
  adequateSystemsPackage.firstIncompletenessForAdequateSystem T

end MathlibExpansion.Logic.Godel
