/-
# Gauss-Bonnet / Signature (Atiyah-Singer III 1968 §6)
B4 for T20c_mid_17_GBSC.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.IndexTheoremConsumers.GaussBonnetSignature

/-- **AS III 1968 §6, Gauss-Bonnet/signature carrier.** -/
structure GBSCarrier where
  eulerChar : ℤ
  signature : ℤ

end MathlibExpansion.Topology.IndexTheoremConsumers.GaussBonnetSignature
