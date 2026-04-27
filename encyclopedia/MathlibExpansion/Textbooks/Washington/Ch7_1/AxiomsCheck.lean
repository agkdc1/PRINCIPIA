import MathlibExpansion.Textbooks.Washington.Ch7_1.WeierstrassPreparation

/-!
# Axioms inventory for Washington Ch. 7.1 — Weierstrass preparation

This file prints the axiom closure of all exports of
`WeierstrassPreparation.lean`:

* `weierstrassPreparation` — Washington Thm 7.3 (corrected form).
* `weierstrassPreparation_withDegree` — same with explicit `natDegree`.
* `preparation_from_firstUnitIndex` — now a **theorem** (no longer an axiom)
  composed from four narrow sub-axioms.

## Sub-axiom roster (Option B decomposition, 2026-04-22 REPLAN c2)

The single original `preparation_from_firstUnitIndex` axiom is replaced by
four narrow upstream sub-axioms, each strictly closer to the Mathlib kernel:

| axiom                                     | direction | scope |
|-------------------------------------------|-----------|-------|
| `trunc_mul_dist_inductive`                | upstream  | finite-level polynomial approximation (no limits) |
| `successive_approximation_cauchy`         | upstream  | coefficient-wise stability (narrow Cauchy) |
| `adic_limit_exists`                       | upstream  | `IsAdicComplete.lift`-surface instance |
| `limit_is_prepared`                       | upstream  | interchange-of-limit-and-sum on this sequence |

## Expected output

Each main theorem depends on:

1. Standard Lean axioms: `Classical.choice`, `propext`, `Quot.sound`.
2. The four narrow sub-axioms listed above.

No `sorry`.  No `Prop := True` poison.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Washington
namespace Ch7_1
namespace AxiomsCheck

#print axioms weierstrassPreparation
#print axioms weierstrassPreparation_withDegree
#print axioms preparation_from_firstUnitIndex
#print axioms trunc_mul_dist_inductive
#print axioms successive_approximation_cauchy
#print axioms adic_limit_exists
#print axioms limit_is_prepared
#print axioms isUnit_of_coeff_zero_isUnit

end AxiomsCheck
end Ch7_1
end Washington
end Textbooks
end MathlibExpansion
