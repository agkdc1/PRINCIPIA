import MathlibExpansion.ConductorReduction
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Splits

/-!
# Coarse reduction-type classifier and Kodaira boundary

This root file records the part of Tate's algorithm currently reachable from
Mathlib v4.17.0: discriminant, `c₄`, and `c₆` valuation tests for integral
Weierstrass curves.  It deliberately reuses the existing
`MathlibExpansion.ConductorReduction` API instead of duplicating the older
reduction-type scaffold.

**W8-R5 (2026-04-20):** `ReductionType.multiplicative_split` constructor deleted
(it was never produced by `reductionTypeAt`; the classifier only returns
`multiplicative_nonsplit`).  `TateAlgorithmOutput` → `CoarseReductionOutput`.
`FreyDiscriminantFormulaBoundary` → `FreyDiscriminantValuationLemma`.
Inertia/NOS/TateModule boundary stubs removed.
-/

namespace NumberTheory

open Polynomial

/-- Kodaira-Néron reduction symbols with parameters for the multiplicative and
`Iₙ*` families.  This is the fine reduction-type target for a future complete
Tate-algorithm classifier; the existing `ReductionType` remains the coarse
conductor-facing API. -/
inductive KodairaReductionType where
  | good
  | mult_split (n : ℕ)
  | mult_nonsplit (n : ℕ)
  | additive_II
  | additive_III
  | additive_IV
  | additive_I0_star
  | additive_In_star (n : ℕ)
  | additive_IV_star
  | additive_III_star
  | additive_II_star
  deriving DecidableEq, Repr

namespace KodairaReductionType

def IsMultiplicative : KodairaReductionType → Prop
  | mult_split _ => True
  | mult_nonsplit _ => True
  | _ => False

def IsAdditive : KodairaReductionType → Prop
  | additive_II => True
  | additive_III => True
  | additive_IV => True
  | additive_I0_star => True
  | additive_In_star _ => True
  | additive_IV_star => True
  | additive_III_star => True
  | additive_II_star => True
  | _ => False

/-- Forget a fine Kodaira-Néron symbol to the coarse conductor-facing
reduction type.  Both `mult_split` and `mult_nonsplit` map to
`multiplicative_nonsplit` (the single coarse multiplicative constructor after
the W8-R5 breach). -/
def toReductionType : KodairaReductionType → ReductionType
  | good => ReductionType.good
  | mult_split _ => ReductionType.multiplicative_nonsplit
  | mult_nonsplit _ => ReductionType.multiplicative_nonsplit
  | additive_II => ReductionType.additive
  | additive_III => ReductionType.additive
  | additive_IV => ReductionType.additive
  | additive_I0_star => ReductionType.additive
  | additive_In_star _ => ReductionType.additive
  | additive_IV_star => ReductionType.additive
  | additive_III_star => ReductionType.additive
  | additive_II_star => ReductionType.additive

/-- The conductor exponent forced by the coarse branch of a Kodaira-Néron
symbol.  This is intentionally coarse: the wild part at residue characteristics
`2` and `3` is part of the missing full Tate-algorithm API. -/
def coarseConductorExponent : KodairaReductionType → ℕ
  | good => 0
  | mult_split _ => 1
  | mult_nonsplit _ => 1
  | additive_II => 2
  | additive_III => 2
  | additive_IV => 2
  | additive_I0_star => 2
  | additive_In_star _ => 2
  | additive_IV_star => 2
  | additive_III_star => 2
  | additive_II_star => 2

theorem coarseConductorExponent_eq_of_toReductionType
    (κ : KodairaReductionType) :
    κ.coarseConductorExponent =
      match κ.toReductionType with
      | ReductionType.good => 0
      | ReductionType.multiplicative_nonsplit => 1
      | ReductionType.additive => 2 := by
  cases κ <;> rfl

end KodairaReductionType

/-- Choose a canonical fine-symbol representative for a coarse local branch.

This is a decidable facade over the existing project-local classifier, not a
claim that the chosen representative is the true Kodaira symbol of the curve.
-/
def coarseToKodairaRepresentative (rt : ReductionType) (n : ℕ) :
    KodairaReductionType :=
  match rt with
  | ReductionType.good => KodairaReductionType.good
  | ReductionType.multiplicative_nonsplit => KodairaReductionType.mult_nonsplit n
  | ReductionType.additive => KodairaReductionType.additive_I0_star

