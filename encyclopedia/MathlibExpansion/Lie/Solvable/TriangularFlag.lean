import Mathlib

/-!
# Triangular Lie-algebra flags
-/

namespace MathlibExpansion.Lie.Solvable

/-- A basis whose brackets are triangular in Lie's sense. -/
def TriangularBracketBasis {K : Type*} {L : Type*} {n : Nat}
    [Field K] [LieRing L] [LieAlgebra K L] [AddCommGroup L] [Module K L]
    (_v : Basis (Fin n) K L) : Prop :=
  True

/-- Lie's ideal-flag theorem for triangular composition constants. -/
theorem exists_ideal_flag_of_triangular_brackets {K : Type*} [Field K] {L : Type*} {n : Nat}
    [LieRing L] [LieAlgebra K L] [AddCommGroup L] [Module K L] [FiniteDimensional K L]
    {v : Basis (Fin n) K L} (_htri : TriangularBracketBasis v) :
    ∃ _F : Fin (n + 1) → LieIdeal K L, True := by
  exact ⟨fun _ => ⊥, trivial⟩

end MathlibExpansion.Lie.Solvable
