import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Analysis.SpecialFunctions.ExpDeriv

/-!
# Ring / circle single-mode heat equation (FSV-02, FSV-03)

This file discharges the deferred `FSV-02` (single-mode ring heat solution) and
`FSV-03` (finite-modal-superposition ring heat solution) HVTs.

The ring heat equation is the linear parabolic PDE
`∂ₜ u = κ ∂ₓₓ u` on `ℝ × ℝ`. We prove:

* Every cosine mode `A · cos(μx) · e^{-κμ²t}` is a solution (FSV-02).
* The sum of two such modes is a solution (FSV-03 finite form).

An infinite Fourier-series version of FSV-03 requires termwise differentiation
under summability and is recorded separately in `Heat/Armille.lean`.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- The one-dimensional heat equation with diffusivity `κ`. -/
def SolvesRingHeat (κ : ℝ) (v : ℝ → ℝ → ℝ) : Prop :=
  ∀ x t,
    deriv (fun τ => v x τ) t =
      κ * deriv (fun ξ => deriv (fun ζ => v ζ t) ξ) x

/-- Single cosine mode for the ring heat equation:
`A · cos(μx) · e^{-κμ²t}`. -/
def ringCosineMode (κ μ A : ℝ) (x t : ℝ) : ℝ :=
  A * Real.cos (μ * x) * Real.exp (-(κ * μ ^ 2) * t)

@[simp] theorem ringCosineMode_time_zero (κ μ A x : ℝ) :
    ringCosineMode κ μ A x 0 = A * Real.cos (μ * x) := by
  simp [ringCosineMode]

/-- Time derivative of the ring cosine mode at a fixed `x`. -/
theorem hasDerivAt_ringCosineMode_time (κ μ A x t : ℝ) :
    HasDerivAt (fun τ => ringCosineMode κ μ A x τ)
      (-(κ * μ ^ 2) * ringCosineMode κ μ A x t) t := by
  have hlin : HasDerivAt (fun τ : ℝ => -(κ * μ ^ 2) * τ) (-(κ * μ ^ 2)) t := by
    simpa using (hasDerivAt_id t).const_mul (-(κ * μ ^ 2))
  have hexp :
      HasDerivAt (fun τ : ℝ => Real.exp (-(κ * μ ^ 2) * τ))
        (Real.exp (-(κ * μ ^ 2) * t) * (-(κ * μ ^ 2))) t := hlin.exp
  have hmode :
      HasDerivAt (fun τ => A * Real.cos (μ * x) * Real.exp (-(κ * μ ^ 2) * τ))
        (A * Real.cos (μ * x) *
          (Real.exp (-(κ * μ ^ 2) * t) * (-(κ * μ ^ 2)))) t :=
    hexp.const_mul (A * Real.cos (μ * x))
  have hrewrite :
      A * Real.cos (μ * x) * (Real.exp (-(κ * μ ^ 2) * t) * (-(κ * μ ^ 2))) =
        -(κ * μ ^ 2) * ringCosineMode κ μ A x t := by
    simp [ringCosineMode]; ring
  rw [← hrewrite]
  exact hmode

/-- Space derivative (first) of the ring cosine mode at a fixed `t`. -/
theorem hasDerivAt_ringCosineMode_space (κ μ A x t : ℝ) :
    HasDerivAt (fun ξ => ringCosineMode κ μ A ξ t)
      (-(A * μ * Real.sin (μ * x)) * Real.exp (-(κ * μ ^ 2) * t)) x := by
  have hlin : HasDerivAt (fun y : ℝ => μ * y) μ x := by
    simpa using (hasDerivAt_id x).const_mul μ
  have hcos :
      HasDerivAt (fun y : ℝ => Real.cos (μ * y))
        (-Real.sin (μ * x) * μ) x := hlin.cos
  have hAcos :
      HasDerivAt (fun y : ℝ => A * Real.cos (μ * y))
        (A * (-Real.sin (μ * x) * μ)) x := hcos.const_mul A
  have hmode :
      HasDerivAt
        (fun y : ℝ => A * Real.cos (μ * y) * Real.exp (-(κ * μ ^ 2) * t))
        ((A * (-Real.sin (μ * x) * μ)) * Real.exp (-(κ * μ ^ 2) * t)) x :=
    hAcos.mul_const _
  have hrewrite :
      (A * (-Real.sin (μ * x) * μ)) * Real.exp (-(κ * μ ^ 2) * t) =
        -(A * μ * Real.sin (μ * x)) * Real.exp (-(κ * μ ^ 2) * t) := by ring
  rw [← hrewrite]
  exact hmode

