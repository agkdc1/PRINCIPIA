/-
# Chern-Symbol Functoriality (Atiyah-Singer III 1968 §3)
B2 for T20c_mid_17_CSF.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.CharacteristicClasses.ChernSymbolFunctoriality

/-- **AS III 1968 §3, Chern character carrier.** -/
structure ChernCarrier where
  rank : ℕ
  chRationalCoeff : ℚ

@[simp] theorem ChernCarrier.zero_rank :
    ({rank := 0, chRationalCoeff := 0} : ChernCarrier).rank = 0 := rfl

end MathlibExpansion.Topology.CharacteristicClasses.ChernSymbolFunctoriality
