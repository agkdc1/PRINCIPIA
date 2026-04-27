import Mathlib

/-!
# Signature-safe metric tensors and coefficient data

This file replaces the earlier coordinate-only positive-definite shell with a
signature-safe root object plus an explicit coordinate coefficient package.
-/

universe u v

noncomputable section

open scoped BigOperators

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

/-- A coordinate tangent vector in `n` dimensions. -/
abbrev CoordinateVector (n : ℕ) := Fin n → ℝ

/-- A signature-safe metric field on a fixed model fibre `V`. -/
structure MetricTensor (M : Type u) (V : Type v)
    [AddCommGroup V] [Module ℝ V] where
  toBilin : M → LinearMap.BilinForm ℝ V
  symm : ∀ x, LinearMap.IsSymm (toBilin x)
  nondegenerate : ∀ x v, (∀ w, toBilin x v w = 0) → v = 0

/-- Positive-definite specialization of `MetricTensor`. -/
structure RiemannianMetricTensor (M : Type u) (V : Type v)
    [AddCommGroup V] [Module ℝ V] extends MetricTensor M V where
  pos_def : ∀ x v, v ≠ 0 → 0 < toBilin x v v

variable {M : Type u} {V : Type v} [AddCommGroup V] [Module ℝ V]

/-- The squared line element is the root signature-safe quantity. -/
def squaredLineElement (g : MetricTensor M V) (x : M) (v : V) : ℝ :=
  g.toBilin x v v

/-- The classical line element lives only in the positive-definite specialization. -/
def lineElement (g : RiemannianMetricTensor M V) (x : M) (v : V) : ℝ :=
  Real.sqrt (squaredLineElement g.toMetricTensor x v)

/-- The line element is the square root of the metric quadratic form by definition. -/
theorem lineElement_eq_sqrt_metricQuadraticForm
    (g : RiemannianMetricTensor M V) (x : M) (v : V) :
    lineElement g x v = Real.sqrt (g.toBilin x v v) :=
  rfl

/-- Two tangent vectors are orthogonal exactly when their metric pairing vanishes. -/
def MetricOrthogonal (g : MetricTensor M V) (x : M) (u v : V) : Prop :=
  g.toBilin x u v = 0

theorem metricOrthogonal_iff (g : MetricTensor M V) (x : M) (u v : V) :
    MetricOrthogonal g x u v ↔ g.toBilin x u v = 0 :=
  Iff.rfl

/-- Metric angle in the positive-definite branch. -/
def metricAngle (g : RiemannianMetricTensor M V) (x : M) (u v : V) : ℝ :=
  Real.arccos ((g.toBilin x u v) /
    (Real.sqrt (g.toBilin x u u) * Real.sqrt (g.toBilin x v v)))

/-- Coordinate coefficients together with their reciprocal matrix data. -/
structure MetricCoefficients (M : Type u) (ι : Type v) [Fintype ι] [DecidableEq ι] where
  coeff : M → Matrix ι ι ℝ
  invCoeff : M → Matrix ι ι ℝ
  coeff_symm : ∀ x : M, (coeff x).IsSymm
  inv_left : ∀ x : M, (invCoeff x) * (coeff x) = 1
  inv_right : ∀ x : M, (coeff x) * (invCoeff x) = 1

variable {ι : Type v} [Fintype ι] [DecidableEq ι]

theorem metricCoeff_isSymm (g : MetricCoefficients M ι) (x : M) :
    (g.coeff x).IsSymm :=
  g.coeff_symm x

theorem invCoeff_mul_coeff (g : MetricCoefficients M ι) (x : M) :
    (g.invCoeff x) * (g.coeff x) = 1 ∧ (g.coeff x) * (g.invCoeff x) = 1 :=
  ⟨g.inv_left x, g.inv_right x⟩

/-- The reciprocal metric is already packaged in `MetricCoefficients`. -/
theorem exists_inverseMetricMatrix (g : MetricCoefficients M ι) (x : M) :
    ∃ Ginv : Matrix ι ι ℝ, Ginv * (g.coeff x) = 1 ∧ (g.coeff x) * Ginv = 1 :=
  ⟨g.invCoeff x, g.inv_left x, g.inv_right x⟩

/-- Metric pairing computed from coefficient data. -/
def metricPairingCoefficients (g : MetricCoefficients M ι) (x : M)
    (u v : ι → ℝ) : ℝ :=
  ∑ i, ∑ j, u i * g.coeff x i j * v j

/-- Pairing computed from the reciprocal metric coefficients. -/
def inverseMetricPairingCoefficients (g : MetricCoefficients M ι) (x : M)
    (u v : ι → ℝ) : ℝ :=
  ∑ i, ∑ j, u i * g.invCoeff x i j * v j

end Riemannian
end Geometry
end MathlibExpansion
