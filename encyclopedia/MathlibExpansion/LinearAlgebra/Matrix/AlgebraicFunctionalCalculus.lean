/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.RingTheory.Adjoin.Polynomial
import MathlibExpansion.LinearAlgebra.Matrix.CentralizerPolynomial

/-!
# Reduced polynomial representatives in `K[M]`

This module records the degree-reduction statement that is already available for
elements of the one-generator algebra `K[M]`: every such element has a
polynomial representative of degree strictly less than the matrix size.
-/

open Polynomial

namespace Matrix

section AlgebraicFunctionalCalculus

variable {n : Type*} {K : Type*}
variable [Fintype n] [DecidableEq n] [Field K] [Nonempty n]

/-- Every element of `K[M]` has a representative of degree `< card n`. -/
theorem exists_reduced_polynomial_of_mem_adjoin_singleton
    {M L : Matrix n n K} (hL : L ∈ Algebra.adjoin K ({M} : Set (Matrix n n K))) :
    ∃ p : K[X], p.natDegree < Fintype.card n ∧ aeval M p = L := by
  have hRange : L ∈ Set.range (Polynomial.aeval (R := K) M) := by
    simpa [Algebra.adjoin_singleton_eq_range_aeval (R := K) (x := M)] using hL
  rcases hRange with ⟨p, rfl⟩
  refine ⟨p %ₘ M.charpoly, ?_, (Matrix.aeval_eq_aeval_mod_charpoly M p).symm⟩
  have hcard : 0 < Fintype.card n := Fintype.card_pos_iff.mpr ‹Nonempty n›
  have hchar_ne_one : M.charpoly ≠ 1 := by
    intro h
    have hdeg := congrArg Polynomial.natDegree h
    simp [Matrix.charpoly_natDegree_eq_dim (M := M), hcard.ne'] at hdeg
  simpa [Matrix.charpoly_natDegree_eq_dim (M := M)] using
    (Polynomial.natDegree_modByMonic_lt p M.charpoly_monic hchar_ne_one)

/-- Honest `2 x 2` square-root corollary: a square root of a non-scalar matrix
is affine in that matrix. The non-scalar hypothesis is necessary; scalar
matrices can have non-scalar square roots. -/
theorem exists_affine_square_root_of_not_scalar_fin_two
    (M L : Matrix (Fin 2) (Fin 2) K)
    (hns : ¬ ∃ μ : K, M = μ • (1 : Matrix (Fin 2) (Fin 2) K))
    (hSq : L ^ 2 = M) :
    ∃ a b : K, L = a • M + b • (1 : Matrix (Fin 2) (Fin 2) K) :=
  Matrix.exists_affine_of_sq_eq_of_not_scalar_fin_two M L hns hSq

end AlgebraicFunctionalCalculus

end Matrix
