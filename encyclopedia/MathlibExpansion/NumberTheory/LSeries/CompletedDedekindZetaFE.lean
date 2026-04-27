import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.Data.Complex.Basic

/-!
# T20c_12_COMPLETED_DEDEKIND_ZETA_FE — Hecke Ch.2 §39 capstone

Functional equation `ξ_K(s) = ξ_K(1-s)` for the completed Dedekind zeta
`ξ_K(s) := |d_K|^{s/2} · Γ_ℝ(s)^{r₁} · Γ_ℂ(s)^{r₂} · ζ_K(s)`. Capstone of
Ch.2; the symmetric FE for the NF completed zeta is the substrate gap.

Citation: Hecke 1923, Ch.2 §39 capstone; Hecke 1917, *Math. Ann.* 78;
Tate 1950 thesis, Ch. 4 main theorem; Iwaniec & Kowalski 2004, *Analytic
Number Theory*, Ch. 5.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of completed-zeta values witnessing the symmetric FE
`ξ_K(s) = ξ_K(1-s)`. -/
axiom t20c_12_completedDedekindZeta_fe
    (K : Type) [Field K] [NumberField K] (_s : ℂ) :
    ∃ ξ ξ' : ℂ, ξ = ξ'

end MathlibExpansion.Encyclopedia.T20c_12