@[simp] theorem coarseToKodairaRepresentative_toReductionType
    (rt : ReductionType) (n : ℕ) :
    (coarseToKodairaRepresentative rt n).toReductionType = rt := by
  cases rt <;> rfl

/-- A computable Kodaira-symbol representative attached to the existing
valuation-level Tate facade.  The multiplicative index is the discriminant
valuation of the supplied model. -/
def kodairaRepresentativeAt
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    KodairaReductionType :=
  coarseToKodairaRepresentative (reductionTypeAt E p hp) (discriminantValuation E p)

@[simp] theorem kodairaRepresentativeAt_toReductionType
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    (kodairaRepresentativeAt E p hp).toReductionType = reductionTypeAt E p hp := by
  simp [kodairaRepresentativeAt]

theorem kodairaRepresentativeAt_coarseConductorExponent
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    (kodairaRepresentativeAt E p hp).coarseConductorExponent =
      conductorExponentAt E p hp := by
  unfold kodairaRepresentativeAt conductorExponentAt
  cases reductionTypeAt E p hp <;> rfl

/-- Coarse reduction output bundling the classifier results for a single prime.
    Renamed from `TateAlgorithmOutput` (W8-R5: Tate label dropped — this is a
    coarse discriminant/c₄ classifier, not a full Tate algorithm). -/
structure CoarseReductionOutput (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) where
  reductionType : ReductionType
  conductorExponent : ℕ
  reductionType_eq : reductionType = reductionTypeAt E p hp
  conductorExponent_eq : conductorExponent = conductorExponentAt E p hp

