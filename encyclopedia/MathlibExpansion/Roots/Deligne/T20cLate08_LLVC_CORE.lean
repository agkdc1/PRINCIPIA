import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_08 LLVC_CORE — Lefschetz Local Invariant/Vanishing-Cycle Machinery (Deligne 1974 §4, substrate_gap, B2)

    **Classification.** `substrate_gap` — the local Lefschetz cycle / vanishing-cycle
    construction (global and local monodromy of a Lefschetz pencil, Picard–Lefschetz
    formula) is cited in Section 4 as the geometric carrier for the §5 pencil argument.
    **Citation.** Deligne, *Weil I*, §4 (local Lefschetz package: vanishing cycles,
    local monodromy, Picard–Lefschetz formula over finite fields); SGA 7 Exp. XIII–XV
    (Deligne–Katz *Groupes de monodromie en géométrie algébrique*); Katz–Laumon
    *Transformation de Fourier et majoration de sommes exponentielles* (1985). -/
namespace MathlibExpansion
namespace Roots
namespace Deligne
namespace T20cLate08_LLVC_CORE

/-- **LLVC_01** vanishing-cycles complex `Rψ F` / `Rϕ F` attached to
    `f : X → S` with `S` smooth curve and `F` constructible `ℚ_ℓ`-sheaf on `X`
    marker (Deligne 1974 §4.1; SGA 7 XIII). -/
axiom vanishing_cycles_complex_definition_marker : True
/-- **LLVC_02** Picard–Lefschetz formula: for a Lefschetz pencil, local monodromy
    around a critical value acts on the vanishing cycle class by the
    Picard–Lefschetz transvection marker (Deligne 1974 §4.2; SGA 7 XV). -/
axiom picard_lefschetz_formula_marker : True
/-- **LLVC_03** local-monodromy rigidity: at each critical fibre the local
    monodromy is quasi-unipotent and Frobenius-compatible via the
    Picard–Lefschetz vanishing class marker (Deligne 1974 §4.3). -/
axiom local_monodromy_rigidity_marker : True

end T20cLate08_LLVC_CORE
end Deligne
end Roots
end MathlibExpansion
