import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_11 RGOC_BRIDGE — Restricted Gysin & Obstruction Corridor (Milnor–Stasheff 1974 §12, breach_candidate, B4)
    **Classification.** breach_candidate — restricted Thom comparison, restricted Gysin, Euler-
    boundary identification, and the forward theorem `nowhere_zero_section → e(E) = 0`. Should
    not lead before `TPI` and `OBEP` are in place. Quarantines: `TWISTED_HANDWAVE_Q`.
    **Citation.** Milnor–Stasheff §12 (obstruction theorem, Gysin sequence for oriented
    bundles); Gysin 1942 *Zur Homologietheorie der Abbildungen und Faserungen*; Steenrod 1951. -/
namespace MathlibExpansion
namespace Roots
namespace Milnor
namespace T20cLate11_RGOC_BRIDGE

/-- **RGOC_01** restricted Thom comparison: for oriented rank-`n` bundle `E → B` and sphere
    bundle `S(E) ⊆ E_0`, the inclusion induces `H^*(E, E_0; ℤ) ≃ H^*(E, S(E); ℤ)`; Thom class
    factors through sphere-bundle pair (Milnor–Stasheff §12, Lem 12.1; Gysin 1942). -/
axiom rgoc_restricted_thom_comparison_marker : True

/-- **RGOC_02** Gysin long exact sequence for oriented sphere bundle `π : S(E) → B`:
    `… → H^k(B; ℤ) →^{⌣ e(E)} H^{k+n}(B; ℤ) →^{π^*} H^{k+n}(S(E); ℤ) →^{π_*} H^{k+1}(B; ℤ) → …`
    (Milnor–Stasheff §12, Thm 12.2). -/
axiom rgoc_oriented_sphere_bundle_gysin_marker : True

/-- **RGOC_03** obstruction theorem: if oriented rank-`n` bundle `E → B` admits a nowhere-zero
    section, then `e(E) = 0 ∈ H^n(B; ℤ)`; converse holds for `B` a CW complex of dimension ≤ `n`
    (Milnor–Stasheff §12, Thm 12.5; Steenrod 1951). -/
axiom rgoc_nowhere_zero_section_euler_vanishing_marker : True

end T20cLate11_RGOC_BRIDGE
end Milnor
end Roots
end MathlibExpansion
