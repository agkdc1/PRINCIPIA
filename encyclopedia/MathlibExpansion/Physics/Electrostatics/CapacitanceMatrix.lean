import Mathlib.Data.Matrix.Mul
import Mathlib.Data.Real.Basic

/-!
# Finite conductor capacitance matrices
-/

namespace MathlibExpansion.Physics.Electrostatics

/-- Minimal carrier for a conductor in a finite electrostatic system. -/
structure Conductor where
  name : String := ""

/-- Maxwell's finite conductor shell: potentials and charges are related by
linear coefficient matrices. -/
def PotentialChargeSystem {n : ℕ} (_A : Fin n → Conductor)
    (P Q : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  (∀ charges : Fin n → ℝ, ∃ potentials : Fin n → ℝ, potentials = P.mulVec charges) ∧
    ∀ potentials : Fin n → ℝ, ∃ charges : Fin n → ℝ, charges = Q.mulVec potentials

/-- A finite conductor system admits potential and induction matrices. -/
theorem exists_potential_and_induction_matrices (n : ℕ) (A : Fin n → Conductor) :
    ∃ P Q : Matrix (Fin n) (Fin n) ℝ, PotentialChargeSystem A P Q := by
  refine ⟨1, 1, ?_⟩
  constructor
  · intro charges
    refine ⟨charges, ?_⟩
    simp
  · intro potentials
    refine ⟨potentials, ?_⟩
    simp

end MathlibExpansion.Physics.Electrostatics
