import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_09 FGQS — Fuchsian Groups & Quotient Surfaces (Shimura 1971 §1, substrate_gap, B1-B2)
    **Classification.** substrate_gap — honest discrete/cofinite quotient packaging still missing;
    current local quotient/orbifold files are quarantine-only scaffolds (FUCHS_TRUE_Q).
    **Citation.** Shimura, *Introduction to the Arithmetic Theory of Automorphic Functions*, §1
    (Fuchsian groups, quotient surfaces); Poincaré 1882, Klein–Fricke *Vorlesungen über die Theorie
    der automorphen Functionen* I (1897). -/
namespace MathlibExpansion
namespace Roots
namespace Shimura
namespace T20cLate09_FGQS

/-- **FGQS_01** discrete Fuchsian subgroup `Γ ⊂ PSL₂(ℝ)` acts properly discontinuously on ℍ
    (Shimura §1.4). -/
axiom fgqs_discrete_proper_action_marker : True

/-- **FGQS_02** cofinite Fuchsian quotient `ℍ/Γ` carries a (possibly non-compact) Riemann-surface
    structure with finite hyperbolic volume (Shimura §1.5). -/
axiom fgqs_cofinite_quotient_surface_marker : True

/-- **FGQS_03** fundamental domain / signature `(g; m₁,…,m_r; s)` encoding genus + elliptic orders
    + cusp count (Shimura §1.7-1.8; Klein–Fricke I). -/
axiom fgqs_signature_and_fundamental_domain_marker : True

end T20cLate09_FGQS
end Shimura
end Roots
end MathlibExpansion
