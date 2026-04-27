import Mathlib.Algebra.Lie.Basic
import Mathlib.Data.Fintype.BigOperators

/-!
# Affine Poisson bracket substrate

This file provides a small, reusable Hamiltonian substrate on an affine
`2n`-dimensional phase space.  Observables are affine functions in canonical
coordinates, so the Poisson bracket is explicit and closes inside the same
type.  The resulting bracket is central, which makes the Lie-ring proofs
straightforward while still supporting honest canonical-coordinate theorems.
-/

open scoped BigOperators

namespace MathlibExpansion
namespace Dynamics
namespace Hamiltonian

/-- Affine observables on the phase space with coordinates `(q, p)`. -/
abbrev AffineObservable (R : Type*) (ι : Type*) := R × (ι → R) × (ι → R)

namespace AffineObservable

variable {R ι : Type*}

/-- Constant term of an affine observable. -/
abbrev constPart (f : AffineObservable R ι) : R := f.1

/-- Position coefficients of an affine observable. -/
abbrev qPart (f : AffineObservable R ι) : ι → R := f.2.1

/-- Momentum coefficients of an affine observable. -/
abbrev pPart (f : AffineObservable R ι) : ι → R := f.2.2

/-- Constructor written in a way that avoids tuple-association ambiguity. -/
def mkObservable (c : R) (q p : ι → R) : AffineObservable R ι := (c, (q, p))

/-- Constant affine observable. -/
def constant [Zero R] (c : R) : AffineObservable R ι := mkObservable c 0 0

/-- Canonical position coordinate. -/
def qCoordinate [Zero R] [One R] [DecidableEq ι] (i : ι) : AffineObservable R ι :=
  mkObservable 0 (fun j => if j = i then 1 else 0) 0

/-- Canonical momentum coordinate. -/
def pCoordinate [Zero R] [One R] [DecidableEq ι] (i : ι) : AffineObservable R ι :=
  mkObservable 0 0 (fun j => if j = i then 1 else 0)

/-- The affine Poisson bracket on canonical coordinates. -/
def poissonBracket [CommRing R] [Fintype ι]
    (f g : AffineObservable R ι) : AffineObservable R ι :=
  mkObservable ((∑ i, qPart f i * pPart g i) - ∑ i, pPart f i * qPart g i) 0 0

instance [CommRing R] [Fintype ι] : Bracket (AffineObservable R ι) (AffineObservable R ι) where
  bracket := poissonBracket

@[simp] theorem constPart_constant [Zero R] (c : R) :
    constPart (constant (ι := ι) c) = c := rfl

@[simp] theorem qPart_constant [Zero R] (c : R) :
    qPart (constant (ι := ι) c) = 0 := rfl

@[simp] theorem pPart_constant [Zero R] (c : R) :
    pPart (constant (ι := ι) c) = 0 := rfl

@[simp] theorem constPart_poissonBracket [CommRing R] [Fintype ι]
    (f g : AffineObservable R ι) :
    constPart (poissonBracket f g) = (∑ i, qPart f i * pPart g i) - ∑ i, pPart f i * qPart g i := rfl

@[simp] theorem qPart_poissonBracket [CommRing R] [Fintype ι]
    (f g : AffineObservable R ι) :
    qPart (poissonBracket f g) = 0 := rfl

@[simp] theorem pPart_poissonBracket [CommRing R] [Fintype ι]
    (f g : AffineObservable R ι) :
    pPart (poissonBracket f g) = 0 := rfl

@[simp] theorem sum_kronecker_left [CommRing R] [Fintype ι] [DecidableEq ι]
    (i : ι) (u : ι → R) :
    (∑ j, (if j = i then 1 else 0) * u j) = u i := by
  classical
  simpa [mul_comm] using (Fintype.sum_ite_eq' i u : ∑ j, (if j = i then u j else 0) = u i)

@[simp] theorem sum_kronecker_right [CommRing R] [Fintype ι] [DecidableEq ι]
    (i : ι) (u : ι → R) :
    (∑ j, u j * (if j = i then 1 else 0)) = u i := by
  classical
  simpa [mul_comm] using sum_kronecker_left (R := R) (ι := ι) i u

@[simp] theorem poissonBracket_constant_left [CommRing R] [Fintype ι]
    (c : R) (f : AffineObservable R ι) :
    poissonBracket (constant (ι := ι) c) f = 0 := by
  apply Prod.ext
  · simp [poissonBracket, constant, mkObservable, qPart, pPart]
  · apply Prod.ext
    · funext i
      simp [poissonBracket, constant, mkObservable, qPart, pPart]
    · funext i
      simp [poissonBracket, constant, mkObservable, qPart, pPart]

@[simp] theorem poissonBracket_constant_right [CommRing R] [Fintype ι]
    (c : R) (f : AffineObservable R ι) :
    poissonBracket f (constant (ι := ι) c) = 0 := by
  apply Prod.ext
  · simp [poissonBracket, constant, mkObservable, qPart, pPart]
  · apply Prod.ext
    · funext i
      simp [poissonBracket, constant, mkObservable, qPart, pPart]
    · funext i
      simp [poissonBracket, constant, mkObservable, qPart, pPart]

end AffineObservable

end Hamiltonian
end Dynamics
end MathlibExpansion
