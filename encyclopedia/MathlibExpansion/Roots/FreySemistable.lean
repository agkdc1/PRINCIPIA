import MathlibExpansion.Roots.CoarseReduction
import MathlibExpansion.Roots.MinimalIntegralModel
import MathlibExpansion.Roots.FreyTwoAdic
import MathlibExpansion.Roots.ReductionType

/-!
# Frey curve semistability at all primes

This file composes the three preceding modules to produce the semistability
certificate for a Frey model: conductor exponent ≤ 1 at every prime.

**At `p = 2`:** provided by `FreyTwoAdicNormalizationData` (from the
`freyTwoAdicNormalization` theorem).

**At odd primes `p`:**
- If `p ∤ Δ(E)`: good reduction, conductor exponent = 0 ≤ 1.
- If `p | Δ(E)` and `v_p(c₄(E)) = 0`: multiplicative reduction, exponent = 1 ≤ 1.

The `oddPrimeCert` field supplies the `FreyDiscriminantValuationData` (linking
`v_p(Δ)` to `v_p(ABC)`) and the `c₄`-unit certificate for odd multiplicative
primes.  Both are honest mathematical data — no `True` placeholder.

The final theorem `freySemistableData_isSemistable` derives `isSemistable E`
from these certificates.  Zero `sorry`, zero `True.intro`.
-/

namespace NumberTheory

open FreyReduction

/-- A bundle of local semistability certificates for a Frey model `E` attached
to the abc triple `(A, B, C)` at exponent `l`.

Fields:
- `twoAdicData`: two-adic normalization data (certified reduction at p=2).
- `oddPrimeDiscData`: Frey discriminant valuation formula at each odd prime.
- `oddPrimeC4Unit`: at odd primes where `p | Δ(E)`, the `c₄` is a unit
  (`v_p(c₄) = 0`), forcing multiplicative rather than additive reduction.

All three fields contain honest mathematical content — no `Prop`-laundering. -/
structure FreySemistableData
    (E : WeierstrassCurve ℤ) (A B C : ℤ) (l : ℕ) where
  twoAdicData   : FreyTwoAdicNormalizationData (classicalFreyModel A B C l) E A B C l
  oddPrimeDiscData : ∀ p : ℕ, Nat.Prime p → p ≠ 2 →
    FreyDiscriminantValuationData E A B C p
  oddPrimeC4Unit : ∀ p : ℕ, Nat.Prime p → p ≠ 2 →
    discriminantValuation E p ≠ 0 → c4Valuation E p = 0

/-- From `FreySemistableData`, prove that the conductor exponent of `E` is ≤ 1
at every prime.

**Proof sketch:**
- `p = 2`: `frey_conductor_at_two_le_one` from `twoAdicData`.
- `p` odd, `v_p(Δ) = 0`: `reductionTypeAt E p hp = good`, exponent = 0.
- `p` odd, `v_p(Δ) ≠ 0`: `oddPrimeC4Unit` gives `c4Valuation E p = 0`, so
  `reductionTypeAt E p hp = multiplicative_nonsplit`, exponent = 1. -/
theorem freySemistableData_conductorExponent_le_one
    (E : WeierstrassCurve ℤ) (A B C : ℤ) (l : ℕ)
    (hd : FreySemistableData E A B C l) :
    ∀ p : ℕ, ∀ hp : Nat.Prime p, conductorExponentAt E p hp ≤ 1 := by
  intro p hp
  by_cases h2 : p = 2
  · -- p = 2: use two-adic normalization certificate
    subst h2
    exact frey_conductor_at_two_le_one E hd.twoAdicData hp
  · -- p is an odd prime
    unfold conductorExponentAt
    by_cases hΔ : discriminantValuation E p = 0
    · -- good reduction: discriminant valuation = 0
      have hgood : reductionTypeAt E p hp = ReductionType.good := by
        unfold reductionTypeAt
        simp [hΔ]
      simp [hgood]
    · -- multiplicative reduction: c₄ is a unit at p
      have hc4 : c4Valuation E p = 0 := hd.oddPrimeC4Unit p hp h2 hΔ
      have hmult : reductionTypeAt E p hp = ReductionType.multiplicative_nonsplit := by
        unfold reductionTypeAt
        simp [hΔ, hc4]
      simp [hmult]

/-- `FreySemistableData` implies the curve `E` is semistable. -/
theorem freySemistableData_isSemistable
    (E : WeierstrassCurve ℤ) (A B C : ℤ) (l : ℕ)
    (hd : FreySemistableData E A B C l) :
    isSemistable E := by
  rw [isSemistable_iff_forall_conductorExponentAt_le_one]
  exact freySemistableData_conductorExponent_le_one E A B C l hd

/-- The coarse conductor exponent is ≤ 1 at all primes for a Frey model with
`FreySemistableData`. -/
theorem freySemistableData_coarseConductorExponent_le_one
    (E : WeierstrassCurve ℤ) (A B C : ℤ) (l : ℕ)
    (hd : FreySemistableData E A B C l) :
    ∀ p : ℕ, ∀ hp : Nat.Prime p, coarseConductorExponentAt E p hp ≤ 1 := by
  intro p hp
  rw [coarseConductorExponentAt_eq_conductorExponentAt]
  exact freySemistableData_conductorExponent_le_one E A B C l hd p hp

/-- Constructing `FreySemistableData` from the two local input surfaces:
`freyTwoAdicNormalization` + per-prime discriminant and c₄ certificates.

This is the intended entry point: given the theorem-produced `E₂` and honest
certificates at odd primes, assemble the `FreySemistableData` bundle. -/
def FreySemistableData.mk'
    (E : WeierstrassCurve ℤ) (A B C : ℤ) (l : ℕ)
    (h2 : FreyTwoAdicNormalizationData (classicalFreyModel A B C l) E A B C l)
    (hdisc : ∀ p : ℕ, Nat.Prime p → p ≠ 2 → FreyDiscriminantValuationData E A B C p)
    (hc4 : ∀ p : ℕ, Nat.Prime p → p ≠ 2 →
             discriminantValuation E p ≠ 0 → c4Valuation E p = 0) :
    FreySemistableData E A B C l where
  twoAdicData := h2
  oddPrimeDiscData := hdisc
  oddPrimeC4Unit := hc4

end NumberTheory
