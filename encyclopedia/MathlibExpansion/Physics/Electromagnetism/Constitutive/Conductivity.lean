import MathlibExpansion.Analysis.VectorCalculus.GradientPotential

/-!
# Conductivity in isotropic media
-/

namespace MathlibExpansion.Physics.Electromagnetism.Constitutive

open MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's isotropic constitutive law for conduction current. -/
def MaxwellConductivity (σ : ℝ) (E Kc : VectorField) : Prop :=
  ∀ x, Kc x = σ • E x

/-- In isotropic media, conduction current is proportional to electric field. -/
theorem conductivity_isotropic (σ : ℝ) (E Kc : VectorField) :
    MaxwellConductivity σ E Kc ↔ ∀ x, Kc x = σ • E x :=
  Iff.rfl

end MathlibExpansion.Physics.Electromagnetism.Constitutive
