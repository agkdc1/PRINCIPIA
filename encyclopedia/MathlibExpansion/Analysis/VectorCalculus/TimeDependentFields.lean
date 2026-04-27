import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.VectorCalculus.DivCurlIdentity

/-!
# Time-dependent field substrate for Maxwell's dynamical equations

This chapter packages the one missing primitive needed before Faraday,
Ampere-Maxwell, and charge continuity can be stated as real `Prop`s over
Maxwell's spatial carrier: a time-derivative operator for ℝ-valued and
spatial-vector-valued paths.

Design notes:

- Time-dependent scalar fields are modeled as `SpatialPoint → ℝ → ℝ`, and
  time-dependent vector fields as `SpatialPoint → ℝ → SpatialPoint`. This
  matches Maxwell's own bookkeeping: every field is a function of both
  position and time.
- The time derivative on a scalar-valued path `ℝ → ℝ` reuses Mathlib's
  classical `deriv`, so Maxwell's temporal primitive does **not** introduce a
  new upstream primitive at that level.
- The vector-valued time derivative is the same Mathlib `deriv` API, specialized
  to `SpatialPoint = EuclideanSpace ℝ (Fin 3)`.
  `direction = upstream`.
-/

noncomputable section

namespace MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's time-dependent scalar field: a scalar value at each point and time. -/
abbrev TimeScalarField := SpatialPoint → ℝ → ℝ

/-- Maxwell's time-dependent vector field: a vector at each point and time. -/
abbrev TimeVectorField := SpatialPoint → ℝ → SpatialPoint

/-- Scalar time derivative: Mathlib's `deriv` repackaged under a Maxwell name. -/
noncomputable def timeDeriv (g : ℝ → ℝ) (t : ℝ) : ℝ :=
  deriv g t

/-- Vector time derivative: Mathlib's vector-valued `deriv` under a Maxwell name. -/
noncomputable def timeDerivVec (f : ℝ → SpatialPoint) (t : ℝ) : SpatialPoint :=
  deriv f t

/-- Fix a scalar path by freezing the spatial argument of a time-scalar field. -/
def scalarPath (f : TimeScalarField) (x : SpatialPoint) : ℝ → ℝ :=
  fun τ => f x τ

/-- Fix a vector path by freezing the spatial argument of a time-vector field. -/
def vectorPath (F : TimeVectorField) (x : SpatialPoint) : ℝ → SpatialPoint :=
  fun τ => F x τ

/-- The pointwise spatial slice of a time-dependent vector field at time `t`. -/
def spatialSliceVec (F : TimeVectorField) (t : ℝ) : VectorField :=
  fun x => F x t

/-- The pointwise spatial slice of a time-dependent scalar field at time `t`. -/
def spatialSliceScalar (f : TimeScalarField) (t : ℝ) : ScalarField :=
  fun x => f x t

end MathlibExpansion.Analysis.VectorCalculus
