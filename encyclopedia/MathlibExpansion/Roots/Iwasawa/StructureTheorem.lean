import Mathlib.Algebra.Module.Torsion
import MathlibExpansion.Roots.Iwasawa.CharacteristicIdeal
import MathlibExpansion.RingTheory.PowerSeries.ElementaryProfile
import MathlibExpansion.Textbooks.Washington.Ch7_1.WeierstrassPreparation

/-!
# Iwasawa Structure Theorem: theorem/axiom boundaries and derived consequences

This file closes the W9-R10 breach by combining the discharged
Weierstrass-preparation theorem with the remaining cited axioms and deriving
honest consequences for μ, λ, and the characteristic ideal.

## Input stack

This file uses one theorem-level input plus a small set of remaining
statement-level `axiom` boundaries, not `Prop := True` poison:

1. `weierstrassPreparation` — theorem, re-exporting
   `Textbooks.Washington.Ch7_1.weierstrassPreparation` (Washington
   *Cyclotomic Fields* Thm 7.3; Lang *Cyclotomic Fields I & II* §5.3).
   Its closure consumes four narrow upstream sub-axioms in
   `Textbooks.Washington.Ch7_1.WeierstrassPreparation`.

2. `iwasawaFreeTorsionSplit` and `iwasawaTorsionUpgradeOfSplit` — two narrow
   upstream existence boundaries whose composition yields the exported theorem
   `iwasawaStructureTheorem` (Washington Thm 13.12; Bourbaki *Comm. Alg.* VII
   §4.4 Thm 5; Neukirch-Schmidt-Wingberg §5.3).

3. `RingTheory.PowerSeries.elementaryConcreteProfile_unique` — narrow upstream
   axiom for two concrete elementary models of the same Λ-module. The exported
   `RingTheory.PowerSeries.elementaryProfile_unique` wrapper derives the
   reindexing data for `LambdaProfileDecomposition`s from their concrete-model
   certificates.
   The derived theorems
   `RingTheory.PowerSeries.elementaryProfile_characteristicIdeal_unique`,
   `RingTheory.PowerSeries.elementaryProfile_mu_unique`, and
   `RingTheory.PowerSeries.elementaryProfile_lambda_unique`
   are consequences of that single boundary.

## Invariants upgrade (honest-invariants replacement of `.some`-laundering)

Prior versions of this file defined `characteristicIdeal`, `iwasawa_mu`,
and `iwasawa_lambda` by `(iwasawa_profileDecomposition_exists p M).some.…`.
That is classical choice: it picks *some* profile decomposition, but with
no guarantee that the value it reads off is independent of the choice.
In the absence of an invariance theorem, the `.some` construction is
signature-laundering — the invariants look well-defined but are not.

The upgrade here uses the single narrow upstream axiom
`RingTheory.PowerSeries.elementaryConcreteProfile_unique`, which says that two
concrete elementary models of the same module differ only by reindexing the
finite elementary families. The `elementaryProfile_unique` wrapper applies it
through the concrete-model certificate in each decomposition. The
characteristic-ideal, μ, and λ uniqueness theorems used below are derived
consequences of that stronger statement.
The module-level invariants are still expressed through
`iwasawa_profileDecomposition_exists`, but the companion theorems
`characteristicIdeal_eq_of_decomposition`,
`iwasawa_mu_eq_of_decomposition`, and `iwasawa_lambda_eq_of_decomposition`
prove choice-independence directly from the axioms.  That turns `.some`
into an honest selector whose value is characterized by a theorem.

The old `characteristicIdeal_free_eq_top`, whose `(M, he)` arguments went
unused, is deleted. Its honest replacement
`characteristicIdeal_eq_top_of_freeEquiv` uses `M` and `he` to build a
free-profile decomposition and applies the concrete uniqueness boundary. Companion
theorems `iwasawa_mu_eq_zero_of_freeEquiv` and
`iwasawa_lambda_eq_zero_of_freeEquiv` follow the same pattern.

## Remaining work for full kernel-adjacent discharge

