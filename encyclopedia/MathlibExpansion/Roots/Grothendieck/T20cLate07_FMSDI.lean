import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 FMSDI — Finite Morphism Supports and Direct Image (SGA 4 Exp. VIII,
    breach_candidate)

    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. VIII (Grothendieck, *Foncteurs fibres,
    supports, étude cohomologique des morphismes finis*); stalks of `f_*` for finite `f`,
    support decomposition, fiber-functor formula. -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_FMSDI

/-- **FMSDI_01** stalk formula for direct image under a finite morphism:
    `(f_* F)_{\bar y} = ⊕_{x ↦ y} F_{\bar x}` (SGA 4 VIII.5.2) marker. -/
axiom finite_direct_image_stalk_formula_marker : True
/-- **FMSDI_02** support decomposition for constructible sheaves over a finite map
    (SGA 4 VIII.2) marker. -/
axiom finite_morphism_support_decomposition_marker : True
/-- **FMSDI_03** exactness of `f_*` on abelian étale sheaves for finite `f` (SGA 4 VIII.5.5)
    marker. -/
axiom finite_direct_image_exactness_marker : True

end T20cLate07_FMSDI
end Grothendieck
end Roots
end MathlibExpansion
