import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.RingTheory.DedekindDomain.Ideal

/-!
# Ideal divisibility for Hilbert's Zahlbericht

This file packages the Dedekind-domain ideal divisibility facts used in the
Hilbert arithmetic queue.
-/

namespace MathlibExpansion.NumberTheory

open NumberField
open scoped NumberField

variable {K : Type*} [Field K] [NumberField K]

/-- Divisibility of ideals is witnessed by an explicit quotient ideal. -/
theorem exists_ideal_quotient_of_dvd {I J : Ideal (𝓞 K)} (h : I ∣ J) :
    ∃ Q : Ideal (𝓞 K), J = I * Q :=
  h

/-- In the ring of integers of a number field, ideal divisibility is reverse inclusion. -/
theorem ideal_dvd_iff_reverse_inclusion {I J : Ideal (𝓞 K)} :
    I ∣ J ↔ J ≤ I :=
  Ideal.dvd_iff_le

end MathlibExpansion.NumberTheory
