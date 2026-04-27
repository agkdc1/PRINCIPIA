import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_09 HLMFF — Higher-Level Modular Function Fields (Shimura 1971 §6.1-6.3, substrate_gap, B2-B3)
    **Classification.** substrate_gap — Chapter 6.1-6.3 foundation only: level-N modular function
    field `F_N` and descent over `ℚ(ζ_N)`. Adelic / canonical-model half belongs to `AACM`
    (no duplication into the same Chapter 6 file family).
    **Citation.** Shimura §6.1-6.3 (the field `F_N` of modular functions of level N, descent
    to `ℚ(ζ_N)`); Fricke–Klein II (1897); Hecke *Abhandlungen* §25 (1959). -/
namespace MathlibExpansion
namespace Roots
namespace Shimura
namespace T20cLate09_HLMFF

/-- **HLMFF_01** level-N modular function field `F_N = ℂ(j, j_N)` with `[F_N : F_1] = [SL₂(ℤ/N) :
    ±1]` (Shimura §6.1, Prop 6.1). -/
axiom hlmff_level_n_function_field_definition_marker : True

/-- **HLMFF_02** Galois theory of `F_N / F_1`: `Gal(F_N / F_1) ≃ SL₂(ℤ/N) / {±1}` via action on
    division points of the universal elliptic curve (Shimura §6.2, Thm 6.6). -/
axiom hlmff_galois_theory_sl2_mod_n_marker : True

/-- **HLMFF_03** descent: `F_N` has a model `F_N^{(ℚ)}` over `ℚ(ζ_N)` with `F_N = ℂ · F_N^{(ℚ)}`
    (Shimura §6.3, Thm 6.23). -/
axiom hlmff_descent_to_cyclotomic_field_marker : True

end T20cLate09_HLMFF
end Shimura
end Roots
end MathlibExpansion
