import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 VBO_CORE — Vector Bundle Operations (Atiyah 1967 §I.2, substrate_gap, B1)
    **Classification.** substrate_gap — bundle-level tensor `⊗`, exterior `Λ^k`, and symmetric
    `Sym^k` are the first honest open Chapter I carrier seam: they cannot be simulated by a
    coefficient-only wedge or fibrewise tensor without bundle-compatible transition cocycles.
    Quarantines: `TOPOLOGICAL_K_GUARD` (no spectra-first shorthand for `⊗`).
    **Citation.** Atiyah, *K-Theory* (1967) §I.2 (VBO_01-VBO_07: bundle operations); Atiyah–Hirzebruch,
    *Vector bundles and homogeneous spaces*, Proc. Symp. Pure Math. 3 (1961); Steenrod 1951 §8. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_VBO_CORE

/-- **VBO_01-02** bundle direct sum `E ⊕ F → X`, fibre-over-base dimension additivity, Whitney
    sum transition cocycles, and naturality under pullback (Atiyah §I.2 Prop 2.1). -/
axiom vbo_direct_sum_whitney_cocycle_naturality_marker : True

/-- **VBO_03-04** bundle tensor `E ⊗ F`, exterior power `Λ^k E`, and symmetric power `Sym^k E`;
    each is a functor on the bundle category with rank-multiplicativity and pullback-naturality
    (Atiyah §I.2 Prop 2.3; Atiyah–Hirzebruch 1961 §2). -/
axiom vbo_tensor_exterior_symmetric_functoriality_marker : True

/-- **VBO_05-07** dual bundle `E*`, internal hom `Hom(E,F)`, and universal properties:
    `Hom(E,F) ≃ E* ⊗ F`; trivial-factor cancellation; ranks add under direct sum and multiply
    under tensor (Atiyah §I.2 Prop 2.4; Steenrod 1951 §8). -/
axiom vbo_dual_internal_hom_rank_algebra_marker : True

end T20cLate13_VBO_CORE
end Atiyah
end Roots
end MathlibExpansion
