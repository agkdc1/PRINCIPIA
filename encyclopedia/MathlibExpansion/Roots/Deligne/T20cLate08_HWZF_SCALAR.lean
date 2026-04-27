import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_08 HWZF_SCALAR — Hasse–Weil Zeta Trace Formula (scalar specialization) (Deligne 1974 §1, substrate_gap, B2)

    **Classification.** `substrate_gap` — zeta-function packaging of the trace
    formula: `Z(X/𝔽_q, t) = Π (det(1 - Ft | Hⁱ))^{(-1)^{i+1}}` is the scalar
    specialization Deligne uses to phrase rationality + functional equation.
    **Citation.** Deligne, *Weil I*, §1 setup (zeta as alternating product of
    characteristic polynomials of Frobenius); Weil *Numbers of solutions…* (1949);
    Grothendieck *Formule de Lefschetz et rationalité des fonctions L* (1964). -/
namespace MathlibExpansion
namespace Roots
namespace Deligne
namespace T20cLate08_HWZF_SCALAR

/-- **HWZF_01** Hasse–Weil zeta function of `X/𝔽_q` as
    `Z(X/𝔽_q, t) = exp(Σ_{n≥1} # X(𝔽_{q^n}) · tⁿ/n)`, with convergence as a
    formal power series marker (Deligne 1974 §1; Weil 1949). -/
axiom hasse_weil_zeta_definition_marker : True
/-- **HWZF_02** scalar specialization of the trace formula:
    `Z(X/𝔽_q, t) = Π_{i=0}^{2d} det(1 - F·t | Hⁱ_c(X_{\overline{𝔽_q}}, ℚ_ℓ))^{(-1)^{i+1}}`
    marker (Deligne 1974 §1; Grothendieck *Rat. fonct. L* Thm. 1). -/
axiom zeta_as_alternating_charpoly_product_marker : True
/-- **HWZF_03** independence of `ℓ` (for `ℓ ≠ char 𝔽_q`) of the resulting
    rational-function expression `Z(X/𝔽_q, t) ∈ ℚ(t)`
    marker (Deligne 1974 §1 remark; Grothendieck–Artin ℓ-independence for
    smooth proper varieties over finite fields). -/
axiom zeta_independent_of_ell_marker : True

end T20cLate08_HWZF_SCALAR
end Deligne
end Roots
end MathlibExpansion
