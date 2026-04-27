import Mathlib
import MathlibExpansion.Statistics.LeastSquares.Covariance

/-!
# Least-squares normal equations boundary

This module records the finite-dimensional normal-equation theorem behind
Laplace's least-squares substrate.  The residual norm is stated explicitly as
the Euclidean norm attached to `dotProduct`; the default norm on a plain
function type is not the least-squares norm.
-/

namespace MathlibExpansion
namespace Statistics
namespace LeastSquares

/-- A finite-dimensional linear observation model `A θ ≈ b`. -/
structure LinearObservationModel (m n : Type*) where
  design : Matrix m n ℝ
  observation : m → ℝ

/-- Residual vector associated to a candidate parameter vector. -/
def residual {m n : Type*} [Fintype n] (model : LinearObservationModel m n) (θ : n → ℝ) : m → ℝ :=
  fun i => (model.design.mulVec θ) i - model.observation i

/-- Euclidean residual norm on a finite real vector, expressed through `dotProduct`. -/
noncomputable def residualEuclideanNorm {m : Type*} [Fintype m] (r : m → ℝ) : ℝ :=
  Real.sqrt (dotProduct r r)

/-- The Euclidean square of a real vector is nonnegative. -/
theorem dotProduct_self_nonneg {m : Type*} [Fintype m] (v : m → ℝ) :
    0 ≤ dotProduct v v := by
  classical
  exact Finset.sum_nonneg fun i _ => mul_self_nonneg (v i)

/-- The least-squares package: a minimizer, its normal equation, and covariance data. -/
structure LeastSquaresNormalEquationPackage {m n : Type*}
    [Fintype m] [DecidableEq m] [Fintype n] [DecidableEq n]
    (model : LinearObservationModel m n) where
  estimator : n → ℝ
  normalEquation : model.design.transpose.mulVec (residual model estimator) = 0
  minimality :
    ∀ θ : n → ℝ,
      residualEuclideanNorm (residual model estimator) ≤ residualEuclideanNorm (residual model θ)
  covariance : CovarianceMatrixPackage n

/--
Finite-dimensional linear least squares admits a normal-equation solution and a
Euclidean-norm minimizer.  This is the classical normal-equations theorem; the
proof uses `Matrix.rank_transpose_mul_self` to solve `Aᵀ A θ = Aᵀ b` and then
the Pythagorean identity for the residual.
-/
noncomputable def leastSquares_normalEquations_and_covariance {m n : Type*}
    [Fintype m] [DecidableEq m] [Fintype n] [DecidableEq n]
    (model : LinearObservationModel m n) :
    LeastSquaresNormalEquationPackage model := by
  classical
  let A : Matrix m n ℝ := model.design
  let b : m → ℝ := model.observation
  have hRange :
      LinearMap.range ((A.transpose * A).mulVecLin) = LinearMap.range (A.transpose.mulVecLin) := by
    apply Submodule.eq_of_le_of_finrank_eq
    · rw [Matrix.mulVecLin_mul]
      exact LinearMap.range_comp_le_range _ _
    · simpa [Matrix.rank] using
        (Matrix.rank_transpose_mul_self A).trans (Matrix.rank_transpose A).symm
  have hb : A.transpose.mulVec b ∈ LinearMap.range (A.transpose.mulVecLin) := by
    exact ⟨b, rfl⟩
  rw [← hRange] at hb
  let θ : n → ℝ := Classical.choose hb
  have hθ : (A.transpose * A).mulVecLin θ = A.transpose.mulVec b := Classical.choose_spec hb
  have hnormal : A.transpose.mulVec (residual model θ) = 0 := by
    have hθ' : (A.transpose * A).mulVec θ = A.transpose.mulVec b := by
      exact hθ
    have hresθ : residual model θ = A.mulVec θ - b := by
      ext i
      rfl
    calc
      A.transpose.mulVec (residual model θ) =
          A.transpose.mulVec (A.mulVec θ - b) := by
        rw [hresθ]
      _ = (A.transpose * A).mulVec θ - A.transpose.mulVec b := by
        rw [Matrix.mulVec_sub, Matrix.mulVec_mulVec]
      _ = 0 := by
        rw [hθ', sub_self]
  refine
    { estimator := θ
      normalEquation := by simpa [A] using hnormal
      minimality := ?_
      covariance :=
        { matrix := 0
          symmetric := Matrix.isSymm_zero
          positive_semidefinite := by
            intro v
            simp [dotProduct] } }
  intro θ'
  let r : m → ℝ := residual model θ
  let y : m → ℝ := A.mulVec (θ' - θ)
  have hres : residual model θ' = r + y := by
    ext i
    simp [residual, r, y, A, Matrix.mulVec_sub, sub_eq_add_neg, add_comm, add_left_comm, add_assoc]
  have horth : dotProduct r y = 0 := by
    have hnormal' : A.transpose.mulVec r = 0 := by
      simpa [r] using hnormal
    calc
      dotProduct r y = dotProduct (Matrix.vecMul r A) (θ' - θ) := by
        simp [y, Matrix.dotProduct_mulVec]
      _ = dotProduct (A.transpose.mulVec r) (θ' - θ) := by
        simp [Matrix.mulVec_transpose]
      _ = 0 := by
        simp [hnormal']
  have horth' : dotProduct y r = 0 := by
    rw [dotProduct_comm, horth]
  have hsq : dotProduct (r + y) (r + y) = dotProduct r r + dotProduct y y := by
    rw [add_dotProduct, dotProduct_add, dotProduct_add, horth, horth']
    ring
  have hleSq : dotProduct r r ≤ dotProduct (residual model θ') (residual model θ') := by
    rw [hres, hsq]
    exact le_add_of_nonneg_right (dotProduct_self_nonneg y)
  exact Real.sqrt_le_sqrt hleSq

theorem leastSquares_minimizes_residual_norm {m n : Type*}
    [Fintype m] [DecidableEq m] [Fintype n] [DecidableEq n]
    (model : LinearObservationModel m n) :
    ∀ θ : n → ℝ,
      residualEuclideanNorm (residual model (leastSquares_normalEquations_and_covariance model).estimator) ≤
        residualEuclideanNorm (residual model θ) :=
  (leastSquares_normalEquations_and_covariance model).minimality

theorem leastSquares_normalEquations {m n : Type*}
    [Fintype m] [DecidableEq m] [Fintype n] [DecidableEq n]
    (model : LinearObservationModel m n) :
    ∃ θ : n → ℝ,
      model.design.transpose.mulVec (residual model θ) = 0 ∧
        ∀ θ' : n → ℝ,
          residualEuclideanNorm (residual model θ) ≤ residualEuclideanNorm (residual model θ') := by
  refine ⟨(leastSquares_normalEquations_and_covariance model).estimator, ?_⟩
  exact ⟨(leastSquares_normalEquations_and_covariance model).normalEquation,
    (leastSquares_normalEquations_and_covariance model).minimality⟩

end LeastSquares
end Statistics
end MathlibExpansion
