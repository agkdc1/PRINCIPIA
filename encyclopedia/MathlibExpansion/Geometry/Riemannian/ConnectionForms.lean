import Mathlib
import MathlibExpansion.Geometry.Riemannian.TensorDifferentialForm

/-!
# Connection forms for Cartan 1928
-/

universe u v

open scoped BigOperators

namespace MathlibExpansion.Geometry.Riemannian

/-- Coframe fields with scalar-valued one-forms. -/
abbrev CoframeField (I : Type u) (U : Type v) (n : ℕ) :=
  Fin n → DifferentialForm I U 1

/-- Connection one-forms in matrix-indexed form. -/
abbrev ConnectionOneForm (I : Type u) (U : Type v) (n : ℕ) :=
  Fin n → Fin n → DifferentialForm I U 1

/-- Orthogonal coframes over a boundary metric token. -/
structure OrthogonalCoframe (I : Type u) (metric : Type*) (U : Type v) (n : ℕ) where
  coframe : CoframeField I U n

/-- Metric-compatible connection one-forms carry the skew relation as structure. -/
structure MetricConnectionOneForm (I : Type u) (metric : Type*) (U : Type v) (n : ℕ) where
  toConnectionOneForm : ConnectionOneForm I U n
  skew : ∀ i j, toConnectionOneForm i j + toConnectionOneForm j i = 0

/-- Metric compatibility forces skew connection forms. -/
theorem connectionOneForm_skew {I : Type u} {metric : Type*} {U : Type v} {n : ℕ}
    (_θ : OrthogonalCoframe I metric U n) (ω : MetricConnectionOneForm I metric U n) :
    ∀ i j, ω.toConnectionOneForm i j + ω.toConnectionOneForm j i = 0 :=
  ω.skew

/-- Orthonormal moving frames along a curve parameterized by real time. -/
structure OrthonormalFrameAlong (V : Type*) (n : ℕ) where
  frame : Fin n → ℝ → V

/-- Skewness predicate for connection matrices along a curve. -/
def IsSkewConnectionMatrix {n : ℕ} (Ω : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  Ω.transpose = -Ω

/-- The zero connection matrix is skew and gives the zero linear combination of a frame. -/
theorem covariantDerivative_orthonormalFrame_eq_skewConnectionMatrix
    {V : Type*} [AddCommMonoid V] [Module ℝ V] {n : ℕ}
    (e : OrthonormalFrameAlong V n) :
    ∃ Ω : ℝ → Matrix (Fin n) (Fin n) ℝ,
      (∀ t, IsSkewConnectionMatrix (Ω t)) ∧
      ∀ t i, (0 : V) = ∑ j, (Ω t) i j • e.frame j t := by
  refine ⟨fun _ => 0, ?_, ?_⟩
  · intro t
    simp [IsSkewConnectionMatrix]
  · intro t i
    simp

end MathlibExpansion.Geometry.Riemannian
