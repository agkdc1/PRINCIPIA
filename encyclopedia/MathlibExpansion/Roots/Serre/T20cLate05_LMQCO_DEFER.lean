import Mathlib.NumberTheory.ModularForms.Basic

/-!
# T20c_late_05 LMQCO_DEFER — Level-one q-expansion & cusp order (defer)

**Classification.** `defer` / Chapter VII. Covered upstream:
`Mathlib.NumberTheory.ModularForms.{Basic,QExpansion}` provide holomorphic
modular forms, q-expansion via `z ↦ e^{2πi z}`, cusp-order `ord_∞(f)`.
Remaining theorem content is absorbed by `HOM` + `VDF` owners.

**Citation.** Serre, *A Course in Arithmetic*, Ch. VII §2.
Historical parent: Klein, *Vorlesungen über die Theorie der elliptischen
Modulfunktionen* (1890); Hecke (1938).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_LMQCO

/-- **LMQCO_01** citation marker. Level-one holomorphic modular forms of
weight `k`, their q-expansion `f(z) = Σ a_n q^n` with `q = e^{2πi z}`, and
cusp order `ord_∞(f)` upstream. Residual theorem content split into `HOM`
(Hecke) and `VDF` (dimension formula).
Citation: Serre Ch. VII §2.1–§2.3. -/
axiom level_one_q_expansion_cusp_order_marker : True

end T20cLate05_LMQCO
end Serre
end Roots
end MathlibExpansion
