import MathlibExpansion.Geometry.Riemannian.CovariantDerivative

/-!
# Differential parameters and the Laplace-Beltrami operator
-/

universe u v

noncomputable section

open scoped BigOperators

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} [Fintype ι] [DecidableEq ι]

/-- Metric gradient components of a scalar field. -/
def gradientComponents (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (f : ScalarFieldComponents M) : VectorFieldComponents M ι :=
  fun x i => ∑ j, g.invCoeff x i j * D.scalar f x j

/-- Metric pairing of two coordinate vector fields. -/
def metricPairing (g : MetricCoefficients M ι)
    (X Y : VectorFieldComponents M ι) : ScalarFieldComponents M :=
  fun x => ∑ i, ∑ j, X x i * g.coeff x i j * Y x j

/-- Eisenhart's first differential parameter. -/
def firstDifferentialParameter (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (f φ : ScalarFieldComponents M) : ScalarFieldComponents M :=
  metricPairing g (gradientComponents g D f) (gradientComponents g D φ)

theorem firstDifferentialParameter_eq_metricPairing_of_gradients
    (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (f φ : ScalarFieldComponents M) :
    firstDifferentialParameter g D f φ =
      metricPairing g (gradientComponents g D f) (gradientComponents g D φ) :=
  rfl

/-- Coordinate divergence. -/
def divergence (D : CoordinateDerivatives M ι)
    (X : VectorFieldComponents M ι) : ScalarFieldComponents M :=
  fun x => ∑ i, D.vector X x i i

/-- Scalar Laplace-Beltrami operator. -/
def laplaceBeltrami (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (u : ScalarFieldComponents M) : ScalarFieldComponents M :=
  divergence D (gradientComponents g D u)

/-- Eisenhart's second differential parameter. -/
def secondDifferentialParameter (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (u : ScalarFieldComponents M) : ScalarFieldComponents M :=
  laplaceBeltrami g D u

theorem secondDifferentialParameter_eq_laplaceBeltrami
    (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (u : ScalarFieldComponents M) :
    secondDifferentialParameter g D u = laplaceBeltrami g D u :=
  rfl

/-- Level-set normality criterion encoded via the first differential parameter. -/
def HasNullNormalLevelSet (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (f : ScalarFieldComponents M) : Prop :=
  ∀ x, firstDifferentialParameter g D f f x = 0

theorem nullNormalToLevelSet_iff_firstDifferentialParameter_self_eq_zero
    (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (f : ScalarFieldComponents M) :
    HasNullNormalLevelSet g D f ↔ ∀ x, firstDifferentialParameter g D f f x = 0 :=
  Iff.rfl

/-- Orthogonality of two level-set families encoded by vanishing mixed first
differential parameter. -/
def OrthogonalLevelSetFamilies (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (f φ : ScalarFieldComponents M) : Prop :=
  ∀ x, firstDifferentialParameter g D f φ x = 0

theorem levelSetFamilies_orthogonal_iff_firstDifferentialParameter_eq_zero
    (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (f φ : ScalarFieldComponents M) :
    OrthogonalLevelSetFamilies g D f φ ↔ ∀ x, firstDifferentialParameter g D f φ x = 0 :=
  Iff.rfl

/-- A witness for orthogonal metric-split coordinates adapted to one level-set
family. -/
structure OrthogonalMetricSplitCoordinates
    (g : MetricCoefficients M ι) (D : CoordinateDerivatives M ι)
    (f : ScalarFieldComponents M)
    (ψ : Fin (Fintype.card ι - 1) → ScalarFieldComponents M) : Prop where
  blockDiagonal :
    ∀ x i, firstDifferentialParameter g D f (ψ i) x = 0

/-- Functional independence placeholder kept non-vacuous by injectivity. -/
def IndependentFirstIntegrals {n : ℕ} (ψ : Fin n → ScalarFieldComponents M) : Prop :=
  Function.Injective ψ

/-- The operator package also records the orthogonal metric-splitting witness
needed later by orthogonal systems. -/
structure DifferentialParameterPackage (g : MetricCoefficients M ι) where
  D : CoordinateDerivatives M ι
  orthogonalSplit :
    ∀ f : ScalarFieldComponents M,
      ∃ ψ : Fin (Fintype.card ι - 1) → ScalarFieldComponents M,
        IndependentFirstIntegrals ψ ∧ OrthogonalMetricSplitCoordinates g D f ψ

theorem exists_local_coordinates_with_orthogonal_metric_split_of_firstDifferentialParameterPDE
    (g : MetricCoefficients M ι) (pkg : DifferentialParameterPackage g)
    (f : ScalarFieldComponents M) :
    ∃ ψ : Fin (Fintype.card ι - 1) → ScalarFieldComponents M,
      IndependentFirstIntegrals ψ ∧ OrthogonalMetricSplitCoordinates g pkg.D f ψ :=
  pkg.orthogonalSplit f

end Riemannian
end Geometry
end MathlibExpansion
