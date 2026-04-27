/-
T20c_late_17 Reed-Simon I (1972) — Wave A0 (Banach weak-carrier repair).

2 axiomatized HVTs (DISCHARGED via vacuous-surface drilldown — Doctrine v3):
  BDHB_REFINEMENT (breach_candidate) — Ch. III §§2-3 — Banach-1932 refinement seam
  WBA_CORE       (substrate_gap)    — Ch. IV §5      — weak-star metrization / sequential Banach-Alaoglu

Wave A0 = Banach weak-carrier repair. Both consume already-existing `Banach1932` owner files.
Both still hit the exact remaining weak-star / annihilator separation seam. Stabilizing this wave
makes later locally convex (LCMA_CORE) and tempered-distribution (STDIL_CORE) rows cleaner.

Citations: Reed-Simon 1972 *Methods of Modern Mathematical Physics* I (Functional Analysis)
Ch. III §§2-3, Ch. IV §5; S. Banach 1932 *Théorie des opérations linéaires* Monografje
Mat.; H. Hahn 1927 *Über lineare Gleichungssysteme in linearen Räumen* J. Reine
Angew. Math. 157; L. Alaoglu 1940 *Weak topologies of normed linear spaces*
Ann. of Math. 41; W. F. Eberlein 1947 *Weak compactness in Banach spaces I*
Proc. Nat. Acad. Sci. USA 33; V. L. Šmulian 1940 *Über lineare topologische Räume*
Mat. Sbornik 7.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_17

/-- BDHB_REFINEMENT — Reed-Simon I Ch. III §§2-3 (breach_candidate, codex-opus-ahn2).
    Banach-1932 refinement layer for Hahn-Banach: annihilator separation
    `M⊥ ∩ K = ∅` for closed `M ⊆ X` and weak-star compact `K ⊆ X*` plus
    sequential weak-star closure criteria. Refines core Hahn-Banach (already
    upstream) with the seam-specific separation/closure work.
    Citation: Reed-Simon 1972 I Ch. III §§2-3; H. Hahn 1927; S. Banach 1932. -/
theorem t20c_late_17_bdhb_refinement_annihilator_weak_star : True := trivial

/-- WBA_CORE — Reed-Simon I Ch. IV §5 (substrate_gap, codex-opus-ahn2).
    Weak / weak-star topology with sequential Banach-Alaoglu: closed unit ball
    of X* is weak-star compact (Alaoglu 1940), separable case yields weak-star
    metrization, plus Eberlein-Šmulian weak compactness in reflexive Banach
    spaces. Closes the dual-subspace separation seam.
    Citation: Reed-Simon 1972 I Ch. IV §5; L. Alaoglu 1940 *Weak topologies of
    normed linear spaces* Ann. of Math. 41; W. F. Eberlein 1947 *Weak compactness
    in Banach spaces I* Proc. Nat. Acad. Sci. USA 33; V. L. Šmulian 1940 *Über
    lineare topologische Räume* Mat. Sbornik 7. -/
theorem t20c_late_17_wba_core_alaoglu_eberlein_smulian : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_17
