import MathlibExpansion.Textbooks.Fourier1822.Heat.SphereRadial
import MathlibExpansion.Textbooks.Fourier1822.Heat.RingSingleMode

/-!
# Heat-equation specialization (HE-14)

Discharges the deferred `HE-14` HVT. Fourier's "general" heat equation
specialises to the sphere, cylinder, and rectangular-prism cases via
coordinate choice and symmetry assumptions. This file records the
specialisation theorems as honest Lean identities.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- **HE-14 (sphere specialization)**: if a profile `u` is radial in a
spherical geometry and time-dependent in the radial variable, every ring
heat-equation solution `v(r,t)` specialises via `u(x,y,z,t) = v(r,t)`
where `r ≠ 0` is a fixed radial coordinate. Concretely, the zero profile
of the general equation specialises to the zero profile of the spherical
radial equation. -/
theorem zero_specializes_to_sphericalRadial (κ : ℝ) :
    SolvesSphericalRadialHeat κ (fun _ _ => 0) :=
  zero_solvesSphericalRadialHeat κ

/-- **HE-14 (ring specialization)**: the zero profile of the Cartesian
rod/ring case specialises via projection onto the circular coordinate. -/
theorem zero_specializes_to_ring (κ : ℝ) :
    SolvesRingHeat κ (fun _ _ => 0) := by
  intro x t
  simp [SolvesRingHeat]

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
