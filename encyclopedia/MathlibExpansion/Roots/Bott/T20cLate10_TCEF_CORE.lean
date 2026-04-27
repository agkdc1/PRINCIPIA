import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 TCEF_CORE — Thom Class & Euler Class via Forms (Bott–Tu 1982 §I.6, §II.11, novel_theorem, B3)
    **Classification.** novel_theorem — Bott–Tu-specific theorem wall: compact-vertical
    normalization, Thom form, and form-theoretic Thom isomorphism are not generic bundle
    wrappers. Quarantines: `CHERN_WEIL_Q` (form reps do NOT replace topological theorem).
    **Citation.** Bott–Tu §I.6 (Thom isomorphism for trivial rank-n bundles), §II.11-12
    (Thom class via forms, Euler class, Euler–Poincaré theorem); Thom 1952 *Espaces fibrés en
    sphères et carrés de Steenrod*; Euler via forms — Bott–Tu §II.12. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_TCEF_CORE

/-- **TCEF_01** compact-vertical de Rham complex `Ω^*_cv(E)` for oriented rank-r vector bundle
    `E → M`, with fibrewise integration `π_* : H^*_{cv}(E) → H^{*-r}_dR(M)` (Bott–Tu §I.6,
    Prop 6.15). -/
axiom tcef_compact_vertical_fibrewise_integration_marker : True

/-- **TCEF_02** Thom class `Φ_E ∈ H^r_{cv}(E)` with `π_* Φ_E = 1` and Thom isomorphism
    `H^*_dR(M) ≃ H^{*+r}_{cv}(E)` via `α ↦ π*α ∧ Φ_E` (Bott–Tu §II.11, Thm 11.2; Thom 1952). -/
axiom tcef_thom_class_and_thom_isomorphism_marker : True

/-- **TCEF_03** Euler class `e(E) = s* Φ_E ∈ H^r_dR(M)` pulled back by zero section `s : M → E`;
    characterizes existence of nonvanishing sections for rank-r bundles (Bott–Tu §II.12,
    Thm 12.5; Euler–Poincaré). -/
axiom tcef_euler_class_zero_section_pullback_marker : True

end T20cLate10_TCEF_CORE
end Bott
end Roots
end MathlibExpansion
