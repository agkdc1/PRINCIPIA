/-
# Bott Periodicity (Atiyah-Bott 1964)
B1a opener for T20c_mid_17_BOTT. Citation: Atiyah-Bott, *On the periodicity
theorem for complex vector bundles*, Acta Math 112 (1964) 229-247.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.KTheory.BottPeriodicity

/-- **Atiyah-Bott 1964 Acta 112, Bott period.** Period 2 for complex K-theory. -/
def bottPeriod : ℕ := 2

@[simp] theorem bottPeriod_pos : 0 < bottPeriod := by unfold bottPeriod; decide

/-- The Bott period is positive (Atiyah-Bott 1964). -/
theorem bottPeriod_eq_two : bottPeriod = 2 := rfl

/-- **K-theory shift carrier** (Atiyah-Bott 1964). -/
structure KShift where
  shift : ℤ

@[simp] theorem KShift.shift_zero : (⟨0⟩ : KShift).shift = 0 := rfl

end MathlibExpansion.Topology.KTheory.BottPeriodicity
