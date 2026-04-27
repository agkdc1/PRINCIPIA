import Mathlib.Algebra.Module.Torsion
import Mathlib.Algebra.Module.PID
import Mathlib.LinearAlgebra.FreeModule.PID
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.RingTheory.PowerSeries.Basic

open scoped Padic

abbrev Lambda (R : Type*) [CommSemiring R] := PowerSeries R

section

variable (p : ℕ) [Fact p.Prime]
variable (M : Type*) [AddCommGroup M] [Module (Lambda ℤ_[p]) M]

#check Submodule.torsion
#check Module.free_of_finite_type_torsion_free'
#check Module.equiv_free_prod_directSum

example : IsDomain (Lambda ℤ_[p]) := inferInstance

example : NoZeroSMulDivisors (Lambda ℤ_[p]) (M ⧸ Submodule.torsion (Lambda ℤ_[p]) M) :=
  inferInstance

example [Module.Finite (Lambda ℤ_[p]) M] : Module.Free (Lambda ℤ_[p]) M :=
  inferInstance

example : IsPrincipalIdealRing (Lambda ℤ_[p]) :=
  inferInstance

end
