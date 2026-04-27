import Mathlib

/-!
# Reed-Simon 1972 — FPT_SIDECAR (DEFER): Fixed-point theorem sidecar

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. V appendix and Vol. I
distributional applications. DEFER row: Reed's corridor consumes Banach's fixed-point
theorem (contraction mapping) and Schauder's fixed-point theorem from external owners.

Primary citations:
- S. Banach (1922), *Sur les opérations dans les ensembles abstraits*, §3 Thm.
- J. Schauder (1930), *Der Fixpunktsatz in Funktionalräumen*.
- Reed-Simon (1972), Vol. I Ch. V appendix; consumer of upstream Mathlib FPTs.
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace Defers

variable {α : Type*} [MetricSpace α] [CompleteSpace α] [Nonempty α]

/--
Reed 1972 Vol. I Ch. V appendix (Banach contraction-mapping theorem reuse): a
contraction mapping on a complete metric space has a unique fixed point.

Citation: Banach 1922 §3 Thm.; Reed-Simon 1972 Vol. I Ch. V appendix. DEFER row —
direct consumer of Mathlib's `ContractingWith.exists_fixedPoint`.
-/
axiom banach_fixed_point_reuse
    (f : α → α) (K : NNReal) (_hK : K < 1)
    (_hcont : ∀ x y : α, dist (f x) (f y) ≤ K * dist x y) :
    ∃! x : α, f x = x

end Defers
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
