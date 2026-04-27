import MathlibExpansion.Textbooks.Fourier1822.HeatEquation.Model

/-!
# Robin boundary condition (HE-09)

Discharges the deferred `HE-09` HVT. Fourier Chapter II formulates the
Newton-cooling boundary condition `k ∂ₙ u + h(u - u_ambient) = 0` at a
conducting surface. We encode this as a predicate on `(u, ∂ₙu)` pairs.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- Robin/Newton boundary condition on a surface: `k · ∂ₙu + h · (u - u_∞) = 0`. -/
def RobinBoundary (k h u_ambient : ℝ) (u dnU : ℝ) : Prop :=
  k * dnU + h * (u - u_ambient) = 0

/-- **HE-09 (equilibrium case)**: at thermal equilibrium with the ambient
temperature, every inward flux is zero, so the Robin condition holds. -/
theorem ambient_equilibrium_robinBoundary
    (k h u_ambient : ℝ) :
    RobinBoundary k h u_ambient u_ambient 0 := by
  simp [RobinBoundary]

/-- **HE-09 (insulation limit)**: if `h = 0` and `∂ₙu = 0`, the Robin
condition reduces to the Neumann condition and holds trivially. -/
theorem insulation_robinBoundary (k u u_ambient : ℝ) :
    RobinBoundary k 0 u_ambient u 0 := by
  simp [RobinBoundary]

/-- **HE-09 (Dirichlet limit)**: if `k = 0` and the surface temperature
matches the ambient temperature, the Robin condition reduces to Dirichlet. -/
theorem dirichlet_robinBoundary (h u_ambient dnU : ℝ) :
    RobinBoundary 0 h u_ambient u_ambient dnU := by
  simp [RobinBoundary]

/-- **HE-09 consistency**: the Robin datum equates the conductive flux and
the convective loss modelled by `boundaryCoolingLoss`. -/
theorem robinBoundary_flux_balance (k : ℝ) (cooling : CoolingData)
    (u dnU : ℝ)
    (h : RobinBoundary k cooling.exchangeCoeff cooling.ambientTemperature u dnU) :
    k * dnU = -boundaryCoolingLoss cooling u := by
  have := h
  simp [RobinBoundary, boundaryCoolingLoss] at this ⊢
  linarith

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
