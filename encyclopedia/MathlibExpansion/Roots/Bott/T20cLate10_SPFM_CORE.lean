import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 SPFM_CORE — Splitting Principle & Flag Manifolds (Bott–Tu 1982 §IV.21, substrate_gap, B4)
    **Classification.** substrate_gap — iterated projectivizations / flag manifolds of complex
    vector bundles are needed to reduce general-rank Chern calculus to line bundles.
    **Citation.** Bott–Tu §IV.21 (flag manifolds, splitting principle); Borel 1953 *Sur la
    cohomologie des espaces fibrés principaux*; Bott–Samelson 1958. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_SPFM_CORE

/-- **SPFM_01** flag manifold `Fl(E) → M` of complex rank-`r` bundle `E → M`: iterated
    projectivizations yielding a tower splitting `π^* E ≃ L_1 ⊕ … ⊕ L_r` into line bundles
    (Bott–Tu §IV.21, p.282-284). -/
axiom spfm_flag_manifold_splitting_tower_marker : True

/-- **SPFM_02** Leray–Hirsch for flag bundle: `H^*_dR(Fl(E))` is free `H^*_dR(M)`-module with
    basis the monomials in `c_1(L_i)` — allows injective pullback of identities on Chern roots
    (Bott–Tu §IV.21, Prop 21.16; Borel 1953). -/
axiom spfm_flag_leray_hirsch_free_basis_marker : True

/-- **SPFM_03** universality: any symmetric polynomial identity in Chern roots that holds
    after pullback to `Fl(E)` holds in `H^*_dR(M)` — promotes line-bundle Chern computations
    to rank-`r` bundles (Bott–Tu §IV.21, Cor 21.17; Bott–Samelson 1958). -/
axiom spfm_chern_root_symmetric_pushforward_marker : True

end T20cLate10_SPFM_CORE
end Bott
end Roots
end MathlibExpansion