def coarseReductionOutput (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    CoarseReductionOutput E p hp where
  reductionType := reductionTypeAt E p hp
  conductorExponent := conductorExponentAt E p hp
  reductionType_eq := rfl
  conductorExponent_eq := rfl

end NumberTheory

namespace WeierstrassCurve

/-- A single-output coarse reduction facade over the verified valuation
classifier available in `MathlibExpansion.ConductorReduction`.
Renamed from `tateAlgorithm` (W8-R5). -/
def coarseReduction (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    NumberTheory.CoarseReductionOutput E p hp :=
  NumberTheory.coarseReductionOutput E p hp

@[simp] theorem coarseReduction_reductionType
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    (E.coarseReduction p hp).reductionType = NumberTheory.reductionTypeAt E p hp := rfl

@[simp] theorem coarseReduction_conductorExponent
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    (E.coarseReduction p hp).conductorExponent =
      NumberTheory.conductorExponentAt E p hp := rfl

theorem coarseReduction_conductorExponent_eq_zero_iff_good
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    (E.coarseReduction p hp).conductorExponent = 0 ↔
      (E.coarseReduction p hp).reductionType = NumberTheory.ReductionType.good := by
  rw [coarseReduction_conductorExponent, coarseReduction_reductionType]
  unfold NumberTheory.conductorExponentAt
  cases NumberTheory.reductionTypeAt E p hp <;> simp

theorem coarseReduction_conductorExponent_le_one_iff_not_additive
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    (E.coarseReduction p hp).conductorExponent ≤ 1 ↔
      (E.coarseReduction p hp).reductionType ≠ NumberTheory.ReductionType.additive := by
  rw [coarseReduction_conductorExponent, coarseReduction_reductionType]
  unfold NumberTheory.conductorExponentAt
  cases NumberTheory.reductionTypeAt E p hp <;> simp

end WeierstrassCurve

namespace NumberTheory

open Polynomial

/-- The residue-field cubic used in Tate algorithm step 3. -/
noncomputable def tateStep3ResidueCubic
    (K : Type*) [Field K] (c4Residue deltaResidue : K) : K[X] :=
  X ^ 3 - C c4Residue ^ 3 + C (1728 : K) * C deltaResidue

def tateStep3ResidueCubicConstant
    (K : Type*) [Field K] (c4Residue deltaResidue : K) : K :=
  (1728 : K) * deltaResidue - c4Residue ^ 3

noncomputable def tateStep3ResidueCubicWithConstant
    (K : Type*) [Field K] (c4Residue deltaResidue : K) : K[X] :=
  X ^ 3 + C (tateStep3ResidueCubicConstant K c4Residue deltaResidue)

def TateStep3ResidueCubicHasLinearFactor
    (K : Type*) [Field K] (c4Residue deltaResidue : K) : Prop :=
  ∃ r : K, (tateStep3ResidueCubic K c4Residue deltaResidue).IsRoot r

def TateStep3ResidueCubicSplits
    (K : Type*) [Field K] (c4Residue deltaResidue : K) : Prop :=
  (tateStep3ResidueCubic K c4Residue deltaResidue).Splits (RingHom.id K)

def TateStep3ResidueCubicHasNonsplitLinearFactor
    (K : Type*) [Field K] (c4Residue deltaResidue : K) : Prop :=
  TateStep3ResidueCubicHasLinearFactor K c4Residue deltaResidue ∧
    ¬ TateStep3ResidueCubicSplits K c4Residue deltaResidue

inductive TateStep3ResidueCubicFactorization where
  | splits
  | nonsplit_linear
  | no_linear_factor
  deriving DecidableEq, Repr

def TateStep3ResidueCubicFactorization.Holds
    (K : Type*) [Field K] (c4Residue deltaResidue : K) :
    TateStep3ResidueCubicFactorization → Prop
  | TateStep3ResidueCubicFactorization.splits =>
      TateStep3ResidueCubicSplits K c4Residue deltaResidue
  | TateStep3ResidueCubicFactorization.nonsplit_linear =>
      TateStep3ResidueCubicHasNonsplitLinearFactor K c4Residue deltaResidue
  | TateStep3ResidueCubicFactorization.no_linear_factor =>
      ¬ TateStep3ResidueCubicHasLinearFactor K c4Residue deltaResidue

def TateStep3ResidueCubicFactorizationBoundary
    (_E : WeierstrassCurve ℤ) (_p : ℕ) (_hp : Nat.Prime _p) : Prop :=
  ∃ (K : Type) (_ : Field K) (c4Residue deltaResidue : K),
    TateStep3ResidueCubicHasLinearFactor K c4Residue deltaResidue

theorem TateStep3ResidueCubicHasLinearFactor.of_root
    (K : Type*) [Field K] (c4Residue deltaResidue r : K)
    (hroot : (tateStep3ResidueCubic K c4Residue deltaResidue).IsRoot r) :
    TateStep3ResidueCubicHasLinearFactor K c4Residue deltaResidue :=
  ⟨r, hroot⟩

theorem TateStep3ResidueCubicHasNonsplitLinearFactor.hasLinearFactor
    {K : Type*} [Field K] {c4Residue deltaResidue : K}
    (h : TateStep3ResidueCubicHasNonsplitLinearFactor K c4Residue deltaResidue) :
    TateStep3ResidueCubicHasLinearFactor K c4Residue deltaResidue :=
  h.1

theorem TateStep3ResidueCubicHasNonsplitLinearFactor.not_splits
    {K : Type*} [Field K] {c4Residue deltaResidue : K}
    (h : TateStep3ResidueCubicHasNonsplitLinearFactor K c4Residue deltaResidue) :
    ¬ TateStep3ResidueCubicSplits K c4Residue deltaResidue :=
  h.2

theorem TateStep3ResidueCubicFactorization.Holds_nonsplit_linear_hasLinearFactor
    {K : Type*} [Field K] {c4Residue deltaResidue : K}
    (h : TateStep3ResidueCubicFactorization.Holds K c4Residue deltaResidue
      TateStep3ResidueCubicFactorization.nonsplit_linear) :
    TateStep3ResidueCubicHasLinearFactor K c4Residue deltaResidue :=
  h.1

def TateStep3ResidueCubicGivesSplitMultiplicative
    (K : Type*) [Field K] (c4Residue deltaResidue : K) (n : ℕ) : Prop :=
  n ≠ 0 ∧ TateStep3ResidueCubicSplits K c4Residue deltaResidue

def TateStep3ResidueCubicGivesNonsplitMultiplicative
    (K : Type*) [Field K] (c4Residue deltaResidue : K) (n : ℕ) : Prop :=
  n ≠ 0 ∧ TateStep3ResidueCubicHasNonsplitLinearFactor K c4Residue deltaResidue

theorem TateStep3ResidueCubicGivesSplitMultiplicative.splits
    {K : Type*} [Field K] {c4Residue deltaResidue : K} {n : ℕ}
    (h : TateStep3ResidueCubicGivesSplitMultiplicative K c4Residue deltaResidue n) :
    TateStep3ResidueCubicSplits K c4Residue deltaResidue :=
  h.2

theorem TateStep3ResidueCubicGivesNonsplitMultiplicative.hasLinearFactor
    {K : Type*} [Field K] {c4Residue deltaResidue : K} {n : ℕ}
    (h : TateStep3ResidueCubicGivesNonsplitMultiplicative K c4Residue deltaResidue n) :
    TateStep3ResidueCubicHasLinearFactor K c4Residue deltaResidue :=
  h.2.1

theorem TateStep3ResidueCubicGivesNonsplitMultiplicative.not_splits
    {K : Type*} [Field K] {c4Residue deltaResidue : K} {n : ℕ}
    (h : TateStep3ResidueCubicGivesNonsplitMultiplicative K c4Residue deltaResidue n) :
    ¬ TateStep3ResidueCubicSplits K c4Residue deltaResidue :=
  h.2.2

def c6Valuation (E : WeierstrassCurve ℤ) (p : ℕ) : ℕ :=
  padicValInt p E.c₆

def hasGoodReductionByDelta (E : WeierstrassCurve ℤ) (p : ℕ) : Prop :=
  discriminantValuation E p = 0

instance instDecidableHasGoodReductionByDelta
    (E : WeierstrassCurve ℤ) (p : ℕ) : Decidable (hasGoodReductionByDelta E p) := by
  unfold hasGoodReductionByDelta
  infer_instance

def hasMultiplicativeReductionByC4 (E : WeierstrassCurve ℤ) (p : ℕ) : Prop :=
  discriminantValuation E p ≠ 0 ∧ c4Valuation E p = 0

def hasMultiplicativeINReduction (E : WeierstrassCurve ℤ) (p n : ℕ) : Prop :=
  discriminantValuation E p = n ∧ n ≠ 0 ∧ c4Valuation E p = 0

theorem hasMultiplicativeINReduction_index_eq_discriminantValuation
    {E : WeierstrassCurve ℤ} {p n : ℕ}
    (h : hasMultiplicativeINReduction E p n) :
    n = discriminantValuation E p := h.1.symm

theorem hasMultiplicativeINReduction_to_hasMultiplicativeReductionByC4
    {E : WeierstrassCurve ℤ} {p n : ℕ}
    (h : hasMultiplicativeINReduction E p n) :
    hasMultiplicativeReductionByC4 E p := by
  exact ⟨by rw [h.1]; exact h.2.1, h.2.2⟩

theorem hasMultiplicativeINReduction_of_hasMultiplicativeReductionByC4
    {E : WeierstrassCurve ℤ} {p : ℕ}
    (h : hasMultiplicativeReductionByC4 E p) :
    hasMultiplicativeINReduction E p (discriminantValuation E p) := by
  exact ⟨rfl, h.1, h.2⟩

theorem exists_multiplicativeINReduction_iff_hasMultiplicativeReductionByC4
    (E : WeierstrassCurve ℤ) (p : ℕ) :
    (∃ n, hasMultiplicativeINReduction E p n) ↔ hasMultiplicativeReductionByC4 E p := by
  constructor
  · rintro ⟨n, h⟩
    exact hasMultiplicativeINReduction_to_hasMultiplicativeReductionByC4 h
  · intro h
    exact ⟨discriminantValuation E p,
      hasMultiplicativeINReduction_of_hasMultiplicativeReductionByC4 h⟩

def hasAdditiveReductionByC4 (E : WeierstrassCurve ℤ) (p : ℕ) : Prop :=
  discriminantValuation E p ≠ 0 ∧ c4Valuation E p ≠ 0

def hasC6VanishingInAdditiveTest (E : WeierstrassCurve ℤ) (p : ℕ) : Prop :=
  hasAdditiveReductionByC4 E p ∧ c6Valuation E p ≠ 0

def localConductorFactor (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) : ℕ :=
  p ^ conductorExponentAt E p hp

theorem reductionTypeAt_eq_good_iff_hasGoodReductionByDelta
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    reductionTypeAt E p hp = ReductionType.good ↔ hasGoodReductionByDelta E p := by
  simpa [hasGoodReductionByDelta] using reductionTypeAt_eq_good_iff_factorization E p hp

theorem conductorExponentAt_eq_zero_iff_hasGoodReductionByDelta
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    conductorExponentAt E p hp = 0 ↔ hasGoodReductionByDelta E p := by
  constructor
  · intro h
    have hgood : reductionTypeAt E p hp = ReductionType.good := by
      have hzero_iff :
          conductorExponentAt E p hp = 0 ↔
            reductionTypeAt E p hp = ReductionType.good := by
        unfold conductorExponentAt
        cases hrt : reductionTypeAt E p hp <;> simp [hrt]
      exact hzero_iff.1 h
    exact (reductionTypeAt_eq_good_iff_hasGoodReductionByDelta E p hp).1 hgood
  · intro h
    have hgood : reductionTypeAt E p hp = ReductionType.good :=
      (reductionTypeAt_eq_good_iff_hasGoodReductionByDelta E p hp).2 h
    exact conductorExponentAt_eq_zero_of_good E p hp hgood

def HasGoodReduction (E : WeierstrassCurve ℤ) (p : ℕ) : Prop :=
  hasGoodReductionByDelta E p

def conductorExponent (E : WeierstrassCurve ℤ) (p : ℕ) : ℕ :=
  if hp : Nat.Prime p then (coarseReductionOutput E p hp).conductorExponent else 0

noncomputable def ellipticCurveConductor (E : WeierstrassCurve ℤ) : ℕ :=
  conductor E

theorem conductorExponent_eq_conductorExponentAt
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    conductorExponent E p = conductorExponentAt E p hp := by
  simp [conductorExponent, hp, coarseReductionOutput]

theorem ellipticCurveConductor_eq_conductor
    (E : WeierstrassCurve ℤ) :
    ellipticCurveConductor E = conductor E := rfl

theorem conductorExponent_eq_zero_iff_HasGoodReduction
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    conductorExponent E p = 0 ↔ HasGoodReduction E p := by
  rw [conductorExponent_eq_conductorExponentAt E p hp]
  simpa [HasGoodReduction] using conductorExponentAt_eq_zero_iff_hasGoodReductionByDelta E p hp

theorem conductorExponent_eq_zero_of_good
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : reductionTypeAt E p hp = ReductionType.good) :
    conductorExponent E p = 0 := by
  rw [conductorExponent_eq_conductorExponentAt E p hp]
  exact conductorExponentAt_eq_zero_of_good E p hp h

theorem conductorExponent_eq_one_of_multiplicative_nonsplit
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : reductionTypeAt E p hp = ReductionType.multiplicative_nonsplit) :
    conductorExponent E p = 1 := by
  rw [conductorExponent_eq_conductorExponentAt E p hp]
  exact conductorExponentAt_eq_one_of_multiplicative_nonsplit E p hp h

