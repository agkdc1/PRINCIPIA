import MathlibExpansion.UnconditionalRRFinal

/-!
# Gap 1 Closed — compContinuousLinearMap / HasDerivAt parity proof

Boardroom board-rr-20260420-03, round 2 consensus:
Gap 1 (`Gamma0TwoQExpCoeffOnePrimitive`) closes via `HasDerivAt.comp` parity proof.
No `sorry`, no `admit`, no new `axiom`.

## Strategy (synthesised from Codex + Sonnet voices, round 2)

Let F = `SlashInvariantFormClass.cuspFunction 2 (restrictCuspFormGamma0ToGamma2 2 f)`.

1. `qExpansion_coeff 1` gives `coeff ℂ 1 = (1!)⁻¹ · iteratedDeriv 1 F 0 = deriv F 0`.
2. For 0 < ‖q‖ < 1: τ := `invQParam 2 q ∈ ℍ` (by `im_invQParam_pos_of_norm_lt_one`),
   and `qParam 2 τ = q` (by `qParam_right_inv`).
   Then `cuspFunction_parity_at_qParam f τ` gives `F(-q) = F(q)`.
3. At q = 0: `F(-0) = F(0)` trivially. So `F(-q) = F(q)` for all ‖q‖ < 1,
   hence `(fun q => F(-q)) =ᶠ[nhds 0] F`.
4. Chain rule (`HasDerivAt.comp`): `HasDerivAt (fun q => F(-q)) (deriv F 0 · (-1)) 0`.
5. Congr (`HasDerivAt.congr_of_eventuallyEq`): `HasDerivAt (fun q => F(-q)) (deriv F 0) 0`.
6. Uniqueness: `deriv F 0 · (-1) = deriv F 0`, so `2 · deriv F 0 = 0`, so `deriv F 0 = 0`.
-/

namespace MathlibExpansion
namespace UnconditionalRRGap1Proof

open MathlibExpansion.UnconditionalRRFinal
open MathlibExpansion.RiemannRochBridge

noncomputable section

/-- **Gap 1 CLOSED — zero sorry/axiom.**

`Gamma0TwoQExpCoeffOnePrimitive`: for every Γ₀(2) weight-2 cusp form f,
the first q-expansion coefficient of its Γ(2) restriction vanishes.

This closes the previously open analytic bridge recorded in prior sessions.
The proof uses only APIs available in Mathlib v4.17.0. -/
theorem Gamma0TwoQExpCoeffOnePrimitive_holds : Gamma0TwoQExpCoeffOnePrimitive := by
  intro f
  -- Step 1: unfold qExpansion_coeff and reduce to deriv F 0 = 0
  rw [ModularFormClass.qExpansion_coeff]
  simp only [Nat.factorial_one, Nat.cast_one, inv_one, one_mul, iteratedDeriv_one]
  -- Goal: deriv (SlashInvariantFormClass.cuspFunction 2 (restrictCuspFormGamma0ToGamma2 2 f)) 0 = 0
  -- Abbreviate the cusp function as F (definitional equality throughout)
  let F := SlashInvariantFormClass.cuspFunction 2 (restrictCuspFormGamma0ToGamma2 2 f)
  show deriv F 0 = 0
  -- Step 2: F is differentiable at 0
  have hdiff : DifferentiableAt ℂ F 0 :=
    (ModularFormClass.analyticAt_cuspFunction_zero 2
      (restrictCuspFormGamma0ToGamma2 2 f)).differentiableAt
  -- Step 3: F(-q) = F(q) for all q with ‖q‖ < 1
  have hparity : ∀ q : ℂ, ‖q‖ < 1 → F (-q) = F q := by
    intro q hq
    by_cases hq0 : q = 0
    · simp [hq0]
    · -- Construct τ ∈ ℍ with qParam 2 τ = q via invQParam
      have him : 0 < (Function.Periodic.invQParam (2 : ℝ) q).im :=
        Function.Periodic.im_invQParam_pos_of_norm_lt_one
          (by norm_num : (0 : ℝ) < 2) hq hq0
      let τ : UpperHalfPlane := ⟨Function.Periodic.invQParam (2 : ℝ) q, him⟩
      have hqτ : Function.Periodic.qParam (2 : ℝ) (τ : ℂ) = q :=
        Function.Periodic.qParam_right_inv (by norm_num : (2 : ℝ) ≠ 0) hq0
      -- Apply T2: F(-(qParam 2 τ)) = F(qParam 2 τ)
      have h : F (-(Function.Periodic.qParam (2 : ℝ) (τ : ℂ))) =
               F (Function.Periodic.qParam (2 : ℝ) (τ : ℂ)) :=
        cuspFunction_parity_at_qParam f τ
      rwa [hqτ] at h
  -- Step 4: F(-q) = F(q) holds eventually in nhds 0
  have hev : ∀ᶠ q : ℂ in nhds 0, F (-q) = F q :=
    Filter.eventually_of_mem (Metric.ball_mem_nhds 0 one_pos) fun q hq => by
      apply hparity
      rwa [Metric.mem_ball, dist_zero_right] at hq
  -- Step 5: chain rule gives HasDerivAt (fun q => F(-q)) (deriv F 0 * (-1)) 0
  have hneg : HasDerivAt (fun q : ℂ => -q) (-1 : ℂ) 0 := by
    have h := (hasDerivAt_id (0 : ℂ)).neg
    simpa using h
  have hchain : HasDerivAt (fun q : ℂ => F (-q)) (deriv F 0 * (-1 : ℂ)) 0 := by
    -- State outer derivative at the correct evaluation point (fun q => -q) 0
    -- so HasDerivAt.comp can unify without needing neg_zero rewriting.
    have hF_at : HasDerivAt F (deriv F 0) ((fun q : ℂ => -q) 0) := by
      simp only [neg_zero]; exact hdiff.hasDerivAt
    have hcomp := hF_at.comp 0 hneg
    simp only [Function.comp] at hcomp
    exact hcomp
  -- Step 6: congr_of_eventuallyEq takes exactly 2 explicit args in Mathlib 4.17:
  -- self (the HasDerivAt) and hg (the eventuallyEq). No 3rd pointwise arg.
  have hcongr : HasDerivAt (fun q : ℂ => F (-q)) (deriv F 0) 0 :=
    hdiff.hasDerivAt.congr_of_eventuallyEq hev
  -- Step 7: uniqueness forces deriv F 0 * (-1) = deriv F 0
  have huniq : deriv F 0 * (-1 : ℂ) = deriv F 0 := hchain.unique hcongr
  -- Step 8: 2 * deriv F 0 = 0 via linear_combination, then char-0 cancellation.
  -- Proof: 2 * d - 0 - (-1) * (d*(-1) - d)
  --      = 2*d + d*(-1) - d  =  2*d - d - d  = 0   (ring, d*(-1) = -d)
  have h2 : (2 : ℂ) * deriv F 0 = 0 := by linear_combination -huniq
  exact (mul_eq_zero.mp h2).resolve_left (by norm_num)

#check @Gamma0TwoQExpCoeffOnePrimitive_holds

end
end UnconditionalRRGap1Proof
end MathlibExpansion
