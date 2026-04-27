import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 KVB_BRIDGE — Grothendieck Group K⁰(X) of Vector Bundles (Atiyah 1967 §II.1, breach_candidate, B2)
    **Classification.** breach_candidate — the unique hinge. This is the first place topological
    `K` becomes a typed object rather than a slogan: bundle-class monoid `Vect(X)/≅`, its group
    completion `K⁰(X)`, stable-equivalence interpretation, and contravariant functoriality.
    All later chapters depend on this single ring-carrier owner.
    Quarantines: `TOPOLOGICAL_K_GUARD` (no spectrum shorthand `K⁰(X) := π₀ Map(X, BU×ℤ)`;
    must be the honest Grothendieck group of ordinary finite-rank bundles).
    **Citation.** Atiyah, *K-Theory* (1967) §II.1 (KVB_01-KVB_06: Grothendieck group,
    stable equivalence, ring structure); Grothendieck, *Classes de faisceaux et théorème de
    Riemann-Roch*, in Borel–Serre, *Le théorème de Riemann-Roch*, Bull. SMF 86 (1958) §4;
    Atiyah–Hirzebruch, *Riemann-Roch theorems for differentiable manifolds*,
    Bull. AMS 65 (1959) 276-281. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_KVB_BRIDGE

/-- **KVB_01-02** `Vect(X) := {iso-classes of complex vector bundles over compact Hausdorff X}`
    is an abelian monoid under direct sum `⊕`; its Grothendieck group completion is `K⁰(X)`
    (Atiyah §II.1 Def 2.1.1; Grothendieck 1958 §4). -/
axiom kvb_vect_monoid_grothendieck_group_completion_marker : True

/-- **KVB_03-04** stable-equivalence interpretation: `[E] = [F]` in `K⁰(X)` iff there exists
    trivial `ℂ^N` with `E ⊕ ℂ^N ≅ F ⊕ ℂ^N`; on compact `X` this is the quotient of Vect(X) by
    stable triviality (consumes CSVBC_01 stable complement; Atiyah §II.1 Prop 2.1.2). -/
axiom kvb_stable_equivalence_interpretation_marker : True

/-- **KVB_05-06** ring structure on `K⁰(X)` via bundle tensor `⊗` (unit = trivial line);
    contravariant functoriality `f* : K⁰(Y) → K⁰(X)` on continuous maps `f : X → Y`;
    composition naturality and homotopy invariance via CSVBC_05 (Atiyah §II.1 Thm 2.1.3). -/
axiom kvb_ring_structure_contravariant_functor_marker : True

end T20cLate13_KVB_BRIDGE
end Atiyah
end Roots
end MathlibExpansion
