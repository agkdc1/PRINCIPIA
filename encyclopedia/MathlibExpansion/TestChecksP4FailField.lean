import Mathlib.Algebra.DualNumber
import Mathlib.RingTheory.Artinian.Module

open scoped DualNumber

universe u

section FailField

variable (K : Type u) [Field K]

#check (inferInstance : IsArtinianRing (DualNumber K))
#check (inferInstance : Module.Finite K (DualNumber K))

end FailField
