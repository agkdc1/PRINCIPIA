import Mathlib

/-!
# Weak convergence to CDF convergence

This file packages the one-dimensional Helly-Bray / Portmanteau corollaries at
the CDF boundary.
-/

namespace MathlibExpansion
namespace Probability
namespace CDF

open scoped Topology

open MeasureTheory Filter Set

/--
A continuity point of the distribution function has no atom.

Source anchor: Lévy (1925), *Calcul des probabilités*, Part II, Chapter 4,
subitem `Limite d'une loi de probabilité`; formal substrate:
`ProbabilityTheory.measure_cdf` and `StieltjesFunction.measure_singleton`.
-/
theorem measure_singleton_eq_zero_of_continuousAt_cdf {μ : ProbabilityMeasure ℝ} {x : ℝ}
    (hx : ContinuousAt (ProbabilityTheory.cdf (μ : Measure ℝ)) x) :
    (μ : Measure ℝ) ({x} : Set ℝ) = 0 := by
  let F : StieltjesFunction := ProbabilityTheory.cdf (μ : Measure ℝ)
  have hleft : Function.leftLim F x = F x :=
    tendsto_nhds_unique (F.mono.tendsto_leftLim x) (hx.tendsto.mono_left nhdsWithin_le_nhds)
  have hF : F.measure ({x} : Set ℝ) = 0 := by
    rw [StieltjesFunction.measure_singleton, hleft, sub_self, ENNReal.ofReal_zero]
  simpa [F, ProbabilityTheory.measure_cdf (μ : Measure ℝ)] using hF

