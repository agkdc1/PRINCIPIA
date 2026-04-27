import Mathlib
import MathlibExpansion.DeligneAttachedRepresentation
import MathlibExpansion.HeckeOperatorReal
import MathlibExpansion.Roots.Flach1992.CongruenceModule
import MathlibExpansion.Roots.Mazur1977.PrimeLevelHecke

/-!
# Residual Galois attachment for a concrete weight-2 newform

The deleted boundary in this file quantified over an arbitrary non-Eisenstein
maximal ideal `𝔪 ⊂ T` of an abstract prime-level Hecke carrier and asserted
directly that there is a residual Galois representation with coefficients in
`T/𝔪`. That was too broad for the current substrate: the namespace does not
contain the typed bridge from a Mazur maximal ideal of an abstract Hecke
carrier to a concrete Deligne-attached residual representation.

The honest boundary available today is the narrower Deligne-style shape:

- a concrete weight-2 prime-level newform `f`,
- a concrete prime-away-from-the-level Hecke eigensystem for `f`,
- a specialization map `π : T → O` from the abstract Hecke carrier to a
  coefficient ring `O`,
- a reduction map `O → 𝔽_p`, and hence
- the residual Hecke kernel `ker ((O → 𝔽_p) ∘ π)`.

The extraction theorem `residualGaloisAttachment` is therefore narrowed to
this newform-specialized surface. It no longer claims to construct a residual
representation from an arbitrary maximal ideal of `T`, and it no longer
quantifies over an arbitrary Frobenius indexing function without evidence.
Instead, the unformalized Deligne input is an explicit typed attachment
evidence object. Once that evidence is supplied, the existential residual
attachment statement is a real theorem.
-/

namespace MathlibExpansion.Roots.Mazur1977

universe u v w x

open CongruenceSubgroup
open NumberTheory
open NumberTheory.HeckeOperatorReal

/-- **Prime-level newform data with residual specialization.**

This packages exactly the typed data needed for the narrowed Deligne-style
boundary:

- a prime level `N`,
- a concrete weight-2 modular form `f : M_2(Γ₀(N))`,
- a prime-away-from-`N` Hecke eigensystem for `f`,
- a specialization map `π : T → O` from the abstract prime-level Hecke
  carrier to a coefficient ring `O`,
- a reduction map `O → 𝔽_p`, and
- maximality of the resulting residual Hecke kernel
  `ker ((O → 𝔽_p) ∘ π)`.

The fields `generator_spec` and `eigenvalue_spec` are the typed links
between the abstract Hecke generators, the algebraic eigenvalues in `O`,
and the complex eigenvalues of the bundled newform. -/
structure ResidualNewformDatum
    {R : Type u} {M : Type v} [CommRing R] [AddCommGroup M] [Module R M]
    {N : ℕ} (C : PrimeLevelHeckeCarrier.{u,v,w} R M N) where
  /-- Mazur's application is prime level. -/
  levelPrime : N.Prime
  /-- Coefficient ring for the algebraic Hecke eigensystem. -/
  coeffRing : Type x
  /-- `coeffRing` is commutative. -/
  instCoeffCommRing : CommRing coeffRing
  /-- Concrete weight-2 modular form of level `Γ₀(N)`. -/
  form : ModularForm (Gamma0 N) 2
  /-- Concrete Hecke eigenvalue system away from the level. -/
  eigenSystem : PrimeHeckeEigenvalueSystem N 2 form
  /-- Algebraic Hecke eigenvalues in the coefficient ring. -/
  algebraicEigenvalue : ℕ → coeffRing
  /-- Chosen embedding of the coefficient ring into `ℂ`. -/
  coeffToComplex : coeffRing →+* ℂ
  /-- The algebraic eigenvalues recover the complex Hecke eigenvalues. -/
  eigenvalue_spec :
      ∀ (ℓ : ℕ), ℓ.Prime → Nat.Coprime ℓ N →
        coeffToComplex (algebraicEigenvalue ℓ) = eigenSystem.eigenvalue ℓ
  /-- Specialization `π : T → O` from the Hecke carrier to the coefficient ring. -/
  specialization :
      MathlibExpansion.Roots.Flach1992.CongruenceModuleData C.T coeffRing
  /-- The prime Hecke generators specialize to the algebraic eigenvalues. -/
  generator_spec :
      ∀ (ℓ : ℕ) (hℓprime : ℓ.Prime) (hℓne : ℓ ≠ N),
        specialization.π (C.generator ⟨ℓ, hℓprime, hℓne⟩) = algebraicEigenvalue ℓ
  /-- Residual characteristic of the reduction. -/
  residualPrime : ℕ
  /-- The residual characteristic is prime. -/
  instResidualPrime : Fact residualPrime.Prime
  /-- Reduction map `O → 𝔽_p`. -/
  residueMap : coeffRing →+* ZMod residualPrime
  /-- The residual Hecke kernel is maximal. -/
  residualKernelMaximal :
      (RingHom.ker (residueMap.comp specialization.π)).IsMaximal

attribute [instance] ResidualNewformDatum.instCoeffCommRing
                     ResidualNewformDatum.instResidualPrime

