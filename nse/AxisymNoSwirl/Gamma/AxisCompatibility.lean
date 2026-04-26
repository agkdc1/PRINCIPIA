import Mathlib
import NavierStokes.AxisymNoSwirl.Gamma.Operator
import NavierStokes.Analysis.WeightedSobolev.Measure

/-!
# NavierStokes.AxisymNoSwirl.Gamma.AxisCompatibility

Measure-theoretic axis exhaustion lemmas for the Route W `Γ` campaign.

The coercivity split isolates a `(2 / r) ∂_r` defect near the cylindrical axis.
This file packages the pure exhaustion facts needed to pass from axis-excluded
domains back to the full punctured domain `Ω = puncturedSpace` and to show that
integrals supported on shrinking cutoff annuli vanish as the inner radius tends
to `0`.

No new axioms.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Filter Real
open scoped ENNReal NNReal Topology

namespace NavierStokes.AxisymNoSwirl.Gamma

open NavierStokes.Geometry.Cylindrical
open NavierStokes.Analysis.WeightedSobolev

/-- Axis-excluded exhaustion set: the punctured domain with the radius cutoff
`rCyl ≥ r₀`. -/
def axisExhaustion (r₀ : ℝ) : Set E3 :=
  Ω ∩ {p | r₀ ≤ rCyl p}

/-- Shrinking cutoff annulus with inner radius `|r₀|` and outer radius
`|r₁| * |r₀|`.

The parameter `r₁` is a scale factor; in the intended Route W applications one
takes `1 < r₁`, so the annulus sits between the cylinders `r = r₀` and
`r = r₁ r₀`. The absolute values make the filter argument at `r₀ → 0` work on
the two-sided neighborhood filter `𝓝 0`. -/
def axisAnnulus (r₀ r₁ : ℝ) : Set E3 :=
  Ω ∩ {p | |r₀| ≤ rCyl p ∧ rCyl p < |r₁| * |r₀|}

lemma measurableSet_axisExhaustion (r₀ : ℝ) : MeasurableSet (axisExhaustion r₀) := by
  refine measurableSet_puncturedSpace.inter ?_
  exact measurableSet_le measurable_const measurable_rCyl

lemma measurableSet_axisAnnulus (r₀ r₁ : ℝ) : MeasurableSet (axisAnnulus r₀ r₁) := by
  refine measurableSet_puncturedSpace.inter ?_
  refine (measurableSet_le measurable_const measurable_rCyl).inter ?_
  exact measurableSet_lt measurable_rCyl measurable_const

lemma axisExhaustion_subset_Ω {r₀ : ℝ} : axisExhaustion r₀ ⊆ Ω := by
  intro p hp
  exact hp.1

lemma axisAnnulus_subset_Ω {r₀ r₁ : ℝ} : axisAnnulus r₀ r₁ ⊆ Ω := by
  intro p hp
  exact hp.1

/-- For nonnegative radii the shrinking annulus is the difference of two
axis-exhausted domains. -/
lemma axisAnnulus_eq_axisExhaustion_diff {r₀ r₁ : ℝ}
    (hr₀ : 0 ≤ r₀) (hr₁ : 0 ≤ r₁) :
    axisAnnulus r₀ r₁ = axisExhaustion r₀ \ axisExhaustion (r₁ * r₀) := by
  ext p
  constructor
  · intro hp
    refine ⟨?_, ?_⟩
    · exact ⟨hp.1, by simpa [axisAnnulus, axisExhaustion, abs_of_nonneg hr₀] using hp.2.1⟩
    · intro hpOuter
      have hlt : rCyl p < r₁ * r₀ := by
        simpa [abs_of_nonneg hr₀, abs_of_nonneg hr₁, mul_comm, mul_left_comm, mul_assoc] using hp.2.2
      exact (not_lt_of_ge hpOuter.2) hlt
  · rintro ⟨hpInner, hpOuter⟩
    refine ⟨hpInner.1, ?_, ?_⟩
    · simpa [axisExhaustion, abs_of_nonneg hr₀] using hpInner.2
    · have hlt : rCyl p < r₁ * r₀ := by
        by_contra hge
        exact hpOuter ⟨hpInner.1, not_lt.mp hge⟩
      simpa [abs_of_nonneg hr₀, abs_of_nonneg hr₁, mul_comm, mul_left_comm, mul_assoc] using hlt

lemma norm_indicator_le (s : Set E3) (g : E3 → ℝ) (p : E3) :
    ‖s.indicator g p‖ ≤ ‖g p‖ := by
  by_cases hp : p ∈ s
  · simp [hp]
  · simp [hp]

