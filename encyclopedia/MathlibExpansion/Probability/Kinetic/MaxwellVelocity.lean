import Mathlib

/-!
# Maxwellian velocity laws

This file provides the owner surface for one-particle Maxwell velocity laws and
their characterization.  The velocity law itself is now the concrete product of
three centered one-dimensional Gaussian laws from Mathlib.  The remaining
characterization boundary is the Herschel-Maxwell/Lancaster theorem that
spherical symmetry plus independent coordinates force the normal law.
-/

namespace MathlibExpansion
namespace Probability
namespace Kinetic

open MeasureTheory ProbabilityTheory
open scoped NNReal

/-- Three-dimensional velocity space for one molecule. -/
abbrev MaxwellVelocitySpace : Type :=
  EuclideanSpace ℝ (Fin 3)

/-- Variance parameter used by the centered Gaussian coordinate laws. -/
noncomputable def maxwellVariance (σ : ℝ) : ℝ≥0 :=
  ⟨σ ^ 2, sq_nonneg σ⟩

/-- The centered one-dimensional Gaussian coordinate law with Maxwell scale
`σ`.  Mathlib already proves that this is a probability measure. -/
noncomputable def maxwellCoordinateMeasure (σ : ℝ) : Measure ℝ :=
  gaussianReal 0 (maxwellVariance σ)

/-- Maxwellian one-particle velocity law: the product of the three centered
Gaussian coordinate laws with common variance `σ ^ 2`, transported from
`Fin 3 → ℝ` to `EuclideanSpace ℝ (Fin 3)`.

This discharges the former owner axiom by using Mathlib's one-dimensional
Gaussian law and finite product measure substrate. -/
noncomputable def maxwellVelocityLaw (σ : ℝ) : ProbabilityMeasure MaxwellVelocitySpace :=
  let μ : Measure (Fin 3 → ℝ) := Measure.pi fun _ : Fin 3 => maxwellCoordinateMeasure σ
  have hμ : IsProbabilityMeasure μ := by
    dsimp [μ, maxwellCoordinateMeasure]
    infer_instance
  ⟨μ.map (EuclideanSpace.measurableEquiv (Fin 3)).symm,
    haveI : IsProbabilityMeasure μ := hμ
    isProbabilityMeasure_map
      (EuclideanSpace.measurableEquiv (Fin 3)).symm.measurable.aemeasurable⟩

/-- Coordinate projection from velocity space. -/
def velocityCoordinate (i : Fin 3) (v : MaxwellVelocitySpace) : ℝ :=
  v i

/-- Predicate asserting coordinate independence for a law on velocity space. -/
def IndepCoordinateLaw (μ : ProbabilityMeasure MaxwellVelocitySpace) : Prop :=
  iIndepFun (fun _ : Fin 3 => inferInstance) (fun i => velocityCoordinate i)
    (μ : Measure MaxwellVelocitySpace)

/-- Radial speed of a velocity vector. -/
noncomputable def velocitySpeed (v : MaxwellVelocitySpace) : ℝ :=
  ‖v‖

/-- Direction of a velocity vector, with the zero vector sent to zero. -/
noncomputable def velocityDirection (v : MaxwellVelocitySpace) : MaxwellVelocitySpace :=
  if _ : ‖v‖ = 0 then 0 else (‖v‖)⁻¹ • v

/-- Orthogonal invariance of a velocity law.  This is the Lean form of spherical
symmetry used by the Herschel-Maxwell characterization. -/
def OrthogonallyInvariantLaw (μ : ProbabilityMeasure MaxwellVelocitySpace) : Prop :=
  ∀ R : MaxwellVelocitySpace ≃ₗᵢ[ℝ] MaxwellVelocitySpace,
    Measure.map R (μ : Measure MaxwellVelocitySpace) = (μ : Measure MaxwellVelocitySpace)

/-- Predicate asserting independence of speed and direction, together with the
orthogonal invariance that makes the Maxwell characterization upstream-narrow
rather than a theorem over arbitrary probability measures. -/
def SpeedDirectionIndependent (μ : ProbabilityMeasure MaxwellVelocitySpace) : Prop :=
  IndepFun velocitySpeed velocityDirection (μ : Measure MaxwellVelocitySpace) ∧
    OrthogonallyInvariantLaw μ

/-- Still upstream-narrow axiom: the Herschel-Maxwell normal-characterization
theorem specialized to one-particle velocity laws.

Exact theorem target: H. O. Lancaster, "The characterisation of the normal
distribution" (Journal of the Australian Mathematical Society, received 1958,
revised 1959), Theorem 5: spherical symmetry of the joint distribution of
independent random variables forces the common normal law.  The historical
kinetic citation chain is James Clerk Maxwell, "Illustrations of the Dynamical
Theory of Gases" (1860), Proposition IV, as recorded in the local Lévy recon.

Current substrate found here and in Mathlib:
* `ProbabilityTheory.gaussianReal` and its probability-measure instance;
* `Measure.pi` and its finite-product probability-measure instance;
* `ProbabilityTheory.iIndepFun` / `IndepFun` for coordinate and radial
  independence.

Missing substrate: the proof that the above independence and orthogonal
invariance predicates identify the concrete Gaussian product law on
`EuclideanSpace ℝ (Fin 3)`. -/
axiom eq_maxwellVelocityLaw_of_indepCoord_of_speed_indep_direction
    (μ : ProbabilityMeasure MaxwellVelocitySpace) :
    IndepCoordinateLaw μ → SpeedDirectionIndependent μ → ∃ σ : ℝ, μ = maxwellVelocityLaw σ

end Kinetic
end Probability
end MathlibExpansion
