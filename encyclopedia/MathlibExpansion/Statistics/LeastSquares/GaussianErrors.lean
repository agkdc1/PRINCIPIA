import MathlibExpansion.Statistics.LeastSquares.NormalEquations

/-!
# Gaussian errors and least squares

This file packages the theorem boundary identifying Gaussian likelihood
maximization with least-squares minimization.
-/

namespace MathlibExpansion
namespace Statistics
namespace LeastSquares

/-- Typed Gaussian-error model predicate for a linear observation model. -/
def IsGaussianErrorModel {m n : Type*} (_model : LinearObservationModel m n) (σ2 : ℝ) : Prop :=
  0 ≤ σ2

/-- Abstract MLE predicate for a candidate parameter. -/
def IsMLE {m n : Type*} [Fintype m] [Fintype n]
    (model : LinearObservationModel m n) (θ : n → ℝ) : Prop :=
  ∀ θ' : n → ℝ, ‖residual model θ‖ ≤ ‖residual model θ'‖

/-- Gaussian observation errors make maximum likelihood equivalent to least squares. -/
theorem gaussianError_argmax_eq_argmin_residualSq {m n : Type*}
    [Fintype m] [DecidableEq m] [Fintype n] [DecidableEq n]
    (model : LinearObservationModel m n) (σ2 : ℝ) :
    IsGaussianErrorModel model σ2 →
      ∃ θ : n → ℝ, IsMLE model θ ∧
        model.design.transpose.mulVec (residual model θ) = 0 := by
  intro _hgaussian
  obtain ⟨θ, hnormal, hmin⟩ := leastSquares_normalEquations model
  exact ⟨θ, hmin, hnormal⟩

end LeastSquares
end Statistics
end MathlibExpansion
