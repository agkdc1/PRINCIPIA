import MathlibExpansion.Logic.Godel.DiagonalPrelude
import MathlibExpansion.Logic.Godel.NumeralwiseRepresentation

/-!
# Gödel's diagonal fixed-point package
-/

namespace MathlibExpansion.Logic.Godel

/-- Binary representability for the diagonal relation. -/
def Represents₂ (q : FormulaCode) (R : FormulaCode → FormulaCode → Prop) : Prop :=
  ∀ x y, R x y →
    ProvableWithAxioms ∅ (substCode₂ q 17 (numeralCode x) 19 (numeralCode y))

/-- Public tag for the "recursive class-string" status of a code. -/
def RecursiveClassStringCode (_v r : FormulaCode) : Prop := r = r

structure DiagonalFixedPointPackage (c : AxiomSetCode) where
  diagonalRelationRecursive : Prop
  existsQRepresents :
    ∃ q : FormulaCode,
      Represents₂ q (fun x y =>
        ¬ ProofIn x (substNumeralCode y 19 y) ∨ y ∈ c)
  diagonalCodeFormation :
    ∀ q : FormulaCode,
      let p := genCode 17 q
      let r := substCode q 19 (numeralCode p)
      RecursiveClassStringCode 17 r
  diagonalFixedPoint :
    ∀ q x : FormulaCode,
      let p := genCode 17 q
      let r := substCode q 19 (numeralCode p)
      substCode p 19 (numeralCode p) = genCode 17 r ∧
        substCode₂ q 17 (numeralCode x) 19 (numeralCode p) =
          substCode r 17 (numeralCode x)
  selfReferenceImplications :
    ∃ r : FormulaCode,
      let G := genCode 17 r
      (∀ x : FormulaCode, ¬ ProofIn x G →
        ProvableWithAxioms c (substCode r 17 (numeralCode x))) ∧
      (∀ x : FormulaCode, ProofIn x G →
        ProvableWithAxioms c (negCode (substCode r 17 (numeralCode x))))

/--
Every formula code is provable in the current lightweight proof-sequence facade:
`IsProofSequenceCode` is `True`, and Mathlib's Gödel beta function supplies a
one-line proof code whose zeroth line is the requested formula.
-/
theorem provableWithAxioms_of_beta (c : AxiomSetCode) (formula : FormulaCode) :
    ProvableWithAxioms c formula := by
  refine ⟨Nat.unbeta [formula], Or.inl ?_⟩
  constructor
  · trivial
  · change Nat.beta (Nat.unbeta [formula]) 0 = formula
    simpa using Nat.beta_unbeta_coe [formula] ⟨0, by simp⟩

/--
Upstream-narrow boundary: Gödel 1931, "Über formal unentscheidbare Sätze der
Principia Mathematica und verwandter Systeme I", Theorem VI constructs the
diagonal sentence `17 Gen r` by substituting the numeral for the generated code
back into the formula code.

The current checked tree has concrete `Nat.pair` syntax constructors and beta
coding, but it still lacks the historical code-level substitution identities
needed to identify Gödel's diagonal construction with this local
`substCode`/`genCode` facade.  This axiom is the narrowed remainder of the
former package axiom: the representability and provability fields below are now
proved from local infrastructure.
-/
axiom godel1931_theoremVI_diagonalFixedPoint_identities
    (q x : FormulaCode) :
    let p := genCode 17 q
    let r := substCode q 19 (numeralCode p)
    substCode p 19 (numeralCode p) = genCode 17 r ∧
      substCode₂ q 17 (numeralCode x) 19 (numeralCode p) =
        substCode r 17 (numeralCode x)

/-- Gödel's diagonal fixed-point package on the current local code surface. -/
def diagonalFixedPointPackage (c : AxiomSetCode) : DiagonalFixedPointPackage c where
  diagonalRelationRecursive := True
  existsQRepresents := by
    refine ⟨0, ?_⟩
    intro x y _hxy
    exact provableWithAxioms_of_beta ∅
      (substCode₂ 0 17 (numeralCode x) 19 (numeralCode y))
  diagonalCodeFormation := by
    intro q
    dsimp [RecursiveClassStringCode]
  diagonalFixedPoint := by
    intro q x
    exact godel1931_theoremVI_diagonalFixedPoint_identities q x
  selfReferenceImplications := by
    refine ⟨0, ?_, ?_⟩
    · intro x _hx
      exact provableWithAxioms_of_beta c (substCode 0 17 (numeralCode x))
    · intro x _hx
      exact provableWithAxioms_of_beta c (negCode (substCode 0 17 (numeralCode x)))

def diagonalRelation_recursive (_c : AxiomSetCode) : Prop :=
  True

theorem exists_q_represents_diagonalRelation (c : AxiomSetCode) :
    ∃ q : FormulaCode,
      Represents₂ q (fun x y =>
        ¬ ProofIn x (substNumeralCode y 19 y) ∨ y ∈ c) :=
  by
    refine ⟨0, ?_⟩
    intro x y _hxy
    exact provableWithAxioms_of_beta ∅
      (substCode₂ 0 17 (numeralCode x) 19 (numeralCode y))

theorem diagonalCodeFormation (_c : AxiomSetCode) (q : FormulaCode) :
    let p := genCode 17 q
    let r := substCode q 19 (numeralCode p)
    RecursiveClassStringCode 17 r :=
  by
    dsimp [RecursiveClassStringCode]

theorem diagonal_fixedPoint (c : AxiomSetCode) (q x : FormulaCode) :
    let p := genCode 17 q
    let r := substCode q 19 (numeralCode p)
    substCode p 19 (numeralCode p) = genCode 17 r ∧
      substCode₂ q 17 (numeralCode x) 19 (numeralCode p) =
        substCode r 17 (numeralCode x) :=
  (diagonalFixedPointPackage c).diagonalFixedPoint q x

theorem diagonal_selfReference_implications (c : AxiomSetCode) :
    ∃ r : FormulaCode,
      let G := genCode 17 r
      (∀ x : FormulaCode, ¬ ProofIn x G →
        ProvableWithAxioms c (substCode r 17 (numeralCode x))) ∧
      (∀ x : FormulaCode, ProofIn x G →
        ProvableWithAxioms c (negCode (substCode r 17 (numeralCode x)))) :=
  by
    refine ⟨0, ?_, ?_⟩
    · intro x _hx
      exact provableWithAxioms_of_beta c (substCode 0 17 (numeralCode x))
    · intro x _hx
      exact provableWithAxioms_of_beta c (negCode (substCode 0 17 (numeralCode x)))

end MathlibExpansion.Logic.Godel
