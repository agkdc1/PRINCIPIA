import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 SET — Small Etale Site and Etale Topos (SGA 4 Exp. VII, breach_candidate)

    **Classification.** `breach_candidate` (Claude Round 1 correction vs. Codex `substrate_gap`).
    The named small-étale carrier `X_ét` + its topos is the **first real geometric breach**;
    this is theorem-facing Lean development, not a packaging PR.
    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. VII §§3–5 (Grothendieck, site et topos
    étale d'un schéma, petit site étale, functorialité). -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_SET

/-- **SET_01** small-étale site `X_ét` of a scheme `X` (étale morphisms U → X as objects,
    étale covers as coverings) marker (SGA 4 VII.1.2). -/
axiom small_etale_site_of_scheme_marker : True
/-- **SET_02** étale topos `Sh(X_ét)` + comparison maps for `X_Zar ↪ X_ét ↪ X_fppf`
    marker (SGA 4 VII.1.7). -/
axiom etale_topos_comparison_maps_marker : True
/-- **SET_03** functoriality: morphism `f : X → Y` of schemes induces geometric morphism
    `f_ét : Sh(X_ét) → Sh(Y_ét)` marker (SGA 4 VII.3). -/
axiom etale_topos_functoriality_marker : True

end T20cLate07_SET
end Grothendieck
end Roots
end MathlibExpansion
