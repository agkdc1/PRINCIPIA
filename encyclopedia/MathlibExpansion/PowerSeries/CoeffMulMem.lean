/-
Copyright (c) 2025 Jz Pan. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jz Pan
-/

import Mathlib.RingTheory.Ideal.Operations
import Mathlib.RingTheory.Ideal.BigOperators
import Mathlib.RingTheory.PowerSeries.Basic

/-!

# Some results on the coefficients of multiplication of two power series

## Main results

- `PowerSeries.coeff_mul_mem_ideal_mul_ideal_of_coeff_mem_ideal`,
  `PowerSeries.coeff_mul_mem_ideal_mul_ideal_of_coeff_mem_ideal'`:
  if for all `i ≤ n` (resp. for all `i`), the `i`-th coefficients of power series `f` and `g` are
  in ideals `I` and `J`, respectively, then for all `i ≤ n` (resp. for all `i`), the `i`-th
  coefficients of `f * g` are in `I * J`.

- `PowerSeries.coeff_mul_mem_ideal_of_coeff_right_mem_ideal`,
  `PowerSeries.coeff_mul_mem_ideal_of_coeff_right_mem_ideal'`:
  if for all `i ≤ n` (resp. for all `i`), the `i`-th coefficients of power series `g` are
  in ideal `I`, then for all `i ≤ n` (resp. for all `i`), the `i`-th coefficients of `f * g` are
  in `I`.

- `PowerSeries.coeff_mul_mem_ideal_of_coeff_left_mem_ideal`,
  `PowerSeries.coeff_mul_mem_ideal_of_coeff_left_mem_ideal'`:
  if for all `i ≤ n` (resp. for all `i`), the `i`-th coefficients of power series `f` are
  in ideal `I`, then for all `i ≤ n` (resp. for all `i`), the `i`-th coefficients of `f * g` are
  in `I`.

-/

namespace MathlibExpansion
namespace PowerSeries

variable {A : Type*} [Semiring A] {I J : Ideal A} {f g : _root_.PowerSeries A}

theorem coeff_mul_mem_ideal_mul_ideal_of_coeff_mem_ideal (n : ℕ)
    (hf : ∀ i ≤ n, _root_.PowerSeries.coeff A i f ∈ I)
    (hg : ∀ i ≤ n, _root_.PowerSeries.coeff A i g ∈ J) :
    ∀ i ≤ n, _root_.PowerSeries.coeff A i (f * g) ∈ I * J := fun i hi => by
  rw [_root_.PowerSeries.coeff_mul]
  exact Ideal.sum_mem _ fun p hp => Ideal.mul_mem_mul
    (hf _ ((Finset.antidiagonal.fst_le hp).trans hi))
    (hg _ ((Finset.antidiagonal.snd_le hp).trans hi))

theorem coeff_mul_mem_ideal_mul_ideal_of_coeff_mem_ideal'
    (hf : ∀ i, _root_.PowerSeries.coeff A i f ∈ I)
    (hg : ∀ i, _root_.PowerSeries.coeff A i g ∈ J) :
    ∀ i, _root_.PowerSeries.coeff A i (f * g) ∈ I * J := fun i =>
  coeff_mul_mem_ideal_mul_ideal_of_coeff_mem_ideal (f := f) (g := g) i
    (fun j _ => hf j) (fun j _ => hg j) i le_rfl

theorem coeff_mul_mem_ideal_of_coeff_right_mem_ideal (n : ℕ)
    (hg : ∀ i ≤ n, _root_.PowerSeries.coeff A i g ∈ I) :
    ∀ i ≤ n, _root_.PowerSeries.coeff A i (f * g) ∈ I := by
  simpa using coeff_mul_mem_ideal_mul_ideal_of_coeff_mem_ideal (A := A) (I := ⊤) (J := I)
    (f := f) (g := g) n (by simp) hg

theorem coeff_mul_mem_ideal_of_coeff_right_mem_ideal'
    (hg : ∀ i, _root_.PowerSeries.coeff A i g ∈ I) :
    ∀ i, _root_.PowerSeries.coeff A i (f * g) ∈ I := by
  simpa using coeff_mul_mem_ideal_mul_ideal_of_coeff_mem_ideal' (A := A) (I := ⊤) (J := I)
    (f := f) (g := g) (by simp) hg

variable [I.IsTwoSided]

theorem coeff_mul_mem_ideal_of_coeff_left_mem_ideal (n : ℕ)
    (hf : ∀ i ≤ n, _root_.PowerSeries.coeff A i f ∈ I) :
    ∀ i ≤ n, _root_.PowerSeries.coeff A i (f * g) ∈ I := by
  simpa only [Ideal.IsTwoSided.mul_one] using
    coeff_mul_mem_ideal_mul_ideal_of_coeff_mem_ideal (A := A) (I := I) (J := 1)
      (f := f) (g := g) n hf (by simp)

theorem coeff_mul_mem_ideal_of_coeff_left_mem_ideal'
    (hf : ∀ i, _root_.PowerSeries.coeff A i f ∈ I) :
    ∀ i, _root_.PowerSeries.coeff A i (f * g) ∈ I := by
  simpa only [Ideal.IsTwoSided.mul_one] using
    coeff_mul_mem_ideal_mul_ideal_of_coeff_mem_ideal' (A := A) (I := I) (J := 1)
      (f := f) (g := g) hf (by simp)

end PowerSeries
end MathlibExpansion
