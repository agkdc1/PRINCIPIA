import MathlibExpansion.Roots.Wiles1995.REqualsT

/-!
# Wiles1995 — `#print axioms` check

Run this file via `lake build MathlibExpansion.Roots.Wiles1995.AxiomsCheck`
to get the axiom dependency list for the terminal `minimal_R_equals_T`
theorem dumped to the build log.

**Expected**: the former Wiles-level axioms are gone. The terminal chain should
now depend on the narrower upstream axioms:
* `Flach1992.flachEulerSystemBound_dual`
* `Wiles1995.numericalCriterion_fittingEq_bridge`
-/

namespace MathlibExpansion.Roots.Wiles1995

#print axioms flachSelmerBound_ad0
#print axioms numericalCriterion_implies_iso
#print axioms minimal_R_equals_T
#print axioms minimal_R_equals_T_matched
#print axioms numericalCriterion_fires_from_flach
#print axioms traceZero_stable_conj

end MathlibExpansion.Roots.Wiles1995