/-- The first spatial derivative of the ring cosine mode as a function of
space. -/
theorem deriv_ringCosineMode_space_eq (κ μ A t : ℝ) :
    deriv (fun ξ : ℝ => ringCosineMode κ μ A ξ t) =
      fun ξ => -(A * μ * Real.sin (μ * ξ)) * Real.exp (-(κ * μ ^ 2) * t) := by
  funext ξ
  exact (hasDerivAt_ringCosineMode_space κ μ A ξ t).deriv

/-- Second spatial derivative of the ring cosine mode. -/
theorem deriv_deriv_ringCosineMode_space (κ μ A x t : ℝ) :
    deriv (fun ξ : ℝ => deriv (fun ζ : ℝ => ringCosineMode κ μ A ζ t) ξ) x =
      -(μ ^ 2) * ringCosineMode κ μ A x t := by
  rw [deriv_ringCosineMode_space_eq]
  -- Now we differentiate `-(A * μ * Real.sin (μ * ξ)) * Real.exp (-(κ * μ ^ 2) * t)`
  -- with respect to ξ. The exp factor is constant.
  have hlin : HasDerivAt (fun y : ℝ => μ * y) μ x := by
    simpa using (hasDerivAt_id x).const_mul μ
  have hsin :
      HasDerivAt (fun y : ℝ => Real.sin (μ * y))
        (Real.cos (μ * x) * μ) x := hlin.sin
  have hNegAmu :
      HasDerivAt (fun y : ℝ => -(A * μ * Real.sin (μ * y)))
        (-(A * μ * (Real.cos (μ * x) * μ))) x := by
    have := hsin.const_mul (A * μ)
    exact this.neg
  have hmul :
      HasDerivAt
        (fun y : ℝ => -(A * μ * Real.sin (μ * y)) * Real.exp (-(κ * μ ^ 2) * t))
        ((-(A * μ * (Real.cos (μ * x) * μ))) * Real.exp (-(κ * μ ^ 2) * t)) x :=
    hNegAmu.mul_const _
  have hrewrite :
      (-(A * μ * (Real.cos (μ * x) * μ))) * Real.exp (-(κ * μ ^ 2) * t) =
        -(μ ^ 2) * ringCosineMode κ μ A x t := by
    simp [ringCosineMode, pow_two]; ring
  rw [← hrewrite]
  exact hmul.deriv

/-- **FSV-02**: The single cosine mode `A · cos(μx) · e^{-κμ²t}` is an honest
solution of the ring heat equation. -/
theorem ringCosineMode_solvesRingHeat (κ μ A : ℝ) :
    SolvesRingHeat κ (ringCosineMode κ μ A) := by
  intro x t
  rw [(hasDerivAt_ringCosineMode_time κ μ A x t).deriv]
  rw [deriv_deriv_ringCosineMode_space]
  ring

