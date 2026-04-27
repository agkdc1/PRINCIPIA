import Mathlib
import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver
import MathlibExpansion.Roots.AtiyahMacdonald.FittingIdeal
import MathlibExpansion.Roots.AtiyahMacdonald.NumericLength

/-!
# Diamond's algebraic criterion: data layer and local kernel bridge

This file packages the public Diamond 1996 consumer surface together with the
local kernel-side hypotheses needed by the injectivity argument.

## What is definition-land here

- `HeckeProjection`
- `ComparisonMap`
- `FittingLengthAPI`
- `AlgebraicCriterionData`
- `fittingLengthAPI_ofFiniteLength`

## What is hypothesis-land here

`AlgebraicCriterionData` carries the local kernel-side hypotheses consumed by
the honest injectivity proof:

- identify the caller-supplied cotangent module with the kernel cotangent
  `ker(R → T) / ker(R → T)^2`,
- provide the locality/nontriviality instances needed by the idempotent-kernel
  argument,
- record that the congruence module is already trivial enough to force
  annihilator `⊤`.

The bridge `cotangentComparisonBridge` is therefore definition-land packaging
of explicit caller data, not a new axiom.
-/

namespace MathlibExpansion.Roots.Diamond1996

universe u

/-! ## 1. Hecke projection and comparison map -/

/-- Typed eigenvalue projection `T →+* O`. Consumer-supplied data. -/
structure HeckeProjection (T O : Type u) [CommRing T] [CommRing O] where
  toRingHom : T →+* O

/-- Typed comparison map `R →ₐ[O] T`, together with surjectivity. -/
structure ComparisonMap
    (O R T : Type u) [CommRing O] [CommRing R] [CommRing T]
    [Algebra O R] [Algebra O T] where
  toAlgHom   : R →ₐ[O] T
  surjective : Function.Surjective toAlgHom

/-! ## 2. Diamond-scoped numerics API -/

/-- Diamond-scoped carrier for the canonical Atiyah-Macdonald numerics bridge. -/
structure FittingLengthAPI
    (O : Type u) [CommRing O]
    (Φ : Type u) [AddCommGroup Φ] [Module O Φ]
    (ψ : Type u) [AddCommGroup ψ] [Module O ψ] : Type u where
  finiteLengthΦ : IsFiniteLength O Φ
  finiteLengthψ : IsFiniteLength O ψ

namespace FittingLengthAPI

variable {O : Type u} [CommRing O]
variable {Φ : Type u} [AddCommGroup Φ] [Module O Φ]
variable {ψ : Type u} [AddCommGroup ψ] [Module O ψ]

/-- Canonical ideal attached to the cotangent module. -/
def fittingΦ (_api : FittingLengthAPI O Φ ψ) : Ideal O :=
  MathlibExpansion.Roots.AtiyahMacdonald.fittingIdeal (R := O) (M := Φ)

/-- Canonical ideal attached to the congruence module. -/
def fittingψ (_api : FittingLengthAPI O Φ ψ) : Ideal O :=
  MathlibExpansion.Roots.AtiyahMacdonald.fittingIdeal (R := O) (M := ψ)

/-- Natural-number length attached to the cotangent module. -/
noncomputable def lengthΦ (api : FittingLengthAPI O Φ ψ) : ℕ :=
  MathlibExpansion.Roots.AtiyahMacdonald.finiteLengthNat
    (R := O) (M := Φ) api.finiteLengthΦ

/-- Natural-number length attached to the congruence module. -/
noncomputable def lengthψ (api : FittingLengthAPI O Φ ψ) : ℕ :=
  MathlibExpansion.Roots.AtiyahMacdonald.finiteLengthNat
    (R := O) (M := ψ) api.finiteLengthψ

/-- The cotangent-side ideal lies below the cotangent annihilator. -/
theorem fittingΦ_le_annΦ (api : FittingLengthAPI O Φ ψ) :
    api.fittingΦ ≤ Module.annihilator O Φ :=
  MathlibExpansion.Roots.AtiyahMacdonald.fittingIdeal_le_annihilator
    (R := O) (M := Φ)

/-- The congruence-side ideal lies below the congruence annihilator. -/
theorem fittingψ_le_annψ (api : FittingLengthAPI O Φ ψ) :
    api.fittingψ ≤ Module.annihilator O ψ :=
  MathlibExpansion.Roots.AtiyahMacdonald.fittingIdeal_le_annihilator
    (R := O) (M := ψ)

/-- The cotangent-side ideal is definitionally the annihilator. -/
@[simp]
theorem fittingΦ_eq_annihilator (api : FittingLengthAPI O Φ ψ) :
    api.fittingΦ = Module.annihilator O Φ :=
  MathlibExpansion.Roots.AtiyahMacdonald.fittingIdeal_eq_annihilator
    (R := O) (M := Φ)

