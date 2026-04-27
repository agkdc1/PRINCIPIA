import Mathlib.NumberTheory.NumberField.FractionalIdeal

/-!
# Integral ideal bases for Hilbert's Zahlbericht

This file exposes the existing `fractionalIdealBasis` surface as an ideal-level
chapter for the Hilbert queue.
-/

namespace MathlibExpansion.NumberTheory

open NumberField
open scoped NumberField nonZeroDivisors

variable (K : Type*) [Field K] [NumberField K]

/-- A `ℤ`-basis for an integral ideal, viewed as a fractional ideal of `K`. -/
noncomputable def idealBasis (I : Ideal (𝓞 K)) :
    Basis (Module.Free.ChooseBasisIndex ℤ (I : FractionalIdeal (𝓞 K)⁰ K)) ℤ
      (I : FractionalIdeal (𝓞 K)⁰ K) :=
  NumberField.fractionalIdealBasis K (I : FractionalIdeal (𝓞 K)⁰ K)

/-- Every integral ideal admits a finite `ℤ`-basis. -/
theorem exists_ideal_basis (I : Ideal (𝓞 K)) :
    Nonempty (Basis (Module.Free.ChooseBasisIndex ℤ (I : FractionalIdeal (𝓞 K)⁰ K)) ℤ
      (I : FractionalIdeal (𝓞 K)⁰ K)) :=
  ⟨idealBasis K I⟩

end MathlibExpansion.NumberTheory
