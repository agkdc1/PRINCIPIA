import MathlibExpansion.Roots.BCDT2001.CompleteLocalOAlg
import MathlibExpansion.Roots.BCDT2001.NumericsConsumer
import MathlibExpansion.Roots.BCDT2001.WildAtThreeBarsottiTate
import MathlibExpansion.Roots.BCDT2001.LanglandsTunnellResidual
import MathlibExpansion.Roots.BCDT2001.ThreeFiveSwitch

/-!
# BCDT 2001 — Bucket 1a: Prelude (import aggregator)

No math. Centralizes the six BCDT bucket imports so downstream consumers
only need `import MathlibExpansion.Roots.BCDT2001.Prelude`.

**Axiom budget check.** This file adds no axioms. After discharge of the two
BCDT-local target axioms, the BCDT 2001 subtree now carries:

1. no net-new BCDT-local axioms in Bucket 2 or Bucket 5,
2. `fittingLengthAPI_ofFiniteLength` — Diamond 1996's definition-land
   numerics constructor (**consumed**, not BCDT-local),
3. `langlandsTunnellResidualModular` — upstream Langlands-Tunnell boundary
   axiom (**consumed**, not BCDT-local).

Total net-new BCDT-local axioms in this subtree: **0**.
-/

namespace MathlibExpansion.Roots.BCDT2001

/-- **Sentinel**: this namespace exists and is reachable. -/
theorem prelude_sentinel : True := trivial

end MathlibExpansion.Roots.BCDT2001
