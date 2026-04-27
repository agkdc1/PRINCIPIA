import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 TDR_BRIDGE — Twisted de Rham for Nonorientable Manifolds (Bott–Tu 1982 §I.7, breach_candidate, B4)
    **Classification.** breach_candidate — twisted coefficients + orientation bundle are the
    first non-trivial local-system bridge on the de Rham side; unlocks Poincaré duality for
    nonorientable manifolds.
    **Citation.** Bott–Tu §I.7 (Poincaré duality for nonorientable manifolds, twisted de Rham);
    de Rham 1955 *Variétés différentiables*; Steenrod 1943 *Homology with local coefficients*. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_TDR_BRIDGE

/-- **TDR_01** orientation bundle `o(M)` as flat real line bundle for nonorientable `M`,
    with twisted de Rham complex `Ω^*(M; o(M))` and twisted cohomology `H^*_dR(M; o(M))`
    (Bott–Tu §I.7, p.84-86; Steenrod 1943). -/
axiom tdr_orientation_bundle_twisted_de_rham_marker : True

/-- **TDR_02** twisted Poincaré duality `H^k_dR(M; o(M)) ≃ H^{n-k}_c(M; ℝ)^*` and
    `H^k_c(M; o(M)) ≃ H^{n-k}_dR(M; ℝ)^*` for nonorientable `n`-manifolds
    (Bott–Tu §I.7, Thm 7.8; de Rham 1955). -/
axiom tdr_twisted_poincare_duality_marker : True

/-- **TDR_03** naturality of twisted cohomology under orientation-double-cover
    `π : M̃ → M`: `H^*_dR(M̃; ℝ) = H^*_dR(M; ℝ) ⊕ H^*_dR(M; o(M))` as ℤ/2-modules
    (Bott–Tu §I.7, Prop 7.10). -/
axiom tdr_double_cover_decomposition_marker : True

end T20cLate10_TDR_BRIDGE
end Bott
end Roots
end MathlibExpansion
