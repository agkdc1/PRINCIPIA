import Mathlib

/-!
# Projective Lie examples
-/

namespace MathlibExpansion.Lie.Examples

/-- A placeholder carrier for Lie's projective infinitesimal transformations. -/
abbrev ProjectiveLie (K : Type*) (n : Nat) :=
  Matrix (Fin (n + 2)) (Fin (n + 2)) K

/--
The current placeholder carrier is not the projective Lie algebra: it is the full
matrix Lie algebra, whose identity matrix is a nonzero central element.

The actual projective statement needs a quotient by scalar matrices, with the
usual dimension and characteristic hypotheses, before Lie's projective
simplicity theorem can be stated.
-/
theorem projectiveLie_not_isSimple {K : Type*} [Field K] (n : Nat) :
    ¬ LieAlgebra.IsSimple K (ProjectiveLie K n) := by
  intro hsimple
  letI : LieAlgebra.IsSimple K (ProjectiveLie K n) := hsimple
  have hOne_mem : (1 : ProjectiveLie K n) ∈ LieAlgebra.center K (ProjectiveLie K n) := by
    rw [LieModule.mem_maxTrivSubmodule]
    intro x
    simp [LieRing.of_associative_ring_bracket]
  have hcenter_ne_bot : LieAlgebra.center K (ProjectiveLie K n) ≠ ⊥ := by
    intro hcenter
    have hOne_zero : (1 : ProjectiveLie K n) = 0 := by
      rw [hcenter] at hOne_mem
      exact (LieSubmodule.mem_bot (R := K) (L := ProjectiveLie K n)
        (M := ProjectiveLie K n) (1 : ProjectiveLie K n)).mp hOne_mem
    exact one_ne_zero hOne_zero
  rcases LieAlgebra.IsSimple.eq_bot_or_eq_top
      (R := K) (L := ProjectiveLie K n) (LieAlgebra.center K (ProjectiveLie K n)) with hbot | htop
  · exact hcenter_ne_bot hbot
  · exact LieAlgebra.IsSimple.non_abelian (R := K) (L := ProjectiveLie K n)
      ((LieAlgebra.isLieAbelian_iff_center_eq_top (R := K) (L := ProjectiveLie K n)).2 htop)

end MathlibExpansion.Lie.Examples
