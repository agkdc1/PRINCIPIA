import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 ICGG_CORE — Idele class group & global quotients (B1 substrate_gap)

**Classification.** `substrate_gap` / `B1`. First hard class-field hinge:
`I_K`, `Kx ↪ I_K`, `C_K := I_K / K^×`, finite-idelic quotient bridge,
compactness of `C_K^1`.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 7 §§4-6.
Historical parent: Chevalley (1940); Cassels-Fröhlich, *Algebraic Number
Theory* (1967); Weil, *Basic Number Theory* (1952).
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_ICGG

/-- **ICGG_01** idele class group carrier marker. `C_K := 𝕀_K / K^×` with
quotient restricted-product topology. Citation: Lang Ch. 7 §4. -/
axiom idele_class_group_carrier_marker : True

/-- **ICGG_03** absolute value & norm-one subgroup marker. `||·|| : C_K → ℝ_{>0}`
global absolute value, kernel `C_K^1` compact. Citation: Lang Ch. 7 §5, Thm. 1. -/
axiom idele_norm_compactness_marker : True

/-- **ICGG_05** ideal class group bridge marker. Surjection
`C_K ↠ Cl_K` inducing `C_K / (connected component · finite-unit part) ≅ Cl_K`.
Citation: Lang Ch. 7 §6. -/
axiom idele_to_ideal_class_bridge_marker : True

end T20cLate04_ICGG
end Lang
end Roots
end MathlibExpansion
