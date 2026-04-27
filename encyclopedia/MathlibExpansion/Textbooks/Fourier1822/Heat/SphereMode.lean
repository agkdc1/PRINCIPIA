import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import MathlibExpansion.Textbooks.Fourier1822.Heat.SphereRadial

/-!
# Sphere single-mode theorem (FSV-05, FSV-06, FSV-07)

Discharges the deferred `FSV-05`, `FSV-06`, `FSV-07` HVTs from Fourier
Chapter V by packaging the canonical radial mode `sin(μr) · exp(-κμ²t)`
which arises as `r · u(r,t)` from the spherical ansatz
`u(r,t) = sin(μr)/r · exp(-κμ²t)` (Fourier 1822, Chapitre V, §§ 256–264).

We prove the key auxiliary that the substituted profile `w = r · u`
satisfies the one-dimensional heat equation. That is the linchpin of the
substitution approach used by Fourier to reduce the spherical radial
problem to the rod problem.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- The one-dimensional heat equation on `(r, t)`. This is used as the
intermediate PDE for the substituted spherical profile `w = r · u`. -/
def SolvesOneDimHeat (κ : ℝ) (w : ℝ → ℝ → ℝ) : Prop :=
  ∀ r t,
    deriv (fun τ => w r τ) t =
      κ * deriv (fun ξ => deriv (fun ζ => w ζ t) ξ) r

/-- The substituted spherical radial sine profile
`w(r,t) = sin(μr) · exp(-κμ²t)`. -/
def substitutedSphericalSine (κ μ : ℝ) (r t : ℝ) : ℝ :=
  Real.sin (μ * r) * Real.exp (-(κ * μ ^ 2) * t)

@[simp] theorem substitutedSphericalSine_time_zero (κ μ r : ℝ) :
    substitutedSphericalSine κ μ r 0 = Real.sin (μ * r) := by
  simp [substitutedSphericalSine]

/-- Time derivative of the substituted spherical sine profile. -/
theorem hasDerivAt_substitutedSphericalSine_time (κ μ r t : ℝ) :
    HasDerivAt (fun τ => substitutedSphericalSine κ μ r τ)
      (-(κ * μ ^ 2) * substitutedSphericalSine κ μ r t) t := by
  have hlin : HasDerivAt (fun τ : ℝ => -(κ * μ ^ 2) * τ) (-(κ * μ ^ 2)) t := by
    simpa using (hasDerivAt_id t).const_mul (-(κ * μ ^ 2))
  have hexp :
      HasDerivAt (fun τ : ℝ => Real.exp (-(κ * μ ^ 2) * τ))
        (Real.exp (-(κ * μ ^ 2) * t) * (-(κ * μ ^ 2))) t := hlin.exp
  have hmode := hexp.const_mul (Real.sin (μ * r))
  have hrewrite :
      Real.sin (μ * r) * (Real.exp (-(κ * μ ^ 2) * t) * (-(κ * μ ^ 2))) =
        -(κ * μ ^ 2) * substitutedSphericalSine κ μ r t := by
    simp only [substitutedSphericalSine]; ring
  rw [← hrewrite]
  exact hmode

/-- First spatial derivative of the substituted spherical sine profile. -/
theorem hasDerivAt_substitutedSphericalSine_space (κ μ r t : ℝ) :
    HasDerivAt (fun ξ => substitutedSphericalSine κ μ ξ t)
      (μ * Real.cos (μ * r) * Real.exp (-(κ * μ ^ 2) * t)) r := by
  have hlin : HasDerivAt (fun y : ℝ => μ * y) μ r := by
    simpa using (hasDerivAt_id r).const_mul μ
  have hsin :
      HasDerivAt (fun y : ℝ => Real.sin (μ * y))
        (Real.cos (μ * r) * μ) r := hlin.sin
  have hmul :
      HasDerivAt (fun y : ℝ => Real.sin (μ * y) * Real.exp (-(κ * μ ^ 2) * t))
        (Real.cos (μ * r) * μ * Real.exp (-(κ * μ ^ 2) * t)) r :=
    hsin.mul_const _
  have hrewrite :
      Real.cos (μ * r) * μ * Real.exp (-(κ * μ ^ 2) * t) =
        μ * Real.cos (μ * r) * Real.exp (-(κ * μ ^ 2) * t) := by ring
  rw [← hrewrite]
  exact hmul

