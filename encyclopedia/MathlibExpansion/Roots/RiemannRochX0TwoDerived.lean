import MathlibExpansion.Roots.RiemannHurwitzX0TwoAxiom
import MathlibExpansion.Roots.ValenceFormula

set_option linter.dupNamespace false

/-!
# Riemann-Roch derived results for X₀(2) — W7 R4

**W7 R4 Analytic Riemann-Roch (Γ₀(2)-scoped) breach plan.**

This file derives `Module.finrank ℂ (CuspForm (Γ₀(2)) 2) = 0` from the
reconstructed W7 R4 boundary witness in `RiemannHurwitzX0TwoAxiom.lean`.
All theorems here are sorry-free.

## Boundary inventory (this derivation chain)

| Witness | File | Role |
|--------|------|------|
| `riemannHurwitz_X0Two_analytic` | RiemannHurwitzX0TwoAxiom | Bundled genus-0 boundary witness |
| `riemannHurwitz_X0Two_genus`    | RiemannHurwitzX0TwoAxiom | Extracted genus field equals `0` |

## Comparison with the Valence route

The Valence route (`ValenceFormula.lean`) derives the same result from:

| Axiom | File | Justification |
|-------|------|---------------|
| `valenceFormula_SL2Z` | ValenceFormula (top-level) | Weight-k valence formula for SL₂(ℤ) |

After the rewrite the W7 R4 boundary witness is no longer an independent axiom
source: it is reconstructed from the valence route while preserving the public
theorem statements that downstream files consume.

## Proof sketch

1. `riemannHurwitz_X0Two_analytic.rrBridge`:
   `dim S₂(Γ₀(2)) = genus(X₀(2))` — from the reconstructed boundary witness.
2. `riemannHurwitz_X0Two_genus`:
   `genus(X₀(2)) = 0` — by evaluation of that witness.
3. Rewrite: `dim S₂(Γ₀(2)) = 0`. QED.
-/

open scoped ModularForm

namespace MathlibExpansion
namespace Roots
namespace RiemannRochX0TwoDerived

open MathlibExpansion.Roots.ModularCurveX0TwoAnalytic
open MathlibExpansion.Roots.RiemannHurwitzX0TwoAxiom

noncomputable section

/-! ### Main W7 R4 theorem -/

/-- **W7 R4 Main Theorem**: `dim S₂(Γ₀(2)) = 0` via Riemann-Hurwitz + Riemann-Roch.

Proof chain (sorry-free):
- `riemannHurwitz_X0Two_analytic.rrBridge`: dim S₂(Γ₀(2)) = genus(X₀(2))
- `riemannHurwitz_X0Two_genus`: genus(X₀(2)) = 0

This is a byte-compatible derivation layer over the same result proved in
`ValenceFormula.finrank_zero_from_valence` via the weight-k valence formula.

Classical sources: Diamond–Shurman §3.1 (genus), §3.3 (holomorphic
differentials), §3.5 (Eichler-Shimura); Forster ch. 16–17 (Riemann-Roch). -/
theorem dim_S2_Gamma0_two_eq_zero_rr_analytic :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 := by
  rw [riemannHurwitz_X0Two_analytic.rrBridge, riemannHurwitz_X0Two_genus]

/-! ### Downstream corollaries -/

/-- The Riemann-Roch cast: `(dim S₂(Γ₀(2)) : ℚ) = genus(X₀(2))`. -/
theorem rr_cast_eq_genus :
    (Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ) =
      (riemannHurwitz_X0Two_analytic.genus : ℚ) := by
  exact_mod_cast riemannHurwitz_X0Two_analytic.rrBridge

/-- The genus extracted via `X0TwoAnalyticGenus` is consistent with the
Riemann-Roch formula giving dim S₂ = 0. -/
theorem analyticGenus_rr_consistent :
    X0TwoAnalyticGenus riemannHurwitz_X0Two_analytic = 0 ∧
      Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  ⟨riemannHurwitz_X0Two_genus, dim_S2_Gamma0_two_eq_zero_rr_analytic⟩

/-- The W7 R4 Riemann-Roch result and the W3′ Valence result are propositionally
equal proofs of the same statement (proof irrelevance on `Prop`). -/
theorem rr_analytic_valence_agree :
    dim_S2_Gamma0_two_eq_zero_rr_analytic =
      MathlibExpansion.Roots.ValenceFormula.finrank_zero_from_valence :=
  Subsingleton.elim _ _

/-! ### Verification -/

#check @dim_S2_Gamma0_two_eq_zero_rr_analytic
#check @rr_cast_eq_genus
#check @analyticGenus_rr_consistent
#check @rr_analytic_valence_agree

end
end RiemannRochX0TwoDerived
end Roots
end MathlibExpansion
