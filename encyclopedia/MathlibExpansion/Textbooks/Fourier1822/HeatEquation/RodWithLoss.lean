import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import MathlibExpansion.Textbooks.Fourier1822.HeatEquation.Model

/-!
# Rod heat equation with lateral loss

This file introduces the one-dimensional heat equation with a linear loss term
and proves that the standard separated cosine modes satisfy it.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- The one-dimensional rod heat equation with linear loss. -/
def SolvesRodHeatWithLoss (α β : ℝ) (v : ℝ → ℝ → ℝ) : Prop :=
  ∀ x t,
    deriv (fun τ => v x τ) t =
      α * deriv (fun ξ => deriv (fun ζ => v ζ t) ξ) x - β * v x t

/-- A separated cosine mode for the rod-with-loss equation. -/
def rodCosineMode (α β μ A : ℝ) (x t : ℝ) : ℝ :=
  A * Real.exp (-(α * μ ^ 2 + β) * t) * Real.cos (μ * x)

@[simp] theorem rodCosineMode_time_zero (α β μ A x : ℝ) :
    rodCosineMode α β μ A x 0 = A * Real.cos (μ * x) := by
  simp [rodCosineMode]

/-- The zero profile is a baseline solution of the rod heat equation with
linear lateral loss. This keeps the PDE interface honest while the nontrivial
modal solution theorem is deferred to a later breach. -/
theorem zero_solvesRodHeatWithLoss (α β : ℝ) :
    SolvesRodHeatWithLoss α β (fun _ _ => 0) := by
  intro x t
  simp [SolvesRodHeatWithLoss]

/-- The standard separated cosine mode is an honest solution of the rod heat
equation with linear lateral loss. -/
theorem rodCosineMode_solvesRodHeatWithLoss (α β μ A : ℝ) :
    SolvesRodHeatWithLoss α β (rodCosineMode α β μ A) := by
  intro x t
  let lam : ℝ := α * μ ^ 2 + β
  have htime :
      deriv (fun τ : ℝ => rodCosineMode α β μ A x τ) t =
        (-lam) * rodCosineMode α β μ A x t := by
    have hlin : HasDerivAt (fun τ : ℝ => -lam * τ) (-lam) t := by
      simpa using (hasDerivAt_id t).const_mul (-lam)
    have hexp :
        HasDerivAt (fun τ : ℝ => Real.exp (-lam * τ))
          (Real.exp (-lam * t) * (-lam)) t :=
      hlin.exp
    have hmode :
        HasDerivAt
          (fun τ : ℝ => rodCosineMode α β μ A x τ)
          ((A * Real.cos (μ * x)) * (Real.exp (-lam * t) * (-lam))) t := by
      simpa [rodCosineMode, lam, mul_assoc, mul_left_comm, mul_comm] using
        hexp.const_mul (A * Real.cos (μ * x))
    simpa [rodCosineMode, lam, mul_assoc, mul_left_comm, mul_comm] using hmode.deriv
  have hfirstEq :
      deriv (fun ξ : ℝ => rodCosineMode α β μ A ξ t) =
        fun ξ => (A * Real.exp (-lam * t)) * (-Real.sin (μ * ξ) * μ) := by
    funext ξ
    have hlin : HasDerivAt (fun y : ℝ => μ * y) μ ξ := by
      simpa using (hasDerivAt_id ξ).const_mul μ
    have hcos :
        HasDerivAt (fun y : ℝ => Real.cos (μ * y))
          (-Real.sin (μ * ξ) * μ) ξ :=
      hlin.cos
    have hmode :
        HasDerivAt
          (fun y : ℝ => rodCosineMode α β μ A y t)
          ((A * Real.exp (-lam * t)) * (-Real.sin (μ * ξ) * μ)) ξ := by
      simpa [rodCosineMode, lam, mul_assoc, mul_left_comm, mul_comm] using
        hcos.const_mul (A * Real.exp (-lam * t))
    simpa [rodCosineMode, lam, mul_assoc, mul_left_comm, mul_comm] using hmode.deriv
  have hspace :
      deriv (fun ξ : ℝ => deriv (fun ζ : ℝ => rodCosineMode α β μ A ζ t) ξ) x =
        (-(μ ^ 2)) * rodCosineMode α β μ A x t := by
    rw [hfirstEq]
    have hlin : HasDerivAt (fun y : ℝ => μ * y) μ x := by
      simpa using (hasDerivAt_id x).const_mul μ
    have hsin :
        HasDerivAt (fun y : ℝ => -Real.sin (μ * y) * μ)
          ((-(Real.cos (μ * x) * μ)) * μ) x := by
      simpa [mul_assoc] using (hlin.sin.neg.mul_const μ)
    have hmode :
        HasDerivAt
          (fun ξ : ℝ => (A * Real.exp (-lam * t)) * (-Real.sin (μ * ξ) * μ))
          ((A * Real.exp (-lam * t)) * (((-(Real.cos (μ * x) * μ)) * μ))) x := by
      simpa [mul_assoc] using hsin.const_mul (A * Real.exp (-lam * t))
    simpa [rodCosineMode, lam, pow_two, mul_assoc, mul_left_comm, mul_comm] using hmode.deriv
  rw [htime, hspace]
  ring

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
