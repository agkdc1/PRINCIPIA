import NavierStokes.AxisymNoSwirl.GammaTransport.Carrier

/-!
# NavierStokes.AxisymNoSwirl.GammaTransport.VorticityEquation

Steady `ω_θ`-equation surface on the cylindrical carrier.

The current namespace does not yet contain a time-dependent axisymmetric NSE predicate.
This file therefore packages the `ω_θ` identity itself as a reusable contract for the
algebraic bridge in `GammaBridge.lean`.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

namespace NavierStokes.AxisymNoSwirl.GammaTransport

open NavierStokes.Geometry.Cylindrical

/-- Steady `ω_θ` equation on the B1 cylindrical carrier. -/
structure IsThetaVorticityEquation
    (ωθ : GammaField) (u : CylVectorField) (hdiv : DivergenceFreeCyl u) : Prop where
  equation :
    ∀ p : E3, p ∈ puncturedSpace →
      thetaVorticityDrift u ωθ p = thetaVorticityDiffusion ωθ p

/-- Pointwise form of the steady `ω_θ` transport-diffusion identity. -/
theorem thetaVorticity_equation
    {ωθ : GammaField} {u : CylVectorField} {hdiv : DivergenceFreeCyl u}
    (hω : IsThetaVorticityEquation ωθ u hdiv)
    {p : E3} (hp : p ∈ puncturedSpace) :
    thetaVorticityDrift u ωθ p = thetaVorticityDiffusion ωθ p :=
  hω.equation p hp

end NavierStokes.AxisymNoSwirl.GammaTransport

end
