import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.RingTheory.FiniteLength
import Mathlib.RingTheory.Ideal.Height
import Mathlib.RingTheory.KrullDimension.Basic
import Mathlib.RingTheory.PowerSeries.Inverse
import MathlibExpansion.Roots.Iwasawa.Basic

open scoped Padic

open MathlibExpansion.Roots.Iwasawa

#check Ideal.height
#check Ideal.height_eq_primeHeight
#check ringKrullDim
#check Ring.KrullDimLE
#check Module.annihilator
#check IsFiniteLength
#check IsLocalRing.maximalIdeal

example (p : ℕ) [Fact p.Prime] : IsLocalRing (Lambda ℤ_[p]) := by
  dsimp [Lambda]
  infer_instance

example (p : ℕ) [Fact p.Prime] :
    Ideal (Lambda ℤ_[p]) :=
  IsLocalRing.maximalIdeal (Lambda ℤ_[p])

example (p : ℕ) [Fact p.Prime] :
    Ideal.height (IsLocalRing.maximalIdeal (Lambda ℤ_[p])) = Ideal.height
      (IsLocalRing.maximalIdeal (Lambda ℤ_[p])) :=
  rfl

