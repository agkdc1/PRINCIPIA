import MathlibExpansion.Probability.CharacteristicFunction.Basic
import MathlibExpansion.Probability.StableLaw.Defs

/-!
# Characteristic-function classification of stable laws

This file packages the law-level characteristic-function templates and
classification boundaries for stable laws.
-/

namespace MathlibExpansion
namespace Probability
namespace StableLaw

open MeasureTheory
open MathlibExpansion.Probability.CharacteristicFunction

/-- Symmetric stable-law characteristic-function template. -/
noncomputable def stableCFSymmetric (α : ℝ) (t : ℝ) : ℂ :=
  Complex.exp (-((Real.rpow |t| α : ℝ) : ℂ))

/-- Skew factor in the one-dimensional stable-law characteristic exponent.

This uses the usual `S0`-style real-line template. The `alpha = 1` logarithmic
branch is intentionally explicit because it is the classical source of
parameterization mistakes in stable-law statements. -/
noncomputable def stableCFSkewFactor (p : StableCFParams) (t : ℝ) : ℂ :=
  if p.alpha = 1 then
    (1 : ℂ) +
      Complex.I * (((2 / Real.pi) * p.beta * Real.sign t * Real.log |t| : ℝ) : ℂ)
  else
    (1 : ℂ) -
      Complex.I *
        ((p.beta * Real.sign t * Real.tan (Real.pi * p.alpha / 2) : ℝ) : ℂ)

/-- General stable-law characteristic-function template. -/
noncomputable def stableCF (p : StableCFParams) (t : ℝ) : ℂ :=
  Complex.exp
    ((((p.shift * t : ℝ) : ℂ) * Complex.I) -
      ((p.scale * Real.rpow |t| p.alpha : ℝ) : ℂ) * stableCFSkewFactor p t)

/-- Stable symmetric classification, hard direction.

Exact theorem-numbered modern owner: E. Lukacs, *Characteristic Functions*
(2nd ed., 1970), §5.7, Theorem 5.7.1, specialized to the symmetric strictly
stable case. Historical source spine: P. Lévy, "Théorie des erreurs. La loi de
Gauss et les lois exceptionnelles", *Bull. Soc. Math. France* 52 (1924),
§§10-11, formulas (7)-(8), and P. Lévy, "Sur les lois stables en calcul des
probabilités", *C. R. Acad. Sci. Paris* 176 (1923), 1284-1286. -/
axiom exists_alpha_of_isStrictlyStableSymmetricLaw (μ : ProbabilityMeasure ℝ)
    (hμ : IsStrictlyStableSymmetricLaw μ) :
    ∃ α : ℝ, 0 < α ∧ α ≤ 2 ∧ characteristicFunction μ = stableCFSymmetric α

/-- Stable symmetric classification, converse direction.

Exact theorem-numbered modern owner: E. Lukacs, *Characteristic Functions*
(2nd ed., 1970), §5.7, Theorem 5.7.1, specialized to symmetric characteristic
functions `exp (-|t|^α)`. Historical source spine: P. Lévy, "Théorie des
erreurs. La loi de Gauss et les lois exceptionnelles", *Bull. Soc. Math.
France* 52 (1924), §§10-11, formulas (7)-(8), and P. Lévy, "Sur les lois
stables en calcul des probabilités", *C. R. Acad. Sci. Paris* 176 (1923),
1284-1286. -/
axiom isStrictlyStableSymmetricLaw_of_exists_alpha (μ : ProbabilityMeasure ℝ)
    (hμ : ∃ α : ℝ, 0 < α ∧ α ≤ 2 ∧ characteristicFunction μ = stableCFSymmetric α) :
    IsStrictlyStableSymmetricLaw μ

/-- Symmetric strict stable laws are exactly the laws with the expected one-parameter transform. -/
theorem isStrictlyStableSymmetricLaw_iff_exists_alpha (μ : ProbabilityMeasure ℝ) :
    IsStrictlyStableSymmetricLaw μ ↔
      ∃ α : ℝ, 0 < α ∧ α ≤ 2 ∧ characteristicFunction μ = stableCFSymmetric α := by
  exact ⟨exists_alpha_of_isStrictlyStableSymmetricLaw μ,
    isStrictlyStableSymmetricLaw_of_exists_alpha μ⟩

/-- General stable-law classification, hard direction.

Exact theorem-numbered modern owner: E. Lukacs, *Characteristic Functions*
(2nd ed., 1970), §5.7, Theorem 5.7.1. Historical source spine: P. Lévy, "Sur les
lois stables en calcul des probabilités", *C. R. Acad. Sci. Paris* 176 (1923),
1284-1286, and P. Lévy, "Théorie des erreurs. La loi de Gauss et les lois
exceptionnelles", *Bull. Soc. Math. France* 52 (1924), §10, including the
footnote sending the dissymmetric case to the 7 May 1923 note. -/
axiom exists_params_of_isStableLaw (μ : ProbabilityMeasure ℝ) (hμ : IsStableLaw μ) :
    ∃ p : StableCFParams, p.Valid ∧ characteristicFunction μ = stableCF p

/-- General stable-law classification, converse direction.

Exact theorem-numbered modern owner: E. Lukacs, *Characteristic Functions*
(2nd ed., 1970), §5.7, Theorem 5.7.1, using the characteristic-function
parameterization to prove stability under affine renormalized sums. Historical
source spine: P. Lévy, "Sur les lois stables en calcul des probabilités",
*C. R. Acad. Sci. Paris* 176 (1923), 1284-1286, and P. Lévy, "Théorie des
erreurs. La loi de Gauss et les lois exceptionnelles", *Bull. Soc. Math.
France* 52 (1924), §10. -/
axiom isStableLaw_of_exists_params (μ : ProbabilityMeasure ℝ)
    (hμ : ∃ p : StableCFParams, p.Valid ∧ characteristicFunction μ = stableCF p) :
    IsStableLaw μ

/-- General stable laws are exactly the laws with the expected four-parameter transform. -/
theorem isStableLaw_iff_exists_params (μ : ProbabilityMeasure ℝ) :
    IsStableLaw μ ↔
      ∃ p : StableCFParams, p.Valid ∧ characteristicFunction μ = stableCF p := by
  exact ⟨exists_params_of_isStableLaw μ, isStableLaw_of_exists_params μ⟩

end StableLaw
end Probability
end MathlibExpansion
