import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 SDFM_CORE — Smooth Differential Forms on Manifolds (Bott–Tu 1982 §I.1-I.2, substrate_gap, B1)
    **Classification.** substrate_gap — root carrier breach: honest manifold forms, wedge, pullback,
    and exterior derivative `d` must replace the local shell (coefficient-only `wedge`, `d := 0`)
    before any Bott–Tu theorem surface is trusted. Quarantines: `DERHAM_SHELL_Q`.
    **Citation.** Bott–Tu, *Differential Forms in Algebraic Topology* (Graduate Texts in
    Mathematics 82, Springer 1982), §I.1-I.2 (vector fields, differential forms, exterior
    derivative); Spivak *Calculus on Manifolds* (1965) §4; Cartan *Les systèmes différentiels
    extérieurs* (1945). -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_SDFM_CORE

/-- **SDFM_01** `Ω^k(M)` sheaf of smooth k-forms on a smooth manifold `M`, with wedge `∧` and
    smooth-function pullback `φ* : Ω^k(N) → Ω^k(M)` for `φ : M → N` smooth (Bott–Tu §I.1). -/
axiom sdfm_smooth_forms_sheaf_wedge_pullback_marker : True

/-- **SDFM_02** exterior derivative `d : Ω^k(M) → Ω^{k+1}(M)` satisfying `d² = 0`, Leibniz rule,
    and naturality `d ∘ φ* = φ* ∘ d` (Bott–Tu §I.1, Prop 1.3; Cartan 1945). -/
axiom sdfm_exterior_derivative_d_squared_zero_naturality_marker : True

/-- **SDFM_03** local coordinate expression `ω = Σ f_I dx^I` on chart domains; smooth-transition
    compatibility gives the global sheaf structure (Bott–Tu §I.1-I.2; Spivak §4). -/
axiom sdfm_local_chart_expansion_compatibility_marker : True

end T20cLate10_SDFM_CORE
end Bott
end Roots
end MathlibExpansion
