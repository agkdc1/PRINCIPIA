import Mathlib

open scoped BoundedContinuousFunction Topology
open Filter

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace ClassicalSpaces

variable (𝕜 : Type*) [NormedField 𝕜]

/-- Banach's ambient bounded-sequence carrier with the sup norm. -/
abbrev BoundedSequence := ℕ →ᵇ 𝕜

/-- Banach's classical `c` space: bounded scalar sequences converging at `atTop`. -/
def cSubspace : Submodule 𝕜 (BoundedSequence 𝕜) where
  carrier := { u | ∃ l : 𝕜, Tendsto (fun n => u n) atTop (𝓝 l) }
  zero_mem' := by
    refine ⟨0, ?_⟩
    simp
  add_mem' := by
    intro u v hu hv
    rcases hu with ⟨lu, hlu⟩
    rcases hv with ⟨lv, hlv⟩
    refine ⟨lu + lv, ?_⟩
    simpa using hlu.add hlv
  smul_mem' := by
    intro a u hu
    rcases hu with ⟨l, hl⟩
    refine ⟨a * l, ?_⟩
    simpa [mul_comm a l] using hl.const_mul a

/-- The type of convergent bounded sequences. -/
abbrev ConvergentSeq := cSubspace 𝕜

namespace ConvergentSeq

variable {𝕜}

instance : CoeFun (ConvergentSeq 𝕜) (fun _ => ℕ → 𝕜) :=
  ⟨fun u => (u : BoundedSequence 𝕜)⟩

/-- The canonical inclusion `c ↪ l^∞`. -/
abbrev subtypeCLM : ConvergentSeq 𝕜 →L[𝕜] BoundedSequence 𝕜 :=
  Submodule.subtypeL (cSubspace 𝕜)

/-- Every element of Banach's `c` space converges to its chosen limit. -/
theorem tends_to_some_limit (u : ConvergentSeq 𝕜) :
    ∃ l : 𝕜, Tendsto (fun n => u n) atTop (𝓝 l) :=
  u.property

/-- The limit of a convergent bounded sequence. -/
noncomputable def limit (u : ConvergentSeq 𝕜) : 𝕜 :=
  Classical.choose u.property

/-- The chosen limit satisfies the convergence predicate. -/
theorem tendsto_limit (u : ConvergentSeq 𝕜) :
    Tendsto (fun n => u n) atTop (𝓝 (limit u)) :=
  Classical.choose_spec u.property

/-- Coordinate evaluation on Banach's `c` space. -/
def evalCLM (n : ℕ) : ConvergentSeq 𝕜 →L[𝕜] 𝕜 :=
  (BoundedContinuousFunction.evalCLM 𝕜 n).comp (subtypeCLM (𝕜 := 𝕜))

@[simp]
theorem evalCLM_apply (n : ℕ) (u : ConvergentSeq 𝕜) :
    evalCLM (𝕜 := 𝕜) n u = u n :=
  rfl

