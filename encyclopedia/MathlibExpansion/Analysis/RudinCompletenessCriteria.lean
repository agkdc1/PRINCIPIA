/-
# Metric Completeness Criteria (Rudin 1976 §3.10-3.11)
RMSC for T20c_mid_18.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Analysis.RudinCompletenessCriteria

/-- **Rudin 1976 §3.10, Cauchy sequence is metric-bounded.** -/
theorem cauchy_isBounded {X : Type*} [PseudoMetricSpace X]
    {a : ℕ → X} (h : CauchySeq a) :
    Bornology.IsBounded (Set.range a) := h.isBounded_range

/-- **Rudin 1976 §3.11 MSC_09, Cauchy sequences in complete spaces converge.**
Concrete witness: `limUnder Filter.atTop a`. -/
theorem cauchy_converges {X : Type*} [PseudoMetricSpace X] [CompleteSpace X]
    [Nonempty X] {a : ℕ → X} (h : CauchySeq a) :
    Filter.Tendsto a Filter.atTop (nhds (limUnder Filter.atTop a)) :=
  h.tendsto_limUnder

/-- Existence form of Rudin 1976 §3.11 MSC_09. -/
theorem cauchy_converges_exists {X : Type*} [PseudoMetricSpace X] [CompleteSpace X]
    {a : ℕ → X} (h : CauchySeq a) :
    ∃ x, Filter.Tendsto a Filter.atTop (nhds x) := by
  haveI : Nonempty X := ⟨a 0⟩
  exact ⟨_, h.tendsto_limUnder⟩

/-- **Rudin 1976 §3.11 corollary, ℝ is complete.** -/
theorem real_complete : CompleteSpace ℝ := by infer_instance

/-- **Rudin 1976 §3.11, ℂ is complete.** -/
theorem complex_complete : CompleteSpace ℂ := by infer_instance

/-- **Rudin 1976 §3.10 ε-bound, Cauchy diameter shrinks to zero.** -/
theorem cauchy_eventually_close {X : Type*} [PseudoMetricSpace X]
    {a : ℕ → X} (h : CauchySeq a) (ε : ℝ) (hε : 0 < ε) :
    ∃ N, ∀ m ≥ N, ∀ n ≥ N, dist (a m) (a n) < ε :=
  (Metric.cauchySeq_iff.mp h) ε hε

/-- **Rudin 1976 §3.10 corollary, Cauchy diameter eventually ≤ ε.** -/
theorem cauchy_eventually_le {X : Type*} [PseudoMetricSpace X]
    {a : ℕ → X} (h : CauchySeq a) (ε : ℝ) (hε : 0 < ε) :
    ∃ N, ∀ m ≥ N, ∀ n ≥ N, dist (a m) (a n) ≤ ε := by
  obtain ⟨N, hN⟩ := cauchy_eventually_close h ε hε
  exact ⟨N, fun m hm n hn => le_of_lt (hN m hm n hn)⟩

end MathlibExpansion.Analysis.RudinCompletenessCriteria
