import Mathlib.Data.Real.Basic

import Mathlib.Topology.EMetricSpace.BoundedVariation
import MathlibExpansion.Analysis.Calculus.DerivedNumbers

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace Calculus
namespace DerivedNumbers

/--
`DNB_05` upstream Lipschitz boundary for functions with bounded derived
numbers.

Citation: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Ch. V, § II, pp. 68-69 and p. 73,
unnumbered bounded-derived-numbers/Lipschitz-condition statement preceding
the rectifiable-curve discussion: if the derived numbers are bounded in
absolute value by `M`, the function satisfies the Lipschitz condition with
constant `M`.
-/
axiom lipschitzOnWith_of_abs_boundedDerivedNumbers {f : ℝ → ℝ} {a b M : ℝ}
    (hM : 0 ≤ M)
    (hD : ∀ x ∈ Set.Icc a b,
      (-(M : ℝ) : EReal) ≤ lowerRightDerived f x ∧
        upperRightDerived f x ≤ (M : EReal) ∧
        (-(M : ℝ) : EReal) ≤ lowerLeftDerived f x ∧
        upperLeftDerived f x ≤ (M : EReal)) :
    LipschitzOnWith (Real.toNNReal M) f (Set.Icc a b)

/--
`DNB_05`: bounded derived numbers force bounded variation.

The analytic gap is isolated in
`lipschitzOnWith_of_abs_boundedDerivedNumbers`; Mathlib then supplies
`LipschitzOnWith.locallyBoundedVariationOn`.
-/
theorem locallyBoundedVariationOn_of_boundedDerivedNumbers {f : ℝ → ℝ} {a b M : ℝ}
    (hM : 0 ≤ M)
    (hD : ∀ x ∈ Set.Icc a b,
      (-(M : ℝ) : EReal) ≤ lowerRightDerived f x ∧
        upperRightDerived f x ≤ (M : EReal) ∧
        (-(M : ℝ) : EReal) ≤ lowerLeftDerived f x ∧
        upperLeftDerived f x ≤ (M : EReal)) :
    LocallyBoundedVariationOn f (Set.Icc a b) :=
  (lipschitzOnWith_of_abs_boundedDerivedNumbers hM hD).locallyBoundedVariationOn

end DerivedNumbers
end Calculus
end Analysis
end MathlibExpansion
