import Mathlib.Data.Real.Irrational
import MathlibExpansion.DedekindCuts.Basic

/-!
# Irrational Dedekind-cut examples

This file records the standard square-root cut as a non-rationally generated example.
-/

namespace MathlibExpansion
namespace DedekindCuts

/-- The cut determined by `√D`. -/
def sqrtCut (D : ℕ) : DedekindCut := ofReal (Real.sqrt D)

theorem nonsquare_cut_not_generated_by_rat {D : ℕ} (hDsq : ¬ IsSquare D) :
    ¬ GeneratedByRat (sqrtCut D) := by
  intro h
  rcases h with ⟨q, hq⟩
  have hEq : Real.sqrt D = q := by
    apply ofReal_injective
    simpa [sqrtCut, ofRat] using hq
  have hIrr : Irrational (Real.sqrt D) :=
    irrational_sqrt_natCast_iff.2 hDsq
  exact hIrr.ne_rat q hEq

end DedekindCuts
end MathlibExpansion
