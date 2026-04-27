import Mathlib

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace CondensationOfSingularities

open Filter Topology
open scoped ENNReal

/-- The unit interval for Banach's `C` and `L¹` pathology examples. -/
abbrev UnitInterval := ↥(Set.Icc (0 : ℝ) 1)

/-- Restricted Lebesgue measure on `[0,1]`. -/
abbrev intervalMeasure : MeasureTheory.Measure ℝ :=
  MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc (0 : ℝ) 1)

/-- Continuous real-valued functions on the unit interval. -/
abbrev CInterval := ContinuousMap UnitInterval ℝ

/-- Banach's `L¹([0,1])` carrier. -/
abbrev L1Interval : Type :=
  ↥(MeasureTheory.Lp ℝ (1 : ℝ≥0∞) intervalMeasure)

/--
Banach's divergence-or-unboundedness alternative for a scalar sequence. This keeps the pathology
lane explicit without forcing a premature Fourier-specific API.
-/
def DivergesOrUnbounded (u : ℕ → ℝ) : Prop :=
  (¬ (∃ l : ℝ, Tendsto u atTop (𝓝 l))) ∨ ¬ Bornology.IsBounded (Set.range u)

/-- The sequence is arbitrarily large along arbitrarily late indices. -/
def ArbitrarilyLargeAtTop (u : ℕ → ℝ) : Prop :=
  ∀ M : ℝ, ∀ N : ℕ, ∃ n : ℕ, N ≤ n ∧ M ≤ u n

/--
Banach's vector-sequence corollary to Banach-Steinhaus: pointwise boundedness on the continuous
dual forces norm boundedness of the underlying vector sequence. This is the standard uniform
boundedness theorem as formalized in Mathlib's `banach_steinhaus`, applied to the canonical
embedding into the double dual.
-/
theorem norm_bdd_of_pointwise_bdd_on_dual
    {𝕜 E : Type*} [RCLike 𝕜] [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    (x : ℕ → E)
    (h : ∀ f : NormedSpace.Dual 𝕜 E, ∃ C : ℝ, ∀ n : ℕ, ‖f (x n)‖ ≤ C) :
    ∃ C' : ℝ, ∀ n : ℕ, ‖x n‖ ≤ C' := by
  let g : ℕ → NormedSpace.Dual 𝕜 E →L[𝕜] 𝕜 := fun n =>
    NormedSpace.inclusionInDoubleDual 𝕜 E (x n)
  obtain ⟨C, hC⟩ := banach_steinhaus (g := g) (by
    intro f
    rcases h f with ⟨C, hC⟩
    exact ⟨C, by
      intro n
      simpa [g, NormedSpace.dual_def] using hC n⟩)
  refine ⟨C, fun n => ?_⟩
  have hnorm : ‖g n‖ = ‖x n‖ := by
    simpa [g, NormedSpace.inclusionInDoubleDualLi] using
      (NormedSpace.inclusionInDoubleDualLi (𝕜 := 𝕜) (E := E)).norm_map (x n)
  simpa [hnorm] using hC n

/--
Banach-Steinhaus condensation of singularities, in the source-strength limsup form.

Upstream-narrow boundary for Banach-Steinhaus, "Sur le principe de la condensation de
singularités", Fundamenta Mathematicae 9 (1927), pp. 50-61, Théorème I: if every row has a point
where the row is singular with unbounded limsup, then a second-category set of points is singular
for every row. The former `Tendsto ... atTop atTop` surface was too strong for the cited theorem;
the paper proves arbitrarily late large values.
-/
axiom exists_secondCategory_rowwise_blowup
    {𝕜 E : Type*} {F : ℕ → Type*} [RCLike 𝕜] [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    [CompleteSpace E] [∀ p, NormedAddCommGroup (F p)] [∀ p, NormedSpace 𝕜 (F p)]
    (U : ∀ p, ℕ → E →L[𝕜] F p)
    (hU : ∀ p : ℕ, ∃ xₚ : E, ArbitrarilyLargeAtTop (fun q : ℕ => ‖U p q xₚ‖)) :
    ∃ G : Set E, ¬ IsMeagre G ∧
      ∀ x ∈ G, ∀ p : ℕ, ArbitrarilyLargeAtTop (fun q : ℕ => ‖U p q x‖)

/--
Scalar condensation of divergent singularities.

Upstream-narrow boundary for Banach-Steinhaus, "Sur le principe de la condensation de
singularités", Fundamenta Mathematicae 9 (1927), pp. 50-61, Théorème II, with the unbounded
alternative tracked explicitly because unbounded real sequences are divergent. This is the
countable-row scalar functional theorem used by the concrete continuous, `L¹`, and Fourier
surfaces below.
-/
axiom exists_common_point_scalar_divergesOrUnbounded
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (u : ℕ → ℕ → E →L[ℝ] ℝ)
    (hlocal : ∀ p : ℕ, ∃ xₚ : E, DivergesOrUnbounded (fun q => u p q xₚ)) :
    ∃ x : E, ∀ p : ℕ, DivergesOrUnbounded (fun q => u p q x)

/--
Banach's continuous-function pathology corollary: a single continuous function can realize the
simultaneous divergence or unboundedness demanded at any prescribed countable family of points.
This is the point-evaluation specialization of Banach-Steinhaus 1927, Théorème II.
-/
theorem exists_continuous_bad_at_countable_points
    (S : ℕ → CInterval →L[ℝ] CInterval) (t : ℕ → UnitInterval)
    (hlocal : ∀ p : ℕ, ∃ xₚ : CInterval, DivergesOrUnbounded (fun n => S n xₚ (t p))) :
    ∃ x : CInterval, ∀ p : ℕ, DivergesOrUnbounded (fun n => S n x (t p)) := by
  let u : ℕ → ℕ → CInterval →L[ℝ] ℝ := fun p n =>
    (ContinuousMap.evalCLM ℝ (t p)).comp (S n)
  simpa [u] using exists_common_point_scalar_divergesOrUnbounded (u := u) hlocal

/--
Banach's `L¹` pathology corollary on countably many prescribed intervals. The row index encodes
the prescribed interval or test functional; the theorem is the `L¹([0,1])` specialization of the
scalar condensation boundary from Banach-Steinhaus 1927, Théorème II.
-/
theorem exists_L1_bad_on_countable_intervals
    (S : ℕ → ℕ → L1Interval →L[ℝ] ℝ)
    (hlocal : ∀ p : ℕ, ∃ xₚ : L1Interval, DivergesOrUnbounded (fun n => S p n xₚ)) :
    ∃ x : L1Interval, ∀ p : ℕ, DivergesOrUnbounded (fun n => S p n x) := by
  simpa using exists_common_point_scalar_divergesOrUnbounded (u := S) hlocal

/--
Banach's Fourier-series pathology lane: a single integrable function can force interval blow-up of
the chosen scalar partial-sum interval functional family everywhere in the prescribed
Banach-Steinhaus sense. This is the Fourier-facing specialization of Banach-Steinhaus 1927,
Théorème II; the analytic construction of the Fourier interval functionals is intentionally kept
outside this condensation theorem.
-/
theorem exists_fourier_interval_blowup
    (S : ℕ → ℕ → L1Interval →L[ℝ] ℝ)
    (hlocal : ∀ p : ℕ, ∃ fₚ : L1Interval, DivergesOrUnbounded (fun n => S p n fₚ)) :
    ∃ f : L1Interval, ∀ p : ℕ, DivergesOrUnbounded (fun n => S p n f) := by
  simpa using exists_common_point_scalar_divergesOrUnbounded (u := S) hlocal

end CondensationOfSingularities
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
