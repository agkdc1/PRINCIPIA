import Mathlib
import MathlibExpansion.FunctionalAnalysis.Banach1932.WeakDual

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace BanachMazur

/-- The closed unit interval, used as Banach's universal compact parameter space. -/
abbrev UnitInterval := ↥(Set.Icc (0 : ℝ) 1)

/-- Banach's universal continuous-function carrier `C([0,1])`. -/
abbrev CUnitInterval := ContinuousMap UnitInterval ℝ

/--
Banach-Alaoglu compactness for the weak-star dual unit ball, used in Banach `1932`,
*Théorie des opérations linéaires*, Ch. XI §8, proof of Théorème 9, pp. 169-170.
-/
theorem weakStar_dualUnitBall_isCompact
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] :
    IsCompact {f : WeakDual ℝ E | ‖WeakDual.toNormedDual f‖ ≤ 1} := by
  have hset :
      (WeakDual.toNormedDual ⁻¹' Metric.closedBall (0 : NormedSpace.Dual ℝ E) 1) =
        {f : WeakDual ℝ E | ‖WeakDual.toNormedDual f‖ ≤ 1} := by
    ext f
    simp [Metric.mem_closedBall, dist_eq_norm]
  simpa [hset] using
    (WeakDual.isCompact_closedBall (𝕜 := ℝ) (E := E) (0 : NormedSpace.Dual ℝ E) 1)

/--
Banach `1932`, *Théorie des opérations linéaires*, Ch. XI §8, proof of Théorème 9, formula
`(34)`, pp. 169-170: for separable `E`, the weak-star dual unit ball is metrizable by evaluation
on a countable dense set.

This is a theorem-level specialization of the upstream closed-ball boundary in
`WeakDual1932`, with radius `1`.
-/
theorem weakStar_dualUnitBall_metrizable
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [TopologicalSpace.SeparableSpace E] :
    TopologicalSpace.MetrizableSpace {f : WeakDual ℝ E | ‖WeakDual.toNormedDual f‖ ≤ 1} :=
  WeakDual1932.weakStar_closedBall_metrizable_of_separable (𝕜 := ℝ) (E := E) 1

/--
Banach's Chapter XI weak-star compact-metrizable dual-unit-ball theorem in the separable case.
Compactness is supplied by Mathlib's Banach-Alaoglu theorem; the remaining local boundary is
Banach `1932`, *Théorie des opérations linéaires*, Ch. XI §8, proof of Théorème 9, formula `(34)`,
pp. 169-170.
-/
theorem weakStar_dualUnitBall_isCompact_metrizable
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    [TopologicalSpace.SeparableSpace E] :
    IsCompact {f : WeakDual ℝ E | ‖WeakDual.toNormedDual f‖ ≤ 1} ∧
      TopologicalSpace.MetrizableSpace {f : WeakDual ℝ E | ‖WeakDual.toNormedDual f‖ ≤ 1} :=
  ⟨weakStar_dualUnitBall_isCompact, weakStar_dualUnitBall_metrizable⟩

/--
Banach-Mazur theorem core, Banach `1932`, *Théorie des opérations linéaires*, Ch. XI §8,
Théorème 9, pp. 169-171: every separable real Banach space embeds linearly and isometrically into
`C([0,1])`. The closed-range clause is automatic for a linear isometry out of a complete space.
-/
axiom exists_linearIsometry_separable_to_C_unitInterval_core
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    [TopologicalSpace.SeparableSpace E] :
    Nonempty (E →ₗᵢ[ℝ] CUnitInterval)

/--
Banach-Mazur theorem, Banach `1932`, *Théorie des opérations linéaires*, Ch. XI §8, Théorème 9,
pp. 169-171: every separable real Banach space embeds linearly and isometrically into `C([0,1])`
with closed range.
-/
theorem exists_linearIsometry_separable_to_C_unitInterval
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    [TopologicalSpace.SeparableSpace E] :
    ∃ U : E →ₗᵢ[ℝ] CUnitInterval, IsClosed (Set.range U) := by
  rcases exists_linearIsometry_separable_to_C_unitInterval_core (E := E) with ⟨U⟩
  exact ⟨U, U.isometry.isUniformInducing.isComplete_range.isClosed⟩

/--
Banach `1932`, *Théorie des opérations linéaires*, Ch. XI §8, Théorème 10, p. 171: every
separable metric space embeds isometrically into `C([0,1])`. Banach cites M. Fréchet,
*Rendiconti del Circolo Matematico di Palermo* 30 (1910), p. 7, for the metric embedding
precursor. This remains subordinate to the linear Banach-Mazur theorem.
-/
axiom exists_isometricEmbedding_separableMetric_to_C_unitInterval
    (X : Type*) [MetricSpace X] [TopologicalSpace.SeparableSpace X] :
    ∃ f : X → CUnitInterval, Isometry f

end BanachMazur
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
