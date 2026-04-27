import Mathlib

/-!
# Kolmogorov 1933 left-continuous CDF wrappers

Kolmogorov's Chapter III uses the strict-cut convention
`a ↦ P(X < a)` rather than mathlib's right-continuous `cdf` based on `Iic`.
This file lands the direct wrapper and proves the one-dimensional regularity
and uniqueness facts from mathlib's measure-continuity and Borel-generator API.
-/

namespace MathlibExpansion
namespace Probability
namespace CDF

open MeasureTheory ProbabilityTheory Set Filter
open scoped Topology

/-- Kolmogorov's strict-cut distribution function `a ↦ P(X < a)`. -/
noncomputable def leftCDF {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ → ℝ :=
  fun a => (μ (X ⁻¹' Set.Iio a)).toReal

theorem leftCDF_mono {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsFiniteMeasure μ] (X : Ω → ℝ) :
    Monotone (leftCDF μ X) := by
  intro a b hab
  have hpre : X ⁻¹' Set.Iio a ⊆ X ⁻¹' Set.Iio b := by
    intro ω hω
    exact lt_of_lt_of_le hω hab
  exact ENNReal.toReal_mono (MeasureTheory.measure_ne_top μ _)
    (measure_mono hpre)

theorem leftCDF_eq_map_Iio {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsFiniteMeasure μ] {X : Ω → ℝ}
    (hX : AEMeasurable X μ) (a : ℝ) :
    leftCDF μ X a = (μ.map X (Set.Iio a)).toReal := by
  simp [leftCDF, Measure.map_apply_of_aemeasurable hX measurableSet_Iio]

private theorem tendsto_measure_Iio_nhdsLT (ν : Measure ℝ) (a : ℝ) :
    Tendsto (fun b : ℝ => ν (Set.Iio b)) (𝓝[<] a) (𝓝 (ν (Set.Iio a))) := by
  rw [← map_coe_Iio_atTop a, tendsto_map'_iff]
  have hmono : Monotone fun b : Set.Iio a => Set.Iio (b : ℝ) := by
    intro b c hbc
    exact Iio_subset_Iio hbc
  have hlim :
      Tendsto (fun b : Set.Iio a => ν (Set.Iio (b : ℝ))) atTop
        (𝓝 (ν (⋃ b : Set.Iio a, Set.Iio (b : ℝ)))) :=
    tendsto_measure_iUnion_atTop (μ := ν) hmono
  have hUnion : (⋃ b : Set.Iio a, Set.Iio (b : ℝ)) = Set.Iio a := by
    ext x
    simp only [Set.mem_iUnion, Set.mem_Iio]
    constructor
    · rintro ⟨b, hb⟩
      exact hb.trans b.2
    · intro hx
      have hxmid : x < (x + a) / 2 := by linarith
      have hmida : (x + a) / 2 < a := by linarith
      exact ⟨⟨(x + a) / 2, hmida⟩, hxmid⟩
  simpa [hUnion] using hlim

private theorem continuousWithinAt_measure_Iio_toReal (ν : Measure ℝ) [IsFiniteMeasure ν]
    (a : ℝ) :
    ContinuousWithinAt (fun b : ℝ => (ν (Set.Iio b)).toReal) (Set.Iio a) a := by
  exact (ENNReal.continuousAt_toReal (measure_ne_top ν (Set.Iio a))).tendsto.comp
    (tendsto_measure_Iio_nhdsLT ν a)

private theorem tendsto_measure_Iio_toReal_atBot (ν : Measure ℝ) [IsFiniteMeasure ν] :
    Tendsto (fun a : ℝ => (ν (Set.Iio a)).toReal) atBot (𝓝 0) := by
  have hlim :
      Tendsto (fun a : ℝ => ν (Set.Iio a)) atBot
        (𝓝 (ν (⋂ a : ℝ, Set.Iio a))) := by
    refine tendsto_measure_iInter_atBot (μ := ν)
      (s := fun a : ℝ => Set.Iio a) (fun _ => measurableSet_Iio.nullMeasurableSet)
      monotone_Iio ⟨0, measure_ne_top ν _⟩
  have hInter : (⋂ a : ℝ, Set.Iio a) = ∅ := by
    exact iInter_Iio_of_not_bddBelow_range (f := fun a : ℝ => a) (by
      rw [not_bddBelow_iff]
      intro x
      exact ⟨x - 1, ⟨x - 1, rfl⟩, by linarith⟩)
  have hlim0 : Tendsto (fun a : ℝ => ν (Set.Iio a)) atBot (𝓝 0) := by
    simpa [hInter] using hlim
  have hzero_ne_top : (0 : ENNReal) ≠ ⊤ := by simp
  have htoReal := (ENNReal.continuousAt_toReal hzero_ne_top).tendsto.comp hlim0
  simpa using htoReal

private theorem tendsto_measure_Iio_toReal_atTop (ν : Measure ℝ) [IsProbabilityMeasure ν] :
    Tendsto (fun a : ℝ => (ν (Set.Iio a)).toReal) atTop (𝓝 1) := by
  have hlim :
      Tendsto (fun a : ℝ => ν (Set.Iio a)) atTop
        (𝓝 (ν (⋃ a : ℝ, Set.Iio a))) :=
    tendsto_measure_iUnion_atTop (μ := ν) monotone_Iio
  have hlim1 : Tendsto (fun a : ℝ => ν (Set.Iio a)) atTop (𝓝 1) := by
    simpa [iUnion_Iio] using hlim
  have hone_ne_top : (1 : ENNReal) ≠ ⊤ := by simp
  have htoReal := (ENNReal.continuousAt_toReal hone_ne_top).tendsto.comp hlim1
  simpa using htoReal

private theorem Measure.ext_of_Iio_real (ν η : Measure ℝ) [IsFiniteMeasure ν]
    (h : ∀ a : ℝ, ν (Set.Iio a) = η (Set.Iio a)) : ν = η := by
  refine Measure.ext_of_generateFrom_of_iUnion (μ := ν) (ν := η)
    (C := Set.range fun a : ℝ => Set.Iio a) (B := fun n : ℕ => Set.Iio (n : ℝ))
    ?_ isPiSystem_Iio ?_ ?_ ?_ ?_
  · simpa using (borel_eq_generateFrom_Iio ℝ)
  · ext x
    simp only [Set.mem_iUnion, Set.mem_Iio, Set.mem_univ, iff_true]
    exact exists_nat_gt x
  · intro n
    exact ⟨(n : ℝ), rfl⟩
  · intro n
    exact measure_ne_top ν _
  · intro s hs
    rcases hs with ⟨a, rfl⟩
    exact h a

/-- Kolmogorov's left-continuity and endpoint package in the strict-cut convention
`P(X < a)`.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter III, §2, pp. 21-22. -/
theorem leftCDF_regularity {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : AEMeasurable X μ) :
    (∀ a, ContinuousWithinAt (leftCDF μ X) (Set.Iio a) a) ∧
      Filter.Tendsto (leftCDF μ X) Filter.atBot (nhds 0) ∧
      Filter.Tendsto (leftCDF μ X) Filter.atTop (nhds 1) := by
  let ν : Measure ℝ := μ.map X
  haveI : IsProbabilityMeasure ν := isProbabilityMeasure_map hX
  have hleft : leftCDF μ X = fun a => (ν (Set.Iio a)).toReal := by
    funext a
    exact leftCDF_eq_map_Iio (μ := μ) (X := X) hX a
  refine ⟨?_, ?_, ?_⟩
  · intro a
    rw [hleft]
    exact continuousWithinAt_measure_Iio_toReal ν a
  · rw [hleft]
    exact tendsto_measure_Iio_toReal_atBot ν
  · rw [hleft]
    exact tendsto_measure_Iio_toReal_atTop ν

/-- Uniqueness theorem phrased directly in Kolmogorov's strict-cut convention.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter III, §2, p. 22. -/
theorem map_eq_of_leftCDF_eq {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] {X Y : Ω → ℝ}
    (hX : AEMeasurable X μ) (hY : AEMeasurable Y μ)
    (hF : leftCDF μ X = leftCDF μ Y) :
    μ.map X = μ.map Y := by
  let νX : Measure ℝ := μ.map X
  let νY : Measure ℝ := μ.map Y
  haveI : IsProbabilityMeasure νX := isProbabilityMeasure_map hX
  haveI : IsProbabilityMeasure νY := isProbabilityMeasure_map hY
  refine Measure.ext_of_Iio_real νX νY ?_
  intro a
  refine (ENNReal.toReal_eq_toReal (measure_ne_top νX _) (measure_ne_top νY _)).mp ?_
  have h := congr_fun hF a
  simpa [νX, νY, leftCDF_eq_map_Iio (μ := μ) (X := X) hX a,
    leftCDF_eq_map_Iio (μ := μ) (X := Y) hY a] using h

end CDF
end Probability
end MathlibExpansion
