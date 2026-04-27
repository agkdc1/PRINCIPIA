import MathlibExpansion.LieGroups.Chevalley.OneParameterSubgroups

/-!
# Exponential map

This file packages the Banach-algebra exponential as a concrete exponential map
into the general linear group model used throughout the Chevalley campaign.
-/

noncomputable section

namespace MathlibExpansion.LieGroups.Chevalley

section

variable {𝕜 : Type*} [RCLike 𝕜]
variable {V : Type*} [NormedAddCommGroup V] [NormedSpace 𝕜 V] [CompleteSpace V]

/-- The Banach-algebra exponential interpreted as a point of `GL(V)`. -/
def generalLinearExp (A : V →L[𝕜] V) : (V →L[𝕜] V)ˣ :=
  (NormedSpace.isUnit_exp 𝕜 A).unit

/-- Ambient-coordinate form of the `GL(V)` exponential map. -/
def generalLinearExpVal : (V →L[𝕜] V) → V →L[𝕜] V :=
  fun A => ((generalLinearExp (𝕜 := 𝕜) A : (V →L[𝕜] V)ˣ) : V →L[𝕜] V)

@[simp] theorem coe_generalLinearExp (A : V →L[𝕜] V) :
    ((generalLinearExp (𝕜 := 𝕜) A : (V →L[𝕜] V)ˣ) : V →L[𝕜] V) = NormedSpace.exp 𝕜 A :=
  IsUnit.unit_spec _

@[simp] theorem generalLinearExp_zero :
    generalLinearExp (𝕜 := 𝕜) (0 : V →L[𝕜] V) = 1 := by
  ext
  simp [generalLinearExp]

theorem generalLinearExp_add_of_commute {A B : V →L[𝕜] V} (hAB : Commute A B) :
    generalLinearExp (𝕜 := 𝕜) (A + B) =
      generalLinearExp (𝕜 := 𝕜) A * generalLinearExp (𝕜 := 𝕜) B := by
  ext
  simp [generalLinearExp, NormedSpace.exp_add_of_commute, hAB]

theorem analyticAt_generalLinearExp_val (A : V →L[𝕜] V) :
    AnalyticAt 𝕜
      (fun B : V →L[𝕜] V => ((generalLinearExp (𝕜 := 𝕜) B : (V →L[𝕜] V)ˣ) : V →L[𝕜] V))
      A := by
  simpa [generalLinearExp] using NormedSpace.exp_analytic (𝕂 := 𝕜) (x := A)

theorem hasStrictFDerivAt_generalLinearExp_val_zero :
    HasStrictFDerivAt
      (generalLinearExpVal (𝕜 := 𝕜) (V := V))
      (1 : (V →L[𝕜] V) →L[𝕜] (V →L[𝕜] V))
      0 := by
  simpa [generalLinearExpVal, generalLinearExp] using
    (hasStrictFDerivAt_exp_zero (𝕂 := 𝕜) (𝔸 := V →L[𝕜] V))

theorem generalLinearExp_eq_oneParameterSubgroup_one (A : V →L[𝕜] V) :
    generalLinearExp (𝕜 := 𝕜) A =
      oneParameterSubgroup (𝕜 := 𝕜) A 1 := by
  ext
  simp [generalLinearExp, oneParameterSubgroup]

theorem hasFDerivAt_generalLinearExp_val_zero :
    HasFDerivAt
      (fun B : V →L[𝕜] V => ((generalLinearExp (𝕜 := 𝕜) B : (V →L[𝕜] V)ˣ) : V →L[𝕜] V))
      (1 : (V →L[𝕜] V) →L[𝕜] (V →L[𝕜] V)) 0 := by
  simpa [generalLinearExp] using
    (hasFDerivAt_exp_zero (𝕂 := 𝕜) (𝔸 := V →L[𝕜] V))

end

end MathlibExpansion.LieGroups.Chevalley
