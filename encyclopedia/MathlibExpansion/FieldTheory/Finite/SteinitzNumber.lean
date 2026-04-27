import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
import Mathlib.Algebra.Algebra.ZMod
import Mathlib.Algebra.Field.ZMod
import Mathlib.Algebra.Order.Monoid.WithTop
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Order.TypeTags

/-!
# Steinitz supernatural degree boundary

This chapter isolates the separate `Sec. 16` lane `FFC_STEINITZ_NUMBER`.

The file introduces a thin sibling-library carrier for Steinitz's supernatural
degree and keeps the construction/classification theorems as upstream-narrow
boundaries.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 16`,
  statements `1`-`3`.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.Finite

/-- Steinitz's supernatural degree profile. -/
abbrev SteinitzNumber := ℕ -> WithTop ℕ

variable (p : ℕ) [Fact p.Prime]

/-- The supernatural degree attached to an absolutely algebraic field of
characteristic `p`.

The `q`-component is the supremum of the `q`-adic exponents of the degrees of
finite-dimensional intermediate fields over the prime field. This is Steinitz's
supernatural degree from E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 16`, theorem `1`. -/
noncomputable def steinitzDegree
    (K : Type*) [Field K] [Algebra (ZMod p) K] [Algebra.IsAlgebraic (ZMod p) K] :
    SteinitzNumber :=
  fun q => ⨆ (S : IntermediateField (ZMod p) K) (_ : FiniteDimensional (ZMod p) S),
    (((Module.finrank (ZMod p) S).factorization q : ℕ) : WithTop ℕ)

/-- Every prescribed Steinitz number is realized by an absolutely algebraic
field of characteristic `p`.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 16`, theorem `2`. -/
axiom exists_absAlgField_of_steinitzDegree (d : SteinitzNumber) :
    ∃ K : Type*, ∃ _ : Field K, ∃ _ : Algebra (ZMod p) K,
      ∃ _ : Algebra.IsAlgebraic (ZMod p) K, steinitzDegree p K = d

/-- Absolutely algebraic fields of characteristic `p` are classified by their
Steinitz numbers.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 16`, theorem `3`. -/
axiom algEquiv_of_steinitzDegree_eq
    {K L : Type*} [Field K] [Field L]
    [Algebra (ZMod p) K] [Algebra (ZMod p) L]
    [Algebra.IsAlgebraic (ZMod p) K] [Algebra.IsAlgebraic (ZMod p) L]
    (h : steinitzDegree p K = steinitzDegree p L) :
    Nonempty (K ≃ₐ[ZMod p] L)

end MathlibExpansion.FieldTheory.Finite
