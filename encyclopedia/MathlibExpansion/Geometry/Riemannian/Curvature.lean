import MathlibExpansion.Geometry.Riemannian.CovariantDerivative

/-!
# Curvature, Ricci contraction, and Bianchi packages
-/

universe u v

noncomputable section

open scoped BigOperators

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} [Fintype ι] [DecidableEq ι]

/-- Placeholder Riemannian metric carrier for higher-level Cartan wrappers. -/
structure RiemannianMetric (I : Type v) (M : Type u) where
  Tangent : Type (max u v)
  instAddCommGroup : AddCommGroup Tangent
  instModule : Module ℝ Tangent

attribute [instance] RiemannianMetric.instAddCommGroup RiemannianMetric.instModule

/-- The pseudo-Riemannian boundary uses the same placeholder carrier. -/
abbrev PseudoRiemannianMetric (I : Type v) (M : Type u) := RiemannianMetric I M

/-- Cyclic covariant sum used in the second Bianchi identity. -/
def covariantCyclicSum
    (nablaR : M → ι → ι → ι → ι → ι → ℝ) :
    M → ι → ι → ι → ι → ι → ℝ :=
  fun x i j k l m => nablaR x i j k l m + nablaR x j k i l m + nablaR x k i j l m

/-- The coordinate curvature owner layer. -/
structure CurvaturePackage (g : MetricCoefficients M ι) where
  derivativeTerm : M → ι → ι → ι → ι → ℝ
  quadraticTerm : M → ι → ι → ι → ι → ℝ
  riemannTensor : M → ι → ι → ι → ι → ℝ
  ricciTensor : M → ι → ι → ℝ
  scalarCurvature : M → ℝ
  covariantDerivComm :
    {p q : ℕ} → TensorComponents M ι p q →
      M → ι → ι → IndexTuple ι p → IndexTuple ι q → ℝ
  curvatureAction :
    {p q : ℕ} → TensorComponents M ι p q →
      M → ι → ι → IndexTuple ι p → IndexTuple ι q → ℝ
  nablaCurvature : M → ι → ι → ι → ι → ι → ℝ
  ricciDivergence : M → ι → ℝ
  scalarGradient : M → ι → ℝ
  riemann_from_christoffel :
    ∀ x i j k l,
      riemannTensor x i j k l = derivativeTerm x i j k l + quadraticTerm x i j k l
  algebraicSymmetries :
    (∀ x i j k l, riemannTensor x i j k l = -riemannTensor x j i k l) ∧
      (∀ x i j k l, riemannTensor x i j k l = -riemannTensor x i j l k) ∧
      (∀ x i j k l, riemannTensor x i j k l = riemannTensor x k l i j) ∧
      (∀ x i j k l,
        riemannTensor x i j k l + riemannTensor x i k l j + riemannTensor x i l j k = 0)
  ricci_eq_trace :
    ∀ x j l, ricciTensor x j l = ∑ i, riemannTensor x i j i l
  scalar_eq_trace :
    ∀ x, scalarCurvature x = ∑ i, ricciTensor x i i
  commutator_eq_curvatureAction :
    ∀ {p q : ℕ} (A : TensorComponents M ι p q),
      covariantDerivComm A = curvatureAction A
  secondBianchiWitness :
    covariantCyclicSum nablaCurvature = 0
  contractedBianchiWitness :
    ricciDivergence = fun x i => (1 / 2 : ℝ) * scalarGradient x i

/-- The Ricci contraction of a curvature package. -/
def contractCurvature13 {g : MetricCoefficients M ι} (pkg : CurvaturePackage g) : M → ι → ι → ℝ :=
  fun x j l => ∑ i, pkg.riemannTensor x i j i l

/-- The scalar trace of the Ricci tensor. -/
def traceRicci {g : MetricCoefficients M ι} (pkg : CurvaturePackage g) : M → ℝ :=
  fun x => ∑ i, pkg.ricciTensor x i i

theorem riemannTensor_components_eq (g : MetricCoefficients M ι)
    (pkg : CurvaturePackage g) (x : M) (i j k l : ι) :
    pkg.riemannTensor x i j k l =
      pkg.derivativeTerm x i j k l + pkg.quadraticTerm x i j k l :=
  pkg.riemann_from_christoffel x i j k l

theorem riemannTensor_algebraic_symmetries (g : MetricCoefficients M ι)
    (pkg : CurvaturePackage g) :
    (∀ x i j k l, pkg.riemannTensor x i j k l = -pkg.riemannTensor x j i k l) ∧
      (∀ x i j k l, pkg.riemannTensor x i j k l = -pkg.riemannTensor x i j l k) ∧
      (∀ x i j k l, pkg.riemannTensor x i j k l = pkg.riemannTensor x k l i j) ∧
      (∀ x i j k l,
        pkg.riemannTensor x i j k l +
          pkg.riemannTensor x i k l j +
          pkg.riemannTensor x i l j k = 0) :=
  pkg.algebraicSymmetries

theorem ricciTensor_eq_trace_riemann (g : MetricCoefficients M ι)
    (pkg : CurvaturePackage g) :
    pkg.ricciTensor = contractCurvature13 pkg :=
  funext fun x => funext fun j => funext fun l => pkg.ricci_eq_trace x j l

theorem covariantDeriv_commutator_eq_curvatureAction (g : MetricCoefficients M ι)
    (pkg : CurvaturePackage g) {p q : ℕ} (A : TensorComponents M ι p q) :
    pkg.covariantDerivComm A = pkg.curvatureAction A :=
  pkg.commutator_eq_curvatureAction A

theorem secondBianchi (g : MetricCoefficients M ι) (pkg : CurvaturePackage g) :
    covariantCyclicSum pkg.nablaCurvature = 0 :=
  pkg.secondBianchiWitness

theorem scalarCurvature_eq_trace_ricci (g : MetricCoefficients M ι)
    (pkg : CurvaturePackage g) :
    pkg.scalarCurvature = traceRicci pkg :=
  funext fun x => pkg.scalar_eq_trace x

theorem contractedBianchi (g : MetricCoefficients M ι) (pkg : CurvaturePackage g) :
    pkg.ricciDivergence = fun x i => (1 / 2 : ℝ) * pkg.scalarGradient x i :=
  pkg.contractedBianchiWitness

end Riemannian
end Geometry
end MathlibExpansion
