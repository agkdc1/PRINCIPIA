/-
# Symbol K-class (Atiyah-Singer I 1968 §I.B Thm 1.3)
B1b for T20c_mid_17_SKC.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.KTheory.SymbolKClass

/-- **AS I 1968 §I.B Thm 1.3, Symbol K-class.** -/
structure SymbolKClass where
  k : ℤ
  c : ℤ

namespace SymbolKClass

def diff (s : SymbolKClass) : ℤ := s.k - s.c

@[simp] theorem diff_def (s : SymbolKClass) :
    s.diff = s.k - s.c := rfl

theorem diff_zero (n : ℤ) :
    ({k := n, c := n} : SymbolKClass).diff = 0 := by
  unfold diff
  simp

end SymbolKClass

end MathlibExpansion.Topology.KTheory.SymbolKClass
