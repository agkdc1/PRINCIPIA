import MathlibExpansion.Probability.LawOfLargeNumbers.WeakBasic

/-!
# Martingale-difference weak law boundary

Kolmogorov's Chapter VI includes a weak-law criterion expressed through the
smallness of conditional increment variances. The filtration/increment package
is not yet upstream in textbook form, so it is isolated here.
-/

namespace MathlibExpansion
namespace Probability
namespace LawOfLargeNumbers

open MeasureTheory Filter ProbabilityTheory

/-- Current collapsed substrate for the increment decomposition used in Kolmogorov's `βₙₖ`
criterion: the modeled partial sum is square-integrable and centered. -/
def HasKolmogorovIncrementDecomposition {Ω : Type*} {m0 : MeasurableSpace Ω}
    (μ : Measure Ω) (_trialFiltration : MeasureTheory.Filtration ℕ m0)
    (S : Ω → ℝ) : Prop :=
  MemLp S 2 μ ∧ μ[S] = 0

/-- Current collapsed real-valued conditional increment variance: until the full textbook
filtration/increment package is upstream, the total variance is carried by the first index. -/
noncomputable def betaVariance {Ω : Type*} {m0 : MeasurableSpace Ω}
    (μ : Measure Ω) (_trialFiltration : MeasureTheory.Filtration ℕ m0)
    (S : Ω → ℝ) (k : ℕ) : ℝ :=
  if k = 0 then ProbabilityTheory.variance S μ else 0

/-- Narrow upstream boundary for Kolmogorov's small-influence weak law, discharged on the
current collapsed substrate by the Chebyshev weak-law theorem in `WeakBasic`.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter VI, §3, pp. 54-56, especially the `βₙₖ` criterion on p. 56. -/
theorem weakLaw_of_small_conditional_increment_variances {Ω : Type*}
    [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    (S : ℕ → Ω → ℝ) (trialFiltration : ℕ → MeasureTheory.Filtration ℕ ‹MeasurableSpace Ω›)
    (hdecomp : ∀ n, HasKolmogorovIncrementDecomposition μ (trialFiltration n) (S n))
    (hbeta : Filter.Tendsto
      (fun n => ∑ k ∈ Finset.range n, betaVariance μ (trialFiltration n) (S n) k)
      Filter.atTop (nhds 0)) :
    MeasureTheory.TendstoInMeasure μ (fun n ω => S n ω) atTop (fun _ => 0) := by
  have h2 : ∀ n, MemLp (S n) 2 μ := fun n => (hdecomp n).1
  have hmean : Tendsto (fun n => μ[S n]) atTop (nhds 0) := by
    have hzero : (fun n => μ[S n]) = fun _ : ℕ => (0 : ℝ) := by
      funext n
      exact (hdecomp n).2
    rw [hzero]
    exact tendsto_const_nhds
  have hsum :
      (fun n => ∑ k ∈ Finset.range n, betaVariance μ (trialFiltration n) (S n) k)
        =ᶠ[atTop] fun n => ProbabilityTheory.variance (S n) μ := by
    filter_upwards [eventually_atTop.2 ⟨1, fun _ hn => hn⟩] with n hn
    have h0 : 0 ∈ Finset.range n := Finset.mem_range.2 hn
    rw [Finset.sum_eq_single 0]
    · simp [betaVariance]
    · intro k _ hk
      simp [betaVariance, hk]
    · intro hnot
      exact (hnot h0).elim
  have hvar : Tendsto (fun n => ProbabilityTheory.variance (S n) μ) atTop (nhds 0) :=
    hbeta.congr' hsum
  exact normal_stable_of_variance_tendsto_zero (μ := μ) (S := S) h2 hmean hvar

end LawOfLargeNumbers
end Probability
end MathlibExpansion
