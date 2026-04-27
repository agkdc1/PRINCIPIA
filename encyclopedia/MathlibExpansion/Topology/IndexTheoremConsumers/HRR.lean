/-
# Hirzebruch-Riemann-Roch consumer (Hirzebruch 1956 + AS 1963)
B4 for T20c_mid_17_RRAC.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.IndexTheoremConsumers.HRR

/-- **Hirzebruch 1956 + AS 1963, HRR carrier.** -/
structure HRRCarrier where
  euler : ℤ
  toddIntegral : ℤ

end MathlibExpansion.Topology.IndexTheoremConsumers.HRR
