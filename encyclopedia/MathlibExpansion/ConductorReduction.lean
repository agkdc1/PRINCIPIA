import Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Data.Nat.Squarefree

/-!
# Conductor and reduction type for integral Weierstrass curves

This file defines a first local reduction-type interface for integral
Weierstrass models using Mathlib's discriminant, `c₄`, and natural
factorization APIs.
-/

namespace NumberTheory

inductive ReductionType where
  | good
  | multiplicative_nonsplit
  | additive
  deriving DecidableEq, Repr

namespace ReductionType

def IsMultiplicative : ReductionType → Prop
  | multiplicative_nonsplit => True
  | _ => False

end ReductionType

def padicValInt (p : ℕ) (z : ℤ) : ℕ :=
  z.natAbs.factorization p

def discriminantValuation (E : WeierstrassCurve ℤ) (p : ℕ) : ℕ :=
  padicValInt p E.Δ

def c4Valuation (E : WeierstrassCurve ℤ) (p : ℕ) : ℕ :=
  padicValInt p E.c₄

def reductionTypeAt (E : WeierstrassCurve ℤ) (p : ℕ) (_hp : Nat.Prime p) : ReductionType :=
  if discriminantValuation E p = 0 then ReductionType.good
  else if c4Valuation E p = 0 then ReductionType.multiplicative_nonsplit
  else ReductionType.additive

def isMultiplicativeReductionAt (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) : Prop :=
  (reductionTypeAt E p hp).IsMultiplicative

def isSemistable (E : WeierstrassCurve ℤ) : Prop :=
  ∀ p (hp : Nat.Prime p), reductionTypeAt E p hp ≠ ReductionType.additive

def conductorExponentAt (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) : ℕ :=
  match reductionTypeAt E p hp with
  | ReductionType.good => 0
  | ReductionType.multiplicative_nonsplit => 1
  | ReductionType.additive => 2

noncomputable def conductor (E : WeierstrassCurve ℤ) : ℕ :=
  E.Δ.natAbs.factorization.prod fun p _e =>
    if hp : Nat.Prime p then p ^ conductorExponentAt E p hp else 1

theorem reductionTypeAt_eq_good_iff_factorization
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    reductionTypeAt E p hp = ReductionType.good ↔ discriminantValuation E p = 0 := by
  unfold reductionTypeAt
  by_cases hΔ : discriminantValuation E p = 0 <;>
  by_cases hc4 : c4Valuation E p = 0 <;> simp [hΔ, hc4]

theorem reductionTypeAt_eq_additive_iff_factorization
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    reductionTypeAt E p hp = ReductionType.additive ↔
      discriminantValuation E p ≠ 0 ∧ c4Valuation E p ≠ 0 := by
  unfold reductionTypeAt
  by_cases hΔ : discriminantValuation E p = 0 <;>
  by_cases hc4 : c4Valuation E p = 0 <;> simp [hΔ, hc4]

theorem reductionTypeAt_multiplicative_iff_factorization
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    isMultiplicativeReductionAt E p hp ↔
      discriminantValuation E p ≠ 0 ∧ c4Valuation E p = 0 := by
  unfold isMultiplicativeReductionAt reductionTypeAt ReductionType.IsMultiplicative
  by_cases hΔ : discriminantValuation E p = 0 <;>
  by_cases hc4 : c4Valuation E p = 0 <;> simp [hΔ, hc4]

theorem conductorExponentAt_eq_zero_of_good
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : reductionTypeAt E p hp = ReductionType.good) :
    conductorExponentAt E p hp = 0 := by
  simp [conductorExponentAt, h]

theorem conductorExponentAt_eq_one_of_multiplicative_nonsplit
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : reductionTypeAt E p hp = ReductionType.multiplicative_nonsplit) :
    conductorExponentAt E p hp = 1 := by
  simp [conductorExponentAt, h]

theorem prime_dvd_discriminant_natAbs_iff_valuation_ne_zero
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (hΔ : E.Δ.natAbs ≠ 0) :
    p ∣ E.Δ.natAbs ↔ discriminantValuation E p ≠ 0 := by
  rw [discriminantValuation, padicValInt]
  constructor
  · intro h
    have hle : 1 ≤ E.Δ.natAbs.factorization p :=
      (hp.dvd_iff_one_le_factorization hΔ).1 h
    exact Nat.ne_of_gt hle
  · intro h
    have hle : 1 ≤ E.Δ.natAbs.factorization p := Nat.succ_le_iff.mpr (Nat.pos_of_ne_zero h)
    exact (hp.dvd_iff_one_le_factorization hΔ).2 hle

theorem reductionTypeAt_eq_good_iff_not_dvd_discriminant
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (hΔ : E.Δ.natAbs ≠ 0) :
    reductionTypeAt E p hp = ReductionType.good ↔ ¬ p ∣ E.Δ.natAbs := by
  rw [reductionTypeAt_eq_good_iff_factorization,
    prime_dvd_discriminant_natAbs_iff_valuation_ne_zero E p hp hΔ]
  exact ⟨fun h h' => h' h, fun h => Classical.not_not.mp (mt (fun h' => h') h)⟩

theorem conductorExponentAt_le_one_of_semistable
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (hss : isSemistable E) :
    conductorExponentAt E p hp ≤ 1 := by
  unfold conductorExponentAt
  have hne : reductionTypeAt E p hp ≠ ReductionType.additive := hss p hp
  cases hrt : reductionTypeAt E p hp <;> simp [hrt] at hne ⊢

theorem discriminant_natAbs_squarefree_of_prime_valuations_le_one
    (E : WeierstrassCurve ℤ) (hΔ : E.Δ.natAbs ≠ 0)
    (hval : ∀ p, Nat.Prime p → discriminantValuation E p ≤ 1) :
    Squarefree E.Δ.natAbs := by
  rw [Nat.squarefree_iff_factorization_le_one hΔ]
  intro p
  by_cases hp : Nat.Prime p
  · exact hval p hp
  · simp [discriminantValuation, padicValInt, Nat.factorization_eq_zero_of_non_prime _ hp]

theorem discriminant_natAbs_squarefree_of_semistable_and_simple_multiplicative
    (E : WeierstrassCurve ℤ) (hΔ : E.Δ.natAbs ≠ 0)
    (hss : isSemistable E)
    (hmul : ∀ p (hp : Nat.Prime p), isMultiplicativeReductionAt E p hp →
      discriminantValuation E p = 1) :
    Squarefree E.Δ.natAbs := by
  exact discriminant_natAbs_squarefree_of_prime_valuations_le_one E hΔ fun p hp => by
    by_cases hzero : discriminantValuation E p = 0
    · simp [hzero]
    · have hc4 : c4Valuation E p = 0 := by
        by_contra hc4
        have hadd : reductionTypeAt E p hp = ReductionType.additive :=
          (reductionTypeAt_eq_additive_iff_factorization E p hp).2 ⟨hzero, hc4⟩
        exact hss p hp hadd
      have hmult : isMultiplicativeReductionAt E p hp :=
        (reductionTypeAt_multiplicative_iff_factorization E p hp).2 ⟨hzero, hc4⟩
      rw [hmul p hp hmult]

end NumberTheory
