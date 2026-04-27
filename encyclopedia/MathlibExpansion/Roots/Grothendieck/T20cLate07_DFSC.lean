import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 DFSC — Derived Functors and Sheaf Cohomology (SGA 4 Exp. V, substrate_gap)

    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. V (Verdier, *Cohomologie dans les topos*);
    resolutions of abelian sheaves, `Rᵢf_*`, δ-functor axioms, comparison isomorphisms.
    Historical parent: Grothendieck's Tôhoku paper (*Sur quelques points d'algèbre
    homologique*, 1957). -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_DFSC

/-- **DFSC_01** right-derived functor of a left-exact functor between abelian sheaf
    categories (universal δ-functor) marker (SGA 4 V.2). -/
axiom right_derived_functor_universal_marker : True
/-- **DFSC_02** comparison isomorphism between sheaf cohomology computed via injective /
    flabby / Čech resolutions (SGA 4 V.3) marker. -/
axiom sheaf_cohomology_comparison_iso_marker : True
/-- **DFSC_03** small-etale theorem-facing specialization: `Hⁱ(X_ét, F)` agrees with the
    site-level right-derived functor (SGA 4 V.6) marker. -/
axiom small_etale_cohomology_specialization_marker : True

end T20cLate07_DFSC
end Grothendieck
end Roots
end MathlibExpansion