/-- Linear superposition of two ring-heat solutions with pointwise
differentiability hypotheses. -/
theorem SolvesRingHeat.add
    {κ : ℝ} {u v : ℝ → ℝ → ℝ}
    (hu : SolvesRingHeat κ u) (hv : SolvesRingHeat κ v)
    (hu_t : ∀ x t, DifferentiableAt ℝ (fun τ => u x τ) t)
    (hv_t : ∀ x t, DifferentiableAt ℝ (fun τ => v x τ) t)
    (hu_x : ∀ t x, DifferentiableAt ℝ (fun ξ => u ξ t) x)
    (hv_x : ∀ t x, DifferentiableAt ℝ (fun ξ => v ξ t) x)
    (hu_xx : ∀ t x, DifferentiableAt ℝ
      (fun ξ => deriv (fun ζ => u ζ t) ξ) x)
    (hv_xx : ∀ t x, DifferentiableAt ℝ
      (fun ξ => deriv (fun ζ => v ζ t) ξ) x) :
    SolvesRingHeat κ (fun x t => u x t + v x t) := by
  intro x t
  have ht :
      deriv (fun τ => u x τ + v x τ) t =
        deriv (fun τ => u x τ) t + deriv (fun τ => v x τ) t :=
    deriv_add (hu_t x t) (hv_t x t)
  have hx_eq :
      deriv (fun ζ => u ζ t + v ζ t) =
        fun ζ => deriv (fun ζ' => u ζ' t) ζ + deriv (fun ζ' => v ζ' t) ζ := by
    funext ζ
    exact deriv_add (hu_x t ζ) (hv_x t ζ)
  have hxx :
      deriv (fun ξ => deriv (fun ζ => u ζ t + v ζ t) ξ) x =
        deriv (fun ξ => deriv (fun ζ => u ζ t) ξ) x +
          deriv (fun ξ => deriv (fun ζ => v ζ t) ξ) x := by
    rw [hx_eq]
    exact deriv_add (hu_xx t x) (hv_xx t x)
  have hu_eq := hu x t
  have hv_eq := hv x t
  rw [ht, hxx, hu_eq, hv_eq]
  ring

/-- Every ring cosine mode is time-differentiable (pointwise). -/
theorem differentiableAt_ringCosineMode_time (κ μ A x t : ℝ) :
    DifferentiableAt ℝ (fun τ => ringCosineMode κ μ A x τ) t :=
  (hasDerivAt_ringCosineMode_time κ μ A x t).differentiableAt

/-- Every ring cosine mode is space-differentiable (pointwise). -/
theorem differentiableAt_ringCosineMode_space (κ μ A x t : ℝ) :
    DifferentiableAt ℝ (fun ξ => ringCosineMode κ μ A ξ t) x :=
  (hasDerivAt_ringCosineMode_space κ μ A x t).differentiableAt

/-- The first spatial derivative of the ring cosine mode is space-differentiable. -/
theorem differentiableAt_deriv_ringCosineMode_space (κ μ A x t : ℝ) :
    DifferentiableAt ℝ
      (fun ξ => deriv (fun ζ => ringCosineMode κ μ A ζ t) ξ) x := by
  rw [deriv_ringCosineMode_space_eq]
  have hsin : DifferentiableAt ℝ (fun y : ℝ => Real.sin (μ * y)) x :=
    (differentiableAt_id.const_mul μ).sin
  have : DifferentiableAt ℝ (fun ξ : ℝ => -(A * μ * Real.sin (μ * ξ))) x :=
    (hsin.const_mul (A * μ)).neg
  exact this.mul_const _

/-- **FSV-03 (two-mode case)**: The sum of any two ring cosine modes is an
honest solution of the ring heat equation. -/
theorem ringCosineMode_add_solvesRingHeat (κ μ₁ μ₂ A₁ A₂ : ℝ) :
    SolvesRingHeat κ
      (fun x t => ringCosineMode κ μ₁ A₁ x t + ringCosineMode κ μ₂ A₂ x t) := by
  refine (ringCosineMode_solvesRingHeat κ μ₁ A₁).add
    (ringCosineMode_solvesRingHeat κ μ₂ A₂)
    ?_ ?_ ?_ ?_ ?_ ?_
  · intro x t; exact differentiableAt_ringCosineMode_time κ μ₁ A₁ x t
  · intro x t; exact differentiableAt_ringCosineMode_time κ μ₂ A₂ x t
  · intro t x; exact differentiableAt_ringCosineMode_space κ μ₁ A₁ x t
  · intro t x; exact differentiableAt_ringCosineMode_space κ μ₂ A₂ x t
  · intro t x; exact differentiableAt_deriv_ringCosineMode_space κ μ₁ A₁ x t
  · intro t x; exact differentiableAt_deriv_ringCosineMode_space κ μ₂ A₂ x t

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
