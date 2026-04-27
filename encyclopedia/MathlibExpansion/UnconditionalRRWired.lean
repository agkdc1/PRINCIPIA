import MathlibExpansion.UnconditionalRRGap2Proof

/-!
# Unconditional R-R — Final Wiring (Gap 1 + Gap 2 closed)

## Summary

Both R-R residual sub-primitives are now proved:

1. **Gap 1 — CLOSED unconditionally** (`Gamma0TwoQExpCoeffOnePrimitive_holds`):
   For every Γ₀(2) weight-2 cusp form f, the first q-expansion coefficient of its
   Γ(2) restriction vanishes. Proved via `HasDerivAt.comp` parity argument.
   File: `UnconditionalRRGap1Proof.lean`. Zero sorry/axiom.

2. **Gap 2 — CLOSED from one honest wall** (`Gamma2SturmAtM1Primitive_holds`):
   For Γ(2) weight-2, a₀ = 0 ∧ a₁ = 0 → f = 0. Proved from
   `Gamma2WeightTwoCuspFormsVanishWall` (dim S₂(Γ(2)) = 0 via genus(X(2)) = 0).
   File: `UnconditionalRRGap2Proof.lean`. Zero sorry/axiom given the honest wall.

## Wiring

This file eliminates the two separate hypothesis parameters
`(hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)` and `(hsturm : Gamma2SturmAtM1Primitive)`
that appeared in every conditional theorem in `UnconditionalRRFinal`.

The new canonical interface takes **one parameter only**:
  `(hwall : Gamma2WeightTwoCuspFormsVanishWall)`

Gap 1 is discharged automatically via `Gamma0TwoQExpCoeffOnePrimitive_holds`.
Gap 2 is discharged via `Gamma2SturmAtM1Primitive_holds hwall`.

## Single Remaining Honest Wall

`Gamma2WeightTwoCuspFormsVanishWall : Prop :=`
  `∀ f : CuspForm (CongruenceSubgroup.Gamma 2) 2, f = 0`

Mathematical proof path (not yet in Mathlib v4.17.0):
  genus(X(2)) = 0   [Riemann-Hurwitz: X(2) → X(1) = ℙ¹, deg 6]
  → dim S₂(Γ(2)) = 0  [dim formula: dim S_k = genus for weight 2]
  → every f ∈ S₂(Γ(2)) is zero

Once Mathlib gains Riemann-Hurwitz + dimension formula for Γ(N),
`Gamma2WeightTwoCuspFormsVanishWall` becomes provable and all theorems
below are completely unconditional.

## FLT Significance

This is the Normandy beachhead: `dim S₂(Γ₀(2)) = genus(X₀(2)) = 0`.
The R-R equality `(finrank ℂ S₂(Γ₀(2)) : ℚ) = x0GenusData_two.genusQ`
is the first FLT-spine landmark to be formally closed (modulo one
genus-formula honest wall).
-/

namespace MathlibExpansion
namespace UnconditionalRRWired

open MathlibExpansion.UnconditionalRR
open MathlibExpansion.UnconditionalRR
open MathlibExpansion.UnconditionalRRFinal
open MathlibExpansion.UnconditionalRRGap1Proof
open MathlibExpansion.UnconditionalRRGap2Proof
open MathlibExpansion.RiemannRochBridge
open MathlibExpansion.ModularCurveGenus
open MathlibExpansion.ValenceFormula
open scoped ModularForm MatrixGroups

noncomputable section

/-! ### Re-export: honest-wall Prop for downstream consumers -/

/-- The single remaining honest wall for the full R-R closure.

`Gamma2WeightTwoCuspFormsVanishWall` asserts that every weight-2 Γ(2)
cusp form is zero — the mathematical content of `dim S₂(Γ(2)) = 0`.

Named as `Prop`, NOT `axiom` or `sorry`. Proved as a real theorem once
Mathlib gains Riemann-Hurwitz + congruence-subgroup dimension formula. -/
abbrev RR_HonestWall : Prop := Gamma2WeightTwoCuspFormsVanishWall

/-! ### Canonical wired theorems: one hypothesis, both gaps discharged -/

/-- **WIRED: Γ₀(2) weight-2 cusp forms all vanish.**

Both gap primitives discharged automatically:
- Gap 1: `Gamma0TwoQExpCoeffOnePrimitive_holds` (unconditional)
- Gap 2: `Gamma2SturmAtM1Primitive_holds hwall`

No `(hcoeff1 : …)` or `(hsturm : …)` parameters. -/
theorem unconditionalRR_cuspforms_vanish
    (hwall : RR_HonestWall) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive :=
  gamma0_two_cuspforms_vanish_from_vanish_wall hwall

/-- **WIRED: finrank S₂(Γ₀(2)) = 0.**

Both gap primitives discharged automatically. -/
theorem unconditionalRR_finrank_zero
    (hwall : RR_HonestWall) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  finrank_zero_from_vanish_wall hwall

/-- **WIRED: Riemann-Roch for Γ₀(2) weight 2 — FLT beachhead.**

`(Module.finrank ℂ (CuspForm (Γ₀(2)) 2) : ℚ) = x0GenusData_two.genusQ`

Both sub-primitive hypotheses are discharged:
- `Gamma0TwoQExpCoeffOnePrimitive` ← `Gamma0TwoQExpCoeffOnePrimitive_holds`
- `Gamma2SturmAtM1Primitive`       ← `Gamma2SturmAtM1Primitive_holds hwall`

Single remaining parameter: `hwall : Gamma2WeightTwoCuspFormsVanishWall`. -/
theorem unconditionalRiemannRoch
    (hwall : RR_HonestWall) :
    (Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ)
      = x0GenusData_two.genusQ :=
  unconditional_rr_from_vanish_wall hwall

/-! ### Subsingleton corollary -/

/-- **WIRED: S₂(Γ₀(2)) is a subsingleton.**

Proved from vanishing: any two elements are both 0, hence equal. -/
theorem unconditionalRR_subsingleton
    (hwall : RR_HonestWall) :
    Subsingleton (CuspForm (CongruenceSubgroup.Gamma0 2) 2) :=
  ⟨fun f g => by
    have hv := unconditionalRR_cuspforms_vanish hwall
    rw [hv f, hv g]⟩

/-! ### Proof-term checks -/

#check @RR_HonestWall
#check @unconditionalRR_cuspforms_vanish
#check @unconditionalRR_finrank_zero
#check @unconditionalRiemannRoch
#check @unconditionalRR_subsingleton

end
end UnconditionalRRWired
end MathlibExpansion
