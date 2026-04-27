import Mathlib.FieldTheory.LinearDisjoint
import Mathlib.Algebra.Algebra.ZMod

/-!
# Coprime degree multiplication boundary

This chapter isolates Steinitz `FFC_COPRIME`: concrete degree formulas for
sums of elements whose prime-field degrees are pairwise coprime.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 15`,
  theorem `6`.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.Finite

open scoped BigOperators

variable {K : Type*} [Field K]
variable {p : ℕ} [Fact p.Prime] [Algebra (ZMod p) K]

/-- Steinitz's coprime-degree multiplication theorem for sums.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 15`, theorem `6`, printed p. 248. -/
axiom minpoly_natDegree_sum_eq_prod_of_pairwiseCoprime
    {ι : Type*} [Fintype ι] (a : ι -> K)
    (hcop :
      Pairwise (Function.onFun Nat.Coprime fun i => (minpoly (ZMod p) (a i)).natDegree)) :
    (minpoly (ZMod p) (∑ i, a i)).natDegree = ∏ i, (minpoly (ZMod p) (a i)).natDegree

end MathlibExpansion.FieldTheory.Finite
