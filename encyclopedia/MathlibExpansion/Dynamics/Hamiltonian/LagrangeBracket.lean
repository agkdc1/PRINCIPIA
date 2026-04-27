import Mathlib.Algebra.Lie.Basic

/-!
# Lagrange-bracket Jacobi identity

Jacobi's three-term cyclic identity is already present upstream for any Lie
ring.  This file gives the mechanics-facing theorem name that downstream
Hamiltonian files can import without reopening the abstract Lie API.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Hamiltonian

section

variable {L : Type*} [LieRing L]

/-- Mechanics-facing wrapper around the Lie-ring Jacobi identity. -/
theorem lagrangeBracket_cyclic_sum_eq_zero (a b c : L) :
    ⁅a, ⁅b, c⁆⁆ + ⁅b, ⁅c, a⁆⁆ + ⁅c, ⁅a, b⁆⁆ = 0 :=
  lie_jacobi a b c

end

end Hamiltonian
end Dynamics
end MathlibExpansion
