import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 AIBO_CORE — Adeles & ideles basic objects (B0 substrate_gap)

**Classification.** `substrate_gap` / `B0`. Multiplicative ideles, principal
ideles, correct restricted-product topology missing; additive adeles exist
upstream.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 7 §§1-3.
Historical parent: Weil, *Basic Number Theory* (1952); Chevalley (1940).

**Poison guardrail.** `IDELE_TOPOLOGY_Q`: idele topology is **not** the
subspace topology from adeles. Restricted-product topology only.
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_AIBO

/-- **AIBO_01** idele group carrier marker. `𝕀_K := ∏'_{v} K_v^×` restricted
product with respect to local units `𝒪_v^×` at each finite place `v`.
Citation: Lang Ch. 7 §2. -/
axiom idele_group_carrier_marker : True

/-- **AIBO_03** principal idele embedding marker. Diagonal `K^× ↪ 𝕀_K`,
`x ↦ (x)_v`, is a discrete subgroup with closed image.
Citation: Lang Ch. 7 §3, Prop. 1. -/
axiom principal_idele_embedding_marker : True

/-- **AIBO_05** restricted-product topology marker. The idele topology has
basic opens `∏_{v ∈ S} U_v × ∏_{v ∉ S} 𝒪_v^×` (finite `S`), strictly finer
than subspace topology from 𝔸_K. Citation: Lang Ch. 7 §2; Weil (1952) §IV.1. -/
axiom restricted_product_topology_marker : True

end T20cLate04_AIBO
end Lang
end Roots
end MathlibExpansion
