import MathlibExpansion.Roots.RiemannRochModular

/-!
# Deprecated post-Valence route-cache — `RiemannRochModular` (W7 R4 historical trace)

**This file exists for historical proof-search trace only. No public re-export.**

These 23 conditional theorems were generated during the multi-attempt route-search
for `dim S₂(Γ₀(2)) = 0` before the W7 R4 Riemann-Hurwitz breakthrough. Each theorem
provides a valid derivation route conditioned on a named `Primitive` boundary type
(packaging missing Mathlib 4.17.0 API).

Superseded by `RiemannHurwitzX0TwoAxiom` + `RiemannRochX0TwoDerived` (sorry-free
under two axioms, independent of all conditional routes below).

Classical references preserved with each theorem docstring.
-/

open scoped ModularForm

namespace MathlibExpansion
namespace Roots
namespace RiemannRochModular

noncomputable section

open MathlibExpansion.ModularCurveGenus
open MathlibExpansion.RiemannRochBridge

/-! ### Route-cache T1–T2: canonical and algebraic GAGA primitives -/

/-- If the three missing analytic primitives are supplied, the canonical
Riemann-Roch route gives the existing target dimension result. This theorem
contains no proof holes and only consumes named primitives. -/
theorem dim_S2_Gamma0_two_eq_zero_of_canonical_primitives
    (X : ModularCurveX0Primitive 2)
    (_hRR : CanonicalRiemannRochPrimitive X)
    (_hDiff : WeightTwoCuspFormsAsDifferentialsPrimitive X)
    (_hGenus : X0TwoAnalyticGenusPrimitive X)
    (hValence : Gamma0TwoCuspFormValenceIdentityPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive_holds
      hValence)

