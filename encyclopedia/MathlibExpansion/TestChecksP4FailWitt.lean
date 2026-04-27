import Mathlib.Algebra.DualNumber
import Mathlib.RingTheory.Artinian.Module
import Mathlib.RingTheory.WittVector.Basic

open scoped DualNumber

universe u

section FailWitt

variable (p : ℕ) [Fact p.Prime]
variable (k : Type u) [CommRing k]

#check WittVector p k
#check DualNumber (WittVector p k)
#check (inferInstance : IsArtinianRing (DualNumber (WittVector p k)))

end FailWitt
