import Mathlib

/-!
# Prolongation shells

This file provides the minimal prolonged-group surface used by the differential
invariant rows.
-/

namespace MathlibExpansion.Geometry.Jet

/-- A transformation group acting on objects of type `Z` over a base `X`. -/
structure TransformationGroup (X : Type*) (Z : Type*) where
  carrier : Type

/-- A finite-dimensional transformation group with an explicit carrier dimension. -/
structure FiniteDimensionalTransformationGroup (𝕜 : Type*) (X : Type*) (Z : Type*) where
  carrier : Type
  dim : Nat

/-- A linear PDE operator on the dependent variable type. -/
abbrev LinearPDOp (Z : Type*) := Z → Z

/-- The `N`th prolongation of a finite-dimensional transformation group. -/
def FiniteDimensionalTransformationGroup.prolong {𝕜 X Z : Type*}
    (G : FiniteDimensionalTransformationGroup 𝕜 X Z) (N : Nat) :
    FiniteDimensionalTransformationGroup 𝕜 X Z :=
  { carrier := G.carrier, dim := G.dim + N }

end MathlibExpansion.Geometry.Jet
