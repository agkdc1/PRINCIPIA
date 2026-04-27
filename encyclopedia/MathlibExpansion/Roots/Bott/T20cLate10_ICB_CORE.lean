import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 ICB_CORE — Integer Cohomology Bridge (Bott–Tu 1982 §III.15-16, substrate_gap, B5)
    **Classification.** substrate_gap — promotes real de Rham classes to integer classes via
    singular/Čech with ℤ coefficients; the bridge to topological characteristic classes.
    Quarantines: `LOCAL_COEFF_Q`.
    **Citation.** Bott–Tu §III.15 (singular cohomology, universal coefficients), §III.16
    (integer cohomology of classifying spaces); Eilenberg–Steenrod 1952 *Foundations of
    Algebraic Topology*. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_ICB_CORE

/-- **ICB_01** singular cohomology `H^*(X; ℤ)` as contravariant functor, Eilenberg–Steenrod
    axioms, and comparison with Čech `Ȟ^*(X; ℤ) ≃ H^*(X; ℤ)` for paracompact Hausdorff
    (Bott–Tu §III.15, p.187-190; Eilenberg–Steenrod 1952). -/
axiom icb_singular_cohomology_eilenberg_steenrod_marker : True

/-- **ICB_02** universal coefficient theorem `0 → Ext(H_{n-1}, ℤ) → H^n(X; ℤ) → Hom(H_n, ℤ) → 0`
    and de Rham-to-integer comparison `H^*_dR(M) ⊗ ℝ ≃ H^*(M; ℤ) ⊗ ℝ` for smooth `M`
    (Bott–Tu §III.15, Thm 15.8). -/
axiom icb_universal_coefficient_de_rham_comparison_marker : True

/-- **ICB_03** integer Chern classes `c_i(E) ∈ H^{2i}(M; ℤ)` and compatibility
    `c_i(E) ⊗_ℤ ℝ = [c_i^{dR}(E)]` for complex bundle `E → M`; integer refinement of
    Bott–Tu §IV.20 forms (Bott–Tu §III.16, Prop 16.8). -/
axiom icb_integer_chern_class_refinement_marker : True

end T20cLate10_ICB_CORE
end Bott
end Roots
end MathlibExpansion