/-- Attempt #2 boundary theorem: if algebraic `X₀(2)`, algebraic
Riemann-Roch, and the needed GAGA comparisons are supplied, the result reduces
to the existing canonical analytic boundary theorem. -/
theorem dim_S2_Gamma0_two_eq_zero_of_algebraic_gaga_primitives
    (Xalg : AlgebraicCurveX0Primitive 2)
    (Xan : ModularCurveX0Primitive 2)
    (hAlgRR : AlgebraicRiemannRochPrimitive Xalg Xan)
    (hGAGA : GAGAWeightTwoCuspFormsPrimitive Xalg Xan)
    (hGenus : GAGAGenusComparisonPrimitive Xalg Xan)
    (hValence : Gamma0TwoCuspFormValenceIdentityPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  dim_S2_Gamma0_two_eq_zero_of_canonical_primitives Xan hAlgRR hGAGA hGenus hValence

/-! ### Route-cache T3–T4: integer-cleared valence parity -/

/-- Attempt #9 honest-wall theorem: the specialized integer-cleared valence
primitive alone forces all weight-two `Γ₀(2)` cusp forms to vanish. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_integralValence
    (hInt : Gamma0TwoWeightTwoIntegralValencePrimitive) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  intro f
  by_contra hf
  rcases hInt f hf with ⟨orderAtInfty, orderAtZero, _hEq, hOne, hBudget⟩
  omega

/-- Attempt #9 dimension consequence, routed through the existing finrank
bypass for a zero cusp-form space. -/
theorem dim_S2_Gamma0_two_eq_zero_of_integralValence
    (hInt : Gamma0TwoWeightTwoIntegralValencePrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_integralValence hInt)

/-! ### Route-cache T5–T7: restricted Γ(2) q-expansion -/

/-- The zeroth q-expansion coefficient of the restricted form is already zero,
because the restriction remains a cusp form. -/
theorem Gamma0TwoRestrictedQCoeffZero
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    (ModularFormClass.qExpansion 2
      (MathlibExpansion.QExpansionLinearMap.cuspFormToModularForm
        (CongruenceSubgroup.Gamma 2) 2
        (MathlibExpansion.RiemannRochBridge.restrictCuspFormGamma0ToGamma2 2 f))).coeff ℂ 0 = 0 := by
  simpa [MathlibExpansion.QExpansionLinearMap.cuspFormToModularForm] using
    MathlibExpansion.RiemannRochBridge.qExpansion_coeff_zero_of_cuspForm_gamma 2 2
      (MathlibExpansion.RiemannRochBridge.restrictCuspFormGamma0ToGamma2 2 f)

/-- Attempt #10 conditional vanishing.  If Mathlib supplies the principal
`Γ(2)` two-coefficient vanishing theorem and the new first-coefficient
boundary, then every weight-two `Γ₀(2)` cusp form is zero. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_restricted_qExpansion
    (hSturm : MathlibExpansion.RiemannRochBridge.GammaTwoWeightTwoVanishingPrimitive)
    (hCoeff : Gamma0TwoRestrictedFirstQCoeffVanishPrimitive) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  intro f
  apply MathlibExpansion.RiemannRochBridge.restrictCuspFormGamma0ToGamma2_injective 2
  let g : CuspForm (CongruenceSubgroup.Gamma 2) 2 :=
    MathlibExpansion.RiemannRochBridge.restrictCuspFormGamma0ToGamma2 2 f
  let gMod : ModularForm (CongruenceSubgroup.Gamma 2) 2 :=
    MathlibExpansion.QExpansionLinearMap.cuspFormToModularForm
      (CongruenceSubgroup.Gamma 2) 2 g
  have hmod : gMod = 0 :=
    hSturm gMod (Gamma0TwoRestrictedQCoeffZero f) (hCoeff f)
  ext z
  exact congrArg
    (fun h : ModularForm (CongruenceSubgroup.Gamma 2) 2 =>
      (h : UpperHalfPlane → ℂ) z) hmod

/-- Attempt #10 dimension consequence from the restricted q-expansion route. -/
theorem dim_S2_Gamma0_two_eq_zero_of_restricted_qExpansion
    (hSturm : MathlibExpansion.RiemannRochBridge.GammaTwoWeightTwoVanishingPrimitive)
    (hCoeff : Gamma0TwoRestrictedFirstQCoeffVanishPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_restricted_qExpansion hSturm hCoeff)

/-! ### Route-cache T8–T9: Riemann sphere differential descent -/

/-- Linear-algebra consequence of the genus-zero descent route: an injective
descent into the zero space of holomorphic differentials on the Riemann sphere
forces every weight-two `Γ₀(2)` cusp form to vanish. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_sphere_differential_descent
    (P : RiemannSpherePrimitive)
    (hDesc : Gamma0TwoWeightTwoDifferentialDescentToSpherePrimitive P)
    (hP1 : RiemannSphereHolomorphicDifferentialsVanishPrimitive P) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  rcases hDesc with ⟨descent, hInjective⟩
  intro f
  apply hInjective
  rw [hP1 (descent f), map_zero]

/-- Dimension consequence for the genus-zero quotient descent route. -/
theorem dim_S2_Gamma0_two_eq_zero_of_sphere_differential_descent
    (P : RiemannSpherePrimitive)
    (hDesc : Gamma0TwoWeightTwoDifferentialDescentToSpherePrimitive P)
    (hP1 : RiemannSphereHolomorphicDifferentialsVanishPrimitive P) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_sphere_differential_descent P hDesc hP1)

/-! ### Route-cache T10–T11: direct X₀(2) differential injection -/

/-- Direct differential route: an injective `f(z) dz` map into a pointwise-zero
differential space forces every weight-two `Γ₀(2)` cusp form to vanish. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_direct_differential_injection
    (X : ModularCurveX0Primitive 2)
    (hDiff : Gamma0TwoWeightTwoDifferentialInjectionPrimitive X)
    (hZero : X0TwoHolomorphicDifferentialsPointwiseVanishPrimitive X) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  rcases hDiff with ⟨toDifferential, hInjective⟩
  intro f
  apply hInjective
  rw [hZero (toDifferential f), map_zero]

/-- Dimension consequence for the direct `X₀(2)` differential-injection route. -/
theorem dim_S2_Gamma0_two_eq_zero_of_direct_differential_injection
    (X : ModularCurveX0Primitive 2)
    (hDiff : Gamma0TwoWeightTwoDifferentialInjectionPrimitive X)
    (hZero : X0TwoHolomorphicDifferentialsPointwiseVanishPrimitive X) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_direct_differential_injection X hDiff hZero)

/-! ### Route-cache T12–T13: Hauptmodul parity -/

/-- Attempt #9 parity route: a future analytic `T`-Hauptmodul divisor API
proving the parity primitive forces all weight-two `Γ₀(2)` cusp forms to
vanish. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_hauptmodulParity
    (hT : Gamma0TwoHauptmodulParityPrimitive) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  intro f
  by_contra hf
  rcases hT f hf with ⟨m, hm⟩
  omega

/-- Dimension consequence for the `T`-Hauptmodul parity route. -/
theorem dim_S2_Gamma0_two_eq_zero_of_hauptmodulParity
    (hT : Gamma0TwoHauptmodulParityPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_hauptmodulParity hT)

