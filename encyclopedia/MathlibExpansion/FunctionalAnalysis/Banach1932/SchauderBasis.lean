import Mathlib
import MathlibExpansion.FunctionalAnalysis.Banach1932.Biorthogonal

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932

open scoped ENNReal

variable {𝕜 E : Type*}
variable [NontriviallyNormedField 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E]

/-- Banach's analytic basis notion: convergent series expansions in a biorthogonal system. -/
structure SchauderBasis extends BiorthogonalSystem (𝕜 := 𝕜) (E := E) where
  hasSum_repr : ∀ x : E, HasSum (fun n : ℕ => coeff n x • vec n) x

namespace SchauderBasis

/-- Coordinate maps of a Schauder basis are continuous by construction. -/
abbrev coordCLM (B : SchauderBasis (𝕜 := 𝕜) (E := E)) (n : ℕ) :
    E →L[𝕜] 𝕜 :=
  B.coeff n

@[simp]
theorem coordCLM_apply (B : SchauderBasis (𝕜 := 𝕜) (E := E)) (n : ℕ) (x : E) :
    B.coordCLM n x = B.coeff n x :=
  rfl

/-- Uniform boundedness of the Banach partial sums. -/
def BoundedPartialSums (B : SchauderBasis (𝕜 := 𝕜) (E := E)) : Prop :=
  ∃ C : ℝ, ∀ n : ℕ, ‖B.toBiorthogonalSystem.partialSumCLM n‖ ≤ C

/-- The `n`th coordinate functional on `ℓ^p(ℕ, ℝ)`. -/
def lpCoordCLM {p : ℝ≥0∞} [Fact (1 ≤ p)] (n : ℕ) :
    lp (fun _ : ℕ => ℝ) p →L[ℝ] ℝ where
  toFun x := x n
  map_add' x y := by
    simp only [lp.coeFn_add, Pi.add_apply]
  map_smul' c x := by
    simp only [lp.coeFn_smul, Pi.smul_apply, RingHom.id_apply]
  cont := by
    exact (continuous_apply n).comp (lp.uniformContinuous_coe (E := fun _ : ℕ => ℝ)
      (p := p)).continuous

/--
Banach, *Théorie des opérations linéaires* (1932), Ch. VII §§1-4: for finite
exponent `p`, the standard coordinate vectors form a Schauder basis of `ℓ^p`.
-/
theorem standardBasis_lp {p : ℝ≥0∞} [Fact (1 ≤ p)] (hp : p ≠ ⊤) :
    Nonempty (SchauderBasis (𝕜 := ℝ) (E := lp (fun _ : ℕ => ℝ) p)) := by
  classical
  refine
    ⟨{ vec := fun n => lp.single p n (1 : ℝ)
       coeff := lpCoordCLM (p := p)
       biorthogonal := ?_
       hasSum_repr := ?_ }⟩
  · intro m n
    by_cases hmn : m = n
    · subst hmn
      simp [lpCoordCLM]
    · simp [lpCoordCLM, hmn]
  · intro x
    refine HasSum.congr_fun (lp.hasSum_single (E := fun _ : ℕ => ℝ) hp x) ?_
    intro n
    simpa [lpCoordCLM] using
      (lp.single_smul (E := fun _ : ℕ => ℝ) p n (x n) (1 : ℝ)).symm

end SchauderBasis

end Banach1932
end FunctionalAnalysis
end MathlibExpansion
