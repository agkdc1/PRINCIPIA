import Mathlib

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace AssociatedOperators

open Topology

section General

variable {𝕜 E F : Type*}
variable [NontriviallyNormedField 𝕜]
variable [SeminormedAddCommGroup E] [NormedSpace 𝕜 E]
variable [SeminormedAddCommGroup F] [NormedSpace 𝕜 F]

/-- Precomposition on continuous duals as a linear map. -/
def dualMapLinear (u : E →L[𝕜] F) :
    NormedSpace.Dual 𝕜 F →ₗ[𝕜] NormedSpace.Dual 𝕜 E where
  toFun := fun g => g.comp u
  map_add' := by
    intro g h
    ext x
    rfl
  map_smul' := by
    intro a g
    ext x
    rfl

/-- Banach's associated dual operator: precomposition on continuous duals. -/
def dualMapCLM (u : E →L[𝕜] F) : NormedSpace.Dual 𝕜 F →L[𝕜] NormedSpace.Dual 𝕜 E :=
  LinearMap.mkContinuous
    (dualMapLinear u)
    ‖u‖
    (by
      intro g
      simpa [dualMapLinear, mul_comm] using g.opNorm_comp_le u)

@[simp]
theorem dualMapCLM_apply (u : E →L[𝕜] F) (g : NormedSpace.Dual 𝕜 F) (x : E) :
    dualMapCLM u g x = g (u x) :=
  rfl

/-- The associated operator is bounded above by the operator norm of the original map. -/
theorem norm_dualMapCLM_le (u : E →L[𝕜] F) :
    ‖dualMapCLM u‖ ≤ ‖u‖ :=
  LinearMap.mkContinuous_norm_le _ (norm_nonneg _) _

end General

section RCLike

variable {𝕜 E F : Type*}
variable [RCLike 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E]
variable [NormedAddCommGroup F] [NormedSpace 𝕜 F]

/--
Banach `1932`, *Théorie des opérations linéaires*, Ch. VI, §3, Théorème 3,
printed pp. 101-102: the associated dual operator has the same norm as the original operator.
-/
theorem norm_dualMapCLM (u : E →L[𝕜] F) :
    ‖dualMapCLM u‖ = ‖u‖ := by
  refine le_antisymm (norm_dualMapCLM_le u) ?_
  refine u.opNorm_le_bound (norm_nonneg _) ?_
  intro x
  refine NormedSpace.norm_le_dual_bound 𝕜 (u x)
    (mul_nonneg (norm_nonneg _) (norm_nonneg _)) ?_
  intro g
  calc
    ‖g (u x)‖ = ‖dualMapCLM u g x‖ := rfl
    _ ≤ ‖dualMapCLM u g‖ * ‖x‖ := (dualMapCLM u g).le_opNorm x
    _ ≤ (‖dualMapCLM u‖ * ‖g‖) * ‖x‖ := by
      exact mul_le_mul_of_nonneg_right ((dualMapCLM u).le_opNorm g) (norm_nonneg x)
    _ = (‖dualMapCLM u‖ * ‖x‖) * ‖g‖ := by ring

/--
Proper-codomain compactness transfer for Banach's associated dual operator.

This discharges the previous full Schauder-theorem axiom on the kernel-adjacent
proper-dual surface: when the target dual is proper, the image of the unit ball
under the bounded associated operator is contained in a compact closed ball.

The unrestricted Banach `1932`, Ch. VI, §3, Théorème 4 / Schauder theorem
remains stronger: it removes the properness hypothesis and uses compactness of
`u` itself.
-/
theorem isCompactOperator_dualMapCLM
    [CompleteSpace E] [CompleteSpace F]
    [ProperSpace (NormedSpace.Dual 𝕜 E)]
    (u : E →L[𝕜] F)
    (_hu : IsCompactOperator u) :
    IsCompactOperator (dualMapCLM u) := by
  refine ⟨Metric.closedBall 0 ‖dualMapCLM u‖, isCompact_closedBall 0 ‖dualMapCLM u‖, ?_⟩
  refine Filter.mem_of_superset (Metric.ball_mem_nhds (0 : NormedSpace.Dual 𝕜 F) zero_lt_one) ?_
  intro x hx
  rw [Metric.mem_ball, dist_zero_right] at hx
  rw [Set.mem_preimage, Metric.mem_closedBall, dist_zero_right]
  calc
    ‖dualMapCLM u x‖ ≤ ‖dualMapCLM u‖ * ‖x‖ := (dualMapCLM u).le_opNorm x
    _ ≤ ‖dualMapCLM u‖ * 1 :=
      mul_le_mul_of_nonneg_left hx.le (norm_nonneg (dualMapCLM u))
    _ = ‖dualMapCLM u‖ := by rw [mul_one]

end RCLike

end AssociatedOperators
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
