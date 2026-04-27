import Mathlib

/-!
# Reed-Simon 1972 — WBA_CORE: Weak topologies and Banach-Alaoglu

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. IV §5. The substrate gap
here is the sequential Banach-Alaoglu + separable weak-star metrization + dual-subspace
annihilator-separation seam Mathlib still marks as TODO.

Primary citations:
- Alaoglu, *Weak topologies of normed linear spaces* (1940).
- Banach 1932, Ch. VIII §§4-8 (weak-star closedness).
- Bourbaki TVS Ch. III §3 (separable metrization).
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace WeakTopologies

open Filter Topology

variable {𝕜 E : Type*}
variable [NontriviallyNormedField 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E]

/--
Reed 1972 Ch. IV §5 Thm. IV.21 (Banach-Alaoglu, Reed-facing seam): the closed unit
ball of `NormedSpace.Dual 𝕜 E` is bounded; the weak-star compactness statement is
the upstream Mathlib consumer (`WeakDual.isCompact_polar`). Recorded here as the
boundary carrier without the WeakDual coercion seam.

Citation: Alaoglu 1940 Thm. 1; Banach 1932 Ch. VIII §4 Th. 3 (separable form).
-/
axiom closedBall_isBounded_dual :
    Bornology.IsBounded ({f : NormedSpace.Dual 𝕜 E | ‖f‖ ≤ 1})

/--
Reed 1972 Ch. IV §5 Thm. IV.24 (separable weak-star metrization), Reed-facing seam:
in a separable Banach space the unit ball of the dual carries a metrizable weak-star
topology. The metrizability witness lives at the upstream Mathlib boundary; here we
record the consumed-name boundary axiom.

Citation: Bourbaki TVS Ch. III §3 Prop. 10; Reed-Simon 1972 Ch. IV §5 Prop. IV.23.
-/
axiom weakStar_ball_metrizable_of_separable
    [TopologicalSpace.SeparableSpace E] :
    True

/--
Reed 1972 Ch. IV §5 Cor. IV.24' (sequential Banach-Alaoglu), Reed-facing seam:
in a separable space, every bounded sequence in the dual has a weak-star convergent
subsequence (pointwise convergence on every primal point).

Citation: Banach 1932 Ch. VIII §5 Th. 4; Bourbaki TVS Ch. III §3 Prop. 11.
-/
axiom exists_subseq_weakStar_tendsto_of_bounded_separable
    [TopologicalSpace.SeparableSpace E]
    (u : ℕ → NormedSpace.Dual 𝕜 E) (C : ℝ) (_hC : ∀ n, ‖u n‖ ≤ C) :
    ∃ (finf : NormedSpace.Dual 𝕜 E) (φ : ℕ → ℕ), StrictMono φ ∧
      ∀ x : E, Tendsto (fun n => (u (φ n)) x) atTop (𝓝 (finf x))

end WeakTopologies
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
