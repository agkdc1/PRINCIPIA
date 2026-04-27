import Mathlib

/-!
# Reed-Simon 1972 — BDHB_REFINEMENT: Banach duality and Hahn-Banach refinement

Reed and Simon, *Methods of Modern Mathematical Physics I: Functional Analysis* (1972),
Ch. III §§2-3. Banach duality refinements and the Hahn-Banach annihilator-separation seam
Reed reuses downstream. This file does not rebuild the core Hahn-Banach theorem — it
records the annihilator-separation refinement axiom and sequential weak-star criteria
that Reed uses as prerequisites for the weak-topology (Ch. IV) and locally convex
(Ch. V) chapters.

Primary citation: Banach, *Théorie des opérations linéaires* (1932), Ch. IV §2 Th. 4 and
Ch. VIII §5 Th. 5-6. Reed 1972 Ch. III §§2-3 follows Banach's Chapter IV/VIII presentation.
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace BanachDuality

open Filter Topology

variable {𝕜 E : Type*}
variable [RCLike 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E]

/--
Reed 1972 Ch. III §2: the Banach-duality refinement package records the sequentially
weakly closed property of a dual subspace. Used by Ch. III §3 and Ch. IV §5.
-/
structure RefinementPackage (Γ : Submodule 𝕜 (NormedSpace.Dual 𝕜 E)) : Prop where
  seq_weak_closed : ∀ ⦃u : ℕ → NormedSpace.Dual 𝕜 E⦄ ⦃f₀ : NormedSpace.Dual 𝕜 E⦄,
    (∀ n : ℕ, u n ∈ Γ) →
    (∀ x : E, Tendsto (fun n => u n x) atTop (𝓝 (f₀ x))) → f₀ ∈ Γ

/--
Reed 1972 Ch. III §3 Proposition 2, following Banach 1932 Ch. IV §2 Th. 4:
for `0 ≤ M`, a bounded linear functional defined on a subspace admits a
norm-bounded continuous extension iff it satisfies the finite-combination
domination criterion. Reed-facing seam axiom: the upstream Banach 1932 Hahn-Banach
refinement is the consumer; recorded here as a boundary axiom until the Banach1932
sibling-library lands.
-/
axiom exists_extension_norm_le_iff_finite_sum_domination
    {G : Submodule 𝕜 E} (f : G →ₗ[𝕜] 𝕜) {M : ℝ} (_hM : 0 ≤ M) :
    (∃ F : E →L[𝕜] 𝕜, (∀ x : G, F x = f x) ∧ ‖F‖ ≤ M) ↔
      ∀ {n : ℕ} (x : Fin n → G) (a : Fin n → 𝕜),
        ‖∑ i, a i * f (x i)‖ ≤ M * ‖∑ i, a i • ((x i : G) : E)‖

/-- The trivial refinement package: the zero subspace is sequentially weakly closed. -/
theorem refinementPackage_bot : RefinementPackage (⊥ : Submodule 𝕜 (NormedSpace.Dual 𝕜 E)) where
  seq_weak_closed := by
    intro u f₀ hu hlim
    have h0 : ∀ n : ℕ, u n = 0 := by
      intro n
      simpa [Submodule.mem_bot] using hu n
    have : ∀ x : E, f₀ x = 0 := by
      intro x
      have : Tendsto (fun n : ℕ => u n x) atTop (𝓝 0) := by
        simpa [h0] using (tendsto_const_nhds : Tendsto (fun _ : ℕ => (0 : 𝕜)) atTop (𝓝 0))
      exact tendsto_nhds_unique (hlim x) this
    have hf₀ : f₀ = 0 := by
      ext x; simpa using this x
    simpa [Submodule.mem_bot] using hf₀

end BanachDuality
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
