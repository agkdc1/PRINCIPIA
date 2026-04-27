import MathlibExpansion.Probability.Kinetic.MaxwellVelocity

/-!
# Maxwellian speed law

This file packages the radial image of the Maxwell velocity law.  Historically,
this is the speed distribution obtained from Maxwell's velocity distribution in
Maxwell (1860), "Illustrations of the dynamical theory of gases. Part I. On the
motions and collisions of perfectly elastic spheres".
-/

namespace MathlibExpansion
namespace Probability
namespace Kinetic

open MeasureTheory

/-- Maxwellian speed law, defined as the radial image of the Maxwellian velocity law. -/
noncomputable def maxwellSpeedLaw (σ : ℝ) : ProbabilityMeasure ℝ :=
  (maxwellVelocityLaw σ).map measurable_norm.aemeasurable

/-- The norm-pushforward of the Maxwell velocity law is the Maxwell speed law. -/
theorem map_norm_maxwellVelocityLaw (σ : ℝ) :
    (maxwellVelocityLaw σ).map measurable_norm.aemeasurable = maxwellSpeedLaw σ := rfl

end Kinetic
end Probability
end MathlibExpansion