/--
Banach's convergent-sequence subspace of `ℕ →ᵇ 𝕜` is closed for the inherited sup norm.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §5, pp. 160-161,
where the classical sequence spaces are treated as Banach spaces with the sup norm.
-/
theorem isClosed_cSubspace [CompleteSpace 𝕜] :
    IsClosed (cSubspace 𝕜 : Set (BoundedSequence 𝕜)) := by
  classical
  rw [← closure_subset_iff_isClosed]
  intro f hf
  rw [Metric.mem_closure_iff] at hf
  have hδ :
      Tendsto (fun n : ℕ => (1 / 2 : ℝ) ^ n) atTop (𝓝 0) :=
    tendsto_pow_atTop_nhds_zero_of_lt_one (by norm_num) (by norm_num)
  choose g hg using fun n : ℕ => hf ((1 / 2 : ℝ) ^ n) (by positivity)
  have hg_tendsto : Tendsto g atTop (𝓝 f) := by
    rw [Metric.tendsto_atTop]
    intro ε hε
    rw [Metric.tendsto_atTop] at hδ
    rcases hδ ε hε with ⟨N, hN⟩
    refine ⟨N, fun n hn => ?_⟩
    have hpow : (1 / 2 : ℝ) ^ n < ε := by
      simpa [Real.dist_eq, abs_of_nonneg (pow_nonneg (by norm_num) n)] using hN n hn
    simpa [dist_comm] using (hg n).2.trans hpow
  have hg_uniform :
      TendstoUniformly (fun k n => g k n) (fun n => f n) atTop :=
    (BoundedContinuousFunction.tendsto_iff_tendstoUniformly).1 hg_tendsto
  choose L hL using fun n : ℕ => (hg n).1
  have hL_dist_le (m n : ℕ) : dist (L m) (L n) ≤ dist (g m) (g n) := by
    exact le_of_tendsto' ((hL m).dist (hL n)) fun k =>
      BoundedContinuousFunction.dist_coe_le_dist k
  have hL_cauchy : CauchySeq L := by
    rw [Metric.cauchySeq_iff]
    intro ε hε
    rw [Metric.tendsto_atTop] at hg_tendsto
    rcases hg_tendsto (ε / 2) (half_pos hε) with ⟨N, hN⟩
    refine ⟨N, fun m hm n hn => ?_⟩
    calc
      dist (L m) (L n) ≤ dist (g m) (g n) := hL_dist_le m n
      _ ≤ dist (g m) f + dist f (g n) := dist_triangle _ _ _
      _ < ε / 2 + ε / 2 := add_lt_add (hN m hm) (by simpa [dist_comm] using hN n hn)
      _ = ε := add_halves ε
  rcases cauchySeq_tendsto_of_complete hL_cauchy with ⟨l, hL_tendsto⟩
  exact ⟨l, hg_uniform.tendsto_of_eventually_tendsto (Eventually.of_forall hL) hL_tendsto⟩

/--
Banach's convergent-sequence space `c` is complete over a complete scalar field.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §5, pp. 160-161.
The completeness hypothesis on `𝕜` is necessary; without it, constant sequences would make the
statement imply completeness of the scalar field itself.
-/
instance instCompleteSpaceConvergentSeq [CompleteSpace 𝕜] : CompleteSpace (ConvergentSeq 𝕜) :=
  (isClosed_cSubspace (𝕜 := 𝕜)).completeSpace_coe

/-- The limit operation on `c` as a linear map. -/
noncomputable def limitLinearMap : ConvergentSeq 𝕜 →ₗ[𝕜] 𝕜 where
  toFun := limit
  map_add' u v := by
    refine tendsto_nhds_unique (tendsto_limit (u + v)) ?_
    simpa using (tendsto_limit u).add (tendsto_limit v)
  map_smul' a u := by
    refine tendsto_nhds_unique (tendsto_limit (a • u)) ?_
    simpa using (tendsto_limit u).const_smul a

/-- The limit of a convergent bounded sequence is bounded by its sup norm. -/
theorem norm_limit_le (u : ConvergentSeq 𝕜) : ‖limit u‖ ≤ ‖u‖ := by
  have hnorm :
      Tendsto (fun n => ‖u n‖) atTop (𝓝 ‖limit u‖) :=
    (tendsto_limit u).norm
  refine le_of_tendsto' hnorm fun n => ?_
  simpa [Submodule.coe_norm] using
    BoundedContinuousFunction.norm_coe_le_norm (f := (u : BoundedSequence 𝕜)) n

/-- Banach's continuous limit functional on the `c` space. -/
noncomputable def limitCLM : ConvergentSeq 𝕜 →L[𝕜] 𝕜 :=
  (limitLinearMap (𝕜 := 𝕜)).mkContinuous 1 (by
    intro u
    simpa using norm_limit_le (𝕜 := 𝕜) u)

/--
The limit functional on Banach's `c` space is continuous linear for the sup norm.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §5, pp. 160-161.
-/
theorem exists_limitCLM : ∃ L : ConvergentSeq 𝕜 →L[𝕜] 𝕜, ∀ u : ConvergentSeq 𝕜, L u = limit u :=
  ⟨limitCLM (𝕜 := 𝕜), fun _ => rfl⟩

@[simp]
theorem limitCLM_apply (u : ConvergentSeq 𝕜) :
    limitCLM (𝕜 := 𝕜) u = limit u :=
  rfl

end ConvergentSeq

end ClassicalSpaces
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
