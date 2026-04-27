import MathlibExpansion.Dynamics.Hamiltonian.CanonicalRelations

/-!
# Basic Hamiltonian substrate

This file packages the coordinate-level Hamiltonian API already landed in the
Jacobi breach into a single reusable module.  The resulting substrate is still
deliberately affine and finite-dimensional, but it exposes the canonical
Hamiltonian vector field and symplectic pairing needed by the Poincare step-6
consumers.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Hamiltonian

open AffineObservable

section

variable {R ι : Type*} [CommRing R] [Fintype ι] [DecidableEq ι]

/-- A minimal Hamiltonian system on affine canonical phase space. -/
structure HamiltonianSystem where
  hamiltonian : AffineObservable R ι

/-- The Hamiltonian vector field acts by Poisson bracketing with the Hamiltonian. -/
def vectorField (H : HamiltonianSystem (R := R) (ι := ι))
    (f : AffineObservable R ι) : AffineObservable R ι :=
  hamiltonianAction H.hamiltonian f

/-- An observable Poisson-commutes with the Hamiltonian when its bracket with `H` vanishes. -/
def PoissonCommutes (H : HamiltonianSystem (R := R) (ι := ι))
    (f : AffineObservable R ι) : Prop :=
  AffineObservable.poissonBracket H.hamiltonian f = 0

/-- The affine symplectic form is the scalar part of the Poisson bracket. -/
def symplecticForm (f g : AffineObservable R ι) : R :=
  constPart (AffineObservable.poissonBracket f g)

@[simp] theorem vectorField_qCoordinate (H : HamiltonianSystem (R := R) (ι := ι)) (i : ι) :
    vectorField H (qCoordinate (R := R) i) = constant (ι := ι) (pPart H.hamiltonian i) := by
  simpa [vectorField] using hamiltonianAction_qCoordinate H.hamiltonian i

@[simp] theorem vectorField_pCoordinate (H : HamiltonianSystem (R := R) (ι := ι)) (i : ι) :
    vectorField H (pCoordinate (R := R) i) = constant (ι := ι) (-qPart H.hamiltonian i) := by
  simpa [vectorField] using hamiltonianAction_pCoordinate H.hamiltonian i

@[simp] theorem poissonCommutes_constant (H : HamiltonianSystem (R := R) (ι := ι)) (c : R) :
    PoissonCommutes H (constant (ι := ι) c) := by
  simpa [PoissonCommutes] using
    (AffineObservable.poissonBracket_constant_right (ι := ι) c H.hamiltonian)

@[simp] theorem symplecticForm_qCoordinate_qCoordinate (i k : ι) :
    symplecticForm (qCoordinate (R := R) i) (qCoordinate (R := R) k) = 0 := by
  simp [symplecticForm, AffineObservable.poissonBracket, qCoordinate, mkObservable, qPart, pPart]

@[simp] theorem symplecticForm_pCoordinate_pCoordinate (i k : ι) :
    symplecticForm (pCoordinate (R := R) i) (pCoordinate (R := R) k) = 0 := by
  simp [symplecticForm, AffineObservable.poissonBracket, pCoordinate, mkObservable, qPart, pPart]

@[simp] theorem symplecticForm_qCoordinate_pCoordinate (i k : ι) :
    symplecticForm (qCoordinate (R := R) i) (pCoordinate (R := R) k) = if i = k then 1 else 0 := by
  simp [symplecticForm, AffineObservable.poissonBracket, qCoordinate, pCoordinate, mkObservable,
    qPart, pPart, sum_kronecker_left, eq_comm]

end

end Hamiltonian
end Dynamics
end MathlibExpansion