/-- The concrete residual Hecke kernel attached to the newform datum. -/
abbrev ResidualNewformDatum.heckeKernel
    {R : Type u} {M : Type v} [CommRing R] [AddCommGroup M] [Module R M]
    {N : ℕ} {C : PrimeLevelHeckeCarrier.{u,v,w} R M N}
    (D : ResidualNewformDatum C) : Ideal C.T :=
  RingHom.ker (D.residueMap.comp D.specialization.π)

/-- The mod-`p` Hecke eigenvalues obtained from the algebraic specialization. -/
abbrev ResidualNewformDatum.residualEigenvalue
    {R : Type u} {M : Type v} [CommRing R] [AddCommGroup M] [Module R M]
    {N : ℕ} {C : PrimeLevelHeckeCarrier.{u,v,w} R M N}
    (D : ResidualNewformDatum C) : ℕ → ZMod D.residualPrime :=
  fun ℓ => D.residueMap (D.algebraicEigenvalue ℓ)

/-- The specialized Hecke generator reduces to the residual eigenvalue. -/
theorem ResidualNewformDatum.generator_residualEigenvalue_eq
    {R : Type u} {M : Type v} [CommRing R] [AddCommGroup M] [Module R M]
    {N : ℕ} {C : PrimeLevelHeckeCarrier.{u,v,w} R M N}
    (D : ResidualNewformDatum C)
    (ℓ : ℕ) (hℓprime : ℓ.Prime) (hℓne : ℓ ≠ N) :
    D.residueMap (D.specialization.π (C.generator ⟨ℓ, hℓprime, hℓne⟩))
      = D.residualEigenvalue ℓ := by
  simp [ResidualNewformDatum.residualEigenvalue, D.generator_spec ℓ hℓprime hℓne]

/-- **Evidence for Deligne-style residual Galois attachment at prime level,
narrowed to a concrete weight-2 newform.**

Given a prime-level Hecke carrier together with a concrete weight-2 newform,
its Hecke specialization to a coefficient ring, and reduction modulo a prime
of that coefficient ring, this structure records a two-dimensional residual
Galois representation whose Frobenius traces recover the reduced Hecke
eigenvalues away from the level and the residual characteristic.

Citation target for the future construction: Pierre Deligne, *Formes
modulaires et représentations `l`-adiques*, Séminaire Bourbaki 1968/69,
exp. 355, Corollary 4.2 and Theorem 4.9 (the Eichler congruence formula
relating Hecke operators and Frobenius). -/
structure ResidualGaloisAttachmentEvidence
    {R : Type u} {M : Type v} [CommRing R] [AddCommGroup M] [Module R M]
    {N : ℕ}
    (C : PrimeLevelHeckeCarrier.{u,v,w} R M N)
    (D : ResidualNewformDatum C)
    (frob : ℕ → Field.absoluteGaloisGroup ℚ) where
  /-- The attached residual representation and its Frobenius compatibility. -/
  exists_rep :
    let p := D.residualPrime
    letI : Fact p.Prime := D.instResidualPrime
    let ev : ℕ → ZMod p := fun ℓ => D.residueMap (D.algebraicEigenvalue ℓ)
    ∃ ρ :
        MathlibExpansion.DeligneAttachedRepresentation.ResidualGaloisRep
          (Field.absoluteGaloisGroup ℚ) p,
      ∀ (ℓ : ℕ), ℓ.Prime → ℓ ≠ N → ℓ ≠ p →
        Matrix.trace
            (ρ.rep (frob ℓ))
          = ev ℓ ∧
        Matrix.det
            (ρ.rep (frob ℓ))
          = ((ℓ : ℕ) : ZMod p)

/-- **Deligne-style residual Galois attachment at prime level, narrowed to a
concrete weight-2 newform.**

Once the Deligne attachment evidence has been supplied for the chosen
Frobenius indexing function, extract the existential residual representation
and its trace/determinant compatibility. This theorem is axiom-free; the
unformalized source theorem is isolated in the typed evidence structure above.
-/
theorem residualGaloisAttachment
    {R : Type u} {M : Type v} [CommRing R] [AddCommGroup M] [Module R M]
    {N : ℕ}
    (C : PrimeLevelHeckeCarrier.{u,v,w} R M N)
    (D : ResidualNewformDatum C)
    (frob : ℕ → Field.absoluteGaloisGroup ℚ)
    (E : ResidualGaloisAttachmentEvidence C D frob) :
    let p := D.residualPrime
    letI : Fact p.Prime := D.instResidualPrime
    let ev : ℕ → ZMod p := fun ℓ => D.residueMap (D.algebraicEigenvalue ℓ)
    ∃ ρ :
        MathlibExpansion.DeligneAttachedRepresentation.ResidualGaloisRep
          (Field.absoluteGaloisGroup ℚ) p,
      ∀ (ℓ : ℕ), ℓ.Prime → ℓ ≠ N → ℓ ≠ p →
        Matrix.trace
            (ρ.rep (frob ℓ))
          = ev ℓ ∧
        Matrix.det
            (ρ.rep (frob ℓ))
          = ((ℓ : ℕ) : ZMod p) := by
  exact E.exists_rep

end MathlibExpansion.Roots.Mazur1977
