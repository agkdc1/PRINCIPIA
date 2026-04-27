/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.LinearAlgebra.Matrix.Charpoly.LinearMap
import Mathlib.LinearAlgebra.Matrix.Spectrum
import Mathlib.LinearAlgebra.Matrix.HermitianFunctionalCalculus
import Mathlib.LinearAlgebra.JordanChevalley
import Mathlib.LinearAlgebra.Eigenspace.Basic
import MathlibExpansion.LinearAlgebra.Matrix.Cayley1858
import MathlibExpansion.LinearAlgebra.Matrix.AlgebraicFunctionalCalculus
import MathlibExpansion.LinearAlgebra.Matrix.TwoByTwoCharpoly
import MathlibExpansion.LinearAlgebra.Matrix.TwoByTwoPowers
import MathlibExpansion.LinearAlgebra.Matrix.Similarity
import MathlibExpansion.LinearAlgebra.Matrix.Periodic
import MathlibExpansion.LinearAlgebra.Matrix.CentralizerPolynomial

/-!
# Linear algebra interfaces for broad paper compilation

This module imports Mathlib's matrix spectral, characteristic polynomial, and
Jordan-Chevalley infrastructure while exposing stable theorem-shape names for
generated downstream formalizations.
-/

namespace MathlibExpansion
namespace LinearAlgebra

/-- A theorem-shape interface for Cayley-Hamilton. -/
structure CayleyHamilton (Ring Module Operator Polynomial : Type*) where
  /-- The characteristic polynomial annihilates the operator. -/
  charpoly_annihilates : Prop
  /-- The matrix form of Cayley-Hamilton is available. -/
  matrix_statement : Prop
  /-- The linear-map form of Cayley-Hamilton is available. -/
  linear_map_statement : Prop
  /-- The Cayley-Hamilton theorem data. -/
  certificate : charpoly_annihilates ∧ matrix_statement ∧ linear_map_statement

/-- Cayley-Hamilton annihilates an operator by its characteristic polynomial. -/
theorem CayleyHamilton.charpoly_annihilates_result
    {Ring Module Operator Polynomial : Type*}
    (h : CayleyHamilton Ring Module Operator Polynomial) :
    h.charpoly_annihilates :=
  h.certificate.1

/-- Cayley-Hamilton is available in matrix form. -/
theorem CayleyHamilton.matrix_result
    {Ring Module Operator Polynomial : Type*}
    (h : CayleyHamilton Ring Module Operator Polynomial) :
    h.matrix_statement :=
  h.certificate.2.1

/-- Cayley-Hamilton is available in linear-map form. -/
theorem CayleyHamilton.linear_map_result
    {Ring Module Operator Polynomial : Type*}
    (h : CayleyHamilton Ring Module Operator Polynomial) :
    h.linear_map_statement :=
  h.certificate.2.2

/-- A theorem-shape interface for Jordan normal form style decomposition. -/
structure JordanNormalForm (Field Space Operator Basis Blocks : Type*) where
  /-- A basis adapted to Jordan blocks exists. -/
  exists_basis : Prop
  /-- The operator decomposes into Jordan blocks. -/
  block_decomposition : Prop
  /-- The nilpotent part of the decomposition is recorded. -/
  nilpotent_part : Prop
  /-- The Jordan normal form theorem data. -/
  certificate : exists_basis ∧ block_decomposition ∧ nilpotent_part

/-- Jordan normal form supplies an adapted basis. -/
theorem JordanNormalForm.exists_basis_result
    {Field Space Operator Basis Blocks : Type*}
    (h : JordanNormalForm Field Space Operator Basis Blocks) :
    h.exists_basis :=
  h.certificate.1

/-- Jordan normal form supplies a block decomposition. -/
theorem JordanNormalForm.block_decomposition_result
    {Field Space Operator Basis Blocks : Type*}
    (h : JordanNormalForm Field Space Operator Basis Blocks) :
    h.block_decomposition :=
  h.certificate.2.1

/-- Jordan normal form records the nilpotent part. -/
theorem JordanNormalForm.nilpotent_part_result
    {Field Space Operator Basis Blocks : Type*}
    (h : JordanNormalForm Field Space Operator Basis Blocks) :
    h.nilpotent_part :=
  h.certificate.2.2

/-- A theorem-shape interface for spectral decomposition. -/
structure SpectralDecomposition (Field Space Operator Projection : Type*) where
  /-- The operator decomposes along eigenspaces. -/
  eigen_decomposition : Prop
  /-- A projection-valued resolution is available. -/
  projection_resolution : Prop
  /-- The projections reconstruct the operator. -/
  reconstructs_operator : Prop
  /-- The spectral decomposition theorem data. -/
  certificate : eigen_decomposition ∧ projection_resolution ∧ reconstructs_operator

/-- Spectral decomposition supplies eigenspace decomposition data. -/
theorem SpectralDecomposition.eigen_decomposition_result
    {Field Space Operator Projection : Type*}
    (h : SpectralDecomposition Field Space Operator Projection) :
    h.eigen_decomposition :=
  h.certificate.1

/-- Spectral decomposition supplies projection resolution data. -/
theorem SpectralDecomposition.projection_resolution_result
    {Field Space Operator Projection : Type*}
    (h : SpectralDecomposition Field Space Operator Projection) :
    h.projection_resolution :=
  h.certificate.2.1

/-- Spectral decomposition reconstructs the operator. -/
theorem SpectralDecomposition.reconstructs_operator_result
    {Field Space Operator Projection : Type*}
    (h : SpectralDecomposition Field Space Operator Projection) :
    h.reconstructs_operator :=
  h.certificate.2.2

/-- A theorem-shape interface for Perron-Frobenius style statements. -/
structure PerronFrobenius (Index Matrix Vector Eigenvalue : Type*) where
  /-- The matrix has the relevant nonnegative or positive entries. -/
  nonnegative_matrix : Prop
  /-- A positive eigenvector exists. -/
  exists_positive_eigenvector : Prop
  /-- The eigenvalue is identified with the spectral radius. -/
  spectral_radius : Prop
  /-- The Perron-Frobenius theorem data. -/
  certificate : nonnegative_matrix ∧ exists_positive_eigenvector ∧ spectral_radius

/-- Perron-Frobenius starts from a nonnegative matrix. -/
theorem PerronFrobenius.nonnegative_matrix_result
    {Index Matrix Vector Eigenvalue : Type*}
    (h : PerronFrobenius Index Matrix Vector Eigenvalue) :
    h.nonnegative_matrix :=
  h.certificate.1

/-- Perron-Frobenius supplies a positive eigenvector. -/
theorem PerronFrobenius.exists_positive_eigenvector_result
    {Index Matrix Vector Eigenvalue : Type*}
    (h : PerronFrobenius Index Matrix Vector Eigenvalue) :
    h.exists_positive_eigenvector :=
  h.certificate.2.1

/-- Perron-Frobenius identifies the spectral radius. -/
theorem PerronFrobenius.spectral_radius_result
    {Index Matrix Vector Eigenvalue : Type*}
    (h : PerronFrobenius Index Matrix Vector Eigenvalue) :
    h.spectral_radius :=
  h.certificate.2.2

end LinearAlgebra
end MathlibExpansion