- UFD / height-1 prime factorization API for `Λ = ℤ_[p][[T]]` is not yet
  exposed (see `RECON_IWASAWA_RR_LAMBDA_PSEUDO_NULL_CALCULUS_REPORT`).
- Height-≥2 pseudo-null predicate (Blindspot C) — see `Pseudo.lean`.
- Noetherianity of `PowerSeries ℤ_[p]` (see `RECON_IWASAWA_RR_LAMBDA_POWERSERIES_NOETHERIAN_REPORT`; 80-180 LOC future discharge).

## Note on Blindspot C

`IsPseudoIsomorphism` (Pseudo.lean) uses `Finite` kernel/cokernel, not
the height-≥2 pseudo-null condition.  Both narrow upstream existence axioms
below are stated using the same weakened predicate to keep the file
self-consistent.  The gap is flagged by `HasProperPseudoNullCalculusAPI := False`
in Pseudo.lean.

## Note on universe levels

`iwasawaStructureTheorem` is stated with the module carrier in `Type 0`
(matching `concreteProfileCarrier`, which returns `Type`).  All derived
theorems that call through the axiom are therefore restricted to
`FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]`.  This is compatible with
the `X∞AsModule` wrapper in `MazurWiles1984.Boundary` whose carrier is
`X∞ p d : Type` (universe 0).
-/

namespace MathlibExpansion
namespace Roots
namespace Iwasawa

open scoped Padic

/-! ## Axiom 1 (former) → Theorem: Weierstrass Preparation

**2026-04-22 Phase 2 #5 REPLAN c2 (opus)**: the former `axiom weierstrassPreparation`
is now a `theorem` exported via `Textbooks.Washington.Ch7_1.weierstrassPreparation`.
Its closure consumes **four** narrow upstream sub-axioms
(`trunc_mul_dist_inductive`, `successive_approximation_cauchy`,
`adic_limit_exists`, `limit_is_prepared` in Ch7_1/WeierstrassPreparation.lean),
each strictly closer to the Mathlib kernel than the original single axiom.
The prior sub-step `preparation_from_firstUnitIndex` is itself now a theorem
chaining the four sub-axioms:

* Smaller hypothesis: the `p`-content factor is already stripped by
  `exists_contentFactor` (closed theorem, no axioms).
* Tighter conclusion: includes `D.poly.natDegree = n` (exact degree equality).
* `0 < n` explicit: rules out the corner-case input.

### Signature correction (necessary)

The former axiom was *latently unprovable* for inputs `f = u' · p^μ` with `u'`
a unit power series: `DistinguishedPolynomial` requires `natDegree ≥ 1`, but no
distinguished polynomial of positive degree is a unit in `ℤ_p[[T]]` (constant
term in `pℤ_p`), so `1 / D.toPowerSeries` is not a power series. Hence no
factorization `u' · p^μ = u · p^μ' · D.toPowerSeries` exists.

The corrected theorem below takes one additional hypothesis `h_nonTrivial`
expressing Washington Thm 7.3's implicit "λ ≥ 1" assumption. This is satisfied
by all downstream Iwasawa consumers (Selmer-group duals are never unit-times-p^μ).

See `Textbooks.Washington.Ch7_1.WeierstrassPreparation` for the full story. -/

/-- **Weierstrass preparation theorem** (Washington Thm 7.3), corrected form.

Every nonzero `f ∈ ℤ_p[[T]]` that is not trivially `u' · p^μ` factors as
`f = u · p^μ · D.toPowerSeries` with `u` a unit power series and `D` a
distinguished polynomial of positive degree.

