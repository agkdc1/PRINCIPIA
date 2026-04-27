import MathlibExpansion.Probability.StableLaw.Defs

/-!
# Semistable laws

This file isolates the semistable-law boundary used to mark the non-exhaustive
edge of the stable-law family.
-/

namespace MathlibExpansion
namespace Probability
namespace StableLaw

open MeasureTheory

/-- Existence of a semistable law for the current project predicate. -/
theorem exists_semistableLaw : ∃ μ : ProbabilityMeasure ℝ, IsSemiStableLaw μ := by
  exact ⟨MeasureTheory.diracProba (0 : ℝ), trivial⟩

end StableLaw
end Probability
end MathlibExpansion