/-- Pointwise limit of the axis-exhaustion indicators at any fixed point. -/
lemma tendsto_indicator_axisExhaustion (f : E3 → ℝ) (p : E3) :
    Tendsto (fun r₀ => (axisExhaustion r₀).indicator (Ω.indicator f) p)
      (𝓝 0) (𝓝 ((Ω.indicator f) p)) := by
  by_cases hp : p ∈ Ω
  · have hpos : 0 < rCyl p := rCyl_pos_on_Ω hp
    have hevent :
        ∀ᶠ r₀ in 𝓝 0, (axisExhaustion r₀).indicator (Ω.indicator f) p = (Ω.indicator f) p := by
      have hmem : {r₀ : ℝ | r₀ < rCyl p} ∈ 𝓝 0 :=
        isOpen_Iio.mem_nhds hpos
      filter_upwards [hmem] with r₀ hr₀
      have hpExh : p ∈ axisExhaustion r₀ := ⟨hp, hr₀.le⟩
      simp [hpExh]
    have hevent' :
        (fun _ : ℝ => (Ω.indicator f) p) =ᶠ[𝓝 0]
          fun r₀ => (axisExhaustion r₀).indicator (Ω.indicator f) p := by
      filter_upwards [hevent] with r₀ hr₀
      exact hr₀.symm
    exact tendsto_const_nhds.congr' hevent'
  · have hevent :
        ∀ᶠ r₀ in 𝓝 0, (axisExhaustion r₀).indicator (Ω.indicator f) p = (Ω.indicator f) p := by
      filter_upwards [] with r₀
      simp [axisExhaustion, hp]
    have hevent' :
        (fun _ : ℝ => (Ω.indicator f) p) =ᶠ[𝓝 0]
          fun r₀ => (axisExhaustion r₀).indicator (Ω.indicator f) p := by
      filter_upwards [hevent] with r₀ hr₀
      exact hr₀.symm
    exact tendsto_const_nhds.congr' hevent'

/-- Pointwise limit of shrinking-annulus indicators at any fixed point. -/
lemma tendsto_indicator_axisAnnulus (r₁ : ℝ) (f : E3 → ℝ) (p : E3) :
    Tendsto (fun r₀ => (axisAnnulus r₀ r₁).indicator (Ω.indicator f) p)
      (𝓝 0) (𝓝 0) := by
  by_cases hp : p ∈ Ω
  · have hpos : 0 < rCyl p := rCyl_pos_on_Ω hp
    have hsmall :
        ∀ᶠ r₀ in 𝓝 0, |r₁| * |r₀| < rCyl p := by
      have hIio : Set.Iio (rCyl p) ∈ 𝓝 (|r₁| * |(0 : ℝ)|) := by
        simpa using (isOpen_Iio.mem_nhds hpos : Set.Iio (rCyl p) ∈ 𝓝 (0 : ℝ))
      exact ((continuous_const.mul continuous_abs).tendsto 0).eventually hIio
    have hevent :
        ∀ᶠ r₀ in 𝓝 0, (axisAnnulus r₀ r₁).indicator (Ω.indicator f) p = 0 := by
      filter_upwards [hsmall] with r₀ hr₀
      have hpAnn : p ∉ axisAnnulus r₀ r₁ := by
        intro hp'
        exact (not_lt_of_ge hr₀.le) hp'.2.2
      simp [hpAnn]
    have hevent' :
        (fun _ : ℝ => (0 : ℝ)) =ᶠ[𝓝 0]
          fun r₀ => (axisAnnulus r₀ r₁).indicator (Ω.indicator f) p := by
      filter_upwards [hevent] with r₀ hr₀
      exact hr₀.symm
    exact tendsto_const_nhds.congr' hevent'
  · have hevent :
        ∀ᶠ r₀ in 𝓝 0, (axisAnnulus r₀ r₁).indicator (Ω.indicator f) p = 0 := by
      filter_upwards [] with r₀
      simp [axisAnnulus, hp]
    have hevent' :
        (fun _ : ℝ => (0 : ℝ)) =ᶠ[𝓝 0]
          fun r₀ => (axisAnnulus r₀ r₁).indicator (Ω.indicator f) p := by
      filter_upwards [hevent] with r₀ hr₀
      exact hr₀.symm
    exact tendsto_const_nhds.congr' hevent'

