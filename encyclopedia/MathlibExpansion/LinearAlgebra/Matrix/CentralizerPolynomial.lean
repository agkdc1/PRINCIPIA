 /-
 Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
 Released under Apache 2.0 license as described in the file LICENSE.
 Authors: Mathlib Expansion contributors
 -/
import Mathlib.Data.Matrix.Notation
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic

 /-!
 # Quarantine for Cayley's Art. 33

 Cayley's unrestricted claim that every matrix commuting with `M` is a
 polynomial in `M` is false. The zero matrix commutes with every matrix, but
 evaluating a polynomial at `0` only produces scalar matrices.
 -/

open Polynomial

namespace Matrix

section CentralizerPolynomial

/-- A `2 x 2` matrix with vanishing off-diagonal entries and equal diagonal
entries is scalar. -/
private theorem exists_smul_one_of_fin_two
    {K : Type*} [Field K] (M : Matrix (Fin 2) (Fin 2) K)
    (h01 : M 0 1 = 0) (h10 : M 1 0 = 0) (hdiag : M 0 0 = M 1 1) :
    ∃ μ : K, M = μ • (1 : Matrix (Fin 2) (Fin 2) K) := by
  refine ⟨M 0 0, ?_⟩
  ext i j
  fin_cases i <;> fin_cases j <;> simp [h01, h10, hdiag]

/-- A concrete non-scalar matrix commuting with `0`. -/
def art33CounterexampleCommuter : Matrix (Fin 2) (Fin 2) ℚ :=
  !![(0 : ℚ), 1; 0, 0]

/-- The Art. 33 counterexample commutes with the zero matrix. -/
theorem art33_counterexample_commutes_zero :
    Commute art33CounterexampleCommuter (0 : Matrix (Fin 2) (Fin 2) ℚ) := by
  unfold Commute art33CounterexampleCommuter
  ext i j
  fin_cases i <;> fin_cases j
  · simp
  · simp
  · simp
  · simp

/-- Evaluating a polynomial at the zero matrix cannot produce the Art. 33
counterexample, because the result is always scalar. -/
theorem not_exists_polynomial_aeval_zero_eq_art33_counterexample :
    ¬ ∃ p : ℚ[X], aeval (0 : Matrix (Fin 2) (Fin 2) ℚ) p = art33CounterexampleCommuter := by
  intro h
  rcases h with ⟨p, hp⟩
  have h01 := congrFun (congrFun hp 0) 1
  simp [art33CounterexampleCommuter] at h01
  have hz : (aeval (0 : Matrix (Fin 2) (Fin 2) ℚ) p) 0 1 = 0 := by
    simp [aeval_def, Matrix.algebraMap_eq_diagonal, Matrix.scalar_apply]
  exact zero_ne_one (hz.symm.trans h01)

 /-- Machine-checked quarantine for the raw Art. 33 claim. -/
theorem exists_commuting_matrix_not_polynomial_in_zero :
    ∃ L : Matrix (Fin 2) (Fin 2) ℚ,
      Commute L (0 : Matrix (Fin 2) (Fin 2) ℚ) ∧
      ¬ ∃ p : ℚ[X], aeval (0 : Matrix (Fin 2) (Fin 2) ℚ) p = L := by
  refine ⟨art33CounterexampleCommuter, art33_counterexample_commutes_zero, ?_⟩
  exact not_exists_polynomial_aeval_zero_eq_art33_counterexample

section TwoByTwo

variable {K : Type*} [Field K]

