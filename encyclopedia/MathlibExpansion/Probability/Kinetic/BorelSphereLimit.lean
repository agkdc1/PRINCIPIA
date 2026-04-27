import MathlibExpansion.Probability.Kinetic.MaxwellVelocity

/-!
# Borel's hypersphere limit to Maxwell

This file isolates the Maxwell--Borel hypersphere limit.  The finite-dimensional
velocity space, energy sphere, and first-molecule projection are concrete; the
remaining upstream boundary is the absence of a checked surface-probability law
on Euclidean spheres and the corresponding high-dimensional marginal limit.
-/

namespace MathlibExpansion
namespace Probability
namespace Kinetic

open Filter MeasureTheory
open scoped Topology

/-- The velocity space of one molecule. -/
abbrev OneMoleculeVelocity : Type :=
  EuclideanSpace ℝ (Fin 3)

/-- Velocity configurations for `n + 1` molecules, with three coordinates per
molecule.  The `+ 1` keeps the first-molecule projection available at `n = 0`;
the asymptotic theorem is unchanged because `n + 1 -> infinity`. -/
abbrev VelocityConfiguration (n : ℕ) : Type :=
  EuclideanSpace ℝ (Fin (3 * (n + 1)))

/-- The total kinetic-energy shell, represented here by the squared Euclidean
norm.  Constants such as mass and the factor `1 / 2` are absorbed into the
energy parameter. -/
noncomputable def totalKineticEnergy (n : ℕ) (v : VelocityConfiguration n) : ℝ :=
  ‖v‖ ^ 2

/-- The energy hypersphere in the `3 * (n + 1)`-dimensional velocity space.
Borel writes this as equation (6) in Émile Borel, *Sur les principes de la
théorie cinétique des gaz* (1906), Part IV, pp. 28-29. -/
def energySphere (n : ℕ) (E : ℝ) : Set (VelocityConfiguration n) :=
  {v | totalKineticEnergy n v = E}

/-- Projection from a full velocity configuration to the velocity of the first
molecule. -/
def firstMoleculeVelocity (n : ℕ) (v : VelocityConfiguration n) : OneMoleculeVelocity :=
  fun i => v ⟨i, by omega⟩

/-- The first-molecule projection is continuous. -/
theorem continuous_firstMoleculeVelocity (n : ℕ) :
    Continuous (firstMoleculeVelocity n) := by
  unfold firstMoleculeVelocity
  fun_prop

/-- The first-molecule projection is Borel-measurable. -/
theorem measurable_firstMoleculeVelocity (n : ℕ) :
    Measurable (firstMoleculeVelocity n) :=
  (continuous_firstMoleculeVelocity n).measurable

/-- Package for a uniform surface probability on Borel's positive-energy
hypersphere. -/
structure UniformEnergySphereProbabilityPackage (n : ℕ) (E : ℝ) (hE : 0 < E) where
  law : ProbabilityMeasure (VelocityConfiguration n)
  supported_energySphere :
    (law : Measure (VelocityConfiguration n)) (energySphere n E) = 1

/-- Uniform surface-probability package on Borel's positive-energy hypersphere.

Upstream boundary.  Exact source anchor: Émile Borel, *Sur les principes de la
théorie cinétique des gaz* (1906), Part IV, pp. 28-29, equation (6) and the
following paragraph: the point of velocity coordinates is distributed on the
hypersphere with probability proportional to the surface element.  The article is
section/equation numbered rather than theorem numbered.  Current Mathlib has
finite `uniformOn` and weak convergence of `ProbabilityMeasure`, but no checked
surface probability measure on arbitrary Euclidean spheres. -/
axiom uniformEnergySphereProbabilityPackage (n : ℕ) (E : ℝ) (hE : 0 < E) :
    UniformEnergySphereProbabilityPackage n E hE

