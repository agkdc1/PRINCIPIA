import MathlibExpansion.RingTheory.PowerSeries.PseudoNull
import MathlibExpansion.Roots.Iwasawa.CharacteristicIdeal

/-!
# Elementary-profile uniqueness over `ℤ_[p]⟦X⟧`

This file packages the C4c boundary for the one-variable Iwasawa algebra
`Λ = ℤ_[p]⟦X⟧`.

At the profile level, the elementary data already lives in
`Roots/Iwasawa/Elementary.lean`:

- a free rank
- a finite family of `p`-power exponents
- a finite family of distinguished factors

What was missing is the uniqueness layer saying that two elementary
decompositions of the same finitely generated `Λ`-module differ only by
reordering of those finite families. We encode "up to reordering" by explicit
equivalences between the finite index types.

The strong boundary below is the concrete-model axiom
`elementaryConcreteProfile_unique`. The exported `elementaryProfile_unique`
wrapper is now derived from the concrete pseudo-isomorphism certificate stored
in each `LambdaProfileDecomposition`. From reindexing equivalence we derive
equality of

- `rank`
- `μ`
- `λ`
- the profile-level characteristic element
- the profile-level characteristic ideal

This lowers the consumer-facing boundary in `Roots/Iwasawa/StructureTheorem`
from three axioms to one.

## Relation to the honest pseudo-null substrate

`RingTheory.PowerSeries.PseudoNull` provides the height-based pseudo-null
language for `Λ = ℤ_[p]⟦X⟧`. The current elementary decomposition objects in
`Roots/Iwasawa/*` still use the legacy pseudo-isomorphism bundle, but each
decomposition now also carries a pseudo-isomorphism to the concrete elementary
module attached to its profile. A future follow-up can replace the legacy
pseudo layer without changing the reindexing API introduced here.
-/

namespace MathlibExpansion
namespace RingTheory
namespace PowerSeries

open scoped Padic
open MathlibExpansion.Roots.Iwasawa

variable {p : ℕ} [Fact p.Prime]

/-- Two elementary profiles are equivalent when they differ only by reordering
of the `p`-power summands and distinguished summands. -/
structure ElementaryProfileEquiv
    (P Q : LambdaElementaryProfile p) where
  rank_eq : P.rank = Q.rank
  pPowerEquiv : P.pPowerIndex ≃ Q.pPowerIndex
  pPowerExponent_eq : ∀ i, P.pPowerExponent i = Q.pPowerExponent (pPowerEquiv i)
  distinguishedEquiv : P.distinguishedIndex ≃ Q.distinguishedIndex
  distinguishedFactor_eq :
    ∀ i, P.distinguishedFactor i = Q.distinguishedFactor (distinguishedEquiv i)

namespace ElementaryProfileEquiv

theorem mu_eq
    {P Q : LambdaElementaryProfile p}
    (h : ElementaryProfileEquiv P Q) :
    P.mu = Q.mu := by
  simpa [LambdaElementaryProfile.mu] using
    Fintype.sum_equiv h.pPowerEquiv P.pPowerExponent Q.pPowerExponent
      h.pPowerExponent_eq

theorem lambda_eq
    {P Q : LambdaElementaryProfile p}
    (h : ElementaryProfileEquiv P Q) :
    P.lambda = Q.lambda := by
  simpa [LambdaElementaryProfile.lambda, LambdaElementaryProfile.distinguishedDegree] using
    Fintype.sum_equiv h.distinguishedEquiv
      (fun i => (P.distinguishedFactor i).poly.natDegree)
      (fun i => (Q.distinguishedFactor i).poly.natDegree)
      (fun i => by simp [h.distinguishedFactor_eq i])

theorem characteristicElement_eq
    {P Q : LambdaElementaryProfile p}
    (h : ElementaryProfileEquiv P Q) :
    P.characteristicElement = Q.characteristicElement := by
  have hprod :
      (∏ i, (P.distinguishedFactor i).toPowerSeries) =
        ∏ i, (Q.distinguishedFactor i).toPowerSeries := by
    exact Fintype.prod_equiv h.distinguishedEquiv
      (fun i => (P.distinguishedFactor i).toPowerSeries)
      (fun i => (Q.distinguishedFactor i).toPowerSeries)
      (fun i => by simp [h.distinguishedFactor_eq i])
  rw [LambdaElementaryProfile.characteristicElement,
    LambdaElementaryProfile.characteristicElement, h.mu_eq, hprod]

