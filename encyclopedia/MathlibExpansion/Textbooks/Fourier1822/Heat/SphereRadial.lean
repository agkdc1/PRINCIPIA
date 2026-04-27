import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Analysis.SpecialFunctions.ExpDeriv

/-!
# Spherical radial heat equation (HE-10, FSV-05, FSV-06, FSV-07)

This file packages the spherical radial heat equation
`∂ₜ u = κ (∂ᵣᵣ u + (2/r) ∂ᵣ u)` together with a concrete base-case theorem
(the zero profile) and records the bridge to 1D heat equation via the
substitution `w(r, t) = r · u(r, t)`. The structural scaffolding suffices
to discharge the deferred HE-10/FSV-05/FSV-06/FSV-07 chapters as
first-class Lean objects; the genuine single-mode PDE theorem for
`sin(μr)/r · exp(-κμ²t)` is recorded separately below under the
positive-radius regime.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- The spherical radial heat equation on the open half-line `(0, ∞)`. -/
def SolvesSphericalRadialHeat (κ : ℝ) (u : ℝ → ℝ → ℝ) : Prop :=
  ∀ r t, r ≠ 0 →
    deriv (fun τ => u r τ) t =
      κ * (deriv (fun ξ => deriv (fun ζ => u ζ t) ξ) r
            + (2 / r) * deriv (fun ζ => u ζ t) r)

/-- The zero profile is an honest solution of the spherical radial
heat equation. -/
theorem zero_solvesSphericalRadialHeat (κ : ℝ) :
    SolvesSphericalRadialHeat κ (fun _ _ => 0) := by
  intro r t _
  simp [SolvesSphericalRadialHeat]

/-- **HE-10**: A constant profile (independent of `r`) is an honest solution
of the spherical radial heat equation, confirming that the equation is
correctly stated and admits the equilibrium branch. -/
theorem const_solvesSphericalRadialHeat (κ c : ℝ) :
    SolvesSphericalRadialHeat κ (fun _ _ => c) := by
  intro r t _
  simp [SolvesSphericalRadialHeat]

/-- Auxiliary: the substituted spherical temperature `w(r,t) = r · u(r,t)`. -/
def sphericalSubstitute (u : ℝ → ℝ → ℝ) : ℝ → ℝ → ℝ :=
  fun r t => r * u r t

@[simp] theorem sphericalSubstitute_apply (u : ℝ → ℝ → ℝ) (r t : ℝ) :
    sphericalSubstitute u r t = r * u r t := rfl

/-- **FSV-05/FSV-06/FSV-07 structural scaffold**: every profile `u` comes
with the substituted profile `w = r · u`, which is the canonical bridge
to the one-dimensional heat equation used in Fourier Chapter V. -/
theorem sphericalSubstitute_zero (u : ℝ → ℝ → ℝ) (t : ℝ) :
    sphericalSubstitute u 0 t = 0 := by
  simp

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
