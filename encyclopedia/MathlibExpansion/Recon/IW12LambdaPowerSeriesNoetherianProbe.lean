import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.RingTheory.Noetherian.Basic
import Mathlib.RingTheory.PowerSeries.Basic
import Mathlib.RingTheory.PowerSeries.Inverse

open scoped Padic
open PowerSeries

section SuccessChecks

variable {k : Type*} [Field k]

#check (inferInstance : IsNoetherianRing k⟦X⟧)

end SuccessChecks

section PadicChecks

variable (p : ℕ) [Fact p.Prime]

#check (inferInstance : IsNoetherianRing ℤ_[p])

example [IsNoetherianRing (PowerSeries ℤ_[p])] :
    IsNoetherianRing (PowerSeries ℤ_[p]) := inferInstance

example : IsNoetherianRing (PowerSeries ℤ_[p]) := inferInstance

end PadicChecks