theorem characteristicIdeal_eq
    {P Q : LambdaElementaryProfile p}
    (h : ElementaryProfileEquiv P Q) :
    P.characteristicIdeal = Q.characteristicIdeal := by
  unfold LambdaElementaryProfile.characteristicIdeal
  rw [h.characteristicElement_eq]

end ElementaryProfileEquiv

/-- Narrow upstream boundary for C4c, sharpened to honest concrete elementary
models: if the same finitely generated `Λ = ℤ_[p]⟦X⟧`-module is
pseudo-isomorphic to two concrete elementary modules, then the two elementary
profiles differ only by reindexing the finite `p`-power and
distinguished-factor families.

Exact discharge target: Washington (1997), *Introduction to Cyclotomic
Fields*, 2nd ed., Chapter 13, Theorem 13.12, uniqueness clause for the
elementary `Λ`-module factors; Bourbaki, *Commutative Algebra*, Chapter VII
§4.4, Theorem 5, elementary-divisor uniqueness after Weierstrass preparation.

Current Mathlib gap: the PID module classification API does not apply to
`PowerSeries ℤ_[p]`; the local stack has Weierstrass preparation and
Noetherian/pseudo-null substrate, but not the height-one UFD factor-count
classification of `p` and distinguished-polynomial factors over
`ℤ_[p]⟦X⟧`. -/
axiom elementaryConcreteProfile_unique (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule ℤ_[p])
    (P Q : LambdaElementaryProfile p)
    (hP : Nonempty
      (MathlibExpansion.Roots.Iwasawa.PseudoIsomorphism
        (R := ℤ_[p]) M.carrier (concreteProfileCarrier P)))
    (hQ : Nonempty
      (MathlibExpansion.Roots.Iwasawa.PseudoIsomorphism
        (R := ℤ_[p]) M.carrier (concreteProfileCarrier Q))) :
    ElementaryProfileEquiv P Q

/-- Reindexing data for any two elementary profile decompositions of the same
finitely generated
`Λ`-module differ only by reindexing the finite `p`-power and
distinguished-factor families.  This exported wrapper is now a definition from the
sharpened concrete-model uniqueness boundary and the `concretePseudo`
certificate stored in `LambdaProfileDecomposition`. -/
noncomputable def elementaryProfile_unique (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule ℤ_[p])
    (D₁ D₂ : LambdaProfileDecomposition p M) :
    ElementaryProfileEquiv D₁.profile D₂.profile :=
  elementaryConcreteProfile_unique p M D₁.profile D₂.profile
    D₁.concretePseudo D₂.concretePseudo

/-- Derived rank uniqueness for elementary profile decompositions. -/
theorem elementaryProfile_rank_unique (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule ℤ_[p])
    (D₁ D₂ : LambdaProfileDecomposition p M) :
    D₁.profile.rank = D₂.profile.rank :=
  (elementaryProfile_unique p M D₁ D₂).rank_eq

/-- Derived characteristic-ideal uniqueness for elementary profile
decompositions. -/
theorem elementaryProfile_characteristicIdeal_unique (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule ℤ_[p])
    (D₁ D₂ : LambdaProfileDecomposition p M) :
    D₁.characteristicIdeal = D₂.characteristicIdeal :=
  (elementaryProfile_unique p M D₁ D₂).characteristicIdeal_eq

/-- Derived `μ`-invariant uniqueness for elementary profile decompositions. -/
theorem elementaryProfile_mu_unique (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule ℤ_[p])
    (D₁ D₂ : LambdaProfileDecomposition p M) :
    D₁.mu = D₂.mu :=
  (elementaryProfile_unique p M D₁ D₂).mu_eq

/-- Derived `λ`-invariant uniqueness for elementary profile decompositions. -/
theorem elementaryProfile_lambda_unique (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule ℤ_[p])
    (D₁ D₂ : LambdaProfileDecomposition p M) :
    D₁.lambda = D₂.lambda :=
  (elementaryProfile_unique p M D₁ D₂).lambda_eq

end PowerSeries
end RingTheory
end MathlibExpansion