This is a theorem (not an axiom): it is a direct re-export of
`Textbooks.Washington.Ch7_1.weierstrassPreparation`, whose closure depends on
the four narrow upstream sub-axioms
`trunc_mul_dist_inductive`, `successive_approximation_cauchy`,
`adic_limit_exists`, and `limit_is_prepared`. -/
theorem weierstrassPreparation (p : ℕ) [Fact p.Prime]
    (f : PowerSeries ℤ_[p]) (hf : f ≠ 0)
    (h_nonTrivial : ¬ ∃ (u : (PowerSeries ℤ_[p])ˣ) (μ : ℕ),
      f = (u : PowerSeries ℤ_[p]) * primeInLambda p ^ μ) :
    ∃ (u : (PowerSeries ℤ_[p])ˣ) (μ : ℕ) (D : DistinguishedPolynomial p),
      f = (u : PowerSeries ℤ_[p]) * primeInLambda p ^ μ * D.toPowerSeries :=
  MathlibExpansion.Textbooks.Washington.Ch7_1.weierstrassPreparation p f hf h_nonTrivial

/-! ## Axiom 2 split: free/torsion reduction + torsion upgrade -/

/-- Narrow upstream existence boundary for Washington Thm 13.12:
every finitely generated `Λ = ℤ_p[[T]]`-module is pseudo-isomorphic to
a finite-rank free module times a finitely generated torsion module.

Exact discharge target: Washington (1997), *Introduction to Cyclotomic
Fields*, 2nd ed., Ch. 13, Theorem 13.12, free-rank/torsion reduction inside
the structure theorem; Bourbaki, *Commutative Algebra*, Ch. VII §4.4,
Theorem 5, pseudo-isomorphism/classification input over the Iwasawa algebra.

This isolates the non-PID free/torsion reduction step from the torsion
classification step.  It is closer to the Mathlib kernel than the full
elementary-profile theorem because it does not yet mention distinguished
factors, `μ`, `λ`, or characteristic ideals.

Current Mathlib gap: `Module.equiv_free_prod_directSum` is available only
under `[IsPrincipalIdealRing R]`; Lean does not synthesize
`IsPrincipalIdealRing (PowerSeries ℤ_[p])`, and mathematically
`ℤ_p[[T]]` is not a PID.  The local Noetherian/pseudo-null substrate is not
yet enough to prove the pseudo-free torsion-free quotient and pseudo-splitting
steps. -/
axiom iwasawaFreeTorsionSplit (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]) :
    ∃ (rank : ℕ) (T : Type)
      (_ : AddCommGroup T)
      (_ : Module (Lambda ℤ_[p]) T)
      (_ : Module.Finite (Lambda ℤ_[p]) T)
      (_ : Module.IsTorsion (Lambda ℤ_[p]) T),
        Nonempty (PseudoIsomorphism (R := ℤ_[p]) M.carrier ((Fin rank → Lambda ℤ_[p]) × T))

/-- Narrow upstream existence boundary for Washington Thm 13.12:
once a free/torsion pseudo-splitting is supplied, the torsion factor can be
upgraded to an honest elementary profile.

Exact discharge target: Washington (1997), *Introduction to Cyclotomic
Fields*, 2nd ed., Ch. 13, Theorem 13.12, torsion elementary decomposition
into `Λ/(p^n)` and distinguished-polynomial cyclic factors; Bourbaki,
*Commutative Algebra*, Ch. VII §4.4, Theorem 5, elementary divisor/factor
classification input after Weierstrass preparation.

This packages the torsion classification step together with the bookkeeping
that reincorporates the free rank into a full `LambdaElementaryProfile`.  It
is strictly downstream of `iwasawaFreeTorsionSplit`, hence narrower than the
old single axiom `iwasawaStructureTheorem`.

Current Mathlib gap: the file has a discharged Weierstrass-preparation
wrapper and profile-level characteristic-ideal API, but no theorem classifying
height-one factors of `PowerSeries ℤ_[p]` into the prime `p` and
distinguished factors, nor legacy pseudo-isomorphism composition/product
bookkeeping for replacing the torsion summand by its elementary model. -/
axiom iwasawaTorsionUpgradeOfSplit (p : ℕ) [Fact p.Prime]
    {M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]}
    (rank : ℕ) (T : Type)
    [AddCommGroup T]
    [Module (Lambda ℤ_[p]) T]
    [Module.Finite (Lambda ℤ_[p]) T]
    (hTorsion : Module.IsTorsion (Lambda ℤ_[p]) T)
    (hSplit : Nonempty
      (PseudoIsomorphism (R := ℤ_[p]) M.carrier ((Fin rank → Lambda ℤ_[p]) × T))) :
    ∃ (P : LambdaElementaryProfile p),
      Nonempty (PseudoIsomorphism (R := ℤ_[p]) M.carrier (concreteProfileCarrier P))

