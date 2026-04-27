import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 EECC — Excellent Equal-Characteristic Cohomology (SGA 4 Exp. XIX, breach_candidate, B8)

    **Classification.** `breach_candidate` — separate frontier extending the earlier
    corridor from noetherian-smooth to excellent equal-characteristic schemes; not a
    corollary wrapper on FACD.
    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. XIX (Artin, *Cohomologie des schémas
    excellents d'égale caractéristique*), §XIX.3 (excellent equal-characteristic base
    → constructibility + finiteness upgrades hold); §XIX.5 (pullback/base-change
    stability under morphisms of excellent schemes).
    Historical parent: EGA IV §7.8 (excellent rings); Artin's approximation theorem. -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_EECC

/-- **EECC_01** excellent equal-characteristic base scheme: definition + closure
    under finite type morphisms and localization marker (EGA IV.7.8.3 citation anchor,
    SGA 4 XIX.2.1). -/
axiom excellent_equal_characteristic_base_marker : True
/-- **EECC_02** constructibility + finiteness for `Rf_! F` over excellent equal-char
    base, `f` of finite type, `F` constructible torsion prime to residual chars
    marker (SGA 4 XIX.3.1). -/
axiom excellent_proper_pushforward_finiteness_marker : True
/-- **EECC_03** base-change stability: morphism of excellent equal-char schemes
    preserves constructibility + finiteness of `Rf_! F` + `Rf_* F`
    marker (SGA 4 XIX.5.1). -/
axiom excellent_base_change_stability_marker : True

end T20cLate07_EECC
end Grothendieck
end Roots
end MathlibExpansion
