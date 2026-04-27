import MathlibExpansion.Logic.Godel.SystemP

/-!
# Peano arithmetic with recursive definition, in Gödel's 1931 sense
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

/-- The named 1931 arithmetic theory singled out by Gödel after Proposition VIII. -/
def PeanoRecursiveTheory1931 : Godel1931System :=
  { defaultGodel1931System with name := "PeanoRecursiveTheory1931" }

/-- A lightweight object-language proxy for `(∀ x) F(x)`. -/
def recursiveUniversalFormula (_F : ℕ → Prop) : PFormula :=
  .all (PVar.base 0) (.atom (.var (PVar.base 0)) .zero)

end MathlibExpansion.Logic.Godel