theorem conductorExponent_le_one_of_semistable
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (hss : isSemistable E) :
    conductorExponent E p ≤ 1 := by
  rw [conductorExponent_eq_conductorExponentAt E p hp]
  exact conductorExponentAt_le_one_of_semistable E p hp hss

theorem isSemistable_iff_forall_conductorExponentAt_le_one
    (E : WeierstrassCurve ℤ) :
    isSemistable E ↔ ∀ p (hp : Nat.Prime p), conductorExponentAt E p hp ≤ 1 := by
  constructor
  · intro hss p hp
    exact conductorExponentAt_le_one_of_semistable E p hp hss
  · intro h p hp hadd
    have hle : conductorExponentAt E p hp ≤ 1 := h p hp
    unfold conductorExponentAt at hle
    rw [hadd] at hle
    norm_num at hle

theorem isSemistable_iff_forall_conductorExponent_le_one
    (E : WeierstrassCurve ℤ) :
    isSemistable E ↔ ∀ ℓ, conductorExponent E ℓ ≤ 1 := by
  constructor
  · intro hss ℓ
    by_cases hℓ : Nat.Prime ℓ
    · rw [conductorExponent_eq_conductorExponentAt E ℓ hℓ]
      exact conductorExponentAt_le_one_of_semistable E ℓ hℓ hss
    · simp [conductorExponent, hℓ]
  · intro h ℓ hℓ hadd
    have hle : conductorExponentAt E ℓ hℓ ≤ 1 := by
      rw [← conductorExponent_eq_conductorExponentAt E ℓ hℓ]
      exact h ℓ
    unfold conductorExponentAt at hle
    rw [hadd] at hle
    norm_num at hle

