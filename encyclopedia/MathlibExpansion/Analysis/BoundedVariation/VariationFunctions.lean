import Mathlib.Data.Real.Basic

import Mathlib.Topology.EMetricSpace.BoundedVariation

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace BoundedVariation

/-- Textbook-facing carrier for canonical positive/negative Jordan components. -/
structure JordanVariationData (f : ℝ → ℝ) (s : Set ℝ) (a : ℝ) where
  positive : ℝ → ℝ
  negative : ℝ → ℝ
  positive_mono : MonotoneOn positive s
  negative_mono : MonotoneOn negative s
  eval_eq : ∀ x ∈ s, f x = f a + positive x - negative x

/--
`BVJD_05`: canonical Jordan components exist for bounded-variation data.

Discharged from Mathlib's
`LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn`, the Lean form of
Jordan's decomposition theorem for bounded-variation functions.
-/
theorem exists_canonical_jordan_components {f : ℝ → ℝ} {s : Set ℝ} {a : ℝ}
    (h : LocallyBoundedVariationOn f s) (ha : a ∈ s) :
    Nonempty (JordanVariationData f s a) := by
  have _ha := ha
  rcases h.exists_monotoneOn_sub_monotoneOn with ⟨p, q, hp, hq, hf⟩
  refine ⟨⟨p, fun x => q x + f a, hp, ?_, ?_⟩⟩
  · intro x hx y hy hxy
    exact add_le_add_right (hq hx hy hxy) (f a)
  · intro x hx
    have hfx : f x = p x - q x := by
      simpa [Pi.sub_apply] using congrFun hf x
    calc
      f x = p x - q x := hfx
      _ = f a + p x - (q x + f a) := by ring

/--
Narrow upstream continuity gap for the interval variation function.

Citation target: Zheng, Rettinger, and von Braunmuehl, 2002,
"On the Jordan Decomposability for Computable Functions of Bounded Variation",
Theorem 2.1(1): if `f` is a continuous bounded-variation function, then its
variation function `v_f` is continuous and increasing.
-/
axiom continuousOn_variationOnFromTo_of_continuousOn {f : ℝ → ℝ} {a b : ℝ}
    (h : LocallyBoundedVariationOn f (Set.Icc a b))
    (hcont : ContinuousOn f (Set.Icc a b)) :
    ContinuousOn (fun x => variationOnFromTo f (Set.Icc a b) a x) (Set.Icc a b)

/--
`BVJD_06`: continuity of `f` propagates to the canonical Jordan components.

The remaining upstream ingredient is the continuity of the total-variation
function, cited above. Once that is available, the canonical components
`v_f` and `v_f - f + f a` are continuous by algebra.
-/
theorem continuous_canonical_jordan_components {f : ℝ → ℝ} {a b : ℝ}
    (h : LocallyBoundedVariationOn f (Set.Icc a b))
    (hcont : ContinuousOn f (Set.Icc a b)) :
    ∃ data : JordanVariationData f (Set.Icc a b) a,
      ContinuousOn data.positive (Set.Icc a b) ∧
        ContinuousOn data.negative (Set.Icc a b) := by
  by_cases hab : a ≤ b
  · let v : ℝ → ℝ := fun x => variationOnFromTo f (Set.Icc a b) a x
    let n : ℝ → ℝ := fun x => v x - f x + f a
    have ha : a ∈ Set.Icc a b := ⟨le_rfl, hab⟩
    have hv_mono : MonotoneOn v (Set.Icc a b) := by
      simpa [v] using variationOnFromTo.monotoneOn h ha
    have hn_mono : MonotoneOn n (Set.Icc a b) := by
      have hv_sub_mono : MonotoneOn (fun x => v x - f x) (Set.Icc a b) := by
        simpa [v, Pi.sub_apply] using variationOnFromTo.sub_self_monotoneOn h ha
      intro x hx y hy hxy
      exact add_le_add_right (hv_sub_mono hx hy hxy) (f a)
    have heval : ∀ x ∈ Set.Icc a b, f x = f a + v x - n x := by
      intro x hx
      simp [n]
      ring
    have hv_cont : ContinuousOn v (Set.Icc a b) := by
      simpa [v] using continuousOn_variationOnFromTo_of_continuousOn h hcont
    have hn_cont : ContinuousOn n (Set.Icc a b) := by
      simpa [n] using (hv_cont.sub hcont).add continuousOn_const
    exact ⟨⟨v, n, hv_mono, hn_mono, heval⟩, hv_cont, hn_cont⟩
  · have h_empty : Set.Icc a b = ∅ := Set.Icc_eq_empty hab
    refine ⟨⟨fun _ => 0, fun _ => 0, ?_, ?_, ?_⟩, ?_, ?_⟩
    · intro x hx y hy hxy
      exact le_rfl
    · intro x hx y hy hxy
      exact le_rfl
    · intro x hx
      rw [h_empty] at hx
      exact False.elim hx
    · exact continuousOn_const
    · exact continuousOn_const

end BoundedVariation
end Analysis
end MathlibExpansion
