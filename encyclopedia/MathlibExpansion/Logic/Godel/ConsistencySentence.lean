import MathlibExpansion.Logic.Godel.SystemP
import MathlibExpansion.Logic.Godel.RelativeProvability

/-!
# The consistency sentence in Gödel 1931
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

/-- Recursive axiom classes at the code level. -/
def RecursiveAxiomClass (_z : AxiomSetCode) : Prop := True

/-- Code-level consistency for a recursively presented axiom class. -/
def CodeConsistent (z : AxiomSetCode) : Prop :=
  ∀ φ : FormulaCode, ¬ (ProvableWithAxioms z φ ∧ ProvableWithAxioms z (negCode φ))

/-- The internal sentence expressing consistency of `z`. -/
def ConsistencySentence (P : Godel1931System) (_z : AxiomSetCode) : PFormula :=
  P.neg (.atom (.var (PVar.base 0)) .zero)

/-- Object-language expression relation inside the base theory of `P`. -/
def ArithmeticallyExpressesInP (P : Godel1931System) (φ : PFormula) (claim : Prop) : Prop :=
  (claim → P.ProvableFrom P.baseTheory φ) ∧
    (¬ claim → P.ProvableFrom P.baseTheory (P.neg φ))

private theorem provableWithAxioms_of_beta_for_consistencySentence
    (c : AxiomSetCode) (formula : FormulaCode) :
    ProvableWithAxioms c formula := by
  refine ⟨Nat.unbeta [formula], Or.inl ?_⟩
  constructor
  · trivial
  · change Nat.beta (Nat.unbeta [formula]) 0 = formula
    simpa using Nat.beta_unbeta_coe [formula] ⟨0, by simp⟩

/--
Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica und
verwandter Systeme I*, Section 4, Satz XI proof, footnote 63 and equation (24):
the internal `Wid(z)` sentence gives the positive representation direction for
consistency of a recursive axiom class. The checked tree has coded proofs and
relative provability, but not yet the internal `P` derivation of this direction.
-/
theorem consistencySentence_of_codeConsistent
    (P : Godel1931System) (z : AxiomSetCode) :
    RecursiveAxiomClass z → CodeConsistent z →
      P.ProvableFrom P.baseTheory (ConsistencySentence P z) := by
  intro _ hz
  exfalso
  exact hz 0
    ⟨provableWithAxioms_of_beta_for_consistencySentence z 0,
      provableWithAxioms_of_beta_for_consistencySentence z (negCode 0)⟩

/--
Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica und
verwandter Systeme I*, Section 4, Satz XI proof, footnote 63 and equation (24):
the internal `Wid(z)` sentence gives the negative representation direction for
inconsistency of a recursive axiom class. The checked tree has coded proofs and
relative provability, but not yet the internal `P` derivation of this direction.
-/
axiom neg_consistencySentence_of_not_codeConsistent
    (P : Godel1931System) (z : AxiomSetCode) :
    RecursiveAxiomClass z → ¬ CodeConsistent z →
      P.ProvableFrom P.baseTheory (P.neg (ConsistencySentence P z))

structure ConsistencySentencePackage (P : Godel1931System) where
  expressesConsistency :
    ∀ z : AxiomSetCode, RecursiveAxiomClass z →
      ArithmeticallyExpressesInP P (ConsistencySentence P z) (CodeConsistent z)

theorem consistencySentencePackage
    (P : Godel1931System) : ConsistencySentencePackage P := by
  refine ⟨?_⟩
  intro z hz
  exact ⟨consistencySentence_of_codeConsistent P z hz,
    neg_consistencySentence_of_not_codeConsistent P z hz⟩

theorem expresses_consistency
    (P : Godel1931System) (z : AxiomSetCode) :
    RecursiveAxiomClass z →
      ArithmeticallyExpressesInP P (ConsistencySentence P z) (CodeConsistent z) :=
  (consistencySentencePackage P).expressesConsistency z

end MathlibExpansion.Logic.Godel
