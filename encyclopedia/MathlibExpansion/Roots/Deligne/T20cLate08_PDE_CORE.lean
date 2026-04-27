import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_08 PDE_CORE — Poincaré Duality Étale (Deligne 1974 §2, substrate_gap, B2)

    **Classification.** `substrate_gap` — scheme-side Tate twists, trace/orientation,
    compact-support pairing; Deligne's `§2` consumes these as the Frobenius-reflection
    input for the sign-and-weight argument of §§6–7.
    **Citation.** Deligne, *Weil I*, §2 (Poincaré duality for smooth proper `X/𝔽_q`:
    `Hⁱ(X, ℚ_ℓ) × H^{2d-i}(X, ℚ_ℓ(d)) → ℚ_ℓ` perfect, Frobenius-equivariant with
    Tate-twist shift); SGA 4 XVIII (Deligne, *La formule de dualité globale*);
    SGA 4½ *Cohomologie étale* Ch. *Dualité*. -/
namespace MathlibExpansion
namespace Roots
namespace Deligne
namespace T20cLate08_PDE_CORE

/-- **PDE_01** Tate twist `ℚ_ℓ(n)` on the étale site of `𝔽_q`-scheme + Frobenius
    acts as `qⁿ`-scaled twist marker (Deligne 1974 §2; SGA 4½ *Tate twists*). -/
axiom tate_twist_l_adic_definition_marker : True
/-- **PDE_02** Poincaré duality for smooth proper `X/𝔽_q` of dim `d`:
    `Hⁱ(X_{\overline{𝔽_q}}, ℚ_ℓ) × H^{2d-i}(X_{\overline{𝔽_q}}, ℚ_ℓ(d)) → ℚ_ℓ` perfect,
    Frobenius-equivariant with twist shift
    marker (Deligne 1974 §2; SGA 4 XVIII.3.2, SGA 4½ *Dualité*). -/
axiom etale_poincare_duality_smooth_proper_marker : True
/-- **PDE_03** Frobenius-reflection corollary: if `α` is Frobenius eigenvalue on
    `Hⁱ`, then `qᵈ/α` is eigenvalue on `H^{2d-i}` (with twist accounting)
    marker (Deligne 1974 §2 corollary; Deligne §7 uses this as the
    complex-conjugate-symmetry substitute). -/
axiom frobenius_eigenvalue_reflection_marker : True

end T20cLate08_PDE_CORE
end Deligne
end Roots
end MathlibExpansion
