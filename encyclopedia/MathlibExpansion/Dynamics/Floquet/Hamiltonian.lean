import MathlibExpansion.Dynamics.Floquet.Autonomous
import MathlibExpansion.Dynamics.Hamiltonian.Basic

/-!
# Hamiltonian Floquet shell

This file records the coordinate-level Hamiltonian consequences used in the
Poincare breach: symmetry of the exponent set under negation, and the
extra-zero-exponent alternative forced by commuting first integrals.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Floquet

def SymmetricUnderNeg {R : Type*} [Neg R] (s : Set R) : Prop :=
  forall {lam : R}, lam ∈ s -> -lam ∈ s

structure HamiltonianFloquetData (R : Type*) (τ : Type*) [AddMonoid τ] [AddGroup R]
    [DecidableEq R] (α : Type*) extends AutonomousFloquetData R τ α where
  paired : SymmetricUnderNeg (characteristicExponentSet toFloquetData)
  completeIntegrals : Prop
  extraZeroAlternative : Prop
  extraZero_of_integrals : completeIntegrals -> extraZeroAlternative

theorem characteristicExponents_symm_and_integrals
    {R τ α : Type*} [AddMonoid τ] [AddGroup R] [DecidableEq R]
    (data : HamiltonianFloquetData R τ α) :
    SymmetricUnderNeg (characteristicExponentSet data.toAutonomousFloquetData.toFloquetData) /\
      (data.completeIntegrals -> data.extraZeroAlternative) := by
  exact And.intro data.paired data.extraZero_of_integrals

end Floquet
end Dynamics
end MathlibExpansion