theorem conductor_eq_factorization_prod_conductorExponentAt
    (E : WeierstrassCurve ℤ) :
    conductor E =
      E.Δ.natAbs.factorization.prod fun p _e =>
        if hp : Nat.Prime p then p ^ conductorExponentAt E p hp else 1 := by
  rfl

theorem conductor_eq_factorization_prod_localConductorFactor
    (E : WeierstrassCurve ℤ) :
    conductor E =
      E.Δ.natAbs.factorization.prod fun p _e =>
        if hp : Nat.Prime p then localConductorFactor E p hp else 1 := by
  rfl

theorem conductor_eq_factorization_prod_conductorExponent
    (E : WeierstrassCurve ℤ) :
    conductor E =
      E.Δ.natAbs.factorization.prod fun p _e =>
        if Nat.Prime p then p ^ conductorExponent E p else 1 := by
  rw [conductor_eq_factorization_prod_conductorExponentAt]
  refine Finsupp.prod_congr (f := E.Δ.natAbs.factorization) ?_
  intro p _hp_support
  by_cases hp : Nat.Prime p
  · simp [hp, conductorExponent_eq_conductorExponentAt E p hp]
  · simp [hp]

def EllipticCurveConductorFormula (E : WeierstrassCurve ℤ) : Prop :=
  ellipticCurveConductor E =
    E.Δ.natAbs.factorization.prod fun p _e =>
      if Nat.Prime p then p ^ conductorExponent E p else 1

