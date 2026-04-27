import Mathlib.Data.Real.Basic

import Mathlib

/-!
# Finite-difference asymptotics

This module packages the sequence-level additive transfer theorem used by
Cauchy's Chapter II, Section III.
-/

open Filter Finset

namespace MathlibExpansion
namespace Analysis
namespace Asymptotics

/-- If the first finite difference of a real sequence tends to `A`, then the
sequence divided by its index tends to the same limit. -/
theorem tendsto_nat_div_of_tendsto_succ_sub {u : ℕ → ℝ} {A : ℝ}
    (h : Tendsto (fun n => u (n + 1) - u n) atTop (nhds A)) :
    Tendsto (fun n => u n / n) atTop (nhds A) := by
  let d : ℕ → ℝ := fun n => u (n + 1) - u n
  have hCesaro : Tendsto (fun n : ℕ => (n⁻¹ : ℝ) * ∑ i ∈ range n, d i) atTop (nhds A) := by
    simpa [d] using h.cesaro
  have hInitial : Tendsto (fun n : ℕ => u 0 / n) atTop (nhds 0) :=
    tendsto_const_nhds.div_atTop tendsto_natCast_atTop_atTop
  have hEventually :
      (fun n : ℕ => u n / n)
        =ᶠ[atTop] fun n => (n⁻¹ : ℝ) * ∑ i ∈ range n, d i + u 0 / n := by
    filter_upwards [Ici_mem_atTop 1] with n hn
    have hn1 : 1 ≤ n := by simpa using hn
    have hn0 : (n : ℝ) ≠ 0 := by
      exact_mod_cast (Nat.ne_of_gt (lt_of_lt_of_le Nat.zero_lt_one hn1))
    have htel : ∑ i ∈ range n, d i = u n - u 0 := by
      simpa [d] using Finset.sum_range_sub u n
    rw [htel]
    field_simp [hn0]
  refine Tendsto.congr' hEventually.symm ?_
  simpa using hCesaro.add hInitial

/-- Upstream-narrow floor reduction of the real-indexed unit-increment transfer
theorem. The extra hypothesis says that replacing `x` by `⌊x⌋₊` changes
`f x / x` only by an asymptotically negligible term. -/
theorem tendsto_div_self_of_tendsto_unitIncrement_floor {f : ℝ → ℝ} {k : ℝ}
    (h : Tendsto (fun x : ℝ => f (x + 1) - f x) atTop (nhds k))
    (hgap : Tendsto (fun x : ℝ => (f x - f ⌊x⌋₊) / x) atTop (nhds 0)) :
    Tendsto (fun x : ℝ => f x / x) atTop (nhds k) := by
  have hNat : Tendsto (fun n : ℕ => f (n + 1) - f n) atTop (nhds k) := by
    simpa [Nat.cast_add, Nat.cast_one] using h.comp tendsto_natCast_atTop_atTop
  have hSeq : Tendsto (fun n : ℕ => f n / n) atTop (nhds k) :=
    tendsto_nat_div_of_tendsto_succ_sub (u := fun n => f n) <|
      by simpa [Nat.cast_add, Nat.cast_one] using hNat
  have hFloorSeq : Tendsto (fun x : ℝ => f ⌊x⌋₊ / (⌊x⌋₊ : ℝ)) atTop (nhds k) := by
    simpa using hSeq.comp tendsto_nat_floor_atTop
  have hFloorAux :
      Tendsto
        (fun x : ℝ => (f ⌊x⌋₊ / (⌊x⌋₊ : ℝ)) * ((⌊x⌋₊ : ℝ) / x))
        atTop (nhds (k * 1)) :=
    hFloorSeq.mul tendsto_nat_floor_div_atTop
  have hFloorEq :
      (fun x : ℝ => f ⌊x⌋₊ / x)
        =ᶠ[atTop] fun x => (f ⌊x⌋₊ / (⌊x⌋₊ : ℝ)) * ((⌊x⌋₊ : ℝ) / x) := by
    filter_upwards [Ioi_mem_atTop (1 : ℝ)] with x hx
    have hx1 : 1 < x := by simpa using hx
    have hfloor_pos : 0 < (⌊x⌋₊ : ℝ) := by
      exact_mod_cast (Nat.floor_pos.mpr hx1.le)
    field_simp [hx1.ne', hfloor_pos.ne']
  have hFloor : Tendsto (fun x : ℝ => f ⌊x⌋₊ / x) atTop (nhds k) := by
    refine Tendsto.congr' hFloorEq.symm ?_
    simpa using hFloorAux
  have hDecomp :
      (fun x : ℝ => f x / x)
        =ᶠ[atTop] fun x => f ⌊x⌋₊ / x + (f x - f ⌊x⌋₊) / x := by
    filter_upwards [Ioi_mem_atTop (0 : ℝ)] with x hx
    have hx0 : 0 < x := by simpa using hx
    field_simp [hx0.ne']
  refine Tendsto.congr' hDecomp.symm ?_
  simpa using hFloor.add hgap

end Asymptotics
end Analysis
end MathlibExpansion
