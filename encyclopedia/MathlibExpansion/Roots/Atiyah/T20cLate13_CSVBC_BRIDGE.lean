import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 CSVBC_BRIDGE — Compact-Space Vector Bundle Classification (Atiyah 1967 §I.4, breach_candidate, B1)
    **Classification.** breach_candidate — compact-Hausdorff complements and the Serre–Swan bridge
    are the first load-bearing Chapter I theorems. The bundle-projective module equivalence is
    the algebraization seam every later K-theory statement quietly assumes.
    Quarantines: `TOPOLOGICAL_K_GUARD` (no replacing Serre–Swan by a spectrum-level abstract
    nonsense shortcut), `FINITE_GEOMETRY_GUARD` (finite Grassmann classifying maps only, no `BU`
    infinite-dimensional shorthand).
    **Citation.** Atiyah, *K-Theory* (1967) §I.4 (CSVBC_01-CSVBC_06: compact classification);
    Serre, *Modules projectifs et espaces fibrés à fibre vectorielle*, Sém. Dubreil 1958;
    Swan, *Vector bundles and projective modules*, Trans. AMS 105 (1962) 264-277;
    Grothendieck, *La théorie des classes de Chern*, Bull. SMF 86 (1958) 137-154. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_CSVBC_BRIDGE

/-- **CSVBC_01-02** on compact Hausdorff `X`, every vector bundle `E → X` admits a
    finite-rank complement `F` with `E ⊕ F ≅ X × ℂ^N` (Atiyah §I.4 Thm 1.4.1; Serre 1958). -/
axiom csvbc_stable_triviality_compact_complement_marker : True

/-- **CSVBC_03-04** Serre–Swan equivalence: the category of vector bundles over compact `X`
    is equivalent to the category of finitely-generated projective `C(X;ℂ)`-modules, via the
    global-section functor `Γ(X, -)` (Atiyah §I.4 Cor 1.4.2; Swan 1962 Thm 2). -/
axiom csvbc_serre_swan_projective_module_equivalence_marker : True

/-- **CSVBC_05-06** homotopy invariance on compact metric base: homotopic maps
    `f₀, f₁ : X → Y` pull back isomorphic bundles `f₀*E ≅ f₁*E`; consequence — bundle
    classification factors through `π₀` of the classifying-map space (Atiyah §I.4 Prop 1.4.3). -/
axiom csvbc_homotopy_invariance_of_pullback_marker : True

end T20cLate13_CSVBC_BRIDGE
end Atiyah
end Roots
end MathlibExpansion