private theorem tendsto_measure_toReal_of_null_frontier {ι : Type*} {L : Filter ι}
    {μs : ι → ProbabilityMeasure ℝ} {μ : ProbabilityMeasure ℝ} (hμs : Tendsto μs L (𝓝 μ))
    {E : Set ℝ} (hE : (μ : Measure ℝ) (frontier E) = 0) :
    Tendsto (fun i ↦ ((μs i : Measure ℝ) E).toReal) L
      (𝓝 (((μ : Measure ℝ) E).toReal)) := by
  exact (ENNReal.tendsto_toReal (measure_ne_top (μ : Measure ℝ) E)).comp
    (ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto' hμs hE)

/--
Weak convergence implies convergence of lower half-line masses at atom-free points.

Source anchor: Lévy (1925), *Calcul des probabilités*, Part II, Chapter 4,
subitem `Limite d'une loi de probabilité`; formal substrate:
`ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto'` and `frontier_Iic`.
-/
theorem tendsto_measure_Iic_of_tendsto {ι : Type*} {L : Filter ι}
    {μs : ι → ProbabilityMeasure ℝ} {μ : ProbabilityMeasure ℝ}
    (hμs : Tendsto μs L (𝓝 μ)) {x : ℝ}
    (hx : (μ : Measure ℝ) ({x} : Set ℝ) = 0) :
    Tendsto (fun i ↦ ((μs i : Measure ℝ) (Set.Iic x)).toReal) L
      (𝓝 (((μ : Measure ℝ) (Set.Iic x)).toReal)) := by
  exact tendsto_measure_toReal_of_null_frontier hμs (by simpa using hx)

/--
Weak convergence implies CDF convergence at continuity points of the limit law.

Source anchor: Lévy (1925), *Calcul des probabilités*, Part II, Chapter 4,
subitem `Limite d'une loi de probabilité`; formal substrate:
`ProbabilityTheory.cdf_eq_toReal` and the lower half-line null-frontier theorem above.
-/
theorem tendsto_cdf_of_tendsto {ι : Type*} {L : Filter ι}
    {μs : ι → ProbabilityMeasure ℝ} {μ : ProbabilityMeasure ℝ}
    (hμs : Tendsto μs L (𝓝 μ)) {x : ℝ}
    (hx : ContinuousAt (ProbabilityTheory.cdf (μ : Measure ℝ)) x) :
    Tendsto (fun i ↦ ProbabilityTheory.cdf (μs i : Measure ℝ) x) L
      (𝓝 (ProbabilityTheory.cdf (μ : Measure ℝ) x)) := by
  simpa [ProbabilityTheory.cdf_eq_toReal] using
    tendsto_measure_Iic_of_tendsto hμs (measure_singleton_eq_zero_of_continuousAt_cdf hx)

/--
Weak convergence implies convergence of open lower half-line masses at atom-free points.

Source anchor: Lévy (1925), *Calcul des probabilités*, Part II, Chapter 4,
subitem `Limite d'une loi de probabilité`; formal substrate:
`ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto'` and `frontier_Iio`.
-/
theorem tendsto_measure_Iio_of_tendsto {ι : Type*} {L : Filter ι}
    {μs : ι → ProbabilityMeasure ℝ} {μ : ProbabilityMeasure ℝ}
    (hμs : Tendsto μs L (𝓝 μ)) {x : ℝ}
    (hx : (μ : Measure ℝ) ({x} : Set ℝ) = 0) :
    Tendsto (fun i ↦ ((μs i : Measure ℝ) (Set.Iio x)).toReal) L
      (𝓝 (((μ : Measure ℝ) (Set.Iio x)).toReal)) := by
  exact tendsto_measure_toReal_of_null_frontier hμs (by simpa using hx)

/--
Weak convergence implies convergence of interval probabilities at continuity endpoints.

Source anchor: Lévy (1925), *Calcul des probabilités*, Part II, Chapter 4,
subitem `Limite d'une loi de probabilité`; formal substrate:
`ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto'` and frontier formulas for
`Icc`, `Ioc`, `Ico`, and `Ioo`.
-/
theorem tendsto_measure_intervals_of_tendsto {ι : Type*} {L : Filter ι}
    {μs : ι → ProbabilityMeasure ℝ} {μ : ProbabilityMeasure ℝ}
    (hμs : Tendsto μs L (𝓝 μ)) {a b : ℝ} (hab : a < b)
    (ha : ContinuousAt (ProbabilityTheory.cdf (μ : Measure ℝ)) a)
    (hb : ContinuousAt (ProbabilityTheory.cdf (μ : Measure ℝ)) b) :
    Tendsto (fun i ↦ ((μs i : Measure ℝ) (Set.Icc a b)).toReal) L
        (𝓝 (((μ : Measure ℝ) (Set.Icc a b)).toReal)) ∧
      Tendsto (fun i ↦ ((μs i : Measure ℝ) (Set.Ioc a b)).toReal) L
        (𝓝 (((μ : Measure ℝ) (Set.Ioc a b)).toReal)) ∧
      Tendsto (fun i ↦ ((μs i : Measure ℝ) (Set.Ico a b)).toReal) L
        (𝓝 (((μ : Measure ℝ) (Set.Ico a b)).toReal)) ∧
      Tendsto (fun i ↦ ((μs i : Measure ℝ) (Set.Ioo a b)).toReal) L
        (𝓝 (((μ : Measure ℝ) (Set.Ioo a b)).toReal)) := by
  have ha0 : (μ : Measure ℝ) ({a} : Set ℝ) = 0 :=
    measure_singleton_eq_zero_of_continuousAt_cdf ha
  have hb0 : (μ : Measure ℝ) ({b} : Set ℝ) = 0 :=
    measure_singleton_eq_zero_of_continuousAt_cdf hb
  have hpair : (μ : Measure ℝ) ({a, b} : Set ℝ) = 0 := by
    rw [show ({a, b} : Set ℝ) = ({a} : Set ℝ) ∪ ({b} : Set ℝ) by
      ext y
      simp [or_comm]]
    rw [measure_union]
    · simp [ha0, hb0]
    · simp [hab.ne]
    · exact measurableSet_singleton b
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact tendsto_measure_toReal_of_null_frontier hμs (by simpa [frontier_Icc hab.le] using hpair)
  · exact tendsto_measure_toReal_of_null_frontier hμs (by simpa [frontier_Ioc hab] using hpair)
  · exact tendsto_measure_toReal_of_null_frontier hμs (by simpa [frontier_Ico hab] using hpair)
  · exact tendsto_measure_toReal_of_null_frontier hμs (by simpa [frontier_Ioo hab] using hpair)

end CDF
end Probability
end MathlibExpansion
