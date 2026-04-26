import MathlibExpansion.Roots.BCDT2001.Prelude

/-!
# Axiom accounting for the BCDT 2001 Opus Delta breach

Runs `#print axioms` on every named theorem / axiom introduced by the
BCDT 2001 breach to verify the axiom budget lock.

**Doctrine v2 budget.** Kernel axioms listed must be either

1. `propext`, `Classical.choice`, `Quot.sound` — standard Lean kernel
   axioms inherited from Mathlib, or
2. Reclaimed external dependencies (consumed from other breaches, NOT
   added here):
   - `fittingLengthAPI_ofFiniteLength` — Diamond 1996's definition-land
     numerics constructor, audited here to stay axiom-free.
   - `langlandsTunnellResidualModular` — upstream Langlands-Tunnell
     boundary axiom, consumed by the BCDT discharge wrapper.
   - `schlessinger_prorepresentable_over_residue` — Mazur 1989
     substrate, inherited transitively (not newly spent here).

Any kernel axiom outside this approved list is a breach violation.
-/

namespace MathlibExpansion.Roots.BCDT2001.AxiomsCheck

/-! ## Discharged target declarations -/

#print axioms MathlibExpansion.Roots.BCDT2001.bcdt_wildAtThree_boundary_exists
#print axioms MathlibExpansion.Roots.BCDT2001.bcdt_langlandsTunnell_mod3_modularity

/-! ## Consumed Diamond 1996 surface (not net-new here) -/

#print axioms MathlibExpansion.Roots.BCDT2001.numericsAPI_ofFiniteLength
#print axioms MathlibExpansion.Roots.BCDT2001.numericalCriterion_forcesBijection
#print axioms MathlibExpansion.Roots.BCDT2001.numericalCriterion_surjective
#print axioms MathlibExpansion.Roots.BCDT2001.numericalCriterion_injective

/-! ## Wild-at-3 consumer-facing projections -/

#print axioms MathlibExpansion.Roots.BCDT2001.wildAtThree_boundary_of_data

/-! ## Langlands-Tunnell consumer-facing projections -/

#print axioms MathlibExpansion.Roots.BCDT2001.langlandsTunnell_of_solvable
#print axioms MathlibExpansion.Roots.BCDT2001.langlandsTunnell_modularity

/-! ## 3/5 switch integration theorems (Bucket 6 terminal) -/

#print axioms MathlibExpansion.Roots.BCDT2001.threeFiveSwitch_fires
#print axioms MathlibExpansion.Roots.BCDT2001.threeFiveSwitch_fires_byCase
#print axioms MathlibExpansion.Roots.BCDT2001.bcdt_modularity_from_switch

/-! ## Prelude sentinel -/

#print axioms MathlibExpansion.Roots.BCDT2001.prelude_sentinel

end MathlibExpansion.Roots.BCDT2001.AxiomsCheck
