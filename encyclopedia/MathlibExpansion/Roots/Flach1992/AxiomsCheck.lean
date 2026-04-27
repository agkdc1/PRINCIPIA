import MathlibExpansion.Roots.Flach1992.WilesBridge

/-!
# Flach1992 — `#print axioms` audit

Run via `lake build MathlibExpansion.Roots.Flach1992.AxiomsCheck`.

## Expected results

* `tatePoitou_selmer_to_dual` — theorem-level at the current length-carrier
  abstraction; no named project axiom dependency remains.
* `flachEulerSystemBound_dual` — listed as an upstream Flach1992 axiom.
* `flachSelmerBound_typed` — depends on `flachEulerSystemBound_dual` only.
* `flachSelmerBound_ad0_from_typed` — depends on the same remaining
  Flach1992 axiom only. `flachSelmerBound_ad0` must NOT appear.
* `toWilesSelmerAdZero`, `toWilesCongruenceLength` — kernel-only.
* `CongruenceModuleData.congruenceIdeal` — kernel-only.
-/

namespace MathlibExpansion.Roots.Flach1992

#print axioms tatePoitou_selmer_to_dual
#print axioms flachEulerSystemBound_dual
#print axioms flachSelmerBound_typed
#print axioms flachSelmerBound_ad0_from_typed
#print axioms toWilesSelmerAdZero
#print axioms toWilesCongruenceLength
#print axioms CongruenceModuleData.congruenceIdeal

end MathlibExpansion.Roots.Flach1992
