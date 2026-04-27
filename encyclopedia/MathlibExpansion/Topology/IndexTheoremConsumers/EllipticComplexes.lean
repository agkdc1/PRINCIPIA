/-
# Elliptic Complexes (Atiyah-Singer IV 1971 §3)
B4 for T20c_mid_17_ECG.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.IndexTheoremConsumers.EllipticComplexes

/-- **AS IV 1971 §3, Elliptic complex carrier.** -/
structure EllipticComplex where
  length : ℕ
  eulerChar : ℤ

end MathlibExpansion.Topology.IndexTheoremConsumers.EllipticComplexes
