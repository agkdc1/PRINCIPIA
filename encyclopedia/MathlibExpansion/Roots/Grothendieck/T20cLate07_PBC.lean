import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 PBC — Proper Base Change (SGA 4 Exp. XII–XIII, breach_candidate, B4)

    **Classification.** `breach_candidate` — central theorem wall; consumes SET + CSH
    + DFSC + PTFF all at once. First place where earlier carrier/coefficient choices
    are forced into one theorem package.
    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. XII (Artin, *Théorème de changement
    de base pour un morphisme propre*), §XII.5 (main theorem: for `f : X → S` proper
    and `F` torsion, the base-change morphism `g^* R^q f_* F → R^q f'_* g'^* F` is iso).
    Exp. XIII (*Applications*) dispatches cohomology of curves/surfaces.
    Historical parent: Deligne's rigidification argument (SGA 4½). -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_PBC

/-- **PBC_01** proper base-change theorem for torsion sheaves: `f` proper, `g` arbitrary,
    `F` torsion → `g^* R^q f_* F → R^q f'_* g'^* F` is an isomorphism
    marker (SGA 4 XII.5.1). -/
axiom proper_base_change_torsion_marker : True
/-- **PBC_02** proper base-change for higher direct images commutes with arbitrary base
    change on geometric points (stalkwise statement) marker (SGA 4 XII.5.2). -/
axiom proper_base_change_stalkwise_marker : True
/-- **PBC_03** proper base-change stability under composition + consequences for `f_!`
    (proper-direct-image with compact support agrees with `f_*` on proper maps)
    marker (SGA 4 XIII.1.2). -/
axiom proper_base_change_f_shriek_agreement_marker : True

end T20cLate07_PBC
end Grothendieck
end Roots
end MathlibExpansion
