import MathlibExpansion.Analysis.InnerProductSpace.FourierSeriesOfOrthonormalFamily

/-!
# Complete orthonormal-family packaging

This file isolates the completeness criterion needed by the von Neumann queue:
the orthogonal complement of the span vanishes exactly when the closed span is
the whole space, equivalently when the corresponding orthogonal projection is
the identity.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

variable {𝕜 : Type*} {E : Type*} {ι : Type*}
variable [RCLike 𝕜] [NormedAddCommGroup E] [_root_.InnerProductSpace 𝕜 E] [CompleteSpace E]

/-- Completeness can be read either as dense span or vanishing orthogonal complement. -/
theorem closedSpan_eq_top_iff_orthogonal_eq_bot (v : ι → E) :
    closedSpan (𝕜 := 𝕜) (E := E) (ι := ι) v = ⊤ ↔
      (Submodule.span 𝕜 (Set.range v))ᗮ = ⊥ := by
  simpa [closedSpan] using
    (Submodule.topologicalClosure_eq_top_iff (K := Submodule.span 𝕜 (Set.range v)))

/--
Completeness criterion linking vanishing orthogonal complement to the identity
action of the closed-span projection.

Source: J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
Ch. II §§3-4, in the Hilbert-basis / orthogonal-expansion corridor.
-/
theorem orthogonal_eq_bot_iff_projection_eq_self (v : ι → E) :
    (Submodule.span 𝕜 (Set.range v))ᗮ = ⊥ ↔
      ∀ x : E,
        (orthogonalProjection (closedSpan (𝕜 := 𝕜) (E := E) (ι := ι) v) x : E) = x := by
  rw [← closedSpan_eq_top_iff_orthogonal_eq_bot (𝕜 := 𝕜) (E := E) (ι := ι) v]
  constructor
  · intro hU x
    exact (orthogonalProjection_eq_self_iff
      (K := closedSpan (𝕜 := 𝕜) (E := E) (ι := ι) v) (v := x)).mpr (by
        rw [hU]
        trivial)
  · intro hproj
    exact top_le_iff.mp (by
      intro x _hx
      exact (orthogonalProjection_eq_self_iff
        (K := closedSpan (𝕜 := 𝕜) (E := E) (ι := ι) v) (v := x)).mp (hproj x))

end InnerProductSpace
end Analysis
end MathlibExpansion