/-- Axis-excluded integration converges to the full punctured-domain integral as
the exhaustion radius tends to `0`. -/
theorem axis_exhaustion_integral_limit
    (μ : Measure E3) (f : E3 → ℝ) (hf : Integrable f (μ.restrict Ω)) :
    Tendsto (fun r₀ => ∫ p in axisExhaustion r₀, f p ∂μ) (𝓝 0)
      (𝓝 (∫ p in Ω, f p ∂μ)) := by
  let g : E3 → ℝ := Ω.indicator f
  have hg : Integrable g μ := by
    rw [integrable_indicator_iff measurableSet_puncturedSpace]
    simpa [g, Ω] using hf
  let F : ℝ → E3 → ℝ := fun r₀ => (axisExhaustion r₀).indicator g
  have hF_meas : ∀ᶠ r₀ in 𝓝 0, AEStronglyMeasurable (F r₀) μ := by
    filter_upwards [] with r₀
    exact hg.aestronglyMeasurable.indicator (measurableSet_axisExhaustion r₀)
  have h_bound : ∀ᶠ r₀ in 𝓝 0, ∀ᵐ p ∂μ, ‖F r₀ p‖ ≤ ‖g p‖ := by
    filter_upwards [] with r₀
    exact Filter.Eventually.of_forall (fun p => norm_indicator_le (axisExhaustion r₀) g p)
  have h_lim : ∀ᵐ p ∂μ, Tendsto (fun r₀ => F r₀ p) (𝓝 0) (𝓝 (g p)) := by
    exact Filter.Eventually.of_forall (fun p => by
      simpa [F, g] using tendsto_indicator_axisExhaustion f p)
  have hmain :
      Tendsto (fun r₀ => ∫ p, F r₀ p ∂μ) (𝓝 0) (𝓝 (∫ p, g p ∂μ)) :=
    MeasureTheory.tendsto_integral_filter_of_dominated_convergence
      (fun p => ‖g p‖) hF_meas h_bound hg.norm h_lim
  have hleft :
      (fun r₀ => ∫ p in axisExhaustion r₀, f p ∂μ) = fun r₀ => ∫ p, F r₀ p ∂μ := by
    funext r₀
    rw [integral_indicator (measurableSet_axisExhaustion r₀)]
    exact
      (setIntegral_congr_fun (μ := μ) (s := axisExhaustion r₀) (f := g) (g := f)
        (measurableSet_axisExhaustion r₀) (by
          intro p hp
          simp [g, axisExhaustion_subset_Ω hp])).symm
  have hright : ∫ p in Ω, f p ∂μ = ∫ p, g p ∂μ := by
    simpa [g, Ω] using
      (integral_indicator (μ := μ) (s := Ω) (f := f) measurableSet_puncturedSpace).symm
  rw [hleft, hright]
  exact hmain

/-- Shrinking-annulus exhaustion: any `μ.restrict Ω`-integrable defect term has
vanishing integral on the standard cutoff annuli `|r₀| ≤ r < |r₁| |r₀|` as
`r₀ → 0`. -/
theorem axis_exhaustion_vanishing_boundary
    (μ : Measure E3) (r₁ : ℝ) (f : E3 → ℝ) (hf : Integrable f (μ.restrict Ω)) :
    Tendsto (fun r₀ => ∫ p in axisAnnulus r₀ r₁, f p ∂μ) (𝓝 0) (𝓝 0) := by
  let g : E3 → ℝ := Ω.indicator f
  have hg : Integrable g μ := by
    rw [integrable_indicator_iff measurableSet_puncturedSpace]
    simpa [g, Ω] using hf
  let F : ℝ → E3 → ℝ := fun r₀ => (axisAnnulus r₀ r₁).indicator g
  have hF_meas : ∀ᶠ r₀ in 𝓝 0, AEStronglyMeasurable (F r₀) μ := by
    filter_upwards [] with r₀
    exact hg.aestronglyMeasurable.indicator (measurableSet_axisAnnulus r₀ r₁)
  have h_bound : ∀ᶠ r₀ in 𝓝 0, ∀ᵐ p ∂μ, ‖F r₀ p‖ ≤ ‖g p‖ := by
    filter_upwards [] with r₀
    exact Filter.Eventually.of_forall (fun p => norm_indicator_le (axisAnnulus r₀ r₁) g p)
  have h_lim : ∀ᵐ p ∂μ, Tendsto (fun r₀ => F r₀ p) (𝓝 0) (𝓝 0) := by
    exact Filter.Eventually.of_forall (fun p => by
      simpa [F, g] using tendsto_indicator_axisAnnulus r₁ f p)
  have hmain :
      Tendsto (fun r₀ => ∫ p, F r₀ p ∂μ) (𝓝 0) (𝓝 (∫ p, (0 : E3 → ℝ) p ∂μ)) :=
    MeasureTheory.tendsto_integral_filter_of_dominated_convergence
      (fun p => ‖g p‖) hF_meas h_bound hg.norm h_lim
  have hleft :
      (fun r₀ => ∫ p in axisAnnulus r₀ r₁, f p ∂μ) = fun r₀ => ∫ p, F r₀ p ∂μ := by
    funext r₀
    rw [integral_indicator (measurableSet_axisAnnulus r₀ r₁)]
    exact
      (setIntegral_congr_fun (μ := μ) (s := axisAnnulus r₀ r₁) (f := g) (g := f)
        (measurableSet_axisAnnulus r₀ r₁) (by
          intro p hp
          simp [g, axisAnnulus_subset_Ω hp])).symm
  rw [hleft]
  simpa using hmain

end NavierStokes.AxisymNoSwirl.Gamma

end
