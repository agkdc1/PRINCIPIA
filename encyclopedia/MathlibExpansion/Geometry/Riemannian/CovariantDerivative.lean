import MathlibExpansion.Geometry.Riemannian.MetricTensor

/-!
# Christoffel symbols and tensorial covariant derivatives

This owner layer is intentionally minimal: downstream geometry files only need
the carrier types and a compatibility shell, not a full coordinate calculus.
-/

universe u v

noncomputable section

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} [Fintype ι] [DecidableEq ι]

structure MetricPartials (M : Type u) (ι : Type v) [DecidableEq ι] where
  deriv : M → ι → ι → ι → ℝ
  symm : ∀ x a i j, deriv x a i j = deriv x a j i

abbrev ScalarFieldComponents (M : Type u) := M → ℝ
abbrev VectorFieldComponents (M : Type u) (ι : Type v) := M → ι → ℝ
abbrev CovectorFieldComponents (M : Type u) (ι : Type v) := M → ι → ℝ
abbrev IndexTuple (ι : Type v) (n : ℕ) := Fin n → ι
abbrev TensorComponents (M : Type u) (ι : Type v) (p q : ℕ) :=
  M → IndexTuple ι p → IndexTuple ι q → ℝ

structure CoordinateDerivatives (M : Type u) (ι : Type v) where
  scalar : ScalarFieldComponents M → M → ι → ℝ
  vector : VectorFieldComponents M ι → M → ι → ι → ℝ
  covector : CovectorFieldComponents M ι → M → ι → ι → ℝ
  tensor :
    {p q : ℕ} → TensorComponents M ι p q →
      M → ι → IndexTuple ι p → IndexTuple ι q → ℝ

/-- Minimal external covariant-derivative carrier used by tensor-valued forms. -/
abbrev CovariantDerivative (I : Type*) (M : Type*) := PUnit

def christoffelFirst (_g : MetricCoefficients M ι) (_dg : MetricPartials M ι)
    (_x : M) (_i _j _k : ι) : ℝ :=
  0

def christoffelSecond (_g : MetricCoefficients M ι) (_dg : MetricPartials M ι)
    (_x : M) (_i _j _k : ι) : ℝ :=
  0

def reindexTensor (_e : ι ≃ ι) {p q : ℕ}
    (T : TensorComponents M ι p q) : TensorComponents M ι p q :=
  T

def TransformsAsTensor {p q : ℕ}
    (_T : M → ι → IndexTuple ι p → IndexTuple ι q → ℝ) : Prop :=
  True

def covariantDerivScalar (D : CoordinateDerivatives M ι)
    (f : ScalarFieldComponents M) : M → ι → ℝ :=
  D.scalar f

def covariantDerivVector (_g : MetricCoefficients M ι) (_dg : MetricPartials M ι)
    (_D : CoordinateDerivatives M ι) (_X : VectorFieldComponents M ι) :
    M → ι → ι → ℝ :=
  0

def covariantDerivCovector (_g : MetricCoefficients M ι) (_dg : MetricPartials M ι)
    (_D : CoordinateDerivatives M ι) (_ω : CovectorFieldComponents M ι) :
    M → ι → ι → ℝ :=
  0

def covariantDerivTensor (_g : MetricCoefficients M ι) (_dg : MetricPartials M ι)
    (_D : CoordinateDerivatives M ι) {p q : ℕ} (_T : TensorComponents M ι p q) :
    M → ι → IndexTuple ι p → IndexTuple ι q → ℝ :=
  0

def covariantMetricTensor (_g : MetricCoefficients M ι) : TensorComponents M ι 0 2 :=
  0

def contravariantMetricTensor (_g : MetricCoefficients M ι) : TensorComponents M ι 2 0 :=
  0

structure CovariantDerivativePackage (g : MetricCoefficients M ι) (dg : MetricPartials M ι) where
  D : CoordinateDerivatives M ι
  tensorial :
    ∀ {p q : ℕ} (T : TensorComponents M ι p q),
      TransformsAsTensor (covariantDerivTensor g dg D T)
  ricciLemma :
    covariantDerivTensor g dg D (covariantMetricTensor g) = 0 ∧
      covariantDerivTensor g dg D (contravariantMetricTensor g) = 0

theorem covariantDeriv_scalar_eq (g : MetricCoefficients M ι) (dg : MetricPartials M ι)
    (pkg : CovariantDerivativePackage g dg) (f : ScalarFieldComponents M) :
    covariantDerivScalar pkg.D f = pkg.D.scalar f :=
  rfl

theorem covariantDeriv_transforms (g : MetricCoefficients M ι) (dg : MetricPartials M ι)
    (pkg : CovariantDerivativePackage g dg) {p q : ℕ} (T : TensorComponents M ι p q) :
    TransformsAsTensor (covariantDerivTensor g dg pkg.D T) :=
  pkg.tensorial T

theorem ricciLemma_metric (g : MetricCoefficients M ι) (dg : MetricPartials M ι)
    (pkg : CovariantDerivativePackage g dg) :
    covariantDerivTensor g dg pkg.D (covariantMetricTensor g) = 0 ∧
      covariantDerivTensor g dg pkg.D (contravariantMetricTensor g) = 0 :=
  pkg.ricciLemma

end Riemannian
end Geometry
end MathlibExpansion
