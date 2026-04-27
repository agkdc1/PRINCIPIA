import Mathlib

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace WeakDual1932

open Topology
open Filter

variable {𝕜 E : Type*}
variable [NontriviallyNormedField 𝕜]
variable [SeminormedAddCommGroup E] [NormedSpace 𝕜 E]

/-- Sequential weak-star convergence of a dual sequence. -/
def WeakStarConvergesSeq (u : ℕ → NormedSpace.Dual 𝕜 E) (f : WeakDual 𝕜 E) : Prop :=
  Tendsto (fun n => NormedSpace.Dual.toWeakDual (u n)) atTop (𝓝 f)

/-- Banach's weak-star convergence criterion is the upstream pointwise-evaluation criterion. -/
theorem weakStarConvergesSeq_iff_forall_eval_tendsto
    {u : ℕ → NormedSpace.Dual 𝕜 E} {f : WeakDual 𝕜 E} :
    WeakStarConvergesSeq (𝕜 := 𝕜) u f ↔
      ∀ x : E, Tendsto (fun n => u n x) atTop (𝓝 (f x)) := by
  simpa [WeakStarConvergesSeq] using
    (tendsto_iff_forall_eval_tendsto_topDualPairing
      (𝕜 := 𝕜) (E := E) (f := fun n => NormedSpace.Dual.toWeakDual (u n)) (x := f)
      (l := atTop))

private def weakDualEvalLM (x : E) : WeakDual 𝕜 E →ₗ[𝕜] 𝕜 :=
  (WeakBilin.eval (topDualPairing 𝕜 E) x).toLinearMap

/--
Upstream-narrow Banach `1932` / Hausdorff `1927` boundary: in a separable normed space, each
weak-star closed dual ball is metrizable by evaluation on a countable dense subset.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. XI §8, proof of
Théorème 9, formula `(34)`, pp. 169--170; Banach cites F. Hausdorff, *Mengenlehre* (1927),
p. 197, for the compact metric sequential extraction step. This is the closed-ball
metrization TODO recorded in `Mathlib/Analysis/Normed/Module/WeakDual.lean`.
-/
axiom weakStar_closedBall_metrizable_of_separable [TopologicalSpace.SeparableSpace E] (C : ℝ) :
    TopologicalSpace.MetrizableSpace {f : WeakDual 𝕜 E | ‖WeakDual.toNormedDual f‖ ≤ C}

/--
Sequential Banach-Alaoglu for bounded dual sequences over a proper scalar field.

