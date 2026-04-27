import Mathlib.Algebra.Lie.Basic

/-!
# First integrals in a Poisson/Lie system

This file isolates the Lie-algebraic heart of Poisson's theorem: if the
Hamiltonian evolution is given by bracketing with `H`, then observables that
commute with `H` are closed under the bracket.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Hamiltonian

section

variable {L : Type*} [LieRing L]

/-- An observable is a first integral when it Poisson-commutes with the
Hamiltonian. -/
def IsFirstIntegral (H f : L) : Prop := ⁅H, f⁆ = 0

/-- Poisson's theorem: the bracket of two first integrals is again a first
integral. -/
theorem poissonBracket_of_firstIntegrals {H f g : L}
    (hf : IsFirstIntegral H f) (hg : IsFirstIntegral H g) :
    IsFirstIntegral H ⁅f, g⁆ := by
  have hg' : ⁅g, H⁆ = 0 := by
    have hneg : -⁅g, H⁆ = 0 := by simpa [IsFirstIntegral, lie_skew] using hg
    exact neg_eq_zero.mp hneg
  have hJac := lie_jacobi H f g
  rw [hg', hf, lie_zero, lie_zero] at hJac
  simpa [IsFirstIntegral, add_assoc] using hJac

end

end Hamiltonian
end Dynamics
end MathlibExpansion
