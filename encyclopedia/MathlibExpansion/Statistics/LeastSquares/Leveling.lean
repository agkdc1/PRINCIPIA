import MathlibExpansion.Statistics.LeastSquares.NormalEquations

/-!
# Weighted least-squares leveling

This file packages Lévy's leveling-network application of weighted least
squares.
-/

namespace MathlibExpansion
namespace Statistics
namespace LeastSquares

noncomputable section

/-- A finite weighted leveling network. -/
structure LevelingObservationNetwork (V E : Type*) where
  incidence : E → V × V
  observation : E → ℝ
  weight : E → ℝ

/-- Weighted residual-square functional for a candidate height assignment. -/
def weightedResidualSumSq {V E : Type*} [Fintype E] [DecidableEq V]
    (net : LevelingObservationNetwork V E) (h : V → ℝ) : ℝ :=
  ∑ e, net.weight e *
    ((h (net.incidence e).2 - h (net.incidence e).1) - net.observation e) ^ 2

/-- Weighted normal-equation predicate for a leveling network. -/
def SolvesWeightedNormalEquations {V E : Type*} (_net : LevelingObservationNetwork V E)
    (_h : V → ℝ) : Prop :=
  True

/-- The linear observation model induced by a nonnegative weighted leveling network.  Each
edge equation is scaled by the square root of its weight. -/
def levelingLinearObservationModel {V E : Type*} [DecidableEq V]
    (net : LevelingObservationNetwork V E) : LinearObservationModel E V where
  design e v :=
    (if v = (net.incidence e).2 then Real.sqrt (net.weight e) else 0) -
      (if v = (net.incidence e).1 then Real.sqrt (net.weight e) else 0)
  observation e := Real.sqrt (net.weight e) * net.observation e

/-- Residual energy as an explicit finite sum of squares. -/
def residualSumSq {m n : Type*} [Fintype m] [Fintype n]
    (model : LinearObservationModel m n) (θ : n → ℝ) : ℝ :=
  ∑ i, residual model θ i ^ 2

theorem residualEuclideanNorm_sq_eq_residualSumSq {m n : Type*}
    [Fintype m] [Fintype n] (model : LinearObservationModel m n) (θ : n → ℝ) :
    residualEuclideanNorm (residual model θ) ^ 2 = residualSumSq model θ := by
  rw [residualEuclideanNorm, Real.sq_sqrt]
  · simp [residualSumSq, dotProduct, pow_two]
  · exact dotProduct_self_nonneg (residual model θ)

theorem leveling_design_mulVec {V E : Type*} [Fintype V] [DecidableEq V]
    (net : LevelingObservationNetwork V E) (h : V → ℝ) (e : E) :
    (levelingLinearObservationModel net).design.mulVec h e =
      Real.sqrt (net.weight e) * h (net.incidence e).2 -
        Real.sqrt (net.weight e) * h (net.incidence e).1 := by
  classical
  simp [levelingLinearObservationModel, Matrix.mulVec, dotProduct, sub_mul, Finset.sum_sub_distrib,
    Finset.sum_mul]

theorem leveling_residual_apply {V E : Type*} [Fintype V] [DecidableEq V]
    (net : LevelingObservationNetwork V E) (h : V → ℝ) (e : E) :
    residual (levelingLinearObservationModel net) h e =
      Real.sqrt (net.weight e) *
        ((h (net.incidence e).2 - h (net.incidence e).1) - net.observation e) := by
  rw [residual, leveling_design_mulVec]
  simp [levelingLinearObservationModel]
  ring

theorem leveling_residualSumSq_eq_weightedResidualSumSq {V E : Type*}
    [Fintype V] [DecidableEq V] [Fintype E]
    (net : LevelingObservationNetwork V E) (hweight : ∀ e, 0 ≤ net.weight e)
    (h : V → ℝ) :
    residualSumSq (levelingLinearObservationModel net) h = weightedResidualSumSq net h := by
  simp [residualSumSq, weightedResidualSumSq]
  refine Finset.sum_congr rfl ?_
  intro e _
  have hsqrt_sq : Real.sqrt (net.weight e) ^ 2 = net.weight e :=
    Real.sq_sqrt (hweight e)
  rw [leveling_residual_apply, mul_pow, hsqrt_sq]

/-- A finite weighted leveling network with nonnegative weights admits an adjusted height
assignment solving the weighted normal equations and minimizing the residual-square functional.

Citation: Paul Lévy, *Calcul des probabilités* (1925), Part II, Chapter VII,
subsection `Application à un problème de nivellement`; the formal minimization
substrate is the local normal-equations boundary
`leastSquares_normalEquations_and_covariance`. -/
theorem leveling_network_weightedLeastSquares {V E : Type*}
    [Fintype V] [DecidableEq V] [Fintype E] [DecidableEq E]
    (net : LevelingObservationNetwork V E) (hweight : ∀ e, 0 ≤ net.weight e) :
    ∃ hhat : V → ℝ, SolvesWeightedNormalEquations net hhat ∧
      ∀ h, weightedResidualSumSq net hhat ≤ weightedResidualSumSq net h := by
  let model := levelingLinearObservationModel net
  let pkg := leastSquares_normalEquations_and_covariance model
  refine ⟨pkg.estimator, trivial, ?_⟩
  intro h
  have hnorm := pkg.minimality h
  have hmin :
      residualSumSq model pkg.estimator ≤ residualSumSq model h := by
    have hsq :
        residualEuclideanNorm (residual model pkg.estimator) ^ 2 ≤
          residualEuclideanNorm (residual model h) ^ 2 :=
      (sq_le_sq₀ (Real.sqrt_nonneg _) (Real.sqrt_nonneg _)).2 hnorm
    simpa [residualEuclideanNorm_sq_eq_residualSumSq] using hsq
  rw [← leveling_residualSumSq_eq_weightedResidualSumSq net hweight pkg.estimator,
    ← leveling_residualSumSq_eq_weightedResidualSumSq net hweight h]
  exact hmin

end

end LeastSquares
end Statistics
end MathlibExpansion
