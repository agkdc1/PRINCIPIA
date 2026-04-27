import Mathlib

/-!
# Covariance and error-propagation API

This file provides the typed covariance surface needed by Laplace's
multi-parameter correction theory.
-/

namespace MathlibExpansion
namespace Statistics
namespace LeastSquares

/-- Covariance data for a finite-dimensional parameter vector. -/
structure CovarianceMatrixPackage (n : Type*) [Fintype n] [DecidableEq n] where
  matrix : Matrix n n ℝ
  symmetric : matrix.IsSymm
  positive_semidefinite : ∀ v : n → ℝ, 0 ≤ dotProduct v (matrix.mulVec v)

/-- Linear error propagation sends `Σ` to `L Σ Lᵀ`. -/
def linearErrorPropagation {n p : Type*}
    [Fintype n] [DecidableEq n] [Fintype p] [DecidableEq p]
    (S : CovarianceMatrixPackage n) (L : Matrix p n ℝ) : Matrix p p ℝ :=
  L * S.matrix * L.transpose

/-- The covariance of a linear image is the propagated covariance matrix. -/
def CovarianceOfLinearImage {n p : Type*}
    [Fintype n] [DecidableEq n] [Fintype p] [DecidableEq p]
    (S : CovarianceMatrixPackage n) (L : Matrix p n ℝ) : Matrix p p ℝ :=
  linearErrorPropagation S L

theorem covariance_linearImage_of_leastSquares {n p : Type*}
    [Fintype n] [DecidableEq n] [Fintype p] [DecidableEq p]
    (S : CovarianceMatrixPackage n) (L : Matrix p n ℝ) :
    CovarianceOfLinearImage S L = linearErrorPropagation S L :=
  rfl

end LeastSquares
end Statistics
end MathlibExpansion
