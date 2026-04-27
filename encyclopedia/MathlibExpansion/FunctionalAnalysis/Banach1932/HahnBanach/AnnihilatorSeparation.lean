import Mathlib
import MathlibExpansion.FunctionalAnalysis.Banach1932.WeakDual

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace HahnBanach

open Topology
open Filter
open WeakDual1932

variable {𝕜 E : Type*}
variable [RCLike 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E]

/-- Banach's sequential weak-closure predicate for linear subspaces of the dual. -/
def SeqWeaklyClosed (Γ : Submodule 𝕜 (NormedSpace.Dual 𝕜 E)) : Prop :=
  ∀ ⦃u : ℕ → NormedSpace.Dual 𝕜 E⦄ ⦃f₀ : NormedSpace.Dual 𝕜 E⦄,
    (∀ n : ℕ, u n ∈ Γ) →
    (∀ x : E, Tendsto (fun n => u n x) atTop (𝓝 (f₀ x))) →
    f₀ ∈ Γ

/--
Banach, *Théorie des opérations linéaires* (1932), Ch. IV §2, Th. 4, following
Hahn 1927, Riesz 1910, and Helly 1912: Banach's finite-combination domination criterion is
equivalent to the existence of a norm-controlled continuous extension.
-/
theorem exists_extension_norm_le_iff_finite_sum_domination
    {G : Submodule 𝕜 E} (f : G →ₗ[𝕜] 𝕜) {M : ℝ} (hM : 0 ≤ M) :
    (∃ F : E →L[𝕜] 𝕜, (∀ x : G, F x = f x) ∧ ‖F‖ ≤ M) ↔
      ∀ {n : ℕ} (x : Fin n → G) (a : Fin n → 𝕜),
        ‖∑ i, a i * f (x i)‖ ≤ M * ‖∑ i, a i • ((x i : G) : E)‖ := by
  constructor
  · rintro ⟨F, hF, hFnorm⟩ n x a
    have hFsum : F (∑ i, a i • ((x i : G) : E)) = ∑ i, a i * f (x i) := by
      simp [map_sum, map_smul, hF, smul_eq_mul]
    rw [← hFsum]
    exact F.le_of_opNorm_le hFnorm _
  · intro h
    have hf_bound : ∀ x : G, ‖f x‖ ≤ M * ‖x‖ := by
      intro x
      simpa using h (n := 1) (fun _ : Fin 1 => x) (fun _ => (1 : 𝕜))
    let fCLM : G →L[𝕜] 𝕜 := f.mkContinuous M hf_bound
    have hfCLM_norm : ‖fCLM‖ ≤ M := by
      simpa [fCLM] using LinearMap.mkContinuous_norm_le f hM hf_bound
    obtain ⟨F, hFext, hFnormeq⟩ := exists_extension_norm_eq G fCLM
    refine ⟨F, ?_, ?_⟩
    · intro x
      simpa [fCLM] using hFext x
    · calc
        ‖F‖ = ‖fCLM‖ := hFnormeq
        _ ≤ M := hfCLM_norm

/--
Upstream-narrow citation boundary for Banach, *Théorie des opérations linéaires*
(1932), Ch. VIII §5, Théorème 6: a weak-star closed linear subspace of the dual is
separated by a primal point with Banach's quantitative norm bound.
-/
axiom exists_annihilating_point_of_weakStarClosed
    {Γ : Submodule 𝕜 (NormedSpace.Dual 𝕜 E)}
    (hΓ :
      IsClosed
        ((NormedSpace.Dual.toWeakDual : NormedSpace.Dual 𝕜 E → WeakDual 𝕜 E) '' (Γ : Set _)))
    {f₀ : NormedSpace.Dual 𝕜 E} (hf₀ : f₀ ∉ Γ) {M : ℝ}
    (hM : 0 < M) (hdist : M < Metric.infDist f₀ (Γ : Set (NormedSpace.Dual 𝕜 E))) :
    ∃ x₀ : E, f₀ x₀ = 1 ∧ (∀ f ∈ (Γ : Set (NormedSpace.Dual 𝕜 E)), f x₀ = 0) ∧ ‖x₀‖ < 1 / M

