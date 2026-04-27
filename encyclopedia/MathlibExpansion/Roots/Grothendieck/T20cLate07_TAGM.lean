import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 TAGM — Topos and Geometric Morphism Package (SGA 4 Exp. IV, substrate_gap)

    **Classification.** `substrate_gap` — upstream has sheaf categories, no bundled
    `Topos` / `GeometricMorphism` / subtopos package.
    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. IV (Verdier, *Topos*),
    §§IV.1–10 (elementary topos, geometric morphisms, subtopoi, localization).
    Historical parent: Lawvere–Tierney (1969, elementary topos axioms). -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_TAGM

/-- **TAGM_01** bundled elementary-topos marker (SGA 4 IV.1). -/
axiom elementary_topos_package_marker : True
/-- **TAGM_02** geometric-morphism (direct/inverse image + left adjoint exactness) marker
    (SGA 4 IV.3). -/
axiom geometric_morphism_adjoint_pair_marker : True
/-- **TAGM_03** subtopos / Lawvere–Tierney topology / localization marker (SGA 4 IV.9). -/
axiom subtopos_lawvere_tierney_marker : True

end T20cLate07_TAGM
end Grothendieck
end Roots
end MathlibExpansion
