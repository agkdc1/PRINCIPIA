import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 ISC_CORE — Integration, Stokes & Compact Support (Bott–Tu 1982 §I.3, substrate_gap, B1)
    **Classification.** substrate_gap — chart-independent integration of compactly supported top
    forms and manifold Stokes are still missing theorem engines.
    **Citation.** Bott–Tu §I.3 (integration on oriented manifolds, Stokes' theorem, compactly
    supported forms); Spivak *Calculus on Manifolds* §5; Stokes 1854 (classical);
    de Rham 1955 Ch. III (manifold Stokes). -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_ISC_CORE

/-- **ISC_01** compactly supported top forms `Ω^n_c(M)` on oriented n-manifold with
    chart-independent integral `∫_M : Ω^n_c(M) → ℝ` via partition of unity (Bott–Tu §I.3, p.27). -/
axiom isc_compactly_supported_integration_marker : True

/-- **ISC_02** manifold Stokes' theorem `∫_M dω = ∫_{∂M} ω` for `ω ∈ Ω^{n-1}_c(M)` on oriented
    manifold with boundary (Bott–Tu §I.3, Thm 3.5; de Rham 1955). -/
axiom isc_manifold_stokes_theorem_marker : True

/-- **ISC_03** compactly supported de Rham complex `Ω^*_c(M)` with integration inducing
    `∫_M : H^n_{dR,c}(M) → ℝ` (Bott–Tu §I.3, Cor 3.6; p.29 for oriented n-manifold). -/
axiom isc_compact_support_cohomology_integration_marker : True

end T20cLate10_ISC_CORE
end Bott
end Roots
end MathlibExpansion
