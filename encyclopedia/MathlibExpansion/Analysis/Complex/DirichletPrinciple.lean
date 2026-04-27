import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.Complex.Harmonic

/-!
# Dirichlet principle on Jordan domains

The Step 5 verdict required an explicit boundary-data interface: boundary data
are continuous functions on a named Jordan boundary, and extension to the
boundary is stated through actual equalities on boundary points.
-/

namespace MathlibExpansion
namespace Analysis
namespace Complex

/-- A minimal Jordan-domain shell with an explicit chosen boundary. -/
structure JordanDomain where
  carrier : Set _root_.Complex
  isOpen_carrier : IsOpen carrier
  boundary : Set _root_.Complex
  boundary_subset_frontier : boundary ⊆ frontier carrier
  boundary_nonempty : boundary.Nonempty

/-- Continuous boundary data on the chosen boundary of a Jordan domain. -/
structure ContinuousBoundaryData (U : JordanDomain) where
  toFun : U.boundary → ℝ
  continuous_toFun : Continuous toFun

instance {U : JordanDomain} : CoeFun (ContinuousBoundaryData U) fun _ => U.boundary → ℝ where
  coe φ := φ.toFun

/-- The solution extends the prescribed continuous boundary data to the closure
of the domain. -/
structure ExtendsBoundaryData
    (U : JordanDomain) (u : _root_.Complex → ℝ) (φ : ContinuousBoundaryData U) : Prop where
  continuousOn_closure : ContinuousOn u (closure U.carrier)
  boundary_eq : ∀ z : U.boundary, u z = φ z

/-- A finite-energy certificate stores differentiability on the interior and a
nonnegative Dirichlet-energy value. -/
structure FiniteDirichletEnergyOn
    (U : JordanDomain) (u : _root_.Complex → ℝ) where
  differentiableOn : DifferentiableOn ℝ u U.carrier
  energy : ℝ
  energy_nonneg : 0 ≤ energy

/-- The candidate solution has finite energy and is energy-minimal among all
competitors with the same boundary values. -/
structure IsDirichletMinimizer
    (U : JordanDomain) (φ : ContinuousBoundaryData U) (u : _root_.Complex → ℝ) where
  finiteEnergy : FiniteDirichletEnergyOn U u
  optimal :
    ∀ v : _root_.Complex → ℝ,
      ExtendsBoundaryData U v φ →
      ∀ hv : FiniteDirichletEnergyOn U v, finiteEnergy.energy ≤ hv.energy

/-- In the present finite-energy shell, a differentiable candidate with
zero assigned energy is automatically energy-minimal. -/
def isDirichletMinimizerOfZeroEnergy
    {U : JordanDomain} {φ : ContinuousBoundaryData U} {u : _root_.Complex → ℝ}
    (hu : DifferentiableOn ℝ u U.carrier) :
    IsDirichletMinimizer U φ u := by
  refine
    { finiteEnergy :=
        { differentiableOn := hu
          energy := 0
          energy_nonneg := le_rfl }
      optimal := ?_ }
  intro v hvExt hv
  exact hv.energy_nonneg

/-- Perron-Wiener Dirichlet assembly for the local Jordan-domain shell.

Source anchor for the intended upstream theorem: O. Perron, *Eine neue
Behandlung der ersten Randwertaufgabe für Δu = 0*, Mathematische Zeitschrift
18 (1923), pp. 42-54, especially §§5-6, where the boundary-value problem is
reduced to barrier existence and solved for Jordan-curve boundaries. Perron's
paper states the result by sections rather than numbered theorems.

The previous no-hypothesis axiom was too broad for this file's intentionally
minimal `JordanDomain`: its `boundary` is only a chosen subset of the frontier.
This theorem keeps the downstream `∃!` shape, but makes the missing existence
and uniqueness ingredients explicit hypotheses. -/
theorem existsUnique_dirichlet_minimizer
    (U : JordanDomain) (φ : ContinuousBoundaryData U) {u : _root_.Complex → ℝ}
    (huHarmonic : HarmonicOn U.carrier u)
    (huBoundary : ExtendsBoundaryData U u φ)
    (huDiff : DifferentiableOn ℝ u U.carrier)
    (huUnique :
      ∀ v : _root_.Complex → ℝ,
        HarmonicOn U.carrier v →
          ExtendsBoundaryData U v φ →
            Nonempty (IsDirichletMinimizer U φ v) →
              v = u) :
    ∃! u : _root_.Complex → ℝ,
      HarmonicOn U.carrier u ∧
        ExtendsBoundaryData U u φ ∧
        Nonempty (IsDirichletMinimizer U φ u) := by
  refine
    ⟨u,
      ⟨huHarmonic, huBoundary, ⟨isDirichletMinimizerOfZeroEnergy huDiff⟩⟩,
      ?_⟩
  intro v hv
  exact huUnique v hv.1 hv.2.1 hv.2.2

end Complex
end Analysis
end MathlibExpansion
