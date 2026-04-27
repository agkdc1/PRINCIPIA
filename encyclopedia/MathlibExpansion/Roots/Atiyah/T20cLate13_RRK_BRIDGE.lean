import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 RRK_BRIDGE — Reduced & Relative K-Theory + Cohomology Axioms (Atiyah 1967 §II.4, breach_candidate, B3)
    **Classification.** breach_candidate — reduced `K̃⁰(X) := ker(K⁰(X) → K⁰(pt))` for pointed
    `(X, x₀)`, relative `K⁰(X, A)` via the mapping cone, suspension isomorphism
    `K̃⁰(ΣX) ≅ K̃⁻¹(X)`, exactness of the cofibration `A ↪ X → X/A` long exact sequence,
    and homotopy invariance. These are concrete Atiyah-facing open owners — no Eilenberg–Steenrod
    abstract substitution allowed.
    Quarantines: `TOPOLOGICAL_K_GUARD` (no spectrum-valued reduced homology shortcut;
    reduced `K̃⁰` must come from bundle-level pointed data).
    **Citation.** Atiyah, *K-Theory* (1967) §II.4 (RRK_01-RRK_05: reduced, relative, suspension,
    exact sequence, homotopy); Atiyah–Hirzebruch, *Vector bundles and homogeneous spaces*,
    Proc. Symp. Pure Math. 3 (1961) 7-38; Puppe, *Homotopiemengen und ihre induzierten
    Abbildungen*, Math. Zeit. 69 (1958) for the cofibre sequence machinery. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_RRK_BRIDGE

/-- **RRK_01-02** reduced K-theory `K̃⁰(X, x₀) := ker(K⁰(X) → K⁰({x₀}))` on a pointed compact
    Hausdorff `(X, x₀)`; canonical splitting `K⁰(X) ≅ K̃⁰(X) ⊕ ℤ` (Atiyah §II.4 Def 2.4.1). -/
axiom rrk_reduced_k_kernel_augmentation_splitting_marker : True

/-- **RRK_03** relative `K⁰(X, A) := K̃⁰(X/A)` for a closed cofibration `A ↪ X`; equivalently
    the mapping-cone-based formulation (Atiyah §II.4 Def 2.4.2; Puppe 1958). -/
axiom rrk_relative_k_via_mapping_cone_marker : True

/-- **RRK_04-05** cofibration long exact sequence `⋯ → K̃⁻¹(A) → K̃⁰(X, A) → K̃⁰(X) → K̃⁰(A)`,
    suspension isomorphism `K̃⁻¹(X) ≅ K̃⁰(ΣX)`, and homotopy invariance at every term
    (Atiyah §II.4 Thm 2.4.3; Atiyah–Hirzebruch 1961 §1). -/
axiom rrk_cofibration_long_exact_suspension_homotopy_marker : True

end T20cLate13_RRK_BRIDGE
end Atiyah
end Roots
end MathlibExpansion
