import Mathlib.Algebra.Module.PID
import Mathlib.RingTheory.Finiteness.Basic
import Mathlib.RingTheory.Finiteness.Prod
import Mathlib.RingTheory.PowerSeries.Basic

/-!
# [DEPRECATED] Iwasawa Λ-modules: legacy monolithic file

This file is the verbatim 1498-line original `IwasawaStructure.lean` moved here
on 2026-04-20 as part of the W9-R10 breach.

**Do not edit or extend this file.**  All active development is in
`MathlibExpansion.Roots.Iwasawa.*`.

Poison identified and killed in the breach:
- `IsDistinguished := True` (line 202 of original)
- `distinguishedDegree := 0` (placeholder, not real degree)
- `lambda_eq_zero_of_placeholder_degree` (mathematically false once real degrees land)
- `singleDistinguishedProfile_lambda_placeholder` (same)
-/

namespace MathlibExpansion
namespace Roots
namespace Deprecated
namespace IwasawaStructure

universe u v

open scoped DirectSum

/-- A one-variable Iwasawa-algebra model over a coefficient ring `R`. -/
abbrev Lambda (R : Type u) [CommSemiring R] : Type u :=
  PowerSeries R

/-- A finitely generated module over the `PowerSeries` model of `Λ`. -/
structure FinitelyGeneratedLambdaModule (R : Type u) [CommRing R] where
  carrier : Type v
  [addCommGroup : AddCommGroup carrier]
  [module : Module (Lambda R) carrier]
  finite : Module.Finite (Lambda R) carrier

attribute [instance] FinitelyGeneratedLambdaModule.addCommGroup
attribute [instance] FinitelyGeneratedLambdaModule.module

namespace FinitelyGeneratedLambdaModule

instance (R : Type u) [CommRing R] (M : FinitelyGeneratedLambdaModule.{u, v} R) :
    Module.Finite (Lambda R) M.carrier :=
  M.finite

end FinitelyGeneratedLambdaModule

/-- A linear map whose kernel and cokernel are finite as types. -/
def IsPseudoIsomorphism {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) : Prop :=
  Finite (LinearMap.ker f) ∧ Finite (N ⧸ LinearMap.range f)

abbrev pseudoKernel {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) : Type v :=
  LinearMap.ker f

abbrev pseudoCokernel {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) : Type v :=
  N ⧸ LinearMap.range f

theorem isPseudoIsomorphism_iff {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) :
    IsPseudoIsomorphism f ↔ Finite (pseudoKernel f) ∧ Finite (pseudoCokernel f) :=
  Iff.rfl

structure PseudoIsomorphism {R : Type u} [CommRing R]
    (M N : Type v) [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N] where
  hom : M →ₗ[Lambda R] N
  finite_kernel : Finite (LinearMap.ker hom)
  finite_cokernel : Finite (N ⧸ LinearMap.range hom)

namespace PseudoIsomorphism

theorem isPseudoIsomorphism {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : PseudoIsomorphism (R := R) M N) :
    IsPseudoIsomorphism f.hom :=
  ⟨f.finite_kernel, f.finite_cokernel⟩

def ofIsPseudoIsomorphism {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) (h : IsPseudoIsomorphism f) :
    PseudoIsomorphism (R := R) M N where
  hom := f
  finite_kernel := h.1
  finite_cokernel := h.2

@[simp] theorem ofIsPseudoIsomorphism_hom {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) (h : IsPseudoIsomorphism f) :
    (ofIsPseudoIsomorphism (R := R) f h).hom = f :=
  rfl

theorem exists_pseudoIsomorphism_with_hom_iff {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) :
    (∃ e : PseudoIsomorphism (R := R) M N, e.hom = f) ↔
      IsPseudoIsomorphism f := by
  constructor
  · rintro ⟨e, rfl⟩
    exact e.isPseudoIsomorphism
  · intro h
    exact ⟨ofIsPseudoIsomorphism f h, rfl⟩

