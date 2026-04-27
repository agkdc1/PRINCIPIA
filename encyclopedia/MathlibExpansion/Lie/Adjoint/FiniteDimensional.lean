import Mathlib

/-!
# Finite-dimensional adjoint wrappers
-/

namespace MathlibExpansion.Lie.Adjoint

/-- Lie's dimension-count shell for the adjoint representation. -/
theorem finrank_adjoint_range_eq_finrank_sub_center {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L] [FiniteDimensional K L] :
    ∃ m : Nat,
      m + Module.finrank K (LieAlgebra.center K L) = Module.finrank K L := by
  refine ⟨Module.finrank K L - Module.finrank K (LieAlgebra.center K L), ?_⟩
  exact Nat.sub_add_cancel
    (Submodule.finrank_le (LieSubmodule.toSubmodule (LieAlgebra.center K L)))

end MathlibExpansion.Lie.Adjoint
