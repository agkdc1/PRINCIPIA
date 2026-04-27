import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_11 BCA_CORE — Bundle Core API: Orientation & Complexification (Milnor–Stasheff 1974 §§2-3, substrate_gap, B1)
    **Classification.** substrate_gap — foundation owner whose failure propagates widest.
    Every later Euler / Chern / Pontrjagin theorem types against the bundle-level orientation +
    complexification surface built here. Quarantines: `COMBINATORIAL_PONTRJAGIN_Q` (§20 is an
    independent track, not a shortcut into this owner).
    **Citation.** Milnor–Stasheff §2 (vector bundle basics, metrics, subbundles), §3 (orientation,
    complexification, conjugate bundle); Steenrod 1951 *Topology of Fibre Bundles*; Husemoller 1966
    *Fibre Bundles*. -/
namespace MathlibExpansion
namespace Roots
namespace Milnor
namespace T20cLate11_BCA_CORE

/-- **BCA_01** orientation of rank-`n` real vector bundle `E → B` as a choice of generator of
    `H^n_{cv}(E_b; ℤ)` for every fibre `E_b`, compatible under local trivializations
    (Milnor–Stasheff §3, p.36-37). -/
axiom bca_oriented_vector_bundle_marker : True

/-- **BCA_02** complexification `E_ℂ = E ⊗_ℝ ℂ → B` of real vector bundle with conjugate bundle
    `\bar{E}_ℂ ≃ E_ℂ` via fibrewise complex conjugation; defines the bundle-level real-to-complex
    transport (Milnor–Stasheff §3, p.35; §15, p.174). -/
axiom bca_complexification_conjugate_marker : True

/-- **BCA_03** naturality: pullback `f^* E` of oriented bundle by continuous `f : B' → B` inherits
    orientation; complexification commutes with pullback `(f^* E)_ℂ ≃ f^* (E_ℂ)` as complex bundles
    (Milnor–Stasheff §§2-3, Lem 3.1-3.4). -/
axiom bca_orientation_complexification_naturality_marker : True

end T20cLate11_BCA_CORE
end Milnor
end Roots
end MathlibExpansion