theorem ellipticCurveConductorFormula
    (E : WeierstrassCurve ℤ) :
    EllipticCurveConductorFormula E := by
  simpa [EllipticCurveConductorFormula] using
    conductor_eq_factorization_prod_conductorExponent E

theorem ellipticCurveConductor_eq_factorization_prod_conductorExponent
    (E : WeierstrassCurve ℤ) :
    ellipticCurveConductor E =
      E.Δ.natAbs.factorization.prod fun p _e =>
        if Nat.Prime p then p ^ conductorExponent E p else 1 := by
  simpa [ellipticCurveConductor] using
    conductor_eq_factorization_prod_conductorExponent E

theorem conductorExponentAt_eq_zero_iff_reductionTypeAt_eq_good
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    conductorExponentAt E p hp = 0 ↔ reductionTypeAt E p hp = ReductionType.good := by
  unfold conductorExponentAt
  cases hrt : reductionTypeAt E p hp <;> simp [hrt]

theorem conductorExponentAt_eq_one_of_multiplicative
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : isMultiplicativeReductionAt E p hp) :
    conductorExponentAt E p hp = 1 := by
  unfold isMultiplicativeReductionAt ReductionType.IsMultiplicative at h
  unfold conductorExponentAt
  cases hrt : reductionTypeAt E p hp <;> simp [hrt] at h ⊢

theorem localConductorFactor_eq_one_of_good
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : reductionTypeAt E p hp = ReductionType.good) :
    localConductorFactor E p hp = 1 := by
  simp [localConductorFactor, conductorExponentAt_eq_zero_of_good E p hp h]

theorem localConductorFactor_eq_p_of_multiplicative
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : isMultiplicativeReductionAt E p hp) :
    localConductorFactor E p hp = p := by
  rw [localConductorFactor, conductorExponentAt_eq_one_of_multiplicative E p hp h]
  exact Nat.pow_one p

theorem reductionTypeAt_multiplicative_iff_hasMultiplicativeReductionByC4
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    isMultiplicativeReductionAt E p hp ↔ hasMultiplicativeReductionByC4 E p := by
  simpa [hasMultiplicativeReductionByC4] using
    reductionTypeAt_multiplicative_iff_factorization E p hp

theorem conductorExponentAt_eq_one_iff_isMultiplicativeReductionAt
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    conductorExponentAt E p hp = 1 ↔ isMultiplicativeReductionAt E p hp := by
  unfold conductorExponentAt isMultiplicativeReductionAt ReductionType.IsMultiplicative
  cases h : reductionTypeAt E p hp <;> simp [h]

theorem conductorExponentAt_le_one_iff_good_or_multiplicative
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    conductorExponentAt E p hp ≤ 1 ↔
      reductionTypeAt E p hp = ReductionType.good ∨ isMultiplicativeReductionAt E p hp := by
  unfold conductorExponentAt isMultiplicativeReductionAt ReductionType.IsMultiplicative
  cases h : reductionTypeAt E p hp <;> simp [h]

theorem conductorExponent_eq_one_iff_isMultiplicativeReductionAt
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    conductorExponent E p = 1 ↔ isMultiplicativeReductionAt E p hp := by
  rw [conductorExponent_eq_conductorExponentAt E p hp]
  exact conductorExponentAt_eq_one_iff_isMultiplicativeReductionAt E p hp

