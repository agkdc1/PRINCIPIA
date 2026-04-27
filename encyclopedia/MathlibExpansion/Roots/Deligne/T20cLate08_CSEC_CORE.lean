import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_08 CSEC_CORE — Constructible Sheaves on Étale Sites over Finite Fields (Deligne 1974 §1, substrate_gap, B1)

    **Classification.** `substrate_gap` — constructible ℚ_ℓ-sheaves on schemes of
    finite type over `𝔽_q` are the coefficient carriers Deligne uses for the
    Grothendieck–Lefschetz trace formula; the constructible class + six-operation
    stability are absent as Deligne-grade owners (only generic `CategoryTheory.Sheaf`).
    **Citation.** Deligne, *Weil I*, §1.2–1.3 (constructible `ℚ_ℓ`-sheaves, stalks at
    `𝔽_q`-points, compatibility with six operations); SGA 4 Exp. IX (Deligne,
    *Faisceaux constructibles*), SGA 4½ *Cohomologie étale* Ch. *Sommes trig.* -/
namespace MathlibExpansion
namespace Roots
namespace Deligne
namespace T20cLate08_CSEC_CORE

/-- **CSEC_01** constructible `ℚ_ℓ`-sheaf on a scheme of finite type over `𝔽_q`:
    definition + stratification criterion + stalk-finiteness
    marker (Deligne 1974 §1.2; SGA 4 IX.2). -/
axiom constructible_l_adic_sheaf_definition_marker : True
/-- **CSEC_02** stalk of a constructible `ℚ_ℓ`-sheaf at an `𝔽_{q^n}`-point as a
    Frobenius-equipped `ℚ_ℓ`-vector space marker (Deligne 1974 §1.3; SGA 4 VII.5). -/
axiom constructible_sheaf_stalk_at_finite_field_point_marker : True
/-- **CSEC_03** six-operation stability for constructible `ℚ_ℓ`-sheaves on
    finite-type `𝔽_q`-schemes (closure under `f^*, Rf_*, Rf_!, f^!, ⊗, RHom`)
    marker (Deligne 1974 §1.3; SGA 4 IX.4–5, SGA 4 XVII). -/
axiom constructible_six_operations_stability_marker : True

end T20cLate08_CSEC_CORE
end Deligne
end Roots
end MathlibExpansion
