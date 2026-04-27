import Mathlib.Logic.Godel.GodelBetaFunction
import MathlibExpansion.Logic.Godel.SyntaxCodes

/-!
# Remainder / beta sidecar for Gödel 1931
-/

namespace MathlibExpansion.Logic.Godel

/-- The public remainder graph used by later arithmetical-definability files. -/
def remainderGraph (n i r : ℕ) : Prop := Nat.beta n i = r

/-- Public code proxy for a remainder formula. -/
def remainderFormulaCode (n i : ℕ) : FormulaCode := Nat.pair n i

/-- Gödel's beta-function lemma in graph form on the public sidecar. -/
theorem beta_unbeta_graph (l : List ℕ) (i : Fin l.length) :
    remainderGraph (Nat.unbeta l) i l[i] := by
  simpa [remainderGraph] using Nat.beta_unbeta_coe l i

end MathlibExpansion.Logic.Godel