/-- Iwasawa structure theorem for finitely generated `Λ = ℤ_p[[T]]`-modules.

Every finitely generated `Λ`-module `M` is pseudo-isomorphic to an elementary
`Λ`-module of the form
`Λ^r ⊕ (⊕_i Λ/(p^{n_i})) ⊕ (⊕_j Λ/(D_j))`
for a unique (up to permutation and associates) elementary profile.

**Reference**: Washington, *Introduction to Cyclotomic Fields*, Thm 13.12;
Bourbaki, *Commutative Algebra* VII §4.4 Thm 5;
Neukirch-Schmidt-Wingberg, *Cohomology of Number Fields*, §5.3.

**Mathlib gap**: Mathlib has the PID structure theorem
(`Module.equiv_free_prod_directSum`) but not the `ℤ_p[[T]]` pseudo-isomorphism
classification.  The theorem below is assembled from the two narrower upstream
boundaries `iwasawaFreeTorsionSplit` and `iwasawaTorsionUpgradeOfSplit`.

**Note on Blindspot C**: The pseudo-isomorphism here uses `Finite` kernel and
cokernel rather than the height-≥2 condition.  See `HasProperPseudoNullCalculusAPI`
in Pseudo.lean. -/
theorem iwasawaStructureTheorem (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]) :
    ∃ (P : LambdaElementaryProfile p),
      Nonempty (PseudoIsomorphism (R := ℤ_[p]) M.carrier (concreteProfileCarrier P)) := by
  rcases iwasawaFreeTorsionSplit p M with
    ⟨rank, T, _instAddCommGroup, _instModule, _instFinite, _instTorsion, hSplit⟩
  exact iwasawaTorsionUpgradeOfSplit p rank T _instTorsion hSplit

/-! ## Existence of profile decompositions -/

/-- From the structure theorem, every f.g. Λ-module has Iwasawa μ and λ invariants.

These are real natural numbers, not axioms themselves.

Note: `lam` is used for the λ-invariant to avoid conflict with Lean 4's `λ` keyword. -/
theorem iwasawa_mu_lambda_exist (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]) :
    ∃ (μ lam : ℕ), ∃ (P : LambdaElementaryProfile p),
      P.mu = μ ∧ P.lambda = lam ∧
        Nonempty (PseudoIsomorphism (R := ℤ_[p]) M.carrier (concreteProfileCarrier P)) := by
  rcases iwasawaStructureTheorem p M with ⟨P, hP⟩
  exact ⟨P.mu, P.lambda, P, rfl, rfl, hP⟩

/-- A profile decomposition exists for every f.g. Λ-module. -/
theorem iwasawa_profileDecomposition_exists (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]) :
    Nonempty (LambdaProfileDecomposition p M) := by
  rcases iwasawaStructureTheorem p M with ⟨P, hP⟩
  exact ⟨{
    profile := P
    realization := concreteProfileRealization P
    pseudo := by simpa [concreteProfileRealization] using hP
    concretePseudo := hP
  }⟩

/-! ## C4c boundary: elementary-profile uniqueness (narrow upstream)

The strong uniqueness statement now lives in
`RingTheory/PowerSeries/ElementaryProfile.lean`. It asserts that the full
elementary profile data is unique up to reindexing of the finite `p`-power and
distinguished-factor families. The characteristic ideal, μ, and λ independence
theorems used below are derived consequences of that single boundary.

**Classical reference**: Mazur–Wiles 1984 derives all three from
Weierstrass preparation (Washington Thm 7.3) plus the UFD factor-count
argument for the associated distinguished factors.  Mathlib exposes
`UniqueFactorizationMonoid` and `normalizedFactors`, but the `UFD` instance
for `Λ = ℤ_[p][[T]]` is not yet available at the type level; see
`RECON_IWASAWA_RR_LAMBDA_PSEUDO_NULL_CALCULUS_REPORT` and
`RECON_IWASAWA_RR_LAMBDA_POWERSERIES_NOETHERIAN_REPORT`.

