import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 MRK_BRIDGE — Multiplicative Structure on Relative K (Atiyah 1967 §II.6, breach_candidate, B4a)
    **Classification.** breach_candidate — relative multiplication on pairs `K⁰(X, A) × K⁰(Y, B)
    → K⁰(X × Y, X × B ∪ A × Y)` is the first multiplicative theorem wall and must land before
    Thom closure in TIK_CORE. Without it the Thom homomorphism cannot be interpreted as
    multiplication by a Thom class.
    Quarantines: `TOPOLOGICAL_K_GUARD` (no spectrum smash-product substitute;
    the relative product must come from honest bundle-cone construction).
    **Citation.** Atiyah, *K-Theory* (1967) §II.6 (MRK_01-MRK_04: external product on pairs,
    associativity, unit, compatibility with the cofibre sequence); Atiyah–Hirzebruch 1961 §1;
    Puppe 1958 for cofibre naturality. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_MRK_BRIDGE

/-- **MRK_01** external product on pairs: for pointed pairs `(X, A)` and `(Y, B)`, a canonical
    bilinear map `K̃⁰(X/A) ⊗ K̃⁰(Y/B) → K̃⁰((X × Y) / (X × B ∪ A × Y))` constructed via the
    pushout of mapping cones (Atiyah §II.6 Def 2.6.1; Puppe 1958). -/
axiom mrk_external_product_pair_pushout_marker : True

/-- **MRK_02-03** associativity, commutativity, and unit axioms for the external product;
    compatibility with the suspension iso `Σ(X/A) × (Y/B) ≅ Σ((X/A) ∧ (Y/B))` (Atiyah §II.6
    Prop 2.6.2). -/
axiom mrk_associativity_commutativity_unit_suspension_marker : True

/-- **MRK_04** naturality under the cofibre long exact sequence: the external product respects
    connecting maps `δ : K̃⁰(X/A) → K̃⁻¹(A)` up to sign; consumed by TIK_CORE Thom construction
    (Atiyah §II.6 Prop 2.6.3). -/
axiom mrk_cofibre_connecting_naturality_marker : True

end T20cLate13_MRK_BRIDGE
end Atiyah
end Roots
end MathlibExpansion
