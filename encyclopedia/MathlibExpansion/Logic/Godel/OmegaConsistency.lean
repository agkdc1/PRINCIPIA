import MathlibExpansion.Logic.Godel.SystemP.Derivability

/-!
# Omega-consistency boundary for Gödel 1931
-/

namespace MathlibExpansion.Logic.Godel

namespace Godel1931System

/--
Gödel's source-faithful omega-consistency boundary, locked by the Step 5
verdict: no class-string may have all numeral instances provable while the
negated universal closure is also provable.
-/
def OmegaConsistent (P : Godel1931System) (c : P.FormulaClass) : Prop :=
  ¬ ∃ a : P.ClassSign,
      (∀ n : ℕ, P.ProvableFrom c (P.instantiateNumeral a n)) ∧
      P.ProvableFrom c (P.neg (P.universalClosure a))

end Godel1931System

end MathlibExpansion.Logic.Godel
