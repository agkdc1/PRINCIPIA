import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib

/-!
# Canonical-product substrate

This file introduces the elementary Weierstrass factor and an honest
canonical-product convergence boundary for downstream entire-function work.
-/

noncomputable section

open Filter
open scoped BigOperators Topology

namespace MathlibExpansion
namespace Analysis
namespace Complex

/-- The classical elementary Weierstrass factor `E(z, m)`. -/
def WeierstrassElementaryFactor (z : ℂ) (m : ℕ) : ℂ :=
  (1 - z) * Complex.exp (∑ k ∈ Finset.range m, z ^ (k + 1) / ((k + 1 : ℕ) : ℂ))

@[simp] theorem WeierstrassElementaryFactor_zero (m : ℕ) :
    WeierstrassElementaryFactor 0 m = 1 := by
  simp [WeierstrassElementaryFactor]

@[simp] theorem WeierstrassElementaryFactor_one (m : ℕ) :
    WeierstrassElementaryFactor 1 m = 0 := by
  simp [WeierstrassElementaryFactor]

theorem WeierstrassElementaryFactor_eq_zero_iff {z : ℂ} {m : ℕ} :
    WeierstrassElementaryFactor z m = 0 ↔ z = 1 := by
  constructor
  · intro hz
    have hmul : 1 - z = 0 := by
      rcases mul_eq_zero.mp hz with hzero | hexp
      · exact hzero
      · exact False.elim (Complex.exp_ne_zero _ hexp)
    have hz' : 1 = z := sub_eq_zero.mp hmul
    simpa [eq_comm] using hz'
  · intro hz
    simp [WeierstrassElementaryFactor, hz]

/-- The `N`-th partial product attached to elementary factors. -/
def canonicalPartialProduct (a : ℕ → ℂ) (m : ℕ → ℕ) (N : ℕ) (z : ℂ) : ℂ :=
  ∏ n ∈ Finset.range N, WeierstrassElementaryFactor (z / a n) (m n)

/-- **Smail 1923, Theorem IV (narrow upstream axiom).**

This is the uniform-convergence bridge from an explicit summable bound on the
deviation of the elementary factors from `1` to compact convergence of the
canonical partial products.  It is narrower than Weierstrass factorization
itself: it says nothing about how the genus sequence `m n` is chosen, only what
happens once a usable bound is already established.

Source: Lloyd L. Smail, "Some Theorems on Uniform Convergence of Infinite
Products", *Tohoku Mathematical Journal* 23 (1923), Theorem IV: an infinite
product `∏ (1 + u_n(x))` converges uniformly and absolutely when the deviations
are bounded by a convergent positive numerical majorant.  This declaration packages
that infinite-product M-test for the concrete Weierstrass elementary factors
below. -/
axiom canonicalProduct_tendstoUniformlyOn_of_summable_bound_axiom
    {a : ℕ → ℂ} {m : ℕ → ℕ} {u : ℕ → ℝ} {K : Set ℂ}
    (hu : Summable u)
    (hK : IsCompact K)
    (hbound : ∀ n z, z ∈ K →
      ‖WeierstrassElementaryFactor (z / a n) (m n) - 1‖ ≤ u n) :
    ∃ f : ℂ → ℂ, TendstoUniformlyOn (canonicalPartialProduct a m) f atTop K

/-- A textbook-facing wrapper for uniform convergence of canonical partial
products on compact sets, once the factors are controlled by a summable bound. -/
theorem canonicalProduct_tendstoUniformlyOn_of_summable_bound
    {a : ℕ → ℂ} {m : ℕ → ℕ} {u : ℕ → ℝ} {K : Set ℂ}
    (hu : Summable u)
    (hK : IsCompact K)
    (hbound : ∀ n z, z ∈ K →
      ‖WeierstrassElementaryFactor (z / a n) (m n) - 1‖ ≤ u n) :
    ∃ f : ℂ → ℂ, TendstoUniformlyOn (canonicalPartialProduct a m) f atTop K :=
  canonicalProduct_tendstoUniformlyOn_of_summable_bound_axiom hu hK hbound

end Complex
end Analysis
end MathlibExpansion
