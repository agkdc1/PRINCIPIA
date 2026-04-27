import Mathlib

/-!
# Small continuity lemmas for Cauchy 1821

This module records the same-sign neighborhood lemma used just before the
intermediate value theorem in Cauchy's Chapter II.
-/

open Filter

namespace MathlibExpansion
namespace Textbooks
namespace Cauchy1821

/-- A continuous function with positive value at a point is eventually positive
near that point. -/
theorem ContinuousAt.eventually_pos {α : Type*} [TopologicalSpace α] {f : α → ℝ} {x : α}
    (hf : ContinuousAt f x) (hx : 0 < f x) : ∀ᶠ y in nhds x, 0 < f y :=
  hf.tendsto.eventually (Ioi_mem_nhds hx)

/-- A continuous function with negative value at a point is eventually negative
near that point. -/
theorem ContinuousAt.eventually_neg {α : Type*} [TopologicalSpace α] {f : α → ℝ} {x : α}
    (hf : ContinuousAt f x) (hx : f x < 0) : ∀ᶠ y in nhds x, f y < 0 :=
  hf.tendsto.eventually (Iio_mem_nhds hx)

/-- A continuous real function near a point with nonzero value is eventually of
the same sign as that value. -/
theorem ContinuousAt.eventually_sameSign {α : Type*} [TopologicalSpace α] {f : α → ℝ} {x : α}
    (hf : ContinuousAt f x) (hx : f x ≠ 0) :
    ∀ᶠ y in nhds x, 0 < f y ∨ f y < 0 := by
  rcases lt_or_gt_of_ne hx with hxneg | hxpos
  · exact (ContinuousAt.eventually_neg hf hxneg).mono fun _ hy => Or.inr hy
  · exact (ContinuousAt.eventually_pos hf hxpos).mono fun _ hy => Or.inl hy

end Cauchy1821
end Textbooks
end MathlibExpansion