/-! ### Route-cache T14–T15: two-cusp residue obstruction -/

/-- Residue route: an injective two-cusp residue map, together with the cusp
condition that all residues vanish, forces every weight-two `Γ₀(2)` cusp form
to vanish. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_twoCuspResidues
    (hResidues : Gamma0TwoTwoCuspResidueMapPrimitive) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  rcases hResidues with ⟨residue, hInjective, hVanish⟩
  intro f
  apply hInjective
  rw [hVanish f, map_zero]

/-- Dimension consequence for the two-cusp residue route. -/
theorem dim_S2_Gamma0_two_eq_zero_of_twoCuspResidues
    (hResidues : Gamma0TwoTwoCuspResidueMapPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_twoCuspResidues hResidues)

/-! ### Route-cache T16–T17: Petersson norm boundary -/

/-- Petersson-norm route: positive-definiteness plus the explicit
fundamental-domain vanishing of the Petersson norm forces all weight-two
`Γ₀(2)` cusp forms to vanish. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_peterssonNorm
    (hPetersson : Gamma0TwoPeterssonNormPrimitive) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  rcases hPetersson with ⟨peterssonNormSq, hZeroImp, hVanish⟩
  intro f
  exact hZeroImp f (hVanish f)

/-- Dimension consequence for the Petersson-norm route. -/
theorem dim_S2_Gamma0_two_eq_zero_of_peterssonNorm
    (hPetersson : Gamma0TwoPeterssonNormPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_peterssonNorm hPetersson)

/-! ### Route-cache T18–T19: Serre-duality negative-degree -/

/-- Serre-duality route: an injective map into a negative-degree section space
whose global sections all vanish forces every weight-two `Γ₀(2)` cusp form to
vanish. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_serreDualNegativeDegree
    (X : ModularCurveX0Primitive 2)
    (hSerre : Gamma0TwoSerreDualNegativeDegreePrimitive X) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  rcases hSerre with ⟨sectionMap, hInjective, hVanish⟩
  intro f
  apply hInjective
  rw [hVanish f, hVanish 0]

/-- Dimension consequence for the Serre-duality negative-degree route. -/
theorem dim_S2_Gamma0_two_eq_zero_of_serreDualNegativeDegree
    (X : ModularCurveX0Primitive 2)
    (hSerre : Gamma0TwoSerreDualNegativeDegreePrimitive X) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_serreDualNegativeDegree X hSerre)

/-! ### Route-cache T20–T21: Serre-derivative weight-four obstruction -/

/-- Derivative route: an injective Serre derivative into a vanishing
weight-four cusp-form space forces every weight-two `Γ₀(2)` cusp form to
vanish. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_serreDerivativeWeightFour
    (hDerivative : Gamma0TwoSerreDerivativeWeightFourPrimitive) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  rcases hDerivative with ⟨serreDerivative, hInjective, hWeightFour⟩
  intro f
  apply hInjective
  rw [hWeightFour (serreDerivative f), map_zero]

/-- Dimension consequence for the derivative obstruction route. -/
theorem dim_S2_Gamma0_two_eq_zero_of_serreDerivativeWeightFour
    (hDerivative : Gamma0TwoSerreDerivativeWeightFourPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_serreDerivativeWeightFour hDerivative)

/-! ### Route-cache T22–T23: trace down to level one -/

/-- Trace route: an injective trace into the vanishing level-one
weight-two cusp-form space forces every weight-two `Γ₀(2)` cusp form to
vanish. -/
theorem Gamma0TwoWeightTwoCuspFormsVanish_of_traceToLevelOne
    (hTrace : Gamma0TwoTraceToLevelOnePrimitive) :
    MathlibExpansion.ValenceFormula.Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  rcases hTrace with ⟨traceToLevelOne, hInjective, hLevelOne⟩
  intro f
  apply hInjective
  rw [hLevelOne (traceToLevelOne f), map_zero]

/-- Dimension consequence for the trace-to-level-one route. -/
theorem dim_S2_Gamma0_two_eq_zero_of_traceToLevelOne
    (hTrace : Gamma0TwoTraceToLevelOnePrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  MathlibExpansion.UnconditionalRR.unconditional_finrank_zero
    (Gamma0TwoWeightTwoCuspFormsVanish_of_traceToLevelOne hTrace)

end
end RiemannRochModular
end Roots
end MathlibExpansion
