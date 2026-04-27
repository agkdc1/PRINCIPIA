/-
# Dirac/Spin Index (Atiyah-Singer V 1971)
B4 for T20c_mid_17_DSCB.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.IndexTheoremConsumers.DiracSpin

/-- **AS V 1971, Dirac index carrier.** -/
structure DiracIndex where
  spinDim : ℕ
  index : ℤ

end MathlibExpansion.Topology.IndexTheoremConsumers.DiracSpin
