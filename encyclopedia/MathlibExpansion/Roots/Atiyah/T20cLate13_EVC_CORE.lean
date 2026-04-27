import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 EVC_CORE — Equivariant Vector Bundle Carrier (Atiyah 1967 §I.6, substrate_gap, B1)
    **Classification.** substrate_gap — no honest equivariant bundle carrier exists in the
    sibling library; ordinary bundles and group actions still live separately. A compact-Lie-group
    `G` action on `E` covering a `G`-action on `X`, `G`-linear fibre maps, and `G`-equivariant
    Hermitian metrics must all land as first-class data before `K_G(X)` can be typed.
    Quarantines: `TOPOLOGICAL_K_GUARD` (no representation-ring shorthand substituting for honest
    `G`-bundle carrier), `FINITE_GEOMETRY_GUARD` (equivariant Grassmann carrier, not `BG`).
    **Citation.** Atiyah, *K-Theory* (1967) §I.6 (EVC_01-EVC_06: equivariant carrier, `G`-morphism,
    equivariant direct sum); Atiyah–Segal, *Equivariant K-theory*, mimeographed (Oxford 1968);
    Segal, *Equivariant K-theory*, Pub. IHES 34 (1968) 129-151. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_EVC_CORE

/-- **EVC_01-02** compact Lie group `G`, continuous `G`-action on base `X`, and a `G`-equivariant
    vector bundle `E → X`: `G` acts on the total space covering the base action, linearly on
    each fibre (Atiyah §I.6 Def 6.1; Segal 1968 Def 1.1). -/
axiom evc_g_bundle_carrier_fibrewise_linear_marker : True

/-- **EVC_03-04** `G`-bundle morphisms, `G`-equivariant direct sum, tensor, and dual; the
    category `Vect_G(X)` of `G`-equivariant bundles is symmetric monoidal
    (Atiyah §I.6 Prop 6.2; Segal 1968 Prop 1.2). -/
axiom evc_g_morphism_monoidal_structure_marker : True

/-- **EVC_05-06** `G`-equivariant Hermitian metric (averaged via Haar integration over `G`);
    orthogonal complement is a `G`-subbundle; homotopy invariance through `G`-equivariant
    homotopies (Atiyah §I.6 Prop 6.3; Segal 1968 Prop 1.3). -/
axiom evc_equivariant_metric_homotopy_invariance_marker : True

end T20cLate13_EVC_CORE
end Atiyah
end Roots
end MathlibExpansion
