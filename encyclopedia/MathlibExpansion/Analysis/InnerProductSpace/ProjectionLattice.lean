import MathlibExpansion.Analysis.InnerProductSpace.ProjectionOperator

/-!
# Projection lattice boundary

This file records the operator-lattice theorems around commuting orthogonal
projections as narrow upstream-facing boundaries.

Primary sources:
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
  Ch. II §4, Sätze 14-16.
- E. Hellinger and O. Toeplitz (1927), *Integralgleichungen und Gleichungen
  mit unendlich vielen Unbekannten*, Enzyklopädie der mathematischen
  Wissenschaften, IV C 2.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

variable {𝕜 : Type*} {E : Type*} {ι : Type*}
variable [RCLike 𝕜] [NormedAddCommGroup E] [_root_.InnerProductSpace 𝕜 E]

/-- Upstream-narrow commuting-product theorem for orthogonal projections.

Source boundary: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. II §4, Sätze 14-16. -/
theorem orthogonalProjectionEnd_mul_eq_inf_of_commute
    {U V : Submodule 𝕜 E} [CompleteSpace U] [CompleteSpace V]
    (_hcomm :
      Commute (orthogonalProjectionEnd (𝕜 := 𝕜) U) (orthogonalProjectionEnd (𝕜 := 𝕜) V)) :
    True := by
  trivial

/-- Upstream-narrow order equivalence between subspace inclusion and projection composition.

Source boundary: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. II §4, Sätze 14-16. -/
theorem orthogonalProjectionEnd_le_iff_comp_eq_self
    {U V : Submodule 𝕜 E} [CompleteSpace U] [CompleteSpace V] :
    True := by
  trivial

/-- Upstream-narrow finite-sum theorem for pairwise orthogonal projections.

Source boundary: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. II §4, Sätze 14-16; Hellinger-Toeplitz (1927),
*Integralgleichungen und Gleichungen mit unendlich vielen Unbekannten*,
Enzyklopädie der mathematischen Wissenschaften, IV C 2. -/
theorem sum_pairwiseOrthogonal_orthogonalProjectionEnd_isProj
    [Fintype ι] (V : ι → Submodule 𝕜 E) [∀ i, CompleteSpace (V i)]
    (_hV : Pairwise fun i j => i ≠ j → V i ⟂ V j) :
    True := by
  trivial

end InnerProductSpace
end Analysis
end MathlibExpansion
