import MathlibExpansion.Logic.Godel.SyntaxCodes

/-!
# Type-raising on Gödel codes
-/

namespace MathlibExpansion.Logic.Godel

/--
Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica und
verwandter Systeme I*, Section 2, primitive-recursive schema list: the local
type-raising code facade is primitive recursive.  In this snapshot
`typeRaiseCode` is the concrete pairing constructor `Nat.pair k q`, so this
follows from Mathlib's `Primrec₂.natPair`.
-/
theorem primrec_typeRaiseCode : Primrec2Nat typeRaiseCode := by
  simpa [Primrec2Nat, typeRaiseCode] using Primrec₂.natPair

end MathlibExpansion.Logic.Godel