/--
The easy half of Banach's Ch. VIII §5 closedness criterion: weak-star closed dual subspaces are
sequentially weakly closed.
-/
theorem seqWeaklyClosed_of_weakStarClosed
    {Γ : Submodule 𝕜 (NormedSpace.Dual 𝕜 E)}
    (hΓ :
      IsClosed
        ((NormedSpace.Dual.toWeakDual : NormedSpace.Dual 𝕜 E → WeakDual 𝕜 E) '' (Γ : Set _))) :
    SeqWeaklyClosed (𝕜 := 𝕜) Γ := by
  intro u f₀ hu hlim
  have hweak :
      Tendsto (fun n => NormedSpace.Dual.toWeakDual (u n)) atTop
        (𝓝 (NormedSpace.Dual.toWeakDual f₀)) := by
    rw [tendsto_iff_forall_eval_tendsto_topDualPairing]
    intro x
    simpa [topDualPairing_apply] using hlim x
  have hmemWeak :
      NormedSpace.Dual.toWeakDual f₀ ∈
        ((NormedSpace.Dual.toWeakDual : NormedSpace.Dual 𝕜 E → WeakDual 𝕜 E) ''
          (Γ : Set _)) := by
    exact hΓ.mem_of_tendsto hweak
      (Filter.Eventually.of_forall fun n => ⟨u n, hu n, rfl⟩)
  rcases hmemWeak with ⟨g, hg, hg_eq⟩
  have hgf : g = f₀ := (NormedSpace.Dual.toWeakDual_inj g f₀).1 hg_eq
  simpa [hgf] using hg

/--
Upstream-narrow citation boundary for Banach, *Théorie des opérations linéaires*
(1932), Ch. VIII §5, Théorème 5: in separable spaces, Banach's sequential weak-closure
criterion implies weak-star closedness for linear subspaces of the dual.
-/
axiom weakStarClosed_of_seqWeaklyClosed [TopologicalSpace.SeparableSpace E]
    {Γ : Submodule 𝕜 (NormedSpace.Dual 𝕜 E)} :
    SeqWeaklyClosed (𝕜 := 𝕜) Γ →
    IsClosed
      ((NormedSpace.Dual.toWeakDual : NormedSpace.Dual 𝕜 E → WeakDual 𝕜 E) '' (Γ : Set _))

/--
Banach, *Théorie des opérations linéaires* (1932), Ch. VIII §5, Théorème 5: for separable
spaces, Banach's closedness notion for dual subspaces agrees with sequential weak closure.
-/
theorem weakStarClosed_iff_seqWeaklyClosed [TopologicalSpace.SeparableSpace E]
    {Γ : Submodule 𝕜 (NormedSpace.Dual 𝕜 E)} :
    IsClosed
      ((NormedSpace.Dual.toWeakDual : NormedSpace.Dual 𝕜 E → WeakDual 𝕜 E) '' (Γ : Set _)) ↔
      SeqWeaklyClosed (𝕜 := 𝕜) Γ := by
  exact ⟨seqWeaklyClosed_of_weakStarClosed, weakStarClosed_of_seqWeaklyClosed⟩

/--
Banach's weak-closed separation theorem, obtained after replacing weak-star closedness by the
sequential criterion in the separable case.
-/
theorem exists_annihilating_point_of_seqWeaklyClosed [TopologicalSpace.SeparableSpace E]
    {Γ : Submodule 𝕜 (NormedSpace.Dual 𝕜 E)}
    (hΓ : SeqWeaklyClosed (𝕜 := 𝕜) Γ)
    {f₀ : NormedSpace.Dual 𝕜 E} (hf₀ : f₀ ∉ Γ) {M : ℝ}
    (hM : 0 < M) (hdist : M < Metric.infDist f₀ (Γ : Set (NormedSpace.Dual 𝕜 E))) :
    ∃ x₀ : E, f₀ x₀ = 1 ∧ (∀ f ∈ (Γ : Set (NormedSpace.Dual 𝕜 E)), f x₀ = 0) ∧
      ‖x₀‖ < 1 / M := by
  exact exists_annihilating_point_of_weakStarClosed
    ((weakStarClosed_iff_seqWeaklyClosed (𝕜 := 𝕜) (E := E)).2 hΓ) hf₀ hM hdist

end HahnBanach
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