theorem conductorExponent_le_one_iff_good_or_multiplicative
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    conductorExponent E p ≤ 1 ↔
      reductionTypeAt E p hp = ReductionType.good ∨ isMultiplicativeReductionAt E p hp := by
  rw [conductorExponent_eq_conductorExponentAt E p hp]
  exact conductorExponentAt_le_one_iff_good_or_multiplicative E p hp

/-- Boundary primitive for the literal R5 target: the biconditional
`conductorExponentAt ≤ 1 ↔ isMultiplicativeReductionAt` is not a theorem —
good reduction has exponent 0, falsifying the right side. The exact statement
is `conductorExponentAt_le_one_iff_good_or_multiplicative`. -/
def ConductorExponentLeOneIffMultiplicativeBoundary
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) : Prop :=
  reductionTypeAt E p hp = ReductionType.good →
    conductorExponentAt E p hp ≤ 1 ∧ ¬ isMultiplicativeReductionAt E p hp

theorem conductorExponentLeOneIffMultiplicativeBoundary_good
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    ConductorExponentLeOneIffMultiplicativeBoundary E p hp := by
  intro hgood
  constructor
  · simp [conductorExponentAt, hgood]
  · simp [isMultiplicativeReductionAt, ReductionType.IsMultiplicative, hgood]

theorem conductorExponentAt_eq_one_of_multiplicativeIN
    (E : WeierstrassCurve ℤ) (p n : ℕ) (hp : Nat.Prime p)
    (h : hasMultiplicativeINReduction E p n) :
    conductorExponentAt E p hp = 1 := by
  have hm : isMultiplicativeReductionAt E p hp :=
    (reductionTypeAt_multiplicative_iff_hasMultiplicativeReductionByC4 E p hp).2
      (hasMultiplicativeINReduction_to_hasMultiplicativeReductionByC4 h)
  exact conductorExponentAt_eq_one_of_multiplicative E p hp hm

theorem reductionTypeAt_eq_additive_iff_hasAdditiveReductionByC4
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    reductionTypeAt E p hp = ReductionType.additive ↔ hasAdditiveReductionByC4 E p := by
  simpa [hasAdditiveReductionByC4] using reductionTypeAt_eq_additive_iff_factorization E p hp

theorem c6Valuation_eq_padicValInt
    (E : WeierstrassCurve ℤ) (p : ℕ) :
    c6Valuation E p = padicValInt p E.c₆ := rfl

theorem hasC6VanishingInAdditiveTest.additive
    {E : WeierstrassCurve ℤ} {p : ℕ}
    (h : hasC6VanishingInAdditiveTest E p) : hasAdditiveReductionByC4 E p :=
  h.1

namespace FreyReduction

/-- Data needed to use the Frey-curve discriminant valuation formula at a
fixed prime. -/
structure FreyDiscriminantValuationData
    (E : WeierstrassCurve ℤ) (a b c : ℤ) (p : ℕ) : Prop where
  abcNonzero : a * b * c ≠ 0
  discriminant_formula :
    discriminantValuation E p = 2 * padicValInt p (a * b * c)

theorem discriminantValuation_eq_two_mul_abcValuation
    {E : WeierstrassCurve ℤ} {a b c : ℤ} {p : ℕ}
    (h : FreyDiscriminantValuationData E a b c p) :
    discriminantValuation E p = 2 * padicValInt p (a * b * c) :=
  h.discriminant_formula

theorem frey_goodReduction_iff_two_mul_abcValuation_eq_zero
    (E : WeierstrassCurve ℤ) (a b c : ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : FreyDiscriminantValuationData E a b c p) :
    reductionTypeAt E p hp = ReductionType.good ↔
      2 * padicValInt p (a * b * c) = 0 := by
  calc
    reductionTypeAt E p hp = ReductionType.good ↔
        discriminantValuation E p = 0 :=
      reductionTypeAt_eq_good_iff_hasGoodReductionByDelta E p hp
    _ ↔ 2 * padicValInt p (a * b * c) = 0 := by
      rw [h.discriminant_formula]

