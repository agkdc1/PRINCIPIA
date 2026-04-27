import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.Data.ZMod.Basic
import Mathlib.GroupTheory.SpecificGroups.Dihedral
import Mathlib.GroupTheory.SpecificGroups.Alternating
import Mathlib.GroupTheory.Solvable

open scoped MatrixGroups

namespace MathlibExpansion.Recon.LT05Checks

#check GL (Fin 2) (ZMod 3)
#check Subgroup (GL (Fin 2) (ZMod 3))
#check DihedralGroup 4
#check alternatingGroup (Fin 4)
#check Equiv.Perm (Fin 4)
#check Equiv.Perm (Fin 5)

end MathlibExpansion.Recon.LT05Checks
