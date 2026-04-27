import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_11 TPI_BRIDGE — Thom Pair & Thom Isomorphism (Milnor–Stasheff 1974 §10, breach_candidate, B2)
    **Classification.** breach_candidate — pair-relative Thom owner is the theorem hinge for the
    Euler / Gysin corridor. Must be Thom-first and pair-relative, not quotient-space-slogan-first.
    Quarantines: `SHEAF_SHORTCUT_Q` (sheafification / Čech nerve does NOT discharge the Thom
    theorem), `TWISTED_HANDWAVE_Q`.
    **Citation.** Milnor–Stasheff §10 (Thom isomorphism, Thom class, oriented bundles);
    Thom 1952 *Espaces fibrés en sphères et carrés de Steenrod*; Bott–Tu 1982 §II.11-12. -/
namespace MathlibExpansion
namespace Roots
namespace Milnor
namespace T20cLate11_TPI_BRIDGE

/-- **TPI_01** Thom pair `(E, E_0)` of oriented rank-`n` real bundle `E → B`, where `E_0` is the
    open subbundle of nonzero vectors; relative cohomology `H^*(E, E_0; ℤ)` typed as the pair
    invariant (Milnor–Stasheff §10, p.97-98; Thom 1952). -/
axiom tpi_thom_pair_relative_cohomology_marker : True

/-- **TPI_02** Thom class `u_E ∈ H^n(E, E_0; ℤ)` normalized by fibrewise restriction
    `u_E|_{(E_b, E_b \ 0)} = generator` matching the chosen orientation of `E_b`
    (Milnor–Stasheff §10, Thm 10.4; Thom 1952). -/
axiom tpi_thom_class_fibrewise_normalization_marker : True

/-- **TPI_03** Thom isomorphism `Φ : H^k(B; ℤ) → H^{k+n}(E, E_0; ℤ)` via
    `Φ(α) = π^* α ⌣ u_E`; bijective for all `k ≥ 0` (Milnor–Stasheff §10, Thm 10.4;
    Bott–Tu 1982 §II.11, Thm 11.2). -/
axiom tpi_thom_isomorphism_cup_with_thom_class_marker : True

end T20cLate11_TPI_BRIDGE
end Milnor
end Roots
end MathlibExpansion