**Direction-over-count classification**: this is now **one** strong
reindexing boundary rather than three separate invariant axioms. Ledger:
`+1 narrow upstream`, direction toward discharge via Weierstrass + UFD
factor-count. -/

/-! ## Module-level Iwasawa invariants

The module-level invariants `characteristicIdeal`, `iwasawa_mu`, and
`iwasawa_lambda` are defined by picking some profile decomposition (supplied
by `iwasawa_profileDecomposition_exists`) and reading off its invariants.
The imported elementary-profile uniqueness theorems guarantee that these
definitions are independent of the choice; the companion theorems
`characteristicIdeal_eq_of_decomposition`, `iwasawa_mu_eq_of_decomposition`,
and `iwasawa_lambda_eq_of_decomposition` expose that independence. -/

/-- The characteristic ideal of a f.g. Λ-module.

Independent of the choice of profile decomposition, witnessed by
`characteristicIdeal_eq_of_decomposition`.

Universe note: restricted to `{0, 0}` to match `iwasawaStructureTheorem`. -/
noncomputable def characteristicIdeal (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]) : Ideal (Lambda ℤ_[p]) :=
  (iwasawa_profileDecomposition_exists p M).some.characteristicIdeal

/-- The Iwasawa μ-invariant of a f.g. Λ-module.

Independent of the choice of profile decomposition, witnessed by
`iwasawa_mu_eq_of_decomposition`. -/
noncomputable def iwasawa_mu (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]) : ℕ :=
  (iwasawa_profileDecomposition_exists p M).some.mu

/-- The Iwasawa λ-invariant of a f.g. Λ-module.

Independent of the choice of profile decomposition, witnessed by
`iwasawa_lambda_eq_of_decomposition`. -/
noncomputable def iwasawa_lambda (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]) : ℕ :=
  (iwasawa_profileDecomposition_exists p M).some.lambda

/-- The module-level characteristic ideal equals the characteristic ideal of
*any* profile decomposition.  This is the theorem that makes the `.some`-based
definition honest: the concrete uniqueness boundary tracks the choice. -/
theorem characteristicIdeal_eq_of_decomposition (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p])
    (D : LambdaProfileDecomposition p M) :
    characteristicIdeal p M = D.characteristicIdeal :=
  MathlibExpansion.RingTheory.PowerSeries.elementaryProfile_characteristicIdeal_unique p M _ D

/-- The module-level μ-invariant equals the μ of *any* profile decomposition. -/
theorem iwasawa_mu_eq_of_decomposition (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p])
    (D : LambdaProfileDecomposition p M) :
    iwasawa_mu p M = D.mu :=
  MathlibExpansion.RingTheory.PowerSeries.elementaryProfile_mu_unique p M _ D

/-- The module-level λ-invariant equals the λ of *any* profile decomposition. -/
theorem iwasawa_lambda_eq_of_decomposition (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p])
    (D : LambdaProfileDecomposition p M) :
    iwasawa_lambda p M = D.lambda :=
  MathlibExpansion.RingTheory.PowerSeries.elementaryProfile_lambda_unique p M _ D

/-! ## Free-module decomposition and invariants

When `M.carrier ≃ₗ[Λ] Λ^rank`, we can explicitly construct a profile
decomposition with `profile = freeLambdaElementaryProfile p rank` and a
realization whose carrier is `Fin rank → Lambda ℤ_[p]`.  Combined with the
uniqueness boundary, this lets us read off `characteristicIdeal p M = ⊤`,
`iwasawa_mu p M = 0`, and `iwasawa_lambda p M = 0` — **honestly** using
both `M` and `he`, with no signature laundering. -/

/-- Build a free-profile decomposition of `M` from an explicit `Λ`-equivalence
`M.carrier ≃ₗ (Fin rank → Lambda ℤ_[p])`.