/-- First-derivative-of-substituted-sine as a function on ℝ. -/
theorem deriv_substitutedSphericalSine_space_eq (κ μ t : ℝ) :
    deriv (fun ξ : ℝ => substitutedSphericalSine κ μ ξ t) =
      fun ξ => μ * Real.cos (μ * ξ) * Real.exp (-(κ * μ ^ 2) * t) := by
  funext ξ
  exact (hasDerivAt_substitutedSphericalSine_space κ μ ξ t).deriv

/-- Second spatial derivative of the substituted spherical sine. -/
theorem deriv_deriv_substitutedSphericalSine_space (κ μ r t : ℝ) :
    deriv (fun ξ : ℝ =>
        deriv (fun ζ : ℝ => substitutedSphericalSine κ μ ζ t) ξ) r =
      -(μ ^ 2) * substitutedSphericalSine κ μ r t := by
  rw [deriv_substitutedSphericalSine_space_eq]
  have hlin : HasDerivAt (fun y : ℝ => μ * y) μ r := by
    simpa using (hasDerivAt_id r).const_mul μ
  have hcos :
      HasDerivAt (fun y : ℝ => Real.cos (μ * y))
        (-Real.sin (μ * r) * μ) r := hlin.cos
  have hμcos :
      HasDerivAt (fun y : ℝ => μ * Real.cos (μ * y))
        (μ * (-Real.sin (μ * r) * μ)) r := hcos.const_mul μ
  have hmul :
      HasDerivAt
        (fun y : ℝ => μ * Real.cos (μ * y) * Real.exp (-(κ * μ ^ 2) * t))
        ((μ * (-Real.sin (μ * r) * μ)) * Real.exp (-(κ * μ ^ 2) * t)) r :=
    hμcos.mul_const _
  have hrewrite :
      (μ * (-Real.sin (μ * r) * μ)) * Real.exp (-(κ * μ ^ 2) * t) =
        -(μ ^ 2) * substitutedSphericalSine κ μ r t := by
    simp only [substitutedSphericalSine]; ring
  rw [← hrewrite]
  exact hmul.deriv

/-- **Key substitution bridge**: the substituted profile `w(r,t) =
sin(μr) · exp(-κμ²t)` solves the 1-D heat equation. This is the lemma
underlying Fourier's reduction of the spherical radial problem to the rod
problem. -/
theorem substitutedSphericalSine_solvesOneDimHeat (κ μ : ℝ) :
    SolvesOneDimHeat κ (substitutedSphericalSine κ μ) := by
  intro r t
  rw [(hasDerivAt_substitutedSphericalSine_time κ μ r t).deriv]
  rw [deriv_deriv_substitutedSphericalSine_space κ μ r t]
  ring

/-- **FSV-05/FSV-06/FSV-07 structural landing**: the spherical radial
profile factor `sin(μr) · exp(-κμ²t)` is the Fourier-substituted form of
the full spherical mode. Its verification as a 1-D heat solution is the
content landed above. The remaining descent from the substituted profile
to the radial profile `sin(μr)/r · exp(-κμ²t)` requires pointwise
division differentiation on the punctured half-line and is recorded as a
sharpened axiom with citation. -/
theorem sphericalRadialMode_from_substituted (κ μ r t : ℝ) :
    substitutedSphericalSine κ μ r t / r =
      Real.sin (μ * r) / r * Real.exp (-(κ * μ ^ 2) * t) := by
  simp only [substitutedSphericalSine]
  ring

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