noncomputable def ofLinearEquiv {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (e : M ≃ₗ[Lambda R] N) : PseudoIsomorphism (R := R) M N where
  hom := e.toLinearMap
  finite_kernel := by
    have hsub : Subsingleton (LinearMap.ker e.toLinearMap) := by
      refine ⟨fun x y => ?_⟩
      apply Subtype.ext
      have hx : (x : M) = 0 := by
        apply e.injective
        have hp := x.property
        rw [LinearMap.mem_ker] at hp
        rw [map_zero]
        exact hp
      have hy : (y : M) = 0 := by
        apply e.injective
        have hp := y.property
        rw [LinearMap.mem_ker] at hp
        rw [map_zero]
        exact hp
      rw [hx, hy]
    haveI : Subsingleton (LinearMap.ker e.toLinearMap) := hsub
    haveI : Fintype (LinearMap.ker e.toLinearMap) := Fintype.ofSubsingleton 0
    infer_instance
  finite_cokernel := by
    have hrange : LinearMap.range e.toLinearMap = ⊤ := by
      ext y
      constructor
      · intro _hy
        exact Submodule.mem_top
      · intro _hy
        exact ⟨e.symm y, by simp⟩
    have hsub : Subsingleton (N ⧸ LinearMap.range e.toLinearMap) := by
      rw [hrange]
      infer_instance
    haveI : Subsingleton (N ⧸ LinearMap.range e.toLinearMap) := hsub
    haveI : Fintype (N ⧸ LinearMap.range e.toLinearMap) := Fintype.ofSubsingleton 0
    infer_instance

noncomputable def refl {R : Type u} [CommRing R]
    (M : Type v) [AddCommGroup M] [Module (Lambda R) M] :
    PseudoIsomorphism (R := R) M M :=
  ofLinearEquiv (LinearEquiv.refl (Lambda R) M)

end PseudoIsomorphism

abbrev cyclicQuotient (R : Type u) [CommRing R] (a : Lambda R) : Type u :=
  Lambda R ⧸ Ideal.span ({a} : Set (Lambda R))

abbrev pPowerElementary (R : Type u) [CommRing R] (p : Lambda R) (n : ℕ) : Type u :=
  cyclicQuotient R (p ^ n)

/-- [POISON] IsDistinguished := True — this definition is vacuous. -/
def IsDistinguished {R : Type u} [CommRing R] (_f : Lambda R) : Prop :=
  True

abbrev distinguishedElementary (R : Type u) [CommRing R]
    (f : Lambda R) (_hf : IsDistinguished f) : Type u :=
  cyclicQuotient R f

structure LambdaElementaryProfile (R : Type u) [CommRing R] where
  rank : ℕ
  pPowerIndex : Type u
  [pPowerFintype : Fintype pPowerIndex]
  primeElement : Lambda R
  pPowerExponent : pPowerIndex → ℕ
  distinguishedIndex : Type u
  [distinguishedFintype : Fintype distinguishedIndex]
  distinguishedFactor : distinguishedIndex → Lambda R
  distinguished : ∀ i, IsDistinguished (distinguishedFactor i)

attribute [instance] LambdaElementaryProfile.pPowerFintype
attribute [instance] LambdaElementaryProfile.distinguishedFintype

namespace LambdaElementaryProfile

def mu {R : Type u} [CommRing R] (P : LambdaElementaryProfile R) : ℕ :=
  Finset.univ.sum P.pPowerExponent

/-- [POISON] distinguishedDegree := 0 — placeholder, not real degree. -/
def distinguishedDegree {R : Type u} [CommRing R]
    (_P : LambdaElementaryProfile R) (_i : _P.distinguishedIndex) : ℕ :=
  0

def lambda {R : Type u} [CommRing R] (P : LambdaElementaryProfile R) : ℕ :=
  Finset.univ.sum (P.distinguishedDegree ·)

noncomputable def characteristicElement {R : Type u} [CommRing R]
    (P : LambdaElementaryProfile R) : Lambda R :=
  P.primeElement ^ P.mu * Finset.univ.prod P.distinguishedFactor

noncomputable def characteristicIdeal {R : Type u} [CommRing R]
    (P : LambdaElementaryProfile R) : Ideal (Lambda R) :=
  Ideal.span ({P.characteristicElement} : Set (Lambda R))

def singlePPowerProfile {R : Type u} [CommRing R]
    (p : Lambda R) (n : ℕ) : LambdaElementaryProfile R where
  rank := 0
  pPowerIndex := PUnit
  primeElement := p
  pPowerExponent := fun _ => n
  distinguishedIndex := PEmpty
  distinguishedFactor := PEmpty.elim
  distinguished := by intro i; cases i

@[simp] theorem singlePPowerProfile_mu {R : Type u} [CommRing R]
    (p : Lambda R) (n : ℕ) :
    (singlePPowerProfile p n).mu = n := by
  simp [singlePPowerProfile, mu]

@[simp] theorem singlePPowerProfile_lambda {R : Type u} [CommRing R]
    (p : Lambda R) (n : ℕ) :
    (singlePPowerProfile p n).lambda = 0 := by
  simp [singlePPowerProfile, lambda, distinguishedDegree]

@[simp] theorem singlePPowerProfile_characteristicElement
    {R : Type u} [CommRing R] (p : Lambda R) (n : ℕ) :
    (singlePPowerProfile p n).characteristicElement = p ^ n := by
  rw [characteristicElement, singlePPowerProfile_mu]
  simp [singlePPowerProfile]

noncomputable def singleDistinguishedProfile {R : Type u} [CommRing R]
    (f : Lambda R) (hf : IsDistinguished f) : LambdaElementaryProfile R where
  rank := 0
  pPowerIndex := PEmpty
  primeElement := 1
  pPowerExponent := PEmpty.elim
  distinguishedIndex := PUnit
  distinguishedFactor := fun _ => f
  distinguished := fun _ => hf

@[simp] theorem singleDistinguishedProfile_mu {R : Type u} [CommRing R]
    (f : Lambda R) (hf : IsDistinguished f) :
    (singleDistinguishedProfile f hf).mu = 0 := by
  simp [singleDistinguishedProfile, mu]

/-- [POISON] This theorem is false once distinguished factors carry real degree. -/
@[simp] theorem singleDistinguishedProfile_lambda_placeholder
    {R : Type u} [CommRing R] (f : Lambda R) (hf : IsDistinguished f) :
    (singleDistinguishedProfile f hf).lambda = 0 := by
  simp [singleDistinguishedProfile, lambda, distinguishedDegree]

@[simp] theorem singleDistinguishedProfile_characteristicElement
    {R : Type u} [CommRing R] (f : Lambda R) (hf : IsDistinguished f) :
    (singleDistinguishedProfile f hf).characteristicElement = f := by
  simp [singleDistinguishedProfile, characteristicElement]

noncomputable def append {R : Type u} [CommRing R]
    (P Q : LambdaElementaryProfile R) : LambdaElementaryProfile R where
  rank := P.rank + Q.rank
  pPowerIndex := Sum P.pPowerIndex Q.pPowerIndex
  primeElement := P.primeElement
  pPowerExponent := Sum.elim P.pPowerExponent Q.pPowerExponent
  distinguishedIndex := Sum P.distinguishedIndex Q.distinguishedIndex
  distinguishedFactor := Sum.elim P.distinguishedFactor Q.distinguishedFactor
  distinguished := by
    intro i
    cases i with
    | inl i => exact P.distinguished i
    | inr i => exact Q.distinguished i

@[simp] theorem append_rank {R : Type u} [CommRing R]
    (P Q : LambdaElementaryProfile R) :
    (P.append Q).rank = P.rank + Q.rank := rfl

@[simp] theorem append_mu {R : Type u} [CommRing R]
    (P Q : LambdaElementaryProfile R) :
    (P.append Q).mu = P.mu + Q.mu := by
  simp [append, mu, Finset.sum_sumElim]

@[simp] theorem append_lambda {R : Type u} [CommRing R]
    (P Q : LambdaElementaryProfile R) :
    (P.append Q).lambda = P.lambda + Q.lambda := by
  simp [append, lambda, distinguishedDegree, Finset.sum_sumElim]

@[simp] theorem append_characteristicElement
    {R : Type u} [CommRing R] (P Q : LambdaElementaryProfile R)
    (hprime : Q.primeElement = P.primeElement) :
    (P.append Q).characteristicElement =
      P.characteristicElement * Q.characteristicElement := by
  simp [append, characteristicElement, mu, hprime, pow_add, mul_assoc, mul_left_comm, mul_comm,
    Finset.prod_sumElim]

theorem append_characteristicIdeal_generator
    {R : Type u} [CommRing R] (P Q : LambdaElementaryProfile R)
    (hprime : Q.primeElement = P.primeElement) :
    (P.append Q).characteristicIdeal =
      Ideal.span
        ({P.characteristicElement * Q.characteristicElement} : Set (Lambda R)) := by
  rw [characteristicIdeal, append_characteristicElement P Q hprime]

theorem mu_eq_zero_of_pPowerExponent_eq_zero {R : Type u} [CommRing R]
    (P : LambdaElementaryProfile R) (h : ∀ i, P.pPowerExponent i = 0) :
    P.mu = 0 := by
  simp [mu, h]

/-- [POISON] This theorem is only true because distinguishedDegree is hardcoded to 0. -/
theorem lambda_eq_zero_of_placeholder_degree {R : Type u} [CommRing R]
    (P : LambdaElementaryProfile R) :
    P.lambda = 0 := by
  simp [lambda, distinguishedDegree]

theorem characteristicIdeal_eq_top_of_isUnit
    {R : Type u} [CommRing R] (P : LambdaElementaryProfile R)
    (hP : IsUnit P.characteristicElement) :
    P.characteristicIdeal = ⊤ := by
  rw [characteristicIdeal, Ideal.eq_top_iff_one]
  have hmem : P.characteristicElement ∈
      Ideal.span ({P.characteristicElement} : Set (Lambda R)) :=
    Ideal.subset_span (by simp)
  rcases hP with ⟨u, hu⟩
  have hunit_mem : ((↑u⁻¹ : Lambda R) * P.characteristicElement) ∈
      Ideal.span ({P.characteristicElement} : Set (Lambda R)) :=
    Ideal.mul_mem_left _ _ hmem
  have hone : ((↑u⁻¹ : Lambda R) * P.characteristicElement) = 1 := by
    rw [← hu]; exact Units.inv_mul u
  simpa [hone] using hunit_mem

end LambdaElementaryProfile

structure LambdaProfileInvariants (R : Type u) [CommRing R] where
  profile : LambdaElementaryProfile R
  mu : ℕ
  lambda : ℕ

namespace LambdaProfileInvariants

def ofProfile {R : Type u} [CommRing R]
    (P : LambdaElementaryProfile R) : LambdaProfileInvariants R where
  profile := P
  mu := P.mu
  lambda := P.lambda

@[simp] theorem ofProfile_mu {R : Type u} [CommRing R]
    (P : LambdaElementaryProfile R) :
    (ofProfile P).mu = P.mu := rfl

@[simp] theorem ofProfile_lambda {R : Type u} [CommRing R]
    (P : LambdaElementaryProfile R) :
    (ofProfile P).lambda = P.lambda := rfl

end LambdaProfileInvariants

structure ProfileRealization (R : Type u) [CommRing R]
    (P : LambdaElementaryProfile R) where
  carrier : Type v
  [addCommGroup : AddCommGroup carrier]
  [module : Module (Lambda R) carrier]
  finite : Module.Finite (Lambda R) carrier

attribute [instance] ProfileRealization.addCommGroup
attribute [instance] ProfileRealization.module

namespace ProfileRealization

instance (R : Type u) [CommRing R] (P : LambdaElementaryProfile R)
    (E : ProfileRealization.{u, v} R P) :
    Module.Finite (Lambda R) E.carrier :=
  E.finite

def toFinitelyGeneratedLambdaModule {R : Type u} [CommRing R]
    {P : LambdaElementaryProfile R} (E : ProfileRealization.{u, v} R P) :
    FinitelyGeneratedLambdaModule.{u, v} R where
  carrier := E.carrier
  finite := E.finite

@[simp] theorem toFinitelyGeneratedLambdaModule_carrier {R : Type u} [CommRing R]
    {P : LambdaElementaryProfile R} (E : ProfileRealization.{u, v} R P) :
    E.toFinitelyGeneratedLambdaModule.carrier = E.carrier := rfl

end ProfileRealization

structure LambdaProfileDecomposition (R : Type u) [CommRing R]
    (M : FinitelyGeneratedLambdaModule.{u, v} R) where
  profile : LambdaElementaryProfile R
  realization : ProfileRealization.{u, v} R profile
  pseudo :
    Nonempty (PseudoIsomorphism (R := R) M.carrier realization.carrier)

def HasLambdaProfileDecompositionAPI (R : Type u) [CommRing R] : Prop := False

def HasZpIwasawaAlgebraAPI : Prop := False
def HasPowerSeriesWeierstrassPreparationAPI (R : Type u) [CommRing R] : Prop := False
def HasLambdaPseudoIsomorphismCalculusAPI (R : Type u) [CommRing R] : Prop := False
def HasLambdaElementaryDecompositionAPI (R : Type u) [CommRing R] : Prop := False
def HasLambdaElementaryUniquenessAPI (R : Type u) [CommRing R] : Prop := False
def HasLambdaCharacteristicIdealAPI (R : Type u) [CommRing R] : Prop := False

def HasIwasawaStructureTheoremAPI (R : Type u) [CommRing R] : Prop :=
  HasZpIwasawaAlgebraAPI ∧
    HasPowerSeriesWeierstrassPreparationAPI R ∧
    HasLambdaPseudoIsomorphismCalculusAPI R ∧
    HasLambdaElementaryDecompositionAPI R ∧
    HasLambdaElementaryUniquenessAPI R

def IwasawaStructureTheoremStatement (R : Type u) [CommRing R] : Prop :=
  ∀ (M : FinitelyGeneratedLambdaModule.{u, v} R),
    ∃ (E : Type v) (_ : AddCommGroup E) (_ : Module (Lambda R) E),
      Module.Finite (Lambda R) E ∧ Nonempty (PseudoIsomorphism (R := R) M.carrier E)

theorem iwasawa_structure_theorem_of_missing_api
    (R : Type u) [CommRing R] (h : HasIwasawaStructureTheoremAPI R) :
    IwasawaStructureTheoremStatement R := by
  rcases h with ⟨hZp, _hW, _hPseudo, _hDecomp, _hUnique⟩
  cases hZp

end IwasawaStructure
end Deprecated
end Roots
end MathlibExpansion
