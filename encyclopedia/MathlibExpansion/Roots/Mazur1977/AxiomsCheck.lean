import MathlibExpansion.Roots.Mazur1977.PrimeLevelHecke
import MathlibExpansion.Roots.Mazur1977.EisensteinIdeal
import MathlibExpansion.Roots.Mazur1977.LocalizedHecke
import MathlibExpansion.Roots.Mazur1977.MultiplicityOne
import MathlibExpansion.Roots.Mazur1977.ResidualAttachment

/-!
# Axiom accounting for the Mazur1977 breach subtree.

Run `#print axioms` on every named theorem / axiom introduced by the
Mazur1977 breach to verify the axiom budget (≤ 2 named Mazur axioms
+ Lean kernel axioms only).

Doctrine v2: every kernel axiom listed here must be either
(1) `propext`, `Classical.choice`, `Quot.sound` — the standard Lean kernel
    axioms inherited from Mathlib, or
(2) `mazurGorenstein163` / `residualGaloisAttachment` — the two
    explicitly budgeted Mazur 1977 axioms.

Any other named axiom is a breach violation.
-/

namespace MathlibExpansion.Roots.Mazur1977.AxiomsCheck

open Matrix

#print axioms PrimeLevelHeckeCarrier.generator_commute
#print axioms PrimeLevelHeckeCarrier.generator_toEnd_commute
#print axioms EisensteinIdeal
#print axioms IsEisenstein
#print axioms IsNonEisenstein
#print axioms generator_sub_qplus1_mem_eisensteinIdeal
#print axioms mazurGorenstein163
#print axioms residualGaloisAttachment

end MathlibExpansion.Roots.Mazur1977.AxiomsCheck
