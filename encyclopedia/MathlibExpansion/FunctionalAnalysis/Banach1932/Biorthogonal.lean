import Mathlib

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932

open scoped BigOperators

variable {𝕜 E : Type*}
variable [NontriviallyNormedField 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E]

/-- A typed infinite biorthogonal system in a Banach space. -/
structure BiorthogonalSystem where
  vec : ℕ → E
  coeff : ℕ → NormedSpace.Dual 𝕜 E
  biorthogonal : ∀ m n : ℕ, coeff m (vec n) = if m = n then 1 else 0

namespace BiorthogonalSystem

/-- The Banach partial-sum operators attached to a biorthogonal system. -/
def partialSumCLM (B : BiorthogonalSystem (𝕜 := 𝕜) (E := E)) (n : ℕ) : E →L[𝕜] E :=
  ∑ i in Finset.range n, (B.coeff i).smulRight (B.vec i)

@[simp]
theorem partialSumCLM_apply (B : BiorthogonalSystem (𝕜 := 𝕜) (E := E)) (n : ℕ) (x : E) :
    B.partialSumCLM n x = ∑ i in Finset.range n, B.coeff i x • B.vec i := by
  simp [partialSumCLM]

/-- Dual partial sums in Banach's Chapter VII arguments. -/
def dualPartialSumCLM (B : BiorthogonalSystem (𝕜 := 𝕜) (E := E)) (n : ℕ) :
    NormedSpace.Dual 𝕜 E →L[𝕜] NormedSpace.Dual 𝕜 E :=
  ∑ i in Finset.range n,
    ((NormedSpace.inclusionInDoubleDual 𝕜 E) (B.vec i)).smulRight (B.coeff i)

@[simp]
theorem dualPartialSumCLM_apply (B : BiorthogonalSystem (𝕜 := 𝕜) (E := E)) (n : ℕ)
    (F : NormedSpace.Dual 𝕜 E) :
    B.dualPartialSumCLM n F =
      ∑ i in Finset.range n, F (B.vec i) • B.coeff i := by
  ext x
  simp [dualPartialSumCLM, Finset.smul_sum]

@[simp]
theorem coeff_vec (B : BiorthogonalSystem (𝕜 := 𝕜) (E := E)) (m n : ℕ) :
    B.coeff m (B.vec n) = if m = n then 1 else 0 :=
  B.biorthogonal m n

end BiorthogonalSystem

end Banach1932
end FunctionalAnalysis
end MathlibExpansion