The compactness input is Mathlib's `WeakDual.isCompact_closedBall`; the remaining upstream
boundary is the cited weak-star closed-ball metrization theorem above.
-/
theorem exists_subseq_tendsto_weakDual_of_bounded_sequence [ProperSpace 𝕜]
    [TopologicalSpace.SeparableSpace E]
    {u : ℕ → NormedSpace.Dual 𝕜 E} (hu : ∃ C : ℝ, ∀ n : ℕ, ‖u n‖ ≤ C) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧
      ∃ f : WeakDual 𝕜 E,
        Tendsto (fun n => NormedSpace.Dual.toWeakDual (u (φ n))) atTop (𝓝 f) := by
  rcases hu with ⟨C, hC⟩
  let s : Set (WeakDual 𝕜 E) := {f : WeakDual 𝕜 E | ‖WeakDual.toNormedDual f‖ ≤ C}
  have hsCompact : IsCompact s := by
    have hset :
        (WeakDual.toNormedDual ⁻¹' Metric.closedBall (0 : NormedSpace.Dual 𝕜 E) C) = s := by
      ext f
      simp [s, Metric.mem_closedBall, dist_eq_norm]
    simpa [s, hset] using
      (WeakDual.isCompact_closedBall (𝕜 := 𝕜) (E := E) (0 : NormedSpace.Dual 𝕜 E) C)
  haveI : CompactSpace s := isCompact_iff_compactSpace.mp hsCompact
  haveI : TopologicalSpace.MetrizableSpace s :=
    weakStar_closedBall_metrizable_of_separable (𝕜 := 𝕜) (E := E) C
  let v : ℕ → s := fun n =>
    ⟨NormedSpace.Dual.toWeakDual (u n), by
      change ‖WeakDual.toNormedDual (NormedSpace.Dual.toWeakDual (u n))‖ ≤ C
      simpa [WeakDual.toNormedDual, NormedSpace.Dual.toWeakDual] using hC n⟩
  rcases CompactSpace.tendsto_subseq v with ⟨a, φ, hφ, hlim⟩
  refine ⟨φ, hφ, a.1, ?_⟩
  have hlim' :
      Tendsto (fun n => (v (φ n) : WeakDual 𝕜 E)) atTop (𝓝 (a : WeakDual 𝕜 E)) :=
    (continuous_subtype_val.tendsto a).comp hlim
  simpa [v, Function.comp_def] using hlim'

/--
Banach `1932`, Ch. VIII §8, Théorème 8, discharged from the induced weak-star topology:
continuity at zero gives a finite set of evaluation coordinates controlling the functional, and
the finite-span kernel criterion combines those coordinates into one primal vector.
-/
theorem weakStarContinuous_dualFunctional_eq_eval [TopologicalSpace.SeparableSpace E]
    (F : WeakDual 𝕜 E →L[𝕜] 𝕜) :
    ∃ x : E, ∀ f : WeakDual 𝕜 E, F f = f x := by
  classical
  let coeMap : WeakDual 𝕜 E → (E → 𝕜) := fun f x => f x
  have hpre : F ⁻¹' Metric.ball (0 : 𝕜) 1 ∈ 𝓝 (0 : WeakDual 𝕜 E) := by
    have hball : Metric.ball (0 : 𝕜) 1 ∈ 𝓝 (F (0 : WeakDual 𝕜 E)) := by
      simpa using Metric.ball_mem_nhds (x := (0 : 𝕜)) zero_lt_one
    exact F.continuous.tendsto (0 : WeakDual 𝕜 E) hball
  have hpre' :
      F ⁻¹' Metric.ball (0 : 𝕜) 1 ∈
        Filter.comap coeMap (𝓝 (coeMap (0 : WeakDual 𝕜 E))) := by
    simpa [coeMap, nhds_induced] using hpre
  rw [Filter.mem_comap] at hpre'
  rcases hpre' with ⟨V, hV, hVsub⟩
  rw [nhds_pi, Filter.mem_pi'] at hV
  rcases hV with ⟨I, t, ht, htV⟩
  let L : {x // x ∈ (I : Set E)} → WeakDual 𝕜 E →ₗ[𝕜] 𝕜 :=
    fun x => weakDualEvalLM (𝕜 := 𝕜) (E := E) x.1
  have hsmall {f : WeakDual 𝕜 E}
      (hf : ∀ x : {x // x ∈ (I : Set E)}, f x.1 = 0) :
      F f ∈ Metric.ball (0 : 𝕜) 1 := by
    apply hVsub
    apply htV
    intro x hx
    have h0 : (0 : 𝕜) ∈ t x := mem_of_mem_nhds (ht x)
    simpa [coeMap, hf ⟨x, hx⟩] using h0
  have hker : ⨅ x, LinearMap.ker (L x) ≤ LinearMap.ker F.toLinearMap := by
    intro f hf
    rw [LinearMap.mem_ker]
    by_contra hFne
    have hnorm_pos : 0 < ‖F f‖ := norm_pos_iff.mpr hFne
    rcases NormedField.exists_lt_norm 𝕜 (‖F f‖⁻¹) with ⟨c, hc⟩
    have hcf_eval : ∀ x : {x // x ∈ (I : Set E)}, (c • f) x.1 = 0 := by
      intro x
      have hfx_mem : f ∈ LinearMap.ker (L x) :=
        (Submodule.mem_iInf (p := fun x => LinearMap.ker (L x))).1 hf x
      have hfx : f x.1 = 0 := by
        simpa [L, weakDualEvalLM, LinearMap.mem_ker] using hfx_mem
      rw [ContinuousLinearMap.smul_apply, hfx, smul_zero]
    have hcsmall := hsmall hcf_eval
    have hcsmall_norm : ‖F (c • f)‖ < 1 := by
      simpa [Metric.mem_ball, dist_eq_norm] using hcsmall
    have hlarge : 1 < ‖F (c • f)‖ := by
      rw [F.map_smul, norm_smul]
      calc
        1 = ‖F f‖⁻¹ * ‖F f‖ := by
          rw [inv_mul_cancel₀ (ne_of_gt hnorm_pos)]
        _ < ‖c‖ * ‖F f‖ := mul_lt_mul_of_pos_right hc hnorm_pos
    exact (not_lt_of_ge hlarge.le) hcsmall_norm
  have hspan : F.toLinearMap ∈ Submodule.span 𝕜 (Set.range L) :=
    mem_span_of_iInf_ker_le_ker (L := L) (K := F.toLinearMap) hker
  rcases (mem_span_range_iff_exists_fun 𝕜).1 hspan with ⟨c, hc⟩
  refine ⟨∑ x, c x • x.1, ?_⟩
  intro f
  have hcongr := LinearMap.congr_fun hc f
  calc
    F f = F.toLinearMap f := rfl
    _ = (∑ i, c i • L i) f := hcongr.symm
    _ = ∑ x, c x * f x.1 := by
      have h_eval_apply :
          ∀ x : {x // x ∈ (I : Set E)},
            ((WeakBilin.eval (topDualPairing 𝕜 E)) x.1) f = f x.1 := by
        intro x
        rfl
      change
        (∑ x, c x • (((WeakBilin.eval (topDualPairing 𝕜 E)) x.1).toLinearMap)) f =
          ∑ x, c x * f x.1
      rw [LinearMap.sum_apply]
      exact Finset.sum_congr rfl (fun x _ => by
        rw [LinearMap.smul_apply]
        change c x * (((WeakBilin.eval (topDualPairing 𝕜 E)) x.1) f) = c x * f x.1
        rw [h_eval_apply x])
    _ = f (∑ x, c x • x.1) := by
      simp [map_sum, map_smul, smul_eq_mul]

end WeakDual1932
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
