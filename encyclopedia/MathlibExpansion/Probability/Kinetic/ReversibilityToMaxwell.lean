import MathlibExpansion.Probability.Kinetic.MaxwellVelocity

/-!
# Reversibility-to-Maxwell boundary

This file packages Levy's collision-balance route to the Maxwell law.
-/

namespace MathlibExpansion
namespace Probability
namespace Kinetic

open MeasureTheory ProbabilityTheory

/-- Hard-sphere collision-balance predicate at equilibrium, narrowed to the
Maxwell-characterization consequences currently present in the local substrate.

Source boundary: Paul Levy, *Calcul des probabilites* (1925), Part II,
Chapter 8, `Reversibilite et irreversibilite. Conclusion relative a la loi de
Maxwell`, recording the opposite-collision-count route to Maxwell's law.  The
active formal payload is the Herschel-Maxwell/Lancaster characterization cited
in `MaxwellVelocity.lean`: H. O. Lancaster, "The characterisation of the normal
distribution" (Journal of the Australian Mathematical Society, received 1958,
revised 1959), Theorem 5. -/
def HardSphereCollisionBalance (μ : ProbabilityMeasure (EuclideanSpace ℝ (Fin 3))) : Prop :=
  IndepCoordinateLaw μ ∧ SpeedDirectionIndependent μ

/-- Collision-balance at equilibrium forces the Maxwellian velocity law.

This is discharged through the upstream-narrow Maxwell characterization boundary:
H. O. Lancaster, "The characterisation of the normal distribution", Theorem 5,
with the historical kinetic anchor Maxwell (1860), Proposition IV, as recorded
in the local Levy recon. -/
theorem eq_maxwellVelocityLaw_of_collision_balance
    (μ : ProbabilityMeasure (EuclideanSpace ℝ (Fin 3))) :
    HardSphereCollisionBalance μ → ∃ σ : ℝ, μ = maxwellVelocityLaw σ := by
  intro hμ
  exact eq_maxwellVelocityLaw_of_indepCoord_of_speed_indep_direction μ hμ.1 hμ.2

end Kinetic
end Probability
end MathlibExpansion
