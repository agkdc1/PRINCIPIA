import MathlibExpansion.Roots.AtiyahMacdonald.FittingLengthBridge

/-!
# Axiom accounting for the Atiyah-Macdonald numerics substrate

This module audits the new theorem-land numerics substrate introduced for the
Diamond 1996 fitting-length breach.

Allowed dependencies are the standard Lean kernel axioms inherited from
Mathlib (`propext`, `Classical.choice`, `Quot.sound`). Any new named axiom
appearing below would be a breach violation.
-/

namespace MathlibExpansion.Roots.AtiyahMacdonald.AxiomsCheck

#print axioms MathlibExpansion.Roots.AtiyahMacdonald.moduleLength
#print axioms MathlibExpansion.Roots.AtiyahMacdonald.fittingIdeal
#print axioms MathlibExpansion.Roots.AtiyahMacdonald.FittingLengthBridge.ofFiniteLength
#print axioms MathlibExpansion.Roots.AtiyahMacdonald.FittingLengthBridge.fittingΦ_le_annΦ
#print axioms MathlibExpansion.Roots.AtiyahMacdonald.FittingLengthBridge.fittingψ_le_annψ

end MathlibExpansion.Roots.AtiyahMacdonald.AxiomsCheck
