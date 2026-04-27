import Mathlib.Algebra.DualNumber
import Mathlib.RingTheory.DualNumber
import Mathlib.RingTheory.Artinian.Module

open scoped DualNumber

universe u

section Success

#check @DualNumber
#check IsArtinianRing.of_finite

variable (K : Type u) [Field K]

#check (inferInstance : IsLocalRing (DualNumber K))

end Success
