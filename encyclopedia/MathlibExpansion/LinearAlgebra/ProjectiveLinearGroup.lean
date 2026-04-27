import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.LinearAlgebra.Projectivization.Cardinality

namespace MathlibExpansion
namespace LinearAlgebra

open scoped LinearAlgebra.Projectivization

variable {K : Type*} [Field K]

/--
An invertible linear transformation induces a permutation of projective space.

This is the concrete projective transformation attached to a matrix in `GL`.
-/
noncomputable def projectivizationPerm {n : Type*} [Fintype n] [DecidableEq n]
    (g : Matrix.GeneralLinearGroup n K) : Equiv.Perm (ℙ K (n → K)) where
  toFun := Projectivization.map (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.toLinearMap
    (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.injective
  invFun := Projectivization.map (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.symm.toLinearMap
    (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.symm.injective
  left_inv p := by
    simpa using (congrArg (fun f => f p)
      (Projectivization.map_comp
        ((Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.toLinearMap)
        (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.injective
        ((Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.symm.toLinearMap)
        (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.symm.injective)).symm
  right_inv p := by
    simpa using (congrArg (fun f => f p)
      (Projectivization.map_comp
        ((Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.symm.toLinearMap)
        (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.symm.injective
        ((Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.toLinearMap)
        (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv.injective)).symm

/-- Jordan's `GL₂` action on the projective line. -/
noncomputable abbrev gl2ProjectiveLinePerm (g : Matrix.GeneralLinearGroup (Fin 2) K) :
    Equiv.Perm (ℙ K (Fin 2 → K)) :=
  projectivizationPerm (K := K) g

/-- The projective line over a finite field has `q + 1` points. -/
theorem card_projectiveLine [Finite K] :
    Nat.card (ℙ K (Fin 2 → K)) = Nat.card K + 1 := by
  simpa using
    (Projectivization.card_of_finrank_two (k := K) (V := Fin 2 → K)
      (Module.finrank_fin_fun (R := K) (n := 2)))

end LinearAlgebra
end MathlibExpansion
