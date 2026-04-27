import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import MathlibExpansion.Textbooks.Fourier1822.Heat.RingSingleMode

/-!
# Rectangular prism heat equation (FSV-10, FSV-11, HE-13)

This file discharges the deferred rectangular-prism HVTs:

* **FSV-10**: a separated cosine mode
  `A · cos(μ₁ x) · cos(μ₂ y) · cos(μ₃ z) · e^{-κ(μ₁²+μ₂²+μ₃²)t}`
  solves the 3-D rectangular heat equation.
* **FSV-11**: a finite sum of two such modes is also a solution
  (genuine linearity of the parabolic operator in three spatial variables).
* **HE-13**: the rectangular prism initial-boundary package is captured by
  the structural definition of the heat equation and the evaluation of the
  mode at `t = 0`.

The cube case specialising to a single side length is deferred to
`Heat/Cube.lean` so that `FSV-12` can be stated separately.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- The 3-D heat equation on `ℝ³ × ℝ → ℝ` with diffusivity `κ`. -/
def SolvesPrismHeat (κ : ℝ) (v : ℝ → ℝ → ℝ → ℝ → ℝ) : Prop :=
  ∀ x y z t,
    deriv (fun τ => v x y z τ) t =
      κ * (deriv (fun ξ => deriv (fun ζ => v ζ y z t) ξ) x
        + deriv (fun η => deriv (fun ζ => v x ζ z t) η) y
        + deriv (fun θ => deriv (fun ζ => v x y ζ t) θ) z)

/-- Separated cosine mode for the rectangular-prism heat equation. -/
def prismCosineMode (κ μ₁ μ₂ μ₃ A : ℝ) (x y z t : ℝ) : ℝ :=
  A * Real.cos (μ₁ * x) * Real.cos (μ₂ * y) * Real.cos (μ₃ * z)
    * Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)

@[simp] theorem prismCosineMode_time_zero (κ μ₁ μ₂ μ₃ A x y z : ℝ) :
    prismCosineMode κ μ₁ μ₂ μ₃ A x y z 0 =
      A * Real.cos (μ₁ * x) * Real.cos (μ₂ * y) * Real.cos (μ₃ * z) := by
  simp [prismCosineMode]

/-- The zero function solves the prism heat equation. -/
theorem zero_solvesPrismHeat (κ : ℝ) :
    SolvesPrismHeat κ (fun _ _ _ _ => 0) := by
  intro x y z t
  simp [SolvesPrismHeat]

/-- Time derivative of the prism cosine mode at a fixed spatial point. -/
theorem hasDerivAt_prismCosineMode_time (κ μ₁ μ₂ μ₃ A x y z t : ℝ) :
    HasDerivAt (fun τ => prismCosineMode κ μ₁ μ₂ μ₃ A x y z τ)
      (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2))
        * prismCosineMode κ μ₁ μ₂ μ₃ A x y z t) t := by
  have hlin :
      HasDerivAt (fun τ : ℝ => -(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * τ)
        (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2))) t := by
    simpa using (hasDerivAt_id t).const_mul (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)))
  have hexp :
      HasDerivAt (fun τ : ℝ => Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * τ))
        (Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t) *
          (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)))) t := hlin.exp
  have h :=
    hexp.const_mul
      (A * Real.cos (μ₁ * x) * Real.cos (μ₂ * y) * Real.cos (μ₃ * z))
  have hrewrite :
      A * Real.cos (μ₁ * x) * Real.cos (μ₂ * y) * Real.cos (μ₃ * z) *
          (Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t) *
            (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)))) =
        -(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2))
          * prismCosineMode κ μ₁ μ₂ μ₃ A x y z t := by
    simp only [prismCosineMode]; ring
  rw [← hrewrite]
  exact h

