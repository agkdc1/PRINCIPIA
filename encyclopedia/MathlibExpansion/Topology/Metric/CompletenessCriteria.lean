/-
# MSC_09 — Shrinking-Set Completeness Criterion (Bourbaki / Rudin §3)
# (Rudin 1976 Principles, §3.10-3.11; Bourbaki, Topologie Générale II §3 No. 5)

This file is the **B2 owner** for HVT `T20c_mid_18_RMSC.MSC_09` of the Rudin
encyclopedia. It ships the load-bearing **shrinking-closed-set** (Cantor)
characterisation of completeness: in a complete metric space, every nested
sequence of non-empty closed sets whose diameters shrink to zero has
non-empty intersection.

References:
* W. Rudin, *Principles of Mathematical Analysis* 3rd ed., McGraw-Hill 1976,
  §3.10-3.11 (Cauchy sequences, completeness, nested intervals).
* Bourbaki, *Éléments de mathématique: Topologie Générale*, Chapitre II,
  §3 No. 5, Théorème 1 (caractérisation par décroissance des fermés).
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Topology.Metric.CompletenessCriteria

/-! ## MSC_09 — shrinking nested closed sets (Cantor / Bourbaki) -/

variable {X : Type*} [PseudoMetricSpace X]

/--
**Rudin 1976 §3.10 (Cantor / Bourbaki shrinking-set criterion, MSC_09).**

In a complete metric space, every nested sequence `S 0 ⊇ S 1 ⊇ S 2 ⊇ …` of
non-empty bounded closed sets whose diameter tends to zero has *non-empty*
intersection.

Hypotheses match Rudin's §3.10: closed (a), non-empty (b), bounded (implicit
in Rudin's "diameter shrinks to 0"), nested (c), `diam → 0` (d). Conclusion:
classical Cantor / Bourbaki single-point intersection.

Proof:
1. Pick `x n ∈ S n`.
2. Show `x` is Cauchy (nesting + diameter shrinkage).
3. Completeness gives a limit `y`.
4. Each `S n` is closed and contains the tail `x m` for `m ≥ n`, so `y ∈ S n`.
-/
theorem msc_09_nested_closed_nonempty
    [CompleteSpace X]
    (S : ℕ → Set X)
    (hS_closed : ∀ n, IsClosed (S n))
    (hS_nonempty : ∀ n, (S n).Nonempty)
    (hS_nested : ∀ ⦃m n⦄, m ≤ n → S n ⊆ S m)
    (hS_bounded : ∀ n, Bornology.IsBounded (S n))
    (hS_diam : Filter.Tendsto (fun n => Metric.diam (S n)) Filter.atTop (nhds 0)) :
    (⋂ n, S n).Nonempty := by
  -- Step 1: pick representatives
  choose x hx using hS_nonempty
  -- Step 2: prove `x` is Cauchy
  have hCauchy : CauchySeq x := by
    rw [Metric.cauchySeq_iff]
    intro ε hε
    obtain ⟨N, hN⟩ : ∃ N, Metric.diam (S N) < ε := by
      have := (Metric.tendsto_nhds.mp hS_diam) ε hε
      obtain ⟨N, hN⟩ := this.exists
      exact ⟨N, by simpa [Real.dist_eq, abs_of_nonneg Metric.diam_nonneg] using hN⟩
    refine ⟨N, fun m hm n hn => ?_⟩
    have hxm : x m ∈ S N := hS_nested hm (hx m)
    have hxn : x n ∈ S N := hS_nested hn (hx n)
    have : dist (x m) (x n) ≤ Metric.diam (S N) :=
      Metric.dist_le_diam_of_mem (hS_bounded N) hxm hxn
    exact lt_of_le_of_lt this hN
  -- Step 3: completeness gives a limit
  obtain ⟨y, hy⟩ := cauchySeq_tendsto_of_complete hCauchy
  refine ⟨y, ?_⟩
  -- Step 4: y is in every S n
  rw [Set.mem_iInter]
  intro n
  refine (hS_closed n).mem_of_tendsto hy ?_
  filter_upwards [Filter.eventually_ge_atTop n] with m hm
  exact hS_nested hm (hx m)

/--
**Witness form, MSC_09'.** Same hypotheses; gives an explicit point `y` lying
in every set of the chain. Used by Banach fixed-point (Rudin §9.23).
-/
theorem msc_09_witness
    [CompleteSpace X]
    (S : ℕ → Set X)
    (hS_closed : ∀ n, IsClosed (S n))
    (hS_nonempty : ∀ n, (S n).Nonempty)
    (hS_nested : ∀ ⦃m n⦄, m ≤ n → S n ⊆ S m)
    (hS_bounded : ∀ n, Bornology.IsBounded (S n))
    (hS_diam : Filter.Tendsto (fun n => Metric.diam (S n)) Filter.atTop (nhds 0)) :
    ∃ y, ∀ n, y ∈ S n := by
  obtain ⟨y, hy⟩ := msc_09_nested_closed_nonempty S hS_closed hS_nonempty
    hS_nested hS_bounded hS_diam
  exact ⟨y, fun n => Set.mem_iInter.mp hy n⟩

/-! ## MSC_10 — completion-style wrapper -/

/--
**Rudin 1976 §3.11 (corollary, MSC_10), Cauchy → convergent in complete space.**

If `X` is complete and `a : ℕ → X` is Cauchy, then `a` converges. Existential
form derived as a corollary of MSC_09 by taking `S n = closure {a k | k ≥ n}`.
Mathlib supplies the direct proof.
-/
theorem msc_10_cauchy_converges
    [CompleteSpace X] {a : ℕ → X} (h : CauchySeq a) :
    ∃ x, Filter.Tendsto a Filter.atTop (nhds x) :=
  cauchySeq_tendsto_of_complete h

/-- ℝ-instance form (Rudin 1976 §3.11 explicitly: ℝ is complete). -/
theorem msc_10_real
    {a : ℕ → ℝ} (h : CauchySeq a) :
    ∃ x, Filter.Tendsto a Filter.atTop (nhds x) :=
  cauchySeq_tendsto_of_complete h

end MathlibExpansion.Topology.Metric.CompletenessCriteria