/-- Uniform surface probability on Borel's positive-energy hypersphere. -/
noncomputable def uniformEnergySphereProbabilityLaw (n : ℕ) (E : ℝ) (hE : 0 < E) :
    ProbabilityMeasure (VelocityConfiguration n) :=
  (uniformEnergySphereProbabilityPackage n E hE).law

/-- The uniform hypersphere law is supported on Borel's energy sphere. -/
theorem uniformEnergySphereProbabilityLaw_supported
    (n : ℕ) (E : ℝ) (hE : 0 < E) :
    (uniformEnergySphereProbabilityLaw n E hE : Measure (VelocityConfiguration n))
      (energySphere n E) = 1 :=
  (uniformEnergySphereProbabilityPackage n E hE).supported_energySphere

/-- Scale extracted from the total energy parameter.  With the constants in
`totalKineticEnergy` absorbed into `E`, this is the nonnegative square-root
scale. -/
noncomputable def sigmaOfEnergy (E : ℝ) : ℝ :=
  Real.sqrt E

/-- First-molecule marginal law coming from positive-energy uniform sphere data.
For nonpositive `E`, the physical energy shell is outside the positive-energy
Borel theorem; the total function is extended by the limiting Maxwell law so that
the historical public API remains total in `E`. -/
noncomputable def uniformEnergySphereVelocityLaw
    (n : ℕ) (E : ℝ) : ProbabilityMeasure OneMoleculeVelocity :=
  if hE : 0 < E then
    (uniformEnergySphereProbabilityLaw n E hE).map
      ((measurable_firstMoleculeVelocity n).aemeasurable)
  else
    maxwellVelocityLaw (sigmaOfEnergy E)

/-- Positive-energy Maxwell--Borel marginal limit.

Upstream boundary.  Exact source anchor: Émile Borel, *Sur les principes de la
théorie cinétique des gaz* (1906), Part IV, pp. 30-31: after deriving the
hypersphere coordinate marginal, Borel identifies the limiting expression as
Maxwell's law and states that each molecule individually has Maxwell's velocity
law; see the recovered OCR witness at
`tmp/t20c_14_levy/borel_1906_principes_kinetique_gaz.txt:941-959`.  The article
is section/equation numbered rather than theorem numbered.  The missing modern
substrate is the asymptotic analysis of uniform surface marginals on
`3 * (n + 1)`-dimensional Euclidean spheres. -/
axiom tendsto_firstMoleculeVelocity_uniformEnergySphereProbabilityLaw
    (E : ℝ) (hE : 0 < E) :
    Tendsto
      (fun n : ℕ =>
        (uniformEnergySphereProbabilityLaw n E hE).map
          ((measurable_firstMoleculeVelocity n).aemeasurable))
      atTop (𝓝 (maxwellVelocityLaw (sigmaOfEnergy E)))

/-- The first-molecule velocity law from Borel's uniform energy sphere converges
to Maxwell's law.  For positive energy this is exactly Borel's hypersphere
limit; for nonpositive energy it follows from the explicit conventional
extension in `uniformEnergySphereVelocityLaw`. -/
theorem tendsto_uniformEnergySphereVelocityLaw (E : ℝ) :
    Tendsto (fun n : ℕ ↦ uniformEnergySphereVelocityLaw n E) atTop
      (𝓝 (maxwellVelocityLaw (sigmaOfEnergy E))) := by
  by_cases hE : 0 < E
  · simpa [uniformEnergySphereVelocityLaw, hE] using
      tendsto_firstMoleculeVelocity_uniformEnergySphereProbabilityLaw E hE
  · have hconst :
        (fun n : ℕ => uniformEnergySphereVelocityLaw n E) =
          fun _ : ℕ => maxwellVelocityLaw (sigmaOfEnergy E) := by
      funext n
      simp [uniformEnergySphereVelocityLaw, hE]
    rw [hconst]
    exact tendsto_const_nhds

end Kinetic
end Probability
end MathlibExpansion
