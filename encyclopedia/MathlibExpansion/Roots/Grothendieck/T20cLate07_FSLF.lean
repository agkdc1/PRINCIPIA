import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 FSLF — Fibered Sites and Limit Formalism (SGA 4 Exp. VI, substrate_gap)

    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. VI (Artin, *Conditions de finitude;
    conditions de passage à la limite*); fibered sites, over-site, passage-to-the-limit
    theorem for cohomology over a cofiltered inverse system.
    Historical parent: Grothendieck's functoriality philosophy (EGA IV.8 for base rings). -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_FSLF

/-- **FSLF_01** fibered-site / over-site package (indexing-category + fiber sheaf-category)
    marker (SGA 4 VI.2). -/
axiom fibered_site_over_site_marker : True
/-- **FSLF_02** exactness of transition functors + associated filtered-colimit sheaf
    marker (SGA 4 VI.4). -/
axiom fibered_site_filtered_colimit_marker : True
/-- **FSLF_03** passage-to-the-limit theorem: `Hⁿ(lim X_α, lim F_α) ≃ colim Hⁿ(X_α, F_α)`
    under finiteness (SGA 4 VI.8) marker. -/
axiom passage_to_limit_cohomology_marker : True

end T20cLate07_FSLF
end Grothendieck
end Roots
end MathlibExpansion
