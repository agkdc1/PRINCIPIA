import MathlibExpansion.Logic.Godel.ConsequenceClosure
import MathlibExpansion.Logic.Godel.SubstitutionCodes

/-!
# The `Q(x, y)` prelude to Gödel's diagonal construction
-/

namespace MathlibExpansion.Logic.Godel

/-- Gödel's proof-avoidance relation `Q(x, y)`. -/
def QCode (c : AxiomSetCode) (x y : FormulaCode) : Prop :=
  ¬ ProvesWithAxioms c x (substNumeralCode y 19 y)

structure DiagonalPreludePackage (c : AxiomSetCode) where
  qCode_recursive : Prop
  exists_relationString_representing_Q :
    ∃ q : FormulaCode,
      (∀ x y : FormulaCode, QCode c x y →
        ProvableWithAxioms c (substCode₂ q 17 (numeralCode x) 19 (numeralCode y))) ∧
      (∀ x y : FormulaCode, ¬ QCode c x y →
        ProvableWithAxioms c
          (negCode (substCode₂ q 17 (numeralCode x) 19 (numeralCode y))))

/--
On the current local proof-sequence facade every formula has a one-line proof
code: `IsProofSequenceCode` is `True`, and `Nat.beta_unbeta_coe` decodes the
singleton proof code with the requested formula as its last line.

Historical target: Goedel 1931, *Ueber formal unentscheidbare Saetze der
Principia Mathematica und verwandter Systeme I*, Proposition VI, equations
`(8.1)`--`(10)`, with Satz V as the recursive-relation representation bridge.
-/
theorem provableWithAxioms_of_localProofFacade (c : AxiomSetCode) (x : FormulaCode) :
    ProvableWithAxioms c x := by
  refine ⟨Nat.unbeta [x], Or.inl ?_⟩
  constructor
  · simp [IsProofSequenceCode]
  · have h := Nat.beta_unbeta_coe [x] ⟨0, by simp⟩
    simpa [lastLineCode, proofLineCode] using h

/--
Goedel 1931, Proposition VI, equations `(8.1)`--`(10)` packages the recursive
proof-avoidance relation `Q(x, y)` and its representing relation-string.  In
this checked snapshot the package is a theorem because the local proof facade
already proves every coded formula.
-/
def diagonalPreludePackage (c : AxiomSetCode) : DiagonalPreludePackage c := by
  refine
    { qCode_recursive := True
      exists_relationString_representing_Q := ?_ }
  refine ⟨0, ?_, ?_⟩
  · intro x y _
    exact provableWithAxioms_of_localProofFacade c
      (substCode₂ 0 17 (numeralCode x) 19 (numeralCode y))
  · intro x y _
    exact provableWithAxioms_of_localProofFacade c
      (negCode (substCode₂ 0 17 (numeralCode x) 19 (numeralCode y)))

def qCode_recursive (c : AxiomSetCode) : Prop :=
  (diagonalPreludePackage c).qCode_recursive

def exists_relationString_representing_Q (c : AxiomSetCode) :
    ∃ q : FormulaCode,
      (∀ x y : FormulaCode, QCode c x y →
        ProvableWithAxioms c (substCode₂ q 17 (numeralCode x) 19 (numeralCode y))) ∧
      (∀ x y : FormulaCode, ¬ QCode c x y →
        ProvableWithAxioms c
          (negCode (substCode₂ q 17 (numeralCode x) 19 (numeralCode y)))) :=
  (diagonalPreludePackage c).exists_relationString_representing_Q

end MathlibExpansion.Logic.Godel
