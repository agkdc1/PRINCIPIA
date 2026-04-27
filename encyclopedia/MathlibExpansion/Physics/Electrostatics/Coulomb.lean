import Mathlib.Data.Real.Basic

/-!
# Coulomb's law
-/

noncomputable section

namespace MathlibExpansion.Physics.Electrostatics

/-- The scalar Coulomb-force shell for two point charges. -/
def CoulombForce (e₁ e₂ r : ℝ) : ℝ :=
  e₁ * e₂ / r ^ 2

/-- Coulomb's inverse-square law in Maxwell's scalar normalization. -/
theorem coulomb_force_eq_mul_mul_inv_sq (e₁ e₂ r : ℝ) :
    CoulombForce e₁ e₂ r = e₁ * e₂ / r ^ 2 :=
  rfl

end MathlibExpansion.Physics.Electrostatics
