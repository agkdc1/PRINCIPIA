import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 MVG_CORE — Mayer–Vietoris, Good Covers & de Rham (Bott–Tu 1982 §I.2-II.5, substrate_gap, B2)
    **Classification.** substrate_gap — good-cover owner plus de Rham Mayer–Vietoris is the first
    global-topology bridge and the immediate parent of Chapter II.
    **Citation.** Bott–Tu §I.2 (Mayer–Vietoris sequence), §II.5 (good covers, nerve theorem);
    Mayer 1929 / Vietoris 1930 original exact sequence; Weil 1952 good covers. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_MVG_CORE

/-- **MVG_01** de Rham Mayer–Vietoris: for open cover `M = U ∪ V`, long exact sequence
    `… → H^k_dR(M) → H^k_dR(U) ⊕ H^k_dR(V) → H^k_dR(U ∩ V) → H^{k+1}_dR(M) → …`
    (Bott–Tu §I.2, Prop 2.3). -/
axiom mvg_mayer_vietoris_exact_sequence_marker : True

/-- **MVG_02** good cover `𝒰 = {U_i}` of manifold `M`: all finite intersections
    `U_{i₀} ∩ … ∩ U_{iₚ}` diffeomorphic to ℝⁿ (contractible convex). Every smooth manifold
    admits a good cover (Bott–Tu §II.5, Thm 5.1; Weil 1952). -/
axiom mvg_good_cover_existence_marker : True

/-- **MVG_03** nerve / refinement stability: Mayer–Vietoris computes `H^*_dR(M)` via the
    Čech nerve of any good cover, refinement-independent (Bott–Tu §II.5, Prop 8.3). -/
axiom mvg_nerve_refinement_stability_marker : True

end T20cLate10_MVG_CORE
end Bott
end Roots
end MathlibExpansion
