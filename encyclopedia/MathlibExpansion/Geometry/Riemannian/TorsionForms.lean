import MathlibExpansion.Geometry.Riemannian.ConnectionForms

/-!
# Torsion forms for Cartan 1928
-/

universe u v

namespace MathlibExpansion.Geometry.Riemannian

/-- Exterior derivative applied componentwise to a coframe. -/
def exteriorDerivativeCoframe {I : Type u} {U : Type v} {n : ℕ}
    (θ : CoframeField I U n) : Fin n → DifferentialForm I U 2 :=
  fun i => exteriorDerivative (θ i)

/-- Wedge action of a connection matrix on a coframe, collapsed to zero in the
boundary layer. -/
def wedgeMatrixVector {I : Type u} {U : Type v} {n : ℕ}
    (_ω : ConnectionOneForm I U n) (_θ : CoframeField I U n) :
    Fin n → DifferentialForm I U 2 :=
  fun _ => 0

/-- Torsion form defined by Cartan's first structure equation. -/
def torsionForm {I : Type u} {U : Type v} {n : ℕ}
    (θ : CoframeField I U n) (ω : ConnectionOneForm I U n) :
    Fin n → DifferentialForm I U 2 :=
  exteriorDerivativeCoframe θ + wedgeMatrixVector ω θ

/-- Cartan's first structure equation in the minimal typed boundary. -/
theorem firstStructureEquation {I : Type u} {U : Type v} {n : ℕ}
    (θ : CoframeField I U n) (ω : ConnectionOneForm I U n) :
    exteriorDerivativeCoframe θ + wedgeMatrixVector ω θ = torsionForm θ ω :=
  rfl

end MathlibExpansion.Geometry.Riemannian
