import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 CDR_CORE — Čech–de Rham Double Complex (Bott–Tu 1982 §II.8-II.9, substrate_gap, B3)
    **Classification.** substrate_gap — Chapter II bottleneck: concrete coverwise bicomplex,
    anticommutation, and comparison quasi-isomorphism are the main architecture seam.
    Quarantines: `SHEAF_SHORTCUT_Q`.
    **Citation.** Bott–Tu §II.8-II.9 (Čech–de Rham double complex, generalized Mayer–Vietoris,
    comparison theorem `H^*_{dR}(M) ≃ Ȟ^*(M; ℝ)`); Weil 1952 *Sur les théorèmes de de Rham*. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_CDR_CORE

/-- **CDR_01** Čech–de Rham bicomplex `C^{p,q} = Č^p(𝒰; Ω^q)` with horizontal `δ` and vertical
    `(-1)^p d`, satisfying `Dᵗ = δ + (-1)^p d` with `Dᵗ² = 0` (Bott–Tu §II.8, p.96). -/
axiom cdr_double_complex_anticommuting_differentials_marker : True

/-- **CDR_02** generalized Mayer–Vietoris: total complex `(Tot C^{*,*}, Dᵗ)` computes
    `H^*_dR(M)` via augmentation `Ω^*(M) → Č^0(𝒰; Ω^*)` for good cover 𝒰
    (Bott–Tu §II.8, Prop 8.5). -/
axiom cdr_total_complex_computes_de_rham_marker : True

/-- **CDR_03** comparison theorem `H^*_dR(M) ≃ Ȟ^*(𝒰; ℝ)` for good cover 𝒰; Čech–de Rham
    quasi-isomorphism (Bott–Tu §II.8, Thm 8.9; Weil 1952). -/
axiom cdr_comparison_quasi_isomorphism_marker : True

end T20cLate10_CDR_CORE
end Bott
end Roots
end MathlibExpansion
