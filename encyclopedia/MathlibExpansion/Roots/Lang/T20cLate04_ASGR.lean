import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 ASGR_CORE — Artin symbol & global reciprocity (B2 substrate_gap)

**Classification.** `substrate_gap` / `B2`. Promote generic Frobenius →
Artin-symbol + global Artin-map + reciprocity API.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 10.
Historical parent: Artin, "Beweis des allgemeinen Reziprozitätsgesetzes"
(1927); Artin-Tate (1967).
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_ASGR

/-- **ASGR_01** Artin symbol marker. For `L/K` abelian, `𝔭` unramified in `L`,
`(L/K, 𝔭) ∈ Gal(L/K)` is the unique Frobenius element with
`(L/K, 𝔭)(α) ≡ α^{N𝔭} (mod 𝔓)` for any `𝔓 | 𝔭`.
Citation: Lang Ch. 10 §1. -/
axiom artin_symbol_marker : True

/-- **ASGR_03** global Artin map marker. Multiplicative extension
`(·, L/K) : I_K^S → Gal(L/K)` on the group of fractional ideals coprime to
ramification / conductor `S`. Citation: Lang Ch. 10 §2. -/
axiom global_artin_map_marker : True

/-- **ASGR_05** Artin reciprocity marker. For `L/K` finite abelian with
conductor `𝔪`, kernel of the Artin map on `I_K^𝔪 / P_𝔪` is `N_{L/K}(I_L^𝔪)`,
so `I_K^𝔪 / P_𝔪 · N_{L/K}(I_L^𝔪) ≅ Gal(L/K)`.
Citation: Lang Ch. 10 §3, Thm. (Artin reciprocity). -/
axiom artin_reciprocity_marker : True

end T20cLate04_ASGR
end Lang
end Roots
end MathlibExpansion
