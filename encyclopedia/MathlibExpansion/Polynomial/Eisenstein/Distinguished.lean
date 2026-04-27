/-
Copyright (c) 2024 Nailin Guan. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Nailin Guan
-/

import Mathlib.RingTheory.Polynomial.Eisenstein.Basic
import Mathlib.RingTheory.PowerSeries.Order

/-!

# Distinguished polynomial

In this file we define the predicate `Polynomial.IsDistinguishedAt`
and develop the most basic lemmas about it.

-/

open scoped Polynomial
open PowerSeries Ideal Quotient

namespace MathlibExpansion
namespace Polynomial

variable {R : Type*} [CommRing R]

/--
Given an ideal `I` of a commutative ring `R`, we say that a polynomial `f : R[X]`
is *distinguished at `I`* if `f` is monic and weakly Eisenstein at `I`.
-/
structure IsDistinguishedAt (f : R[X]) (I : Ideal R) : Prop where
  toIsWeaklyEisensteinAt : f.IsWeaklyEisensteinAt I
  monic : f.Monic

namespace IsDistinguishedAt

lemma mem {f : R[X]} {I : Ideal R} (distinguish : IsDistinguishedAt f I) {n : ℕ}
    (hn : n < f.natDegree) : f.coeff n ∈ I :=
  distinguish.toIsWeaklyEisensteinAt.mem hn

lemma mul {f f' : R[X]} {I : Ideal R} (hf : IsDistinguishedAt f I)
    (hf' : IsDistinguishedAt f' I) : IsDistinguishedAt (f * f') I := by
  refine ⟨?_, hf.monic.mul hf'.monic⟩
  refine (_root_.Polynomial.isWeaklyEisensteinAt_iff _ _).2 ?_
  intro i hi
  rw [hf.monic.natDegree_mul hf'.monic] at hi
  rw [_root_.Polynomial.coeff_mul]
  refine Submodule.sum_mem _ fun p hp => ?_
  rcases p with ⟨a, b⟩
  rw [Finset.mem_antidiagonal] at hp
  by_cases ha : a < f.natDegree
  · exact Ideal.mul_mem_right _ _ (hf.mem ha)
  · have hb : b < f'.natDegree := by
      omega
    exact Ideal.mul_mem_left _ _ (hf'.mem hb)

lemma map_eq_X_pow {f : R[X]} {I : Ideal R} (distinguish : IsDistinguishedAt f I) :
    f.map (Ideal.Quotient.mk I) = _root_.Polynomial.X ^ f.natDegree := by
  ext i
  by_cases ne : i = f.natDegree
  · simp [ne, distinguish.monic]
  · rcases lt_or_gt_of_ne ne with lt | gt
    · simpa [ne, eq_zero_iff_mem] using (distinguish.mem lt)
    · simp [ne, _root_.Polynomial.coeff_eq_zero_of_natDegree_lt gt]

section degree_eq_order_map

variable {I : Ideal R} (f h : R⟦X⟧) {g : R[X]}

lemma map_ne_zero_of_eq_mul (distinguish : IsDistinguishedAt g I)
    (notMem : _root_.PowerSeries.constantCoeff R h ∉ I) (eq : f = g * h) :
    f.map (Ideal.Quotient.mk I) ≠ 0 := fun H => by
  have mapf : f.map (Ideal.Quotient.mk I) =
      (_root_.Polynomial.X ^ g.natDegree : (R ⧸ I)[X]) * h.map (Ideal.Quotient.mk I) := by
    simp [← map_eq_X_pow distinguish, eq]
  have hcoeff := congrArg (_root_.PowerSeries.coeff (R := R ⧸ I) g.natDegree) H
  simp [mapf, _root_.PowerSeries.coeff_X_pow_mul', eq_zero_iff_mem, notMem] at hcoeff

lemma degree_eq_coe_lift_order_map (distinguish : IsDistinguishedAt g I)
    (notMem : _root_.PowerSeries.constantCoeff R h ∉ I) (eq : f = g * h) :
    g.degree = (f.map (Ideal.Quotient.mk I)).order.lift
      (_root_.PowerSeries.order_finite_iff_ne_zero.2
        (distinguish.map_ne_zero_of_eq_mul f h notMem eq)) := by
  have : Nontrivial R := _root_.nontrivial_iff.mpr
    ⟨0, _root_.PowerSeries.constantCoeff R h, ne_of_mem_of_not_mem I.zero_mem notMem⟩
  rw [_root_.Polynomial.degree_eq_natDegree distinguish.monic.ne_zero, Nat.cast_inj, ← ENat.coe_inj,
    ENat.coe_lift, Eq.comm, _root_.PowerSeries.order_eq_nat]
  have mapf : f.map (Ideal.Quotient.mk I) =
      (_root_.Polynomial.X ^ g.natDegree : (R ⧸ I)[X]) * h.map (Ideal.Quotient.mk I) := by
    simp [← map_eq_X_pow distinguish, eq]
  constructor
  · simp [mapf, _root_.PowerSeries.coeff_X_pow_mul', eq_zero_iff_mem, notMem]
  · intro i hi
    simp [mapf, _root_.PowerSeries.coeff_X_pow_mul', hi]

lemma coe_natDegree_eq_order_map (distinguish : IsDistinguishedAt g I)
    (notMem : _root_.PowerSeries.constantCoeff R h ∉ I) (eq : f = g * h) :
    g.natDegree = (f.map (Ideal.Quotient.mk I)).order := by
  haveI : Nontrivial R := _root_.nontrivial_iff.mpr
    ⟨0, _root_.PowerSeries.constantCoeff R h, ne_of_mem_of_not_mem I.zero_mem notMem⟩
  have hne : (f.map (Ideal.Quotient.mk I)).order < ⊤ :=
    _root_.PowerSeries.order_finite_iff_ne_zero.2 <|
      distinguish.map_ne_zero_of_eq_mul f h notMem eq
  have hdeg := distinguish.degree_eq_coe_lift_order_map f h notMem eq
  rw [_root_.Polynomial.degree_eq_natDegree distinguish.monic.ne_zero] at hdeg
  exact hdeg.trans (ENat.coe_lift _ hne)

end degree_eq_order_map

end IsDistinguishedAt
end Polynomial
end MathlibExpansion
