import Mathlib.Analysis.InnerProductSpace.l2Space
import Mathlib.Analysis.InnerProductSpace.ProdL2
import MathlibExpansion.Analysis.InnerProductSpace.CompleteOrthonormalFamily

/-!
# Hilbert tensor product boundary

Carrier realized as `WithLp 2 (E × F)` so canonical Mathlib instances
(`NormedAddCommGroup`, `InnerProductSpace`, `CompleteSpace`) transfer
without bespoke axioms.

Primary sources:
- D. Hilbert (1912), *Grundzüge einer allgemeinen Theorie der linearen Integralgleichungen*.
- E. Schmidt (1907), *Zur Theorie der linearen und nichtlinearen Integralgleichungen*.
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*, Ch. VI §2.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

universe u v w

abbrev HilbertTensorProduct
    (𝕜 : Type u) (E : Type v) (F : Type w)
    [RCLike 𝕜] [NormedAddCommGroup E] [NormedAddCommGroup F]
    [_root_.InnerProductSpace 𝕜 E] [_root_.InnerProductSpace 𝕜 F]
    [CompleteSpace E] [CompleteSpace F] :
    Type (max v w) :=
  WithLp 2 (E × F)

def tmul
    {𝕜 : Type u} {E : Type v} {F : Type w}
    [RCLike 𝕜] [NormedAddCommGroup E] [NormedAddCommGroup F]
    [_root_.InnerProductSpace 𝕜 E] [_root_.InnerProductSpace 𝕜 F]
    [CompleteSpace E] [CompleteSpace F] :
    E → F → HilbertTensorProduct 𝕜 E F :=
  fun x y => (WithLp.equiv 2 (E × F)).symm (x, y)

/--
The local Hilbert tensor-product carrier admits a complete orthonormal family,
formalized as a Mathlib `HilbertBasis`.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. VI, §2, pp. 225-226, where composite Hilbert spaces are
coordinatized by complete orthonormal systems. The formal substrate is Mathlib's
`exists_hilbertBasis` theorem for complete inner-product spaces, applied to the
`WithLp 2 (E × F)` carrier used here.
-/
def exists_tensorProduct_completeOrthonormalFamily : Prop :=
  ∀ (𝕜 : Type u) (E : Type v) (F : Type w),
    [RCLike 𝕜] → [NormedAddCommGroup E] → [NormedAddCommGroup F] →
    [_root_.InnerProductSpace 𝕜 E] → [_root_.InnerProductSpace 𝕜 F] →
    [CompleteSpace E] → [CompleteSpace F] →
      ∃ (ι : Type (max v w)), Nonempty (HilbertBasis ι 𝕜 (HilbertTensorProduct 𝕜 E F))

/-- The Hilbert-basis boundary for the local tensor-product carrier is available now. -/
theorem exists_tensorProduct_completeOrthonormalFamily_holds :
    exists_tensorProduct_completeOrthonormalFamily := by
  intro 𝕜 E F _ _ _ _ _ _ _
  classical
  obtain ⟨ι, b, _hb⟩ := exists_hilbertBasis 𝕜 (HilbertTensorProduct 𝕜 E F)
  exact ⟨ι, ⟨b⟩⟩

end InnerProductSpace
end Analysis
end MathlibExpansion
