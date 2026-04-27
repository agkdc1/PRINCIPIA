/-
# Topological Index from K-Theory (AS I 1968 §I.C Thm 2.4)
B1b for T20c_mid_17_TPF.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.KTheory.TopologicalIndex

/-- **AS I 1968 §I.C Thm 2.4, Topological index carrier.** -/
structure TopologicalIndex where
  value : ℤ

@[simp] theorem TopologicalIndex.value_zero :
    (⟨0⟩ : TopologicalIndex).value = 0 := rfl

end MathlibExpansion.Topology.KTheory.TopologicalIndex
