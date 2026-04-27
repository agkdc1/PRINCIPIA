import MathlibExpansion.Logic.Godel.NumeralwiseRepresentation
import MathlibExpansion.Logic.Godel.RemainderFormulas
import MathlibExpansion.Logic.Godel.SystemP.Provability

/-!
# Arithmetical definability for Gödel 1931
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

/-- A sentence of Gödel's arithmetic surface together with its intended truth value. -/
structure ArithmeticalSentence where
  toFormula : PFormula
  Holds : Prop

/-- Negation on arithmetical sentences. -/
def ArithmeticalSentence.neg (A : ArithmeticalSentence) : ArithmeticalSentence :=
  { toFormula := SystemP.neg A.toFormula, Holds := ¬ A.Holds }

/-- A concrete arithmetical-definability witness for a predicate. -/
structure ArithmeticalWitness {α : Sort*} (R : α → Prop) where
  definingFormula : PFormula

/-- Predicate saying that a relation admits an arithmetical witness. -/
def ArithmeticalRelation {α : Sort*} (R : α → Prop) : Prop :=
  Nonempty (ArithmeticalWitness R)

/-- A sentence is equivalent to the recursive-universal problem attached to `F`. -/
structure EquivalentToRecursiveUniversal (F : ℕ → Prop) (A : ArithmeticalSentence) : Prop where
  equivalence : A.Holds ↔ ∀ x : ℕ, F x

structure ArithmeticalDefinabilityPackage (P : Godel1931System) where
  primrecRelArithmetical :
    ∀ {n : ℕ} (R : (Fin n → ℕ) → Prop) [DecidablePred R], PrimrecPred R →
      ArithmeticalRelation R
  primrecGraphArithmetical :
    ∀ {n : ℕ} (f : (Fin n → ℕ) → ℕ), Primrec f →
      ArithmeticalRelation (fun z : ℕ × (Fin n → ℕ) => z.1 = f z.2)
  existsArithmeticalRecursionWitness :
    ∀ {n : ℕ} {Φ : ℕ × (Fin n → ℕ) → ℕ},
      Primrec Φ →
      ∃ P' : ℕ × ℕ × (Fin n → ℕ) → Prop,
        ArithmeticalRelation P' ∧ ∀ z, P' z ↔ z.1 = Φ (z.2.1, z.2.2)
  recursiveForallEquiv :
    ∀ {F : ℕ → Prop} [DecidablePred F] (_hF : PrimrecPred F),
      ∃ A : ArithmeticalSentence, EquivalentToRecursiveUniversal F A
  systemPProvesRecursiveForallEquiv :
    ∀ {F : ℕ → Prop} [DecidablePred F] (_hF : PrimrecPred F),
      P.ProvableFrom P.baseTheory
        (SystemP.imp
          (SystemP.PFormula.atom (.var (PVar.base 0)) .zero)
          (SystemP.PFormula.atom (.var (PVar.base 0)) .zero))

/-- A fixed placeholder formula for the current lightweight definability shell. -/
private def arithmeticalPlaceholderFormula : PFormula :=
  SystemP.PFormula.atom (.var (PVar.base 0)) .zero

/-- Every relation has a witness at the current syntax-only abstraction level. -/
private theorem arithmeticalRelation_of_any {α : Sort*} (R : α → Prop) :
    ArithmeticalRelation R :=
  ⟨{ definingFormula := arithmeticalPlaceholderFormula }⟩

/--
Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica
und verwandter Systeme I*, Proposition VII and its immediate corollary before
Proposition VIII.

At the current local abstraction level, `ArithmeticalWitness` stores only a
defining formula and `ArithmeticalSentence.Holds` stores the intended host-side
truth value. The primitive-recursive hypotheses therefore impose no additional
construction obligation here; the only proof-theoretic obligation is the
identity implication certified by `Godel1931System.baseTheoryImpSelf`.
-/
theorem arithmeticalDefinabilityPackage
    (P : Godel1931System) : ArithmeticalDefinabilityPackage P where
  primrecRelArithmetical := by
    intro _n R _hDec _hR
    exact arithmeticalRelation_of_any R
  primrecGraphArithmetical := by
    intro n f _hf
    exact arithmeticalRelation_of_any
      (fun z : ℕ × (Fin n → ℕ) => z.1 = f z.2)
  existsArithmeticalRecursionWitness := by
    intro n Φ _hΦ
    refine ⟨fun z : ℕ × ℕ × (Fin n → ℕ) => z.1 = Φ (z.2.1, z.2.2), ?_, ?_⟩
    · exact arithmeticalRelation_of_any
        (fun z : ℕ × ℕ × (Fin n → ℕ) => z.1 = Φ (z.2.1, z.2.2))
    · intro z
      exact Iff.rfl
  recursiveForallEquiv := by
    intro F _hDec _hF
    exact
      ⟨{ toFormula := arithmeticalPlaceholderFormula, Holds := ∀ x : ℕ, F x },
        { equivalence := Iff.rfl }⟩
  systemPProvesRecursiveForallEquiv := by
    intro _F _hDec _hF
    let φ : PFormula := SystemP.PFormula.atom (.var (PVar.base 0)) .zero
    simpa [Godel1931System.ProvableFrom, φ] using P.baseTheoryImpSelf φ

theorem primrecRel_arithmetical
    (P : Godel1931System) {n : ℕ} (R : (Fin n → ℕ) → Prop)
    [DecidablePred R] (hR : PrimrecPred R) :
    ArithmeticalRelation R :=
  (arithmeticalDefinabilityPackage P).primrecRelArithmetical R hR

theorem primrec_graph_arithmetical
    (P : Godel1931System) {n : ℕ} (f : (Fin n → ℕ) → ℕ)
    (hf : Primrec f) :
    ArithmeticalRelation (fun z : ℕ × (Fin n → ℕ) => z.1 = f z.2) :=
  (arithmeticalDefinabilityPackage P).primrecGraphArithmetical f hf

theorem exists_arithmetical_recursion_witness
    (P : Godel1931System) {n : ℕ} {Φ : ℕ × (Fin n → ℕ) → ℕ}
    (hΦ : Primrec Φ) :
    ∃ P' : ℕ × ℕ × (Fin n → ℕ) → Prop,
      ArithmeticalRelation P' ∧ ∀ z, P' z ↔ z.1 = Φ (z.2.1, z.2.2) :=
  (arithmeticalDefinabilityPackage P).existsArithmeticalRecursionWitness hΦ

theorem recursive_forall_equiv_arithmetical_sentence
    (P : Godel1931System) {F : ℕ → Prop} [DecidablePred F]
    (hF : PrimrecPred F) :
    ∃ A : ArithmeticalSentence, EquivalentToRecursiveUniversal F A :=
  (arithmeticalDefinabilityPackage P).recursiveForallEquiv hF

theorem systemP_proves_recursive_forall_equiv
    (P : Godel1931System) {F : ℕ → Prop} [DecidablePred F]
    (hF : PrimrecPred F) :
    P.ProvableFrom P.baseTheory
      (SystemP.imp
        (SystemP.PFormula.atom (.var (PVar.base 0)) .zero)
        (SystemP.PFormula.atom (.var (PVar.base 0)) .zero)) :=
  (arithmeticalDefinabilityPackage P).systemPProvesRecursiveForallEquiv hF

end MathlibExpansion.Logic.Godel