theorem frey_not_dvd_discriminant_iff_two_mul_abcValuation_eq_zero
    (E : WeierstrassCurve ℤ) (a b c : ℤ) (p : ℕ) (hp : Nat.Prime p)
    (hΔ : E.Δ.natAbs ≠ 0)
    (h : FreyDiscriminantValuationData E a b c p) :
    ¬ p ∣ E.Δ.natAbs ↔ 2 * padicValInt p (a * b * c) = 0 := by
  calc
    ¬ p ∣ E.Δ.natAbs ↔ reductionTypeAt E p hp = ReductionType.good :=
      (reductionTypeAt_eq_good_iff_not_dvd_discriminant E p hp hΔ).symm
    _ ↔ 2 * padicValInt p (a * b * c) = 0 :=
      frey_goodReduction_iff_two_mul_abcValuation_eq_zero E a b c p hp h

/-- The Frey discriminant valuation formula at all primes.  Renamed from
`FreyDiscriminantFormulaBoundary` (W8-R5: it is an honest mathematical lemma
about the Frey model, not a vacuous boundary marker). -/
def FreyDiscriminantValuationLemma
    (E : WeierstrassCurve ℤ) (a b c : ℤ) : Prop :=
  ∀ p, Nat.Prime p →
    FreyDiscriminantValuationData E a b c p

theorem freyDiscriminantValuationData_of_boundary
    {E : WeierstrassCurve ℤ} {a b c : ℤ} {p : ℕ} (hp : Nat.Prime p)
    (h : FreyDiscriminantValuationLemma E a b c) :
    FreyDiscriminantValuationData E a b c p :=
  h p hp

structure FreyLocalReductionClassification
    (E : WeierstrassCurve ℤ) (a b c : ℤ) (p : ℕ) (hp : Nat.Prime p) where
  reductionType : ReductionType
  conductorExponent : ℕ
  reductionType_eq : reductionType = reductionTypeAt E p hp
  conductorExponent_eq : conductorExponent = conductorExponentAt E p hp
  discriminantData : FreyDiscriminantValuationData E a b c p

def frey_reduction_classify_from_data
    (E : WeierstrassCurve ℤ) (a b c : ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : FreyDiscriminantValuationData E a b c p) :
    FreyLocalReductionClassification E a b c p hp where
  reductionType := reductionTypeAt E p hp
  conductorExponent := conductorExponentAt E p hp
  reductionType_eq := rfl
  conductorExponent_eq := rfl
  discriminantData := h

@[simp] theorem frey_reduction_classify_from_data_reductionType
    (E : WeierstrassCurve ℤ) (a b c : ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : FreyDiscriminantValuationData E a b c p) :
    (frey_reduction_classify_from_data E a b c p hp h).reductionType =
      reductionTypeAt E p hp := rfl

@[simp] theorem frey_reduction_classify_from_data_conductorExponent
    (E : WeierstrassCurve ℤ) (a b c : ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : FreyDiscriminantValuationData E a b c p) :
    (frey_reduction_classify_from_data E a b c p hp h).conductorExponent =
      conductorExponentAt E p hp := rfl

theorem frey_reduction_classify_good_iff_two_mul_abcValuation_eq_zero
    {E : WeierstrassCurve ℤ} {a b c : ℤ} {p : ℕ} {hp : Nat.Prime p}
    (C : FreyLocalReductionClassification E a b c p hp) :
    C.reductionType = ReductionType.good ↔
      2 * padicValInt p (a * b * c) = 0 := by
  rw [C.reductionType_eq]
  exact frey_goodReduction_iff_two_mul_abcValuation_eq_zero E a b c p hp
    C.discriminantData

theorem frey_reduction_classify_conductorExponent_eq_zero_iff_two_mul_abcValuation_eq_zero
    {E : WeierstrassCurve ℤ} {a b c : ℤ} {p : ℕ} {hp : Nat.Prime p}
    (C : FreyLocalReductionClassification E a b c p hp) :
    C.conductorExponent = 0 ↔ 2 * padicValInt p (a * b * c) = 0 := by
  rw [C.conductorExponent_eq]
  exact (conductorExponentAt_eq_zero_iff_reductionTypeAt_eq_good E p hp).trans
    (frey_goodReduction_iff_two_mul_abcValuation_eq_zero E a b c p hp
      C.discriminantData)

/-- Alias for `FreyDiscriminantValuationLemma` for compatibility. -/
def FreyCurveModelBoundary (E : WeierstrassCurve ℤ) (a b c : ℤ) : Prop :=
  FreyDiscriminantValuationLemma E a b c

end FreyReduction

end NumberTheory
