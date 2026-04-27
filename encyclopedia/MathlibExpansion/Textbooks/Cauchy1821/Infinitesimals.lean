import Mathlib

/-!
# Cauchy 1821 infinitesimals

This module packages the filter-based infinitesimal vocabulary used in
`Cours d'Analyse` and a minimal sign API for exact-order infinitesimals.
-/

open Filter
open scoped Asymptotics

namespace MathlibExpansion
namespace Textbooks
namespace Cauchy1821

/-- Cauchy's infinitesimal variables are sequences or nets tending to `0`. -/
def CauchyInfinitesimal {α : Type*} (u : α → ℝ) (l : Filter α) : Prop :=
  Tendsto u l (nhds 0)

/-- Cauchy's infinite variables are characterized by the absolute value tending
to `+∞`. -/
def CauchyInfinite {α : Type*} (u : α → ℝ) (l : Filter α) : Prop :=
  Tendsto (fun i => |u i|) l atTop

/-- `u` is an infinitesimal of exact order `n` with respect to the base
infinitesimal `α` if it is asymptotic to a nonzero scalar multiple of `α^n`. -/
def IsInfinitesimalOfOrder {α : Type*} (u α₀ : α → ℝ) (n : ℕ) (l : Filter α) : Prop :=
  ∃ c : ℝ, c ≠ 0 ∧ u ~[l] (fun i => c * α₀ i ^ n)

namespace Asymptotics.IsEquivalent

/-- Asymptotic equivalence preserves eventual positivity. -/
theorem eventually_pos {α : Type*} {l : Filter α} {u v : α → ℝ}
    (huv : u ~[l] v) (hv : ∀ᶠ x in l, 0 < v x) : ∀ᶠ x in l, 0 < u x := by
  rcases huv.exists_eq_mul with ⟨φ, hφ, hEq⟩
  have hφpos : ∀ᶠ x in l, 0 < φ x := hφ.eventually (Ioi_mem_nhds zero_lt_one)
  filter_upwards [hEq, hφpos, hv] with x hx hφx hvx
  simpa [hx, Pi.mul_apply] using mul_pos hφx hvx

/-- Asymptotic equivalence preserves eventual negativity. -/
theorem eventually_neg {α : Type*} {l : Filter α} {u v : α → ℝ}
    (huv : u ~[l] v) (hv : ∀ᶠ x in l, v x < 0) : ∀ᶠ x in l, u x < 0 := by
  rcases huv.exists_eq_mul with ⟨φ, hφ, hEq⟩
  have hφpos : ∀ᶠ x in l, 0 < φ x := hφ.eventually (Ioi_mem_nhds zero_lt_one)
  filter_upwards [hEq, hφpos, hv] with x hx hφx hvx
  simpa [hx, Pi.mul_apply] using mul_neg_of_pos_of_neg hφx hvx

end Asymptotics.IsEquivalent

/-- A nonzero even power is eventually positive. -/
theorem eventually_pos_const_mul_pow_even {α : Type*} {l : Filter α} {α₀ : α → ℝ}
    {c : ℝ} {n : ℕ} (hc : 0 < c) (hn : Even n) (hα : ∀ᶠ x in l, α₀ x ≠ 0) :
    ∀ᶠ x in l, 0 < c * α₀ x ^ n := by
  rcases hn with ⟨m, rfl⟩
  filter_upwards [hα] with x hx
  have hpow : 0 < α₀ x ^ (m + m) := by
    simpa [pow_add, pow_two] using sq_pos_of_ne_zero (pow_ne_zero m hx)
  exact mul_pos hc hpow

/-- A nonzero even power has the sign of its nonzero scalar coefficient. -/
theorem eventually_neg_const_mul_pow_even {α : Type*} {l : Filter α} {α₀ : α → ℝ}
    {c : ℝ} {n : ℕ} (hc : c < 0) (hn : Even n) (hα : ∀ᶠ x in l, α₀ x ≠ 0) :
    ∀ᶠ x in l, c * α₀ x ^ n < 0 := by
  rcases hn with ⟨m, rfl⟩
  filter_upwards [hα] with x hx
  have hpow : 0 < α₀ x ^ (m + m) := by
    simpa [pow_add, pow_two] using sq_pos_of_ne_zero (pow_ne_zero m hx)
  exact mul_neg_of_neg_of_pos hc hpow

/-- For odd order, eventual positivity of the base infinitesimal forces
eventual positivity of the model term. -/
theorem eventually_pos_const_mul_pow_odd_of_eventually_pos {α : Type*} {l : Filter α}
    {α₀ : α → ℝ} {c : ℝ} {n : ℕ} (hc : 0 < c) (_hn : Odd n)
    (hα : ∀ᶠ x in l, 0 < α₀ x) :
    ∀ᶠ x in l, 0 < c * α₀ x ^ n := by
  filter_upwards [hα] with x hx
  exact mul_pos hc (pow_pos hx _)

/-- Exact-order even infinitesimals with positive leading coefficient are
eventually positive. -/
theorem eventually_pos_of_order_even {α : Type*} {l : Filter α} {u α₀ : α → ℝ}
    {c : ℝ} {n : ℕ} (hu : u ~[l] (fun x => c * α₀ x ^ n)) (hc : 0 < c)
    (hn : Even n) (hα : ∀ᶠ x in l, α₀ x ≠ 0) :
    ∀ᶠ x in l, 0 < u x :=
  MathlibExpansion.Textbooks.Cauchy1821.Asymptotics.IsEquivalent.eventually_pos hu
    (eventually_pos_const_mul_pow_even hc hn hα)

/-- Exact-order even infinitesimals with negative leading coefficient are
eventually negative. -/
theorem eventually_neg_of_order_even {α : Type*} {l : Filter α} {u α₀ : α → ℝ}
    {c : ℝ} {n : ℕ} (hu : u ~[l] (fun x => c * α₀ x ^ n)) (hc : c < 0)
    (hn : Even n) (hα : ∀ᶠ x in l, α₀ x ≠ 0) :
    ∀ᶠ x in l, u x < 0 :=
  MathlibExpansion.Textbooks.Cauchy1821.Asymptotics.IsEquivalent.eventually_neg hu
    (eventually_neg_const_mul_pow_even hc hn hα)

/-- Exact-order odd infinitesimals with positive leading coefficient inherit the
eventual sign of a positive base infinitesimal. -/
theorem eventually_pos_of_order_odd_of_eventually_pos {α : Type*} {l : Filter α}
    {u α₀ : α → ℝ} {c : ℝ} {n : ℕ}
    (hu : u ~[l] (fun x => c * α₀ x ^ n)) (hc : 0 < c) (hn : Odd n)
    (hα : ∀ᶠ x in l, 0 < α₀ x) :
    ∀ᶠ x in l, 0 < u x :=
  MathlibExpansion.Textbooks.Cauchy1821.Asymptotics.IsEquivalent.eventually_pos hu
    (eventually_pos_const_mul_pow_odd_of_eventually_pos hc hn hα)

end Cauchy1821
end Textbooks
end MathlibExpansion
