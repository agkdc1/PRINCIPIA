import NavierStokes.AxisymNoSwirl.Gamma.MaxPrinciple
import NavierStokes.AxisymNoSwirl.Velocity.LInftyBootstrap

/-!
# NavierStokes.AxisymNoSwirl.Gamma.MaxPrincipleComparison

Route W **CROWN THEOREM** — comparison / `L^∞` propagation for the
axisymmetric no-swirl `Γ = ω_θ / r` transport-diffusion system.

This file consumes the Route W substrate — B5 Stampacchia a.e. `L^∞`
propagation (`stampacchia_L_infty_propagation`) and B7 velocity `L^∞`
bootstrap (`linfty_velocity_bootstrap`) — and advertises the crown at the
interface the post-recon boardroom endorsed:

> "The proof will still contain iteration/truncation mechanics, but the
> theorem interface should advertise comparison / L^∞ propagation."
> — ANS B5 Post-Recon Boardroom Verdict (Route W)

The comparison here is *comparison of the real solution `Γ(U t)` against a
constant `M`* — equivalently, the real solution against the trivial
supersolution `Γ₂ ≡ M`. This is the form the existing substrate
(positive truncation `(Γ - M)_+`) directly proves. In the current shell the
`Γ` carrier is not a free function argument but a fixed functional
`Γ(u) = thetaCurl u / rCyl` of the velocity field, so a literal "two
solutions" signature would duplicate the velocity field, not the scalar.
The comparison-with-constant form captures the same content.

## Textbook Spine

- **DiBenedetto 1993** — *Degenerate Parabolic Equations*, Ch. II-III
  (weak maximum principle via truncation energy).
- **Stampacchia 1965** — *Équations elliptiques du second ordre à
  coefficients discontinus*, Ch. I (truncation test functions; level-set
  iteration).

## Substrate

- `Gamma.MaxPrinciple.lean` (B5 — Stampacchia crown, zero axioms).
- `Velocity.LInftyBootstrap.lean` (B7 — velocity bootstrap; 1 narrow
  upstream axiom already filed there, not introduced here).
- W1 (`Gamma.DriftCancellation.lean`) — drift cancellation.
- W2 (`Gamma.Coercivity.lean`) — truncation coercivity.
- W3 (`Gamma.AxisCompatibility.lean`) — axis seam.
- W4 (`Gamma.EnergyInequality.lean`) — Steklov-regularized energy balance.

## No new axioms

This file is a pure rewrapping + composition on top of the Route W
substrate. Net axiom delta introduced by this file: `0`.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

open MeasureTheory Set Real
open scoped ENNReal NNReal

namespace NavierStokes.AxisymNoSwirl.Gamma

open NavierStokes.Geometry.Cylindrical
open NavierStokes.Analysis.WeightedSobolev
open NavierStokes.AxisymNoSwirl.BiotSavart
open NavierStokes.Mathlib.WeightedSobolev
open NavierStokes.AxisymNoSwirl.Velocity

/-! ## A.e. upper comparison with a constant — CROWN -/

/-- **Route W crown — a.e. upper comparison (weak maximum principle).**

For axisymmetric no-swirl `Γ = ω_θ/r` satisfying the transport-diffusion
shell under `divergenceCyl u = 0`, with the W4 energy-inequality
certificate at level `M ≥ 0`, an a.e. initial upper bound propagates:

  `Γ(U 0) ≤ M   a.e. on Ω`
  `⟹ ∀ t ∈ [0, T], Γ(U t) ≤ M   a.e. on Ω.`

Viewed as comparison: the real solution `Γ(U t)` stays below the constant
supersolution `M` for all `t ∈ [0, T]`. The proof wraps B5's
`stampacchia_L_infty_propagation` on the positive truncation `(Γ - M)_+`
and re-advertises the conclusion at the cleaner comparison level. -/
theorem maxPrincipleComparison
    (U : ℝ → AxisymNoSwirlField) (M T : ℝ) (hM : 0 ≤ M)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U M T hdiv hsolves)
    (h_init :
      ∀ᵐ p ∂(weightedMeasure.restrict Ω), Γ (U 0) p ≤ M) :
    ∀ t ∈ Set.Icc 0 T,
      ∀ᵐ p ∂(weightedMeasure.restrict Ω), Γ (U t) p ≤ M := by
  -- Step 1: initial a.e. bound ⟹ shiftedPosPart (Γ (U 0)) M vanishes a.e.
  have h_init_ae :
      (fun p => shiftedPosPart (Γ (U 0)) M p)
        =ᵐ[weightedMeasure.restrict Ω] 0 := by
    filter_upwards [h_init] with p hp
    show max (Γ (U 0) p - M) 0 = 0
    exact max_eq_right (by linarith)
  -- Step 2: B5 a.e. L^∞ propagation at level `M`
  have h_t_ae :=
    stampacchia_L_infty_propagation U M T hM hdiv hsolves hEnergy h_init_ae
  -- Step 3: vanishing shiftedPosPart a.e. ⟹ upper bound `≤ M` a.e.
  intro t ht
  filter_upwards [h_t_ae t ht] with p hp
  have hmax : max (Γ (U t) p - M) 0 = 0 := hp
  have h_le_zero : Γ (U t) p - M ≤ 0 :=
    (le_max_left _ _).trans hmax.le
  linarith

/-! ## Full crown — Γ comparison ⊕ velocity `L^∞` bootstrap

Single deliverable packaging B5 a.e. upper bound + B7 velocity `L^∞`
bootstrap on the same interval `[0, T]`. The B7 half carries the one
narrow upstream axiom already filed in `Velocity/LInftyBootstrap.lean`;
this crown introduces none. -/

/-- **Route W full crown.** The comparison + bootstrap assembly:

1. `Γ(U t) ≤ M` a.e. on `Ω` for every `t ∈ [0, T]`  (B5 + this file).
2. `‖U t‖_{L^∞(Ω)} ≤ M_{vel}` for some `M_{vel} ≥ 0`, uniformly on
   `[0, T]`  (B7, via the scalar envelope hypotheses `hΓ_init_finite`
   and `hΓ_bound`).

The axisymmetric no-swirl `Γ → u` closure at the `L^∞` level. -/
theorem maxPrincipleCrown
    (U : ℝ → AxisymNoSwirlField) (M T : ℝ) (hM : 0 ≤ M) (hT : 0 < T)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U M T hdiv hsolves)
    (h_init_ae :
      ∀ᵐ p ∂(weightedMeasure.restrict Ω), Γ (U 0) p ≤ M)
    (hΓ_init_finite : gammaLInftyNorm (Γ (U 0)) < ⊤)
    (hΓ_bound :
      ∀ t ∈ Set.Icc 0 T,
        gammaLInftyNorm (Γ (U t)) ≤ gammaLInftyNorm (Γ (U 0))) :
    (∀ t ∈ Set.Icc 0 T,
        ∀ᵐ p ∂(weightedMeasure.restrict Ω), Γ (U t) p ≤ M)
      ∧ ∃ Mvel : ℝ, 0 ≤ Mvel ∧
          ∀ t ∈ Set.Icc 0 T,
            (velocityLInftyNorm (U t)).toReal ≤ Mvel := by
  refine ⟨?_, ?_⟩
  · exact maxPrincipleComparison U M T hM hdiv hsolves hEnergy h_init_ae
  · exact
      linfty_velocity_bootstrap U (fun t => Γ (U t)) T hT hdiv hsolves
        (fun _ => rfl) hΓ_init_finite hΓ_bound

end NavierStokes.AxisymNoSwirl.Gamma

end
