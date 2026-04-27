import Mathlib.Data.Real.Basic

import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Gradient potential shell for Maxwell

This file fixes the public spatial carrier for the Maxwell Step 6 breach queue
to `EuclideanSpace ℝ (Fin 3)` and packages the basic "field from potential"
interface used by the electrostatics and vector-calculus chapters.
-/

noncomputable section

open scoped Gradient

namespace MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's public spatial carrier for the first breach wave. -/
abbrev SpatialPoint := EuclideanSpace ℝ (Fin 3)

/-- Scalar fields on Maxwell's three-dimensional Euclidean space. -/
abbrev ScalarField := SpatialPoint → ℝ

/-- Vector fields on Maxwell's three-dimensional Euclidean space. -/
abbrev VectorField := SpatialPoint → SpatialPoint

/-- The coordinate partial derivative obtained by varying one coordinate line. -/
def partialDeriv (i : Fin 3) (f : ScalarField) (x : SpatialPoint) : ℝ :=
  deriv (fun t : ℝ => f (Function.update x i t)) (x i)

/-- The gradient packaged as a vector field. -/
def gradientField (V : ScalarField) : VectorField := fun x => ∇ V x

/-- The electrostatic field attached to a scalar potential. -/
def electricFieldFromPotential (V : ScalarField) : VectorField := fun x => -(gradientField V x)

/-- Predicate recording that a vector field comes from a scalar potential. -/
def ElectricFieldIsGradientPotential (V : ScalarField) (E : VectorField) : Prop :=
  ∀ x, E x = electricFieldFromPotential V x

/-- Maxwell's electrostatic force field is the negative gradient of the potential. -/
theorem electricField_eq_neg_gradient_potential (V : ScalarField) :
    ∃ E : VectorField, ∀ x, E x = -(∇ V x) := by
  refine ⟨electricFieldFromPotential V, ?_⟩
  intro x
  rfl

/-- The packaged electric field satisfies the gradient-potential interface. -/
theorem electricFieldFromPotential_spec (V : ScalarField) :
    ElectricFieldIsGradientPotential V (electricFieldFromPotential V) := by
  intro x
  rfl

end MathlibExpansion.Analysis.VectorCalculus