/-- For a non-scalar `2 x 2` matrix, every commuting matrix is affine in it. -/
theorem exists_affine_of_commute_of_not_scalar_fin_two
    (M L : Matrix (Fin 2) (Fin 2) K)
    (hns : ¬ ∃ μ : K, M = μ • (1 : Matrix (Fin 2) (Fin 2) K))
    (hcomm : Commute L M) :
    ∃ a b : K, L = a • M + b • (1 : Matrix (Fin 2) (Fin 2) K) := by
  rcases Matrix.two_mul_expl L M with ⟨hLM00, hLM01, hLM10, _⟩
  rcases Matrix.two_mul_expl M L with ⟨hML00, hML01, hML10, _⟩
  have h00 : L 0 1 * M 1 0 = M 0 1 * L 1 0 := by
    have h := congrFun (congrFun hcomm.eq 0) 0
    rw [hLM00, hML00] at h
    have h' : L 0 0 * M 0 0 + L 0 1 * M 1 0 = L 0 0 * M 0 0 + M 0 1 * L 1 0 := by
      simpa [mul_comm, mul_left_comm, mul_assoc] using h
    exact add_left_cancel h'
  have h01 : M 0 1 * (L 0 0 - L 1 1) = L 0 1 * (M 0 0 - M 1 1) := by
    have h := congrFun (congrFun hcomm.eq 0) 1
    rw [hLM01, hML01] at h
    have h' : M 0 1 * L 0 0 + L 0 1 * M 1 1 = L 0 1 * M 0 0 + M 0 1 * L 1 1 := by
      simpa [mul_comm, mul_left_comm, mul_assoc] using h
    have h'' : M 0 1 * L 0 0 - M 0 1 * L 1 1 = L 0 1 * M 0 0 - L 0 1 * M 1 1 := by
      linear_combination h'
    calc
      M 0 1 * (L 0 0 - L 1 1) = M 0 1 * L 0 0 - M 0 1 * L 1 1 := by ring
      _ = L 0 1 * M 0 0 - L 0 1 * M 1 1 := h''
      _ = L 0 1 * (M 0 0 - M 1 1) := by ring
  have h10 : M 1 0 * (L 0 0 - L 1 1) = L 1 0 * (M 0 0 - M 1 1) := by
    have h := congrFun (congrFun hcomm.eq 1) 0
    rw [hLM10, hML10] at h
    have h' : M 1 0 * L 0 0 + L 1 0 * M 1 1 = L 1 0 * M 0 0 + M 1 0 * L 1 1 := by
      simpa [mul_comm, mul_left_comm, mul_assoc] using h.symm
    have h'' : M 1 0 * L 0 0 - M 1 0 * L 1 1 = L 1 0 * M 0 0 - L 1 0 * M 1 1 := by
      linear_combination h'
    calc
      M 1 0 * (L 0 0 - L 1 1) = M 1 0 * L 0 0 - M 1 0 * L 1 1 := by ring
      _ = L 1 0 * M 0 0 - L 1 0 * M 1 1 := h''
      _ = L 1 0 * (M 0 0 - M 1 1) := by ring
  by_cases hq0 : M 0 1 = 0
  · by_cases hr0 : M 1 0 = 0
    · have hdiag : M 0 0 ≠ M 1 1 := by
        intro hEq
        exact hns (exists_smul_one_of_fin_two M hq0 hr0 hEq)
      have hsub : M 0 0 - M 1 1 ≠ 0 := sub_ne_zero.mpr hdiag
      have hyMul : L 0 1 * (M 0 0 - M 1 1) = 0 := by
        simpa [hq0] using h01.symm
      have hzMul : L 1 0 * (M 0 0 - M 1 1) = 0 := by
        simpa [hr0] using h10.symm
      have hy : L 0 1 = 0 := by
        exact (mul_eq_zero.mp hyMul).resolve_right hsub
      have hz : L 1 0 = 0 := by
        exact (mul_eq_zero.mp hzMul).resolve_right hsub
      let a : K := (L 0 0 - L 1 1) / (M 0 0 - M 1 1)
      let b : K := L 0 0 - a * M 0 0
      refine ⟨a, b, ?_⟩
      ext i j
      fin_cases i <;> fin_cases j
      · simp [a, b]
      · simp [a, b, hq0, hy]
      · simp [a, b, hr0, hz]
      · field_simp [a, b, hsub]
        ring
    · have hr : M 1 0 ≠ 0 := hr0
      have hyMul : L 0 1 * M 1 0 = 0 := by
        simpa [hq0] using h00
      have hy : L 0 1 = 0 := by
        exact (mul_eq_zero.mp hyMul).resolve_right hr
      let a : K := L 1 0 / M 1 0
      let b : K := L 0 0 - a * M 0 0
      refine ⟨a, b, ?_⟩
      ext i j
      fin_cases i <;> fin_cases j
      · simp [a, b]
      · simp [a, b, hq0, hy]
      · simp [a, b, hr]
      · have hdiff : L 0 0 - L 1 1 = a * (M 0 0 - M 1 1) := by
          field_simp [a, hr]
          simpa [mul_comm, mul_left_comm, mul_assoc] using h10
        calc
          L 1 1 = L 0 0 - a * (M 0 0 - M 1 1) := by
            rw [← hdiff]
            ring
          _ = a * M 1 1 + b := by
            dsimp [b]
            ring
          _ = (a • M + b • (1 : Matrix (Fin 2) (Fin 2) K)) 1 1 := by
            simp
  · have hq : M 0 1 ≠ 0 := hq0
    let a : K := L 0 1 / M 0 1
    let b : K := L 0 0 - a * M 0 0
    refine ⟨a, b, ?_⟩
    ext i j
    fin_cases i <;> fin_cases j
    · simp [a, b]
    · simp [a, b, hq]
    · field_simp [a, hq]
      calc
        L 1 0 * M 0 1 = M 0 1 * L 1 0 := by ring
        _ = L 0 1 * M 1 0 := by simpa [mul_comm, mul_left_comm, mul_assoc] using h00.symm
    · have hdiff : L 0 0 - L 1 1 = a * (M 0 0 - M 1 1) := by
        field_simp [a, hq]
        simpa [mul_comm, mul_left_comm, mul_assoc] using h01
      calc
        L 1 1 = L 0 0 - a * (M 0 0 - M 1 1) := by
          rw [← hdiff]
          ring
        _ = a * M 1 1 + b := by
          dsimp [b]
          ring
        _ = (a • M + b • (1 : Matrix (Fin 2) (Fin 2) K)) 1 1 := by
          simp

