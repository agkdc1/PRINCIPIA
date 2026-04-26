import MathlibExpansion.Roots.TaylorWiles1995.PatchingLemma

/-!
# Taylor-Wiles 1995 — `#print axioms` check

Run this file via

    lake build MathlibExpansion.Roots.TaylorWiles1995.AxiomsCheck

to get the axiom dependency list for the terminal `patchingLemma` theorem
dumped to the build log.

**Expected**: no new axioms beyond the Lean kernel base / Mathlib
primitives excluded from the budget.
-/

namespace MathlibExpansion.Roots.TaylorWiles1995

#print axioms patchingLemma
#print axioms patchingLemma_finite
#print axioms patchedModule_isFinite

end MathlibExpansion.Roots.TaylorWiles1995
