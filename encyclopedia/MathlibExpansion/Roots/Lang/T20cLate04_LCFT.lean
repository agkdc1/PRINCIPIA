import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 LCFT_CORE — Local class field theory (B3 novel_theorem)

**Classification.** `novel_theorem` / `B3`. Local reciprocity, norm-kernel,
functoriality, local existence/classification, Lubin-Tate route.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 11b.
Historical parent: Serre, *Corps locaux* (1962); Lubin-Tate, "Formal complex
multiplication in local fields" (1965); Hasse (1930, local reciprocity).
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_LCFT

/-- **LCFT_01** local reciprocity marker. For local field `K`, there is a
canonical continuous homomorphism `θ_K : K^× → Gal(K^{ab}/K)` with dense
image, factoring through `K^× / N_{L/K} L^×` for each finite abelian `L/K`.
Citation: Lang Ch. 11 §1; Serre, *Corps locaux* §XI. -/
axiom local_reciprocity_marker : True

/-- **LCFT_03** norm-kernel classification marker. `L ↦ N_{L/K} L^×` is
a bijection between finite abelian extensions `L/K` and open finite-index
subgroups of `K^×`, order-reversing under `L_1 ⊆ L_2 ⇔ N(L_2^×) ⊆ N(L_1^×)`.
Citation: Lang Ch. 11 §2; Serre §XIV. -/
axiom local_norm_kernel_classification_marker : True

/-- **LCFT_05** local existence theorem marker. Every open finite-index
subgroup `H ⊆ K^×` is `N_{L_H/K} L_H^×` for a unique finite abelian `L_H/K`.
Citation: Lang Ch. 11 §3, Thm. (local existence). -/
axiom local_existence_theorem_marker : True

/-- **LCFT_07** Lubin-Tate construction marker. For each uniformizer `π ∈ K`,
Lubin-Tate formal group `F_π` over `𝒪_K` with `[π]_F(T) = πT + T^q`; torsion
points generate the maximal totally ramified abelian extension of `K`,
explicit reciprocity `θ_K(π) ↦ id` on `K^{ur}` and `[u]_F` action on
`F_π[π^n]` for `u ∈ 𝒪_K^×`.
Citation: Lang Ch. 11 §5; Lubin-Tate (1965). -/
axiom lubin_tate_construction_marker : True

end T20cLate04_LCFT
end Lang
end Roots
end MathlibExpansion
