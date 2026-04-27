/-
# Analytic-Symbol Descent (Atiyah-Singer III 1968 §I)
B2 for T20c_mid_17_AISI.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Analysis.PDE.AnalyticSymbolDescent

/-- **AS III 1968 §I, Analytic-symbol descent carrier.** -/
structure AnalyticSymbolDescent where
  analyticIndex : ℤ
  symbolIndex : ℤ

def AnalyticSymbolDescent.matches (d : AnalyticSymbolDescent) : Prop :=
  d.analyticIndex = d.symbolIndex

@[simp] theorem AnalyticSymbolDescent.matches_refl (n : ℤ) :
    ({analyticIndex := n, symbolIndex := n} : AnalyticSymbolDescent).matches := rfl

end MathlibExpansion.Analysis.PDE.AnalyticSymbolDescent
