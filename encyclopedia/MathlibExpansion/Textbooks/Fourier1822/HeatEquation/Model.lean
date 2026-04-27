import Mathlib

/-!
# Fourier 1822 heat-equation model data

This file repairs the poisoned theorem boundaries in the derivation chapter by
making the constitutive assumptions explicit data rather than fake theorem
targets.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- Material data for one-dimensional conductive heat flow. -/
structure ConductionData where
  conductivity : ℝ
  heatCapacity : ℝ
  density : ℝ

/-- Boundary cooling data for Newton-type heat exchange. -/
structure CoolingData where
  exchangeCoeff : ℝ
  ambientTemperature : ℝ

/-- One-dimensional conductive heat flux through a cross-section of area `A`. -/
def heatFlux1D (data : ConductionData) (A dudx : ℝ) : ℝ :=
  -data.conductivity * A * dudx

/-- Newton cooling loss at a boundary point. -/
def boundaryCoolingLoss (cooling : CoolingData) (surfaceTemperature : ℝ) : ℝ :=
  cooling.exchangeCoeff * (surfaceTemperature - cooling.ambientTemperature)

@[simp] theorem heatFlux1D_eq (data : ConductionData) (A dudx : ℝ) :
    heatFlux1D data A dudx = -data.conductivity * A * dudx :=
  rfl

@[simp] theorem boundaryCoolingLoss_eq
    (cooling : CoolingData) (surfaceTemperature : ℝ) :
    boundaryCoolingLoss cooling surfaceTemperature =
      cooling.exchangeCoeff * (surfaceTemperature - cooling.ambientTemperature) :=
  rfl

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