The realization uses the bare carrier `Fin rank → Lambda ℤ_[p]` (not
`concreteProfileCarrier`) so that the pseudo-isomorphism is literally the
provided equivalence — no PEmpty-based shimming is needed. -/
noncomputable def freeProfileDecomposition (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]) (rank : ℕ)
    (he : M.carrier ≃ₗ[Lambda ℤ_[p]] (Fin rank → Lambda ℤ_[p])) :
    LambdaProfileDecomposition p M where
  profile := freeLambdaElementaryProfile p rank
  realization :=
    { carrier := Fin rank → Lambda ℤ_[p]
      finite := inferInstance }
  pseudo := ⟨PseudoIsomorphism.ofLinearEquiv he⟩
  concretePseudo := ⟨PseudoIsomorphism.ofLinearEquiv
    (he.trans (freeProfileConcreteEquiv (p := p) rank))⟩

/-- **Honest** replacement of the deprecated `characteristicIdeal_free_eq_top`:
for a free Λ-module, the module-level characteristic ideal is the unit ideal.

Uses both `M` and `he`: the equivalence `he` is consumed by
`freeProfileDecomposition` to build an explicit profile decomposition whose
profile is the free one, and the uniqueness boundary identifies the module-level
invariant with the profile-level computation. -/
theorem characteristicIdeal_eq_top_of_freeEquiv (p : ℕ) [Fact p.Prime] (rank : ℕ)
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p])
    (he : M.carrier ≃ₗ[Lambda ℤ_[p]] (Fin rank → Lambda ℤ_[p])) :
    characteristicIdeal p M = ⊤ := by
  have hD :=
    characteristicIdeal_eq_of_decomposition p M (freeProfileDecomposition p M rank he)
  rw [hD]
  show (freeLambdaElementaryProfile p rank).characteristicIdeal = ⊤
  exact charIdeal_free_eq_top (p := p) rank

/-- For a free Λ-module, the module-level μ-invariant is zero.  Honest
replacement using `M` and `he` non-vacuously. -/
theorem iwasawa_mu_eq_zero_of_freeEquiv (p : ℕ) [Fact p.Prime] (rank : ℕ)
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p])
    (he : M.carrier ≃ₗ[Lambda ℤ_[p]] (Fin rank → Lambda ℤ_[p])) :
    iwasawa_mu p M = 0 := by
  have hD :=
    iwasawa_mu_eq_of_decomposition p M (freeProfileDecomposition p M rank he)
  rw [hD]
  show (freeLambdaElementaryProfile p rank).mu = 0
  exact freeLambdaElementaryProfile_mu p rank

/-- For a free Λ-module, the module-level λ-invariant is zero.  Honest
replacement using `M` and `he` non-vacuously. -/
theorem iwasawa_lambda_eq_zero_of_freeEquiv (p : ℕ) [Fact p.Prime] (rank : ℕ)
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p])
    (he : M.carrier ≃ₗ[Lambda ℤ_[p]] (Fin rank → Lambda ℤ_[p])) :
    iwasawa_lambda p M = 0 := by
  have hD :=
    iwasawa_lambda_eq_of_decomposition p M (freeProfileDecomposition p M rank he)
  rw [hD]
  show (freeLambdaElementaryProfile p rank).lambda = 0
  exact freeLambdaElementaryProfile_lambda p rank

/-- Compact statement of the Iwasawa structure theorem:
every f.g. Λ-module has an elementary pseudo-isomorphic model. -/
theorem iwasawa_structure (p : ℕ) [Fact p.Prime]
    (M : FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p]) :
    ∃ (E : Type) (_ : AddCommGroup E) (_ : Module (Lambda ℤ_[p]) E),
      Module.Finite (Lambda ℤ_[p]) E ∧
        Nonempty (PseudoIsomorphism (R := ℤ_[p]) M.carrier E) := by
  rcases iwasawaStructureTheorem p M with ⟨P, hP⟩
  exact ⟨concreteProfileCarrier P, inferInstance, inferInstance,
         concreteProfileCarrier_module_finite P, hP⟩

end Iwasawa
end Roots
end MathlibExpansion