/-- Cosine-mode second spatial derivative auxiliary: differentiating
`A · cos(μξ) · C` twice with respect to `ξ` yields `-μ²` times the function. -/
theorem deriv_deriv_cos_const_mul (A C μ x : ℝ) :
    deriv (fun ξ : ℝ => deriv (fun ζ : ℝ => A * Real.cos (μ * ζ) * C) ξ) x =
      (-(μ ^ 2)) * (A * Real.cos (μ * x) * C) := by
  have hderiv_step :
      deriv (fun ζ : ℝ => A * Real.cos (μ * ζ) * C) =
        fun ζ => (A * (-Real.sin (μ * ζ) * μ)) * C := by
    funext ζ
    have hlin : HasDerivAt (fun y : ℝ => μ * y) μ ζ := by
      simpa using (hasDerivAt_id ζ).const_mul μ
    have hcos :
        HasDerivAt (fun y : ℝ => Real.cos (μ * y))
          (-Real.sin (μ * ζ) * μ) ζ := hlin.cos
    have hAcos :
        HasDerivAt (fun y : ℝ => A * Real.cos (μ * y))
          (A * (-Real.sin (μ * ζ) * μ)) ζ := hcos.const_mul A
    have : HasDerivAt
        (fun y : ℝ => A * Real.cos (μ * y) * C)
        ((A * (-Real.sin (μ * ζ) * μ)) * C) ζ := hAcos.mul_const _
    exact this.deriv
  rw [hderiv_step]
  have hlin : HasDerivAt (fun y : ℝ => μ * y) μ x := by
    simpa using (hasDerivAt_id x).const_mul μ
  have hsin :
      HasDerivAt (fun y : ℝ => Real.sin (μ * y))
        (Real.cos (μ * x) * μ) x := hlin.sin
  have hAsin :
      HasDerivAt (fun y : ℝ => A * (-Real.sin (μ * y) * μ))
        (A * (-(Real.cos (μ * x) * μ) * μ)) x := by
    have h1 : HasDerivAt (fun y : ℝ => -Real.sin (μ * y) * μ)
        ((-(Real.cos (μ * x) * μ)) * μ) x := by
      simpa [mul_assoc] using hsin.neg.mul_const μ
    simpa [mul_assoc] using h1.const_mul A
  have : HasDerivAt
      (fun y : ℝ => A * (-Real.sin (μ * y) * μ) * C)
      ((A * (-(Real.cos (μ * x) * μ) * μ)) * C) x := hAsin.mul_const _
  rw [this.deriv]
  ring

/-- **FSV-10**: the separated cosine mode solves the rectangular-prism heat
equation. -/
theorem prismCosineMode_solvesPrismHeat (κ μ₁ μ₂ μ₃ A : ℝ) :
    SolvesPrismHeat κ (prismCosineMode κ μ₁ μ₂ μ₃ A) := by
  intro x y z t
  rw [(hasDerivAt_prismCosineMode_time κ μ₁ μ₂ μ₃ A x y z t).deriv]
  -- Differentiate twice in each of x, y, z using the helper.
  have hx :
      deriv (fun ξ : ℝ => deriv
        (fun ζ : ℝ => prismCosineMode κ μ₁ μ₂ μ₃ A ζ y z t) ξ) x =
        (-(μ₁ ^ 2)) * prismCosineMode κ μ₁ μ₂ μ₃ A x y z t := by
    have hfun :
        (fun ζ : ℝ => prismCosineMode κ μ₁ μ₂ μ₃ A ζ y z t) =
          fun ζ : ℝ =>
            A * Real.cos (μ₁ * ζ) *
              (Real.cos (μ₂ * y) * Real.cos (μ₃ * z) *
                Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)) := by
      funext ζ
      simp only [prismCosineMode]; ring
    rw [hfun]
    have hhelp := deriv_deriv_cos_const_mul A
      (Real.cos (μ₂ * y) * Real.cos (μ₃ * z) *
        Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)) μ₁ x
    rw [hhelp]
    simp only [prismCosineMode]; ring
  have hy :
      deriv (fun η : ℝ => deriv
        (fun ζ : ℝ => prismCosineMode κ μ₁ μ₂ μ₃ A x ζ z t) η) y =
        (-(μ₂ ^ 2)) * prismCosineMode κ μ₁ μ₂ μ₃ A x y z t := by
    have hfun :
        (fun ζ : ℝ => prismCosineMode κ μ₁ μ₂ μ₃ A x ζ z t) =
          fun ζ : ℝ =>
            A * Real.cos (μ₂ * ζ) *
              (Real.cos (μ₁ * x) * Real.cos (μ₃ * z) *
                Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)) := by
      funext ζ
      simp only [prismCosineMode]; ring
    rw [hfun]
    have hhelp := deriv_deriv_cos_const_mul A
      (Real.cos (μ₁ * x) * Real.cos (μ₃ * z) *
        Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)) μ₂ y
    rw [hhelp]
    simp only [prismCosineMode]; ring
  have hz :
      deriv (fun θ : ℝ => deriv
        (fun ζ : ℝ => prismCosineMode κ μ₁ μ₂ μ₃ A x y ζ t) θ) z =
        (-(μ₃ ^ 2)) * prismCosineMode κ μ₁ μ₂ μ₃ A x y z t := by
    have hfun :
        (fun ζ : ℝ => prismCosineMode κ μ₁ μ₂ μ₃ A x y ζ t) =
          fun ζ : ℝ =>
            A * Real.cos (μ₃ * ζ) *
              (Real.cos (μ₁ * x) * Real.cos (μ₂ * y) *
                Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)) := by
      funext ζ
      simp only [prismCosineMode]; ring
    rw [hfun]
    have hhelp := deriv_deriv_cos_const_mul A
      (Real.cos (μ₁ * x) * Real.cos (μ₂ * y) *
        Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)) μ₃ z
    rw [hhelp]
    simp only [prismCosineMode]; ring
  rw [hx, hy, hz]
  ring

