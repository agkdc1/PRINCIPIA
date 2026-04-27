import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 EKG_BRIDGE — Equivariant K-Theory K_G(X) (Atiyah 1967 §II.3, breach_candidate, B4a)
    **Classification.** breach_candidate — sibling theory after ordinary `K⁰(X)` (KVB_CORE) and
    `G`-bundles (EVC_CORE) exist. Equivariant projective / Thom tails remain explicitly
    downstream of ordinary CBS_CORE and TIK_CORE — must not co-schedule with them.
    Quarantines: `FINITE_GEOMETRY_GUARD` (no `BG` equivariant classifying-space shorthand
    substituting for equivariant finite Grassmann); `TOPOLOGICAL_K_GUARD` (no representation-ring
    tensor substitute for honest `G`-bundle Grothendieck completion).
    **Citation.** Atiyah, *K-Theory* (1967) §II.3 (EKG_01-EKG_07); Atiyah–Segal, *Equivariant
    K-theory* (Oxford mimeograph, 1968); Segal, *Equivariant K-theory*, Pub. IHES 34 (1968)
    129-151; Atiyah–Segal, *The index of elliptic operators: II*, Ann. Math. 87 (1968) 531-545. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_EKG_BRIDGE

/-- **EKG_01-02** `K_G⁰(X) := Grothendieck group of Vect_G(X)` from EVC_CORE; ring structure
    via `G`-equivariant tensor; contravariant functoriality on `G`-maps `f : X → Y`
    (Atiyah §II.3 Def 2.3.1; Segal 1968 §1). -/
axiom ekg_equivariant_k_grothendieck_ring_functoriality_marker : True

/-- **EKG_03-04** pointwise comparison: for `G` trivial, `K_G⁰(X) = K⁰(X) ⊗ R(G)` where `R(G)`
    is the representation ring; restriction `G' ⊆ G` gives `res : K_G⁰(X) → K_{G'}⁰(X)`;
    induction for finite-index subgroups (Atiyah §II.3 Prop 2.3.2; Segal 1968 Prop 2.2). -/
axiom ekg_representation_ring_restriction_induction_marker : True

/-- **EKG_05-07** equivariant reduced `K̃_G`, relative `K_G⁰(X, A)`, and cofibration long exact
    sequence; equivariant homotopy invariance; isotropy-group localization statement reserved
    for downstream closure (Atiyah §II.3 Thm 2.3.3; Segal 1968 Prop 2.5 + §3 reserve). -/
axiom ekg_reduced_relative_equivariant_cofibration_marker : True

end T20cLate13_EKG_BRIDGE
end Atiyah
end Roots
end MathlibExpansion
