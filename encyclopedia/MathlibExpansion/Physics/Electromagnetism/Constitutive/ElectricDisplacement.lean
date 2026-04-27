import MathlibExpansion.Analysis.VectorCalculus.GradientPotential

/-!
# Electric displacement in isotropic media
-/

namespace MathlibExpansion.Physics.Electromagnetism.Constitutive

open MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's isotropic constitutive law for electric displacement. -/
def MaxwellElectricDisplacement (K : ℝ) (E D : VectorField) : Prop :=
  ∀ x, D x = ((K / (4 * Real.pi)) : ℝ) • E x

/-- In isotropic media, electric displacement is proportional to electric field. -/
theorem electric_displacement_isotropic (K : ℝ) (E D : VectorField) :
    MaxwellElectricDisplacement K E D ↔
      ∀ x, D x = ((K / (4 * Real.pi)) : ℝ) • E x :=
  Iff.rfl

end MathlibExpansion.Physics.Electromagnetism.Constitutive
