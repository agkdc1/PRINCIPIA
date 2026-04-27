import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.RingTheory.Noetherian.Basic
import Mathlib.RingTheory.PowerSeries.Basic

open scoped Padic

section IW02

variable (p : ℕ) [Fact p.Prime]
variable (M : Type*) [AddCommGroup M] [Module (PowerSeries ℤ_[p]) M]

#check PowerSeries ℤ_[p]
#check (inferInstance : CommRing (PowerSeries ℤ_[p]))
#check (inferInstance : Module (PowerSeries ℤ_[p]) (PowerSeries ℤ_[p]))

example [Module.Finite (PowerSeries ℤ_[p]) M] :
    Module.Finite (PowerSeries ℤ_[p]) M := inferInstance

example [IsNoetherianRing (PowerSeries ℤ_[p])] [Module.Finite (PowerSeries ℤ_[p]) M] :
    IsNoetherian (PowerSeries ℤ_[p]) M :=
  isNoetherian_of_isNoetherianRing_of_finite (PowerSeries ℤ_[p]) M

end IW02
