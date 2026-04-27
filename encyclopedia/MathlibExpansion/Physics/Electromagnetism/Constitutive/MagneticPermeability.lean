import MathlibExpansion.Analysis.VectorCalculus.GradientPotential

/-!
# Magnetic permeability in isotropic media
-/

namespace MathlibExpansion.Physics.Electromagnetism.Constitutive

open MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's isotropic constitutive law for magnetic induction. -/
def MaxwellMagneticPermeability (μ : ℝ) (H B : VectorField) : Prop :=
  ∀ x, B x = μ • H x

/-- In isotropic media, magnetic induction is permeability times magnetic force. -/
theorem magnetic_permeability_isotropic (μ : ℝ) (H B : VectorField) :
    MaxwellMagneticPermeability μ H B ↔ ∀ x, B x = μ • H x :=
  Iff.rfl

end MathlibExpansion.Physics.Electromagnetism.Constitutive
