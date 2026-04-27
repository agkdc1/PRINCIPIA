import MathlibExpansion.Probability.StableLaw.CharacteristicFunction

/-!
# Existence of stable laws

This file isolates the existence theorem asserting that admissible stable-law
characteristic-function templates are realized by actual probability laws.
-/

namespace MathlibExpansion
namespace Probability
namespace StableLaw

open MeasureTheory
open MathlibExpansion.Probability.CharacteristicFunction

/-- Every admissible stable characteristic-function template is realized by a probability law.

Exact theorem-numbered source: E. J. G. Pitman and Jim Pitman, "A direct
approach to the stable distributions" (2016), Theorem 1.1, the `if` direction
of the Levy-Khintchine representation of stable distributions on the real line.
The theorem states that the displayed stable exponent form with `0 < alpha <= 2`,
nonnegative scale, and `|beta| <= 1` is the characteristic function of a stable
probability distribution. This declaration uses the harmless scale
reparameterization `c ^ alpha = scale` with `0 < scale`. The Pitman-Pitman
formulation follows Gnedenko--Kolmogorov (1954), Section 34, with the sign
corrections of P. Hall, "A comedy of errors: the canonical form for a stable
characteristic function" (1981), and is encapsulated as Samorodnitsky--Taqqu
(1994), Definition 1.1.6. -/
axiom exists_probabilityMeasure_of_stableCFParams (p : StableCFParams) (hp : p.Valid) :
    ∃ μ : ProbabilityMeasure ℝ, characteristicFunction μ = stableCF p

end StableLaw
end Probability
end MathlibExpansion
