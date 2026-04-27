import MathlibExpansion.Logic.Godel.SyntaxCodes

/-!
# Substitution on Gödel codes
-/

namespace MathlibExpansion.Logic.Godel

/-- Substitute the numeral code of `y` for variable `v` in the code `q`. -/
def substNumeralCode (q v y : FormulaCode) : FormulaCode :=
  substCode q v (numeralCode y)

/--
Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica und
verwandter Systeme I*, Section 2, primitive-recursive schema list, functions
27--31: the local substitution-code facade is primitive recursive.  In this
snapshot `substCode` is the concrete pairing constructor
`Nat.pair q (Nat.pair v t)`, so this follows from Mathlib's primitive
recursiveness of `Nat.pair`.
-/
theorem primrec_substCode : Primrec3 substCode := by
  unfold Primrec3 substCode
  exact
    Nat.Primrec'.natPair.comp₂ _
      (Nat.Primrec'.get ⟨0, by decide⟩)
      (Nat.Primrec'.natPair.comp₂ _
        (Nat.Primrec'.get ⟨1, by decide⟩)
        (Nat.Primrec'.get ⟨2, by decide⟩))

theorem substNumeralCode_def (q v y : FormulaCode) :
    substNumeralCode q v y = substCode q v (numeralCode y) :=
  rfl

end MathlibExpansion.Logic.Godel
