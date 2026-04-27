import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.SpecialFunctions.Gaussian.FourierTransform
import MathlibExpansion.Analysis.PDE.Heat.KernelBasic

/-!
# Integral-transform inversion for the heat kernel

This file lands the Fourier-integral representation of the heat multiplier:
the Gaussian Fourier multiplier `exp(-4π²κt ξ²)` for the heat semigroup has
Fourier transform equal to a normalized Gaussian in the dual variable. This
is the Fourier-inversion identity underlying the heat-kernel representation
of the Green function.

HVT closed in this file:

* `HKM_08` — integral-transform inversion for the heat kernel via
  Fourier duality.

No axioms.
-/

noncomputable section

open scoped FourierTransform Real
open Complex

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

/-- The Fourier multiplier associated with the heat semigroup:
`m(ξ, κ, t) = exp(-4 π² κ t ξ²)`. This is the Gaussian multiplier that
implements time evolution on the Fourier side. -/
def fourierHeatMultiplier (κ t ξ : ℝ) : ℂ :=
  Complex.exp (-(4 * Real.pi ^ 2 * κ * t : ℂ) * (ξ : ℂ) ^ 2)

/-- Rewriting of the heat multiplier in the Gaussian form `exp(-π b ξ²)`
with real-scaled parameter `b := 4 π κ t` (positive at `κ, t > 0`). -/
theorem fourierHeatMultiplier_eq (κ t ξ : ℝ) :
    fourierHeatMultiplier κ t ξ =
      Complex.exp (-↑Real.pi * ((4 * Real.pi * κ * t : ℝ) : ℂ) * (ξ : ℂ) ^ 2) := by
  unfold fourierHeatMultiplier
  congr 1
  push_cast
  ring

/-- The Fourier transform of the Gaussian heat multiplier is again a
Gaussian — on the dual side it equals `(4πκt)^(-1/2) · exp(-π x²/(4πκt))`,
which is (up to an overall normalization) the whole-line heat kernel
profile. This is the heart of the Fourier-inversion representation of the
Green function. -/
theorem fourierIntegral_fourierHeatMultiplier {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) :
    𝓕 (fun ξ : ℝ => fourierHeatMultiplier κ t ξ) =
      fun x : ℝ =>
        1 / (((4 * Real.pi * κ * t : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
          Complex.exp (-↑Real.pi / (((4 * Real.pi * κ * t : ℝ) : ℂ)) * (x : ℂ) ^ 2) := by
  have hπpos : (0 : ℝ) < Real.pi := Real.pi_pos
  have hbreal : (0 : ℝ) < 4 * Real.pi * κ * t := by positivity
  have hb_re : (0 : ℝ) < ((4 * Real.pi * κ * t : ℝ) : ℂ).re := by
    have : (((4 * Real.pi * κ * t : ℝ) : ℂ).re) = 4 * Real.pi * κ * t := by simp
    rw [this]; exact hbreal
  -- Reduce the heat multiplier to its Gaussian form.
  have hmul :
      (fun ξ : ℝ => fourierHeatMultiplier κ t ξ)
        = fun ξ : ℝ => Complex.exp (-↑Real.pi * ((4 * Real.pi * κ * t : ℝ) : ℂ) * (ξ : ℂ) ^ 2) := by
    funext ξ; exact fourierHeatMultiplier_eq κ t ξ
  rw [hmul]
  exact fourierIntegral_gaussian_pi hb_re

end Heat
end PDE
end Analysis
end MathlibExpansion
