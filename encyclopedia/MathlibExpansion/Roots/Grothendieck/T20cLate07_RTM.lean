import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 RTM — Ringed Topoi and Modules (SGA 4 Exp. IV.11–14, substrate_gap)

    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. IV §§11–14 (ringed topoi,
    morphisms of ringed topoi, sheaves of modules, recollement).
    Historical parent: Godement (*Théorie des faisceaux*, 1958). -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_RTM

/-- **RTM_01** bundled ringed-topos object (topos + ring object + module sheaves)
    marker (SGA 4 IV.11). -/
axiom ringed_topos_bundled_marker : True
/-- **RTM_02** morphism-of-ringed-topoi (compatible geometric + ring-map pair)
    marker (SGA 4 IV.13). -/
axiom morphism_of_ringed_topoi_marker : True
/-- **RTM_03** recollement / gluing-of-topoi package marker (SGA 4 IV.9.4, extended in
    SGA 4 IV.14). -/
axiom recollement_gluing_topoi_marker : True

end T20cLate07_RTM
end Grothendieck
end Roots
end MathlibExpansion
