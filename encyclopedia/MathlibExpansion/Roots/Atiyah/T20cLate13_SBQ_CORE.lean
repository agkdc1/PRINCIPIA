import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 SBQ_CORE — Subbundle & Quotient Bundle Package (Atiyah 1967 §I.3, substrate_gap, B1)
    **Classification.** substrate_gap — named subbundles, kernel/image packaging, quotient bundles
    `E/F`, and short-exact split lemma are the missing Chapter I carrier package. Without them
    the Serre–Swan algebraization and every later relative-K statement loses type safety.
    Quarantines: `TOPOLOGICAL_K_GUARD` (no spectra-level substitute for bundle-level split).
    **Citation.** Atiyah, *K-Theory* (1967) §I.3 (SBQ_01-SBQ_06: subbundle carrier and quotients);
    Steenrod 1951 §6; Husemoller *Fibre Bundles* (1966) Ch 3 §3-§5. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_SBQ_CORE

/-- **SBQ_01-02** subbundle `F ⊆ E` as a closed-fibre locally trivial carrier; kernel / image of
    a bundle morphism; rank-constancy assumption and its failure surface (Atiyah §I.3 Prop 3.1). -/
axiom sbq_subbundle_kernel_image_rank_constancy_marker : True

/-- **SBQ_03-04** quotient bundle `E/F` with continuous projection, local triviality from the
    subbundle chart, and universal property over the base (Atiyah §I.3 Prop 3.2; Husemoller §3.5). -/
axiom sbq_quotient_bundle_universal_property_marker : True

/-- **SBQ_05-06** short exact sequence `0 → F → E → E/F → 0` splits over compact-Hausdorff
    base with a choice of Hermitian metric (consumes HMAS_01 metric existence); Serre–Swan
    direction of the splitting is recorded but depends on CSVBC_CORE (Atiyah §I.3 Prop 3.3). -/
axiom sbq_short_exact_split_over_compact_base_marker : True

end T20cLate13_SBQ_CORE
end Atiyah
end Roots
end MathlibExpansion