/-- The congruence-side ideal is definitionally the annihilator. -/
@[simp]
theorem fittingψ_eq_annihilator (api : FittingLengthAPI O Φ ψ) :
    api.fittingψ = Module.annihilator O ψ :=
  MathlibExpansion.Roots.AtiyahMacdonald.fittingIdeal_eq_annihilator
    (R := O) (M := ψ)

/-- The cotangent-side natural length matches the internal `ℕ∞` length. -/
theorem lengthΦ_eq_moduleLength (api : FittingLengthAPI O Φ ψ) :
    (api.lengthΦ : ℕ∞) =
      MathlibExpansion.Roots.AtiyahMacdonald.moduleLength (R := O) (M := Φ) := by
  rw [MathlibExpansion.Roots.AtiyahMacdonald.moduleLength_eq_coe_finiteLengthNat
    (R := O) (M := Φ) api.finiteLengthΦ]
  simp [lengthΦ]

/-- The congruence-side natural length matches the internal `ℕ∞` length. -/
theorem lengthψ_eq_moduleLength (api : FittingLengthAPI O Φ ψ) :
    (api.lengthψ : ℕ∞) =
      MathlibExpansion.Roots.AtiyahMacdonald.moduleLength (R := O) (M := ψ) := by
  rw [MathlibExpansion.Roots.AtiyahMacdonald.moduleLength_eq_coe_finiteLengthNat
    (R := O) (M := ψ) api.finiteLengthψ]
  simp [lengthψ]

end FittingLengthAPI

/-! ## 3. Typed Diamond bundle -/

/-- Typed bundle for Diamond's algebraic criterion. -/
structure AlgebraicCriterionData
    (Λ k O R T : Type u)
    [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
    [Algebra Λ O] [Algebra O R] [Algebra O T] where
  cotangentModule    : Type u
  [cotAddGroup       : AddCommGroup cotangentModule]
  [cotModule         : Module O cotangentModule]
  congruenceModule   : Type u
  [congAddGroup      : AddCommGroup congruenceModule]
  [congModule        : Module O congruenceModule]
  comparison         : ComparisonMap O R T
  projection         : HeckeProjection T O
  [nontrivialTarget  : Nontrivial T]
  [localRingSource   : IsLocalRing R]
  [noetherianSource  : IsNoetherianRing R]
  cotangentLinearEquiv :
    cotangentModule ≃ₗ[O] (RingHom.ker comparison.toAlgHom.toRingHom).Cotangent
  congruenceSubsingleton : Subsingleton congruenceModule
  api                : FittingLengthAPI O cotangentModule congruenceModule

attribute [instance]
  AlgebraicCriterionData.cotAddGroup
  AlgebraicCriterionData.cotModule
  AlgebraicCriterionData.congAddGroup
  AlgebraicCriterionData.congModule

variable {Λ k O R T : Type u}
variable [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
variable [Algebra Λ O] [Algebra O R] [Algebra O T]

/-- Kernel ideal of the typed comparison map. -/
def AlgebraicCriterionData.comparisonKernel
    (D : AlgebraicCriterionData Λ k O R T) : Ideal R :=
  RingHom.ker D.comparison.toAlgHom.toRingHom

/-! ## 4. Minimal upstream bridge -/

/-- Kernel-facing comparison data extracted from the typed Diamond bundle. -/
structure CotangentComparisonData
    (D : AlgebraicCriterionData Λ k O R T) : Type (u + 1) where
  instNontrivialTarget : Nontrivial T
  instLocalRingSource  : IsLocalRing R
  instNoetherianSource : IsNoetherianRing R
  cotangentLinearEquiv :
    D.cotangentModule ≃ₗ[O] D.comparisonKernel.Cotangent
  congruenceSubsingleton : Subsingleton D.congruenceModule

/-- Repackage the caller-supplied kernel comparison data into the bridge shape
consumed by the injectivity proof. -/
def cotangentComparisonBridge
    (D : AlgebraicCriterionData Λ k O R T) :
    CotangentComparisonData D := by
  letI := D.nontrivialTarget
  letI := D.localRingSource
  letI := D.noetherianSource
  exact
    { instNontrivialTarget := inferInstance
      instLocalRingSource := inferInstance
      instNoetherianSource := inferInstance
      cotangentLinearEquiv := D.cotangentLinearEquiv
      congruenceSubsingleton := D.congruenceSubsingleton }

/-! ## 5. Definition-land numerics constructor -/

/-- Package finite-length hypotheses into the Diamond-scoped numerics API. -/
def fittingLengthAPI_ofFiniteLength
    {O : Type u} [CommRing O]
    {Φ : Type u} [AddCommGroup Φ] [Module O Φ]
    {ψ : Type u} [AddCommGroup ψ] [Module O ψ]
    (hΦ : IsFiniteLength O Φ) (hψ : IsFiniteLength O ψ) :
    FittingLengthAPI O Φ ψ :=
  ⟨hΦ, hψ⟩

end MathlibExpansion.Roots.Diamond1996
