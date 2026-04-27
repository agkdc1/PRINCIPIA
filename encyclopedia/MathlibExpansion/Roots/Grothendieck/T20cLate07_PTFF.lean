import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 PTFF — Points of Topoi and Fiber Functors (SGA 4 Exp. IV + VII–VIII, substrate_gap)

    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. IV §§6, Exp. VII–VIII
    (points of topoi, geometric points, small étale stalks).
    Historical parent: Giraud (*Méthode de la descente*, 1964). -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_PTFF

/-- **PTFF_01** abstract "point of a topos" as geometric morphism from Set (SGA 4 IV.6). -/
axiom abstract_point_of_topos_marker : True
/-- **PTFF_02** fiber-functor / conservative-family-of-points (sufficiently-pointed topoi)
    marker (SGA 4 IV.6.5). -/
axiom fiber_functor_conservative_family_marker : True
/-- **PTFF_03** small-etale geometric-point consumer (stalks along geometric points)
    marker (SGA 4 VIII.3). -/
axiom geometric_point_etale_stalk_marker : True

end T20cLate07_PTFF
end Grothendieck
end Roots
end MathlibExpansion
