import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 CSH — Constructible Sheaves (SGA 4 Exp. IX, breach_candidate)

    **Classification.** `breach_candidate` (Claude Round 1 correction vs. Codex
    `substrate_gap`). Constructibility is a named finiteness class central to every
    later cohomology theorem; this is original Lean development, not packaging.
    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. IX (Grothendieck, *Faisceaux
    constructibles, cohomologie d'une courbe algébrique*); constructible sheaves as
    the stable class under `f_!`, `f_*`, `⊗`, `Hom`.
    Historical parent: Godement's sheafification abstract, Serre's FAC §10. -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_CSH

/-- **CSH_01** constructible-sheaf definition (locally constant on a finite stratification
    by locally closed subschemes) marker (SGA 4 IX.2.3). -/
axiom constructible_sheaf_definition_marker : True
/-- **CSH_02** stability of constructibility under the six operations `f_*`, `f_!`, `f^*`,
    `f^!`, `⊗`, `RHom` marker (SGA 4 IX.2.7 + IX.4). -/
axiom constructible_sheaf_six_operations_stability_marker : True
/-- **CSH_03** finiteness for cohomology of a curve with constructible coefficients
    (SGA 4 IX.5.1) marker. -/
axiom constructible_cohomology_finiteness_on_curve_marker : True

end T20cLate07_CSH
end Grothendieck
end Roots
end MathlibExpansion