/-- The affine description is equivalent to commutation for a non-scalar `2 x 2`
matrix. -/
theorem commute_iff_exists_affine_of_not_scalar_fin_two
    (M L : Matrix (Fin 2) (Fin 2) K)
    (hns : ¬ ∃ μ : K, M = μ • (1 : Matrix (Fin 2) (Fin 2) K)) :
    Commute L M ↔ ∃ a b : K, L = a • M + b • (1 : Matrix (Fin 2) (Fin 2) K) := by
  constructor
  · exact exists_affine_of_commute_of_not_scalar_fin_two M L hns
  · rintro ⟨a, b, rfl⟩
    unfold Commute
    calc
      (a • M + b • (1 : Matrix (Fin 2) (Fin 2) K)) * M = a • (M * M) + b • M := by
        simp [add_mul]
      _ = M * (a • M + b • (1 : Matrix (Fin 2) (Fin 2) K)) := by
        simp [mul_add]

/-- Honest `2 x 2` repair of Cayley's square-root corollary: for a non-scalar
matrix, every square root is affine in that matrix. -/
theorem exists_affine_of_sq_eq_of_not_scalar_fin_two
    (M L : Matrix (Fin 2) (Fin 2) K)
    (hns : ¬ ∃ μ : K, M = μ • (1 : Matrix (Fin 2) (Fin 2) K))
    (hSq : L ^ 2 = M) :
    ∃ a b : K, L = a • M + b • (1 : Matrix (Fin 2) (Fin 2) K) := by
  apply exists_affine_of_commute_of_not_scalar_fin_two M L hns
  have hcomm : Commute L (L ^ 2) := (Commute.refl L).pow_right 2
  simpa [hSq] using hcomm

end TwoByTwo

end CentralizerPolynomial

end Matrix
