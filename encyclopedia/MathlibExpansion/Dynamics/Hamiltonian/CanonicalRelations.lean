import MathlibExpansion.Dynamics.Hamiltonian.CanonicalElements

/-!
# Canonical relations for affine canonical coordinates

This is the first concrete `JL-05` boundary: the standard coordinate
observables on affine phase space satisfy the canonical Poisson relations.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Hamiltonian

open AffineObservable

section

variable {R ι : Type*} [CommRing R] [Fintype ι] [DecidableEq ι]

@[simp] theorem poissonBracket_qCoordinate_qCoordinate (i k : ι) :
    ⁅qCoordinate (R := R) i, qCoordinate (R := R) k⁆ = 0 := by
  classical
  change AffineObservable.poissonBracket (qCoordinate (R := R) i) (qCoordinate (R := R) k) = 0
  apply Prod.ext
  · simp [AffineObservable.poissonBracket, qCoordinate, mkObservable, pPart, qPart]
  · apply Prod.ext
    · funext j
      simp [AffineObservable.poissonBracket, qCoordinate, mkObservable, pPart, qPart]
    · funext j
      simp [AffineObservable.poissonBracket, qCoordinate, mkObservable, pPart, qPart]

@[simp] theorem poissonBracket_pCoordinate_pCoordinate (i k : ι) :
    ⁅pCoordinate (R := R) i, pCoordinate (R := R) k⁆ = 0 := by
  classical
  change AffineObservable.poissonBracket (pCoordinate (R := R) i) (pCoordinate (R := R) k) = 0
  apply Prod.ext
  · simp [AffineObservable.poissonBracket, pCoordinate, mkObservable, pPart, qPart]
  · apply Prod.ext
    · funext j
      simp [AffineObservable.poissonBracket, pCoordinate, mkObservable, pPart, qPart]
    · funext j
      simp [AffineObservable.poissonBracket, pCoordinate, mkObservable, pPart, qPart]

@[simp] theorem poissonBracket_qCoordinate_pCoordinate (i k : ι) :
    ⁅qCoordinate (R := R) i, pCoordinate (R := R) k⁆ =
      constant (ι := ι) (if i = k then 1 else 0) := by
  classical
  change AffineObservable.poissonBracket (qCoordinate (R := R) i) (pCoordinate (R := R) k) =
    constant (ι := ι) (if i = k then 1 else 0)
  apply Prod.ext
  · simp [AffineObservable.poissonBracket, qCoordinate, pCoordinate, constant, mkObservable,
      pPart, qPart, sum_kronecker_left, eq_comm]
  · apply Prod.ext
    · funext j
      simp [AffineObservable.poissonBracket, qCoordinate, pCoordinate, constant, mkObservable,
        pPart, qPart]
    · funext j
      simp [AffineObservable.poissonBracket, qCoordinate, pCoordinate, constant, mkObservable,
        pPart, qPart]

/-- The standard canonical commutation relations on affine phase space. -/
theorem canonical_relations (i k : ι) :
    ⁅qCoordinate (R := R) i, qCoordinate (R := R) k⁆ = 0 ∧
      ⁅pCoordinate (R := R) i, pCoordinate (R := R) k⁆ = 0 ∧
      ⁅qCoordinate (R := R) i, pCoordinate (R := R) k⁆ =
        constant (ι := ι) (if i = k then 1 else 0) := by
  exact ⟨poissonBracket_qCoordinate_qCoordinate (R := R) i k,
    poissonBracket_pCoordinate_pCoordinate (R := R) i k,
    poissonBracket_qCoordinate_pCoordinate (R := R) i k⟩

end

end Hamiltonian
end Dynamics
end MathlibExpansion
