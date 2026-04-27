import Mathlib.FieldTheory.Finite.Basic
import Mathlib.NumberTheory.NumberField.FinitePlaces
import Mathlib.RingTheory.Ideal.Norm.AbsNorm

/-!
# Residue fields of prime ideals in rings of integers

This file packages the finite-residue-field / Frobenius congruence surface used
by the Dirichlet-Dedekind textbook campaign.
-/

namespace MathlibExpansion.NumberTheory

open scoped NumberField
open Ideal IsDedekindDomain HeightOneSpectrum NumberField.RingOfIntegers

/-- The residue field at a nonzero prime ideal of `𝓞 K` is finite. -/
theorem finite_residueField {K : Type*} [Field K] [NumberField K]
    (P : IsDedekindDomain.HeightOneSpectrum (𝓞 K)) :
    Finite (𝓞 K ⧸ P.asIdeal) :=
  (P.asIdeal.fintypeQuotientOfFreeOfNeBot P.ne_bot).finite

/-- The residue-field cardinality is the absolute norm. -/
theorem natCard_residueField_eq_absNorm {K : Type*} [Field K] [NumberField K]
    (P : IsDedekindDomain.HeightOneSpectrum (𝓞 K)) :
    Nat.card (𝓞 K ⧸ P.asIdeal) = Ideal.absNorm P.asIdeal := by
  haveI : Fintype (𝓞 K ⧸ P.asIdeal) := P.asIdeal.fintypeQuotientOfFreeOfNeBot P.ne_bot
  rw [← Submodule.cardQuot_apply, ← Ideal.absNorm_apply]

/-- The absolute norm of a nonzero prime ideal in `𝓞 K` is a prime power. -/
theorem exists_prime_nat_and_residue_degree {K : Type*} [Field K] [NumberField K]
    (P : IsDedekindDomain.HeightOneSpectrum (𝓞 K)) :
    ∃ p f : ℕ, Nat.Prime p ∧ Ideal.absNorm P.asIdeal = p ^ f := by
  haveI : Fintype (𝓞 K ⧸ P.asIdeal) := P.asIdeal.fintypeQuotientOfFreeOfNeBot P.ne_bot
  haveI : P.asIdeal.IsMaximal := P.isMaximal
  haveI : Field (𝓞 K ⧸ P.asIdeal) := Ideal.Quotient.field P.asIdeal
  obtain ⟨p, f, hp, hcard⟩ := FiniteField.card' (𝓞 K ⧸ P.asIdeal)
  refine ⟨p, (f : ℕ), hp, ?_⟩
  rw [← natCard_residueField_eq_absNorm P, Nat.card_eq_fintype_card, hcard]

