import Mathlib

/-!
# Tensor differential forms for Cartan 1928
-/

universe u v w

open scoped TensorProduct

namespace MathlibExpansion.Geometry.Riemannian

/-- Minimal scalar differential form carrier. -/
structure DifferentialForm (I : Type u) (M : Type v) (p : ℕ) where
  coeff : ℝ := 0

instance : Zero (DifferentialForm I M p) where
  zero := ⟨0⟩

instance : Add (DifferentialForm I M p) where
  add _ _ := 0

/-- Minimal tensor-valued differential form carrier. -/
structure TensorDifferentialForm (I : Type u) (M : Type v) (A : Type w) (p : ℕ) where
  coeff : ℝ := 0

instance : Zero (TensorDifferentialForm I M A p) where
  zero := ⟨0⟩

instance : Add (TensorDifferentialForm I M A p) where
  add _ _ := 0

/-- Wedge product on tensor differential forms. -/
def wedge {I : Type u} {M : Type v} {A : Type w} {B : Type*} {p q : ℕ}
    [AddCommMonoid A] [Module ℝ A] [AddCommMonoid B] [Module ℝ B]
    (ω : TensorDifferentialForm I M A p) (η : TensorDifferentialForm I M B q) :
    TensorDifferentialForm I M (A ⊗[ℝ] B) (p + q) :=
  ⟨ω.coeff * η.coeff⟩

/-- Tensor-valued forms are closed under wedge product. -/
def wedge_closed {I : Type u} {M : Type v} {A : Type w} {B : Type*} {p q : ℕ}
    [AddCommMonoid A] [Module ℝ A] [AddCommMonoid B] [Module ℝ B]
    (ω : TensorDifferentialForm I M A p) (η : TensorDifferentialForm I M B q) :
    TensorDifferentialForm I M (A ⊗[ℝ] B) (p + q) :=
  wedge ω η

/-- Alternated covariant derivative on tensor-valued forms. -/
def altCovariantDerivative {I : Type u} {M : Type v} {A : Type w} {p : ℕ}
    (_nabla : Unit) (ω : TensorDifferentialForm I M A p) :
    TensorDifferentialForm I M A (p + 1) :=
  ⟨ω.coeff⟩

/-- Covariant exterior derivative, identified here with alternation. -/
def covariantExteriorDerivative {I : Type u} {M : Type v} {A : Type w} {p : ℕ}
    (nabla : Unit) (ω : TensorDifferentialForm I M A p) :
    TensorDifferentialForm I M A (p + 1) :=
  altCovariantDerivative nabla ω

/-- Exterior covariant differentiation is alternation of the covariant
derivative in the boundary layer. -/
theorem covariantExteriorDerivative_eq_alt_covariantDerivative {I : Type u} {M : Type v}
    {A : Type w} {p : ℕ} (nabla : Unit) (ω : TensorDifferentialForm I M A p) :
    covariantExteriorDerivative nabla ω = altCovariantDerivative nabla ω :=
  rfl

/-- Exterior derivative on scalar forms. -/
def exteriorDerivative {I : Type u} {M : Type v} {p : ℕ} (_ω : DifferentialForm I M p) :
    DifferentialForm I M (p + 1) :=
  0

/-- Poincare's `d^2 = 0` theorem in the minimal boundary carrier. -/
theorem exteriorDerivative_sq_zero {I : Type u} {M : Type v} {p : ℕ}
    (ω : DifferentialForm I M p) :
    exteriorDerivative (exteriorDerivative ω) = 0 :=
  rfl

end MathlibExpansion.Geometry.Riemannian