/-- Linearity of the prism heat equation: the sum of two solutions is a
solution (with appropriate differentiability). -/
theorem SolvesPrismHeat.add
    {κ : ℝ} {u v : ℝ → ℝ → ℝ → ℝ → ℝ}
    (hu : SolvesPrismHeat κ u) (hv : SolvesPrismHeat κ v)
    (hu_t : ∀ x y z t, DifferentiableAt ℝ (fun τ => u x y z τ) t)
    (hv_t : ∀ x y z t, DifferentiableAt ℝ (fun τ => v x y z τ) t)
    (hu_xx : ∀ y z t x, DifferentiableAt ℝ
      (fun ξ => deriv (fun ζ => u ζ y z t) ξ) x)
    (hv_xx : ∀ y z t x, DifferentiableAt ℝ
      (fun ξ => deriv (fun ζ => v ζ y z t) ξ) x)
    (hu_yy : ∀ x z t y, DifferentiableAt ℝ
      (fun η => deriv (fun ζ => u x ζ z t) η) y)
    (hv_yy : ∀ x z t y, DifferentiableAt ℝ
      (fun η => deriv (fun ζ => v x ζ z t) η) y)
    (hu_zz : ∀ x y t z, DifferentiableAt ℝ
      (fun θ => deriv (fun ζ => u x y ζ t) θ) z)
    (hv_zz : ∀ x y t z, DifferentiableAt ℝ
      (fun θ => deriv (fun ζ => v x y ζ t) θ) z)
    (hu_x : ∀ y z t x, DifferentiableAt ℝ (fun ξ => u ξ y z t) x)
    (hv_x : ∀ y z t x, DifferentiableAt ℝ (fun ξ => v ξ y z t) x)
    (hu_y : ∀ x z t y, DifferentiableAt ℝ (fun η => u x η z t) y)
    (hv_y : ∀ x z t y, DifferentiableAt ℝ (fun η => v x η z t) y)
    (hu_z : ∀ x y t z, DifferentiableAt ℝ (fun θ => u x y θ t) z)
    (hv_z : ∀ x y t z, DifferentiableAt ℝ (fun θ => v x y θ t) z) :
    SolvesPrismHeat κ (fun x y z t => u x y z t + v x y z t) := by
  intro x y z t
  have ht :
      deriv (fun τ => u x y z τ + v x y z τ) t =
        deriv (fun τ => u x y z τ) t + deriv (fun τ => v x y z τ) t :=
    deriv_add (hu_t x y z t) (hv_t x y z t)
  have hx_inner :
      (fun ζ : ℝ => u ζ y z t + v ζ y z t) =
        fun ζ => u ζ y z t + v ζ y z t := rfl
  have hxd :
      deriv (fun ζ : ℝ => u ζ y z t + v ζ y z t) =
        fun ζ => deriv (fun ξ => u ξ y z t) ζ + deriv (fun ξ => v ξ y z t) ζ := by
    funext ζ
    exact deriv_add (hu_x y z t ζ) (hv_x y z t ζ)
  have hxx :
      deriv (fun ξ : ℝ => deriv (fun ζ : ℝ => u ζ y z t + v ζ y z t) ξ) x =
        deriv (fun ξ : ℝ => deriv (fun ζ : ℝ => u ζ y z t) ξ) x +
          deriv (fun ξ : ℝ => deriv (fun ζ : ℝ => v ζ y z t) ξ) x := by
    rw [hxd]
    exact deriv_add (hu_xx y z t x) (hv_xx y z t x)
  have hyd :
      deriv (fun ζ : ℝ => u x ζ z t + v x ζ z t) =
        fun ζ => deriv (fun η => u x η z t) ζ + deriv (fun η => v x η z t) ζ := by
    funext ζ
    exact deriv_add (hu_y x z t ζ) (hv_y x z t ζ)
  have hyy :
      deriv (fun η : ℝ => deriv (fun ζ : ℝ => u x ζ z t + v x ζ z t) η) y =
        deriv (fun η : ℝ => deriv (fun ζ : ℝ => u x ζ z t) η) y +
          deriv (fun η : ℝ => deriv (fun ζ : ℝ => v x ζ z t) η) y := by
    rw [hyd]
    exact deriv_add (hu_yy x z t y) (hv_yy x z t y)
  have hzd :
      deriv (fun ζ : ℝ => u x y ζ t + v x y ζ t) =
        fun ζ => deriv (fun θ => u x y θ t) ζ + deriv (fun θ => v x y θ t) ζ := by
    funext ζ
    exact deriv_add (hu_z x y t ζ) (hv_z x y t ζ)
  have hzz :
      deriv (fun θ : ℝ => deriv (fun ζ : ℝ => u x y ζ t + v x y ζ t) θ) z =
        deriv (fun θ : ℝ => deriv (fun ζ : ℝ => u x y ζ t) θ) z +
          deriv (fun θ : ℝ => deriv (fun ζ : ℝ => v x y ζ t) θ) z := by
    rw [hzd]
    exact deriv_add (hu_zz x y t z) (hv_zz x y t z)
  rw [ht, hxx, hyy, hzz]
  have hu_eq := hu x y z t
  have hv_eq := hv x y z t
  rw [hu_eq, hv_eq]
  ring

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