/-- Upstream-narrow boundary for transporting finite-field Frobenius back to
the ring-of-integers quotient in textbook language. -/
theorem frobenius_congruence {K : Type*} [Field K] [NumberField K]
    (P : IsDedekindDomain.HeightOneSpectrum (𝓞 K)) :
    ∃ p f : ℕ, Nat.Prime p ∧ Ideal.absNorm P.asIdeal = p ^ f ∧
      ∀ x : 𝓞 K, x ^ (p ^ f) - x ∈ P.asIdeal := by
  obtain ⟨p, f, hp, hnorm⟩ := exists_prime_nat_and_residue_degree P
  refine ⟨p, f, hp, hnorm, ?_⟩
  intro x
  haveI : Fintype (𝓞 K ⧸ P.asIdeal) := P.asIdeal.fintypeQuotientOfFreeOfNeBot P.ne_bot
  haveI : P.asIdeal.IsMaximal := P.isMaximal
  have hcard : Fintype.card (𝓞 K ⧸ P.asIdeal) = p ^ f := by
    rw [← Nat.card_eq_fintype_card, natCard_residueField_eq_absNorm P, hnorm]
  classical
  have hcardUnits :
      Fintype.card (𝓞 K ⧸ P.asIdeal)ˣ =
        Fintype.card (𝓞 K ⧸ P.asIdeal) - 1 := by
    let e : (𝓞 K ⧸ P.asIdeal)ˣ ≃ {a : 𝓞 K ⧸ P.asIdeal // a ≠ 0} :=
      Equiv.ofBijective
        (fun u : (𝓞 K ⧸ P.asIdeal)ˣ =>
          (⟨(u : 𝓞 K ⧸ P.asIdeal), Units.ne_zero u⟩ :
            {a : 𝓞 K ⧸ P.asIdeal // a ≠ 0}))
        ⟨by
          intro u v h
          ext
          exact congr_arg Subtype.val h,
        by
          intro a
          have ha : IsUnit (a : 𝓞 K ⧸ P.asIdeal) := by
            rcases Ideal.Quotient.exists_inv a.property with ⟨b, hb⟩
            exact isUnit_iff_exists_inv.mpr ⟨b, hb⟩
          rcases ha with ⟨u, hu⟩
          refine ⟨u, ?_⟩
          ext
          exact hu⟩
    calc
      Fintype.card (𝓞 K ⧸ P.asIdeal)ˣ =
          Fintype.card {a : 𝓞 K ⧸ P.asIdeal // a ≠ 0} :=
        Fintype.card_congr e
      _ = Fintype.card (𝓞 K ⧸ P.asIdeal) - 1 := by
        rw [Fintype.card_subtype_compl (fun a : 𝓞 K ⧸ P.asIdeal => a = 0),
          Fintype.card_subtype_eq (0 : 𝓞 K ⧸ P.asIdeal)]
  rw [← Ideal.Quotient.eq_zero_iff_mem]
  change (Ideal.Quotient.mk P.asIdeal x : 𝓞 K ⧸ P.asIdeal) ^ (p ^ f) -
      Ideal.Quotient.mk P.asIdeal x = 0
  rw [← hcard]
  have hpow :
      (Ideal.Quotient.mk P.asIdeal x : 𝓞 K ⧸ P.asIdeal) ^
          Fintype.card (𝓞 K ⧸ P.asIdeal) =
        Ideal.Quotient.mk P.asIdeal x := by
    let a : 𝓞 K ⧸ P.asIdeal := Ideal.Quotient.mk P.asIdeal x
    change a ^ Fintype.card (𝓞 K ⧸ P.asIdeal) = a
    by_cases hx : a = 0
    · rw [hx]
      exact zero_pow Fintype.card_ne_zero
    · have ha : IsUnit a := by
        rcases Ideal.Quotient.exists_inv hx with ⟨b, hb⟩
        exact isUnit_iff_exists_inv.mpr ⟨b, hb⟩
      obtain ⟨u, hu⟩ := ha
      rw [← hu]
      rw [← Nat.succ_pred_eq_of_pos Fintype.card_pos, pow_succ, Nat.pred_eq_sub_one]
      have hunit :
          ((u : 𝓞 K ⧸ P.asIdeal) ^
              (Fintype.card (𝓞 K ⧸ P.asIdeal) - 1)) = 1 := by
        calc
          ((u : 𝓞 K ⧸ P.asIdeal) ^
              (Fintype.card (𝓞 K ⧸ P.asIdeal) - 1)) =
              ((u ^ (Fintype.card (𝓞 K ⧸ P.asIdeal) - 1) : (𝓞 K ⧸ P.asIdeal)ˣ) :
                𝓞 K ⧸ P.asIdeal) := by
            rw [Units.val_pow_eq_pow_val]
          _ = 1 := by
            rw [← hcardUnits]
            simpa only [Units.val_one] using
              congr_arg (fun v : (𝓞 K ⧸ P.asIdeal)ˣ => (v : 𝓞 K ⧸ P.asIdeal))
              (pow_card_eq_one (x := u))
      rw [hunit, one_mul]
  exact sub_eq_zero.mpr hpow

end MathlibExpansion.NumberTheory
