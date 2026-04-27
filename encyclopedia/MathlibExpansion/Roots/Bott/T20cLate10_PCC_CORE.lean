import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 PCC_CORE — Presheaf & Čech Cohomology Corridor (Bott–Tu 1982 §II.8-II.10, substrate_gap, B2)
    **Classification.** substrate_gap — presheaves and sheaves are covered upstream, but Bott–Tu
    Čech cohomology, refinement stability, and monodromy owners are still open.
    Quarantines: `SHEAF_SHORTCUT_Q` (sheafification / Čech nerve does NOT discharge theorem).
    **Citation.** Bott–Tu §II.8 (presheaves and Čech cohomology), §II.10 (monodromy, covering
    spaces); Čech 1932 *Théorie générale des variétés à `n` dimensions*; Leray 1950 *L'anneau
    spectral et l'anneau filtré d'homologie d'un espace localement compact*. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_PCC_CORE

/-- **PCC_01** Čech complex `Č^p(𝒰; ℱ) = Π_{i₀<…<iₚ} ℱ(U_{i₀} ∩ … ∩ U_{iₚ})` for presheaf `ℱ`
    on open cover `𝒰`; differential `δ : Č^p → Č^{p+1}` via alternating restriction
    (Bott–Tu §II.8, Def 8.1). -/
axiom pcc_cech_complex_alternating_differential_marker : True

/-- **PCC_02** Čech cohomology `Ȟ^p(𝒰; ℱ)` and refinement stability `Ȟ^*(M; ℱ) = colim_𝒰
    Ȟ^*(𝒰; ℱ)` (Bott–Tu §II.8, Thm 8.9; Leray 1950). -/
axiom pcc_cech_cohomology_refinement_stability_marker : True

/-- **PCC_03** monodromy action of `π₁(M)` on fibres of locally constant sheaf; identifies
    `Ȟ¹(M; ℤ) ≃ Hom(π₁(M), ℤ)` when `M` is connected (Bott–Tu §II.10, Prop 10.2). -/
axiom pcc_monodromy_first_cohomology_marker : True

end T20cLate10_PCC_CORE
end Bott
end Roots
end MathlibExpansion
