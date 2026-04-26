import NavierStokes.AxisymNoSwirl.GammaTransport.Carrier
import NavierStokes.AxisymNoSwirl.GammaTransport.ProductRule
import NavierStokes.AxisymNoSwirl.GammaTransport.VorticityEquation
import NavierStokes.AxisymNoSwirl.GammaTransport.GammaBridge
import NavierStokes.AxisymNoSwirl.GammaTransport.FiveDRadialLaplacian

/-!
# NavierStokes.AxisymNoSwirl.GammaTransport.TestChecks

Axiom diagnostics for the ANS-B4 `Γ`-transport surface.
-/

open NavierStokes.AxisymNoSwirl.GammaTransport

-- Carrier theorems
#print axioms differentiableAt_rCyl
#print axioms hasDerivAt_radialLine
#print axioms hasDerivAt_verticalLine
#print axioms hasDerivAt_comp_radialLine
#print axioms hasDerivAt_comp_verticalLine
#print axioms deriv_radialLine_eq_radialDeriv
#print axioms deriv_verticalLine_eq_verticalDeriv
#print axioms rCyl_radialLine_eq_abs
#print axioms rCyl_verticalLine_eq
#print axioms hasDerivAt_rCyl_radialLine
#print axioms radialDeriv_rCyl_eq_one
#print axioms hasDerivAt_rCyl_verticalLine
#print axioms verticalDeriv_rCyl_eq_zero

-- Product rule
#print axioms radialDeriv_rCyl_mul
#print axioms verticalDeriv_rCyl_mul
#print axioms gammaAdvection_rCyl_mul

-- Vorticity equation surface
#print axioms IsThetaVorticityEquation
#print axioms thetaVorticity_equation

-- Gamma bridge
#print axioms HasGammaSubstitution
#print axioms thetaVorticityDrift_rCyl_mul
#print axioms thetaVorticityDiffusion_rCyl_mul
#print axioms gammaTransport_of_thetaVorticityEquation

-- 5D structural bridge
#print axioms secondPartialDeriv5
#print axioms laplacian5
#print axioms radialRadius4
#print axioms radialLift
#print axioms radialEmbed
#print axioms HasFiveDRadialLaplacianData
#print axioms gammaDiffusion_is_5D_radial_Laplacian
