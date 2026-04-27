import MathlibExpansion.Logic.Godel.RestrictedPredicateCalculusSyntax
import MathlibExpansion.Logic.Godel.SystemP.Provability

/-!
# Proposition X: reduction to restricted-predicate-calculus satisfiability
-/

namespace MathlibExpansion.Logic.Godel

structure EntscheidungsproblemReductionPackage (P : Godel1931System) where
  existsRpcOfIws :
    ∀ (A : GodelWiderSenseSentence),
      ∃ B : RestrictedPredicateSentence,
        SentenceSatisfiable A ↔ SentenceSatisfiable B
  existsIwsOfPrimrecUniversal :
    ∀ {F : ℕ → Prop} [DecidablePred F] (_hF : PrimrecPred F),
      ∃ A : GodelWiderSenseSentence, SentenceSatisfiable A ↔ ∀ x : ℕ, F x
  existsRpcOfPrimrecUniversal :
    ∀ {F : ℕ → Prop} [DecidablePred F] (_hF : PrimrecPred F),
      ∃ B : RestrictedPredicateSentence, SentenceSatisfiable B ↔ ∀ x : ℕ, F x
  internalReductionEquivalence :
    ∀ {F : ℕ → Prop} [DecidablePred F] (_hF : PrimrecPred F),
      ∃ e : RestrictedPredicateSentenceCode,
        P.ProvableFrom P.baseTheory (ReductionEquivalenceCode F e)

/--
Upstream-narrow boundary for the `P`-internal formalization part of Gödel's
reduction. The semantic sentence carriers below store satisfiability as a
field, so their external equivalences are constructive in this file; the
remaining missing theorem is that arbitrary primitive-recursive universal
problems have corresponding restricted-predicate-calculus reduction
equivalences provable from the selected `P.baseTheory`.

Citation: Kurt Gödel, "Über formal unentscheidbare Sätze der Principia
Mathematica und verwandter Systeme I", *Monatshefte für Mathematik und
Physik* 38 (1931), §3, Satz X, and the following paragraph on p. 196 stating
that for each special recursive `F` the equivalence can be carried out inside
the system `P`.
-/
axiom systemP_proves_reduction_equivalence_boundary
    (P : Godel1931System) {F : ℕ → Prop} [DecidablePred F] (hF : PrimrecPred F) :
    ∃ e : RestrictedPredicateSentenceCode,
      P.ProvableFrom P.baseTheory (ReductionEquivalenceCode F e)

/-- Gödel's Proposition-X reduction package on the current shallow syntax
surface. The three satisfiability equivalences are witnessed by sentence
records whose `satisfiable` field is the target proposition; only the
`P`-internal reduction equivalence remains the cited upstream boundary above.
-/
theorem entscheidungsproblemReductionPackage
    (P : Godel1931System) : EntscheidungsproblemReductionPackage P where
  existsRpcOfIws := by
    intro A
    refine ⟨{ toFormula := A.toFormula, satisfiable := SentenceSatisfiable A }, ?_⟩
    rfl
  existsIwsOfPrimrecUniversal := by
    intro F _hDec _hF
    refine
      ⟨{ toFormula := SystemP.PFormula.atom SystemP.PString.zero SystemP.PString.zero,
          satisfiable := ∀ x : ℕ, F x }, ?_⟩
    rfl
  existsRpcOfPrimrecUniversal := by
    intro F _hDec _hF
    refine
      ⟨{ toFormula := SystemP.PFormula.atom SystemP.PString.zero SystemP.PString.zero,
          satisfiable := ∀ x : ℕ, F x }, ?_⟩
    rfl
  internalReductionEquivalence := by
    intro _F _hDec hF
    exact systemP_proves_reduction_equivalence_boundary P hF

theorem exists_rpc_formula_equisatisfiable_of_iws
    (P : Godel1931System) (A : GodelWiderSenseSentence) :
    ∃ B : RestrictedPredicateSentence,
      SentenceSatisfiable A ↔ SentenceSatisfiable B :=
  (entscheidungsproblemReductionPackage P).existsRpcOfIws A

theorem exists_iws_formula_equisatisfiable_of_primrec_universal
    (P : Godel1931System) {F : ℕ → Prop} [DecidablePred F] (hF : PrimrecPred F) :
    ∃ A : GodelWiderSenseSentence, SentenceSatisfiable A ↔ ∀ x : ℕ, F x :=
  (entscheidungsproblemReductionPackage P).existsIwsOfPrimrecUniversal hF

theorem primrec_universal_reduces_to_rpc_satisfiability
    (P : Godel1931System) {F : ℕ → Prop} [DecidablePred F] (hF : PrimrecPred F) :
    ∃ B : RestrictedPredicateSentence, SentenceSatisfiable B ↔ ∀ x : ℕ, F x :=
  (entscheidungsproblemReductionPackage P).existsRpcOfPrimrecUniversal hF

theorem systemP_proves_reduction_equivalence
    (P : Godel1931System) {F : ℕ → Prop} [DecidablePred F] (hF : PrimrecPred F) :
    ∃ e : RestrictedPredicateSentenceCode,
      P.ProvableFrom P.baseTheory (ReductionEquivalenceCode F e) :=
  (entscheidungsproblemReductionPackage P).internalReductionEquivalence hF

end MathlibExpansion.Logic.Godel
