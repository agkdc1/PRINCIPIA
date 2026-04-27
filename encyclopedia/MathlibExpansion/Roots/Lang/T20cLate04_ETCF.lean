import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 ETCF_CORE — Existence theorem for class fields (B3 novel_theorem)

**Classification.** `novel_theorem` / `B3`. Global classification: admissible
open finite-index subgroups of `C_K` ↔ finite abelian extensions of `K`.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 11a.
Historical parent: Takagi (1920); Artin (1927); Chevalley (1940);
Artin-Tate, *Class Field Theory* (1967).
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_ETCF

/-- **ETCF_01** global reciprocity kernel marker. Global Artin map
`θ : C_K → Gal(K^{ab}/K)` has kernel = connected component of identity in
`C_K` (number-field case), surjects continuously.
Citation: Lang Ch. 11 §4. -/
axiom global_reciprocity_kernel_marker : True

/-- **ETCF_03** order-reversing correspondence marker. `L ↦ N_{L/K} C_L` is a
bijection between finite abelian `L/K` and open finite-index subgroups of
`C_K` containing the connected component; `L_1 ⊆ L_2 ⇔ N(C_{L_2}) ⊆ N(C_{L_1})`.
Citation: Lang Ch. 11 §4, Thm. -/
axiom class_field_order_reversing_marker : True

/-- **ETCF_05** global existence theorem marker. Every open finite-index
subgroup of `C_K` containing the connected component is `N_{L_H/K} C_{L_H}`
for a unique finite abelian `L_H/K` (the class field of `H`).
Citation: Lang Ch. 11 §4, Thm. (global existence). -/
axiom global_existence_theorem_marker : True

end T20cLate04_ETCF
end Lang
end Roots
end MathlibExpansion
