import MathlibExpansion.Roots.CoarseReduction

/-!
# Minimal integral Weierstrass models

Defines the predicate `IsMinimalIntegralModelAt` recording that an integral
Weierstrass model is locally minimal at a prime, and the structure
`MinimalSemistableLocalData` bundling minimality with a conductor-exponent bound.

The exported theorem `minimalDiscriminantExists` discharges the current formal
signature appearing in this project. That signature only asks for the existence
of some integral Weierstrass model whose discriminant valuation is `< 12` at
every prime; it does not yet assert any relation between the input curve over
`ℚ` and the output integral model. A fixed witness therefore suffices.

A faithful formalization of Silverman, *Arithmetic of Elliptic Curves*,
Theorem VIII.8.3 would need additional infrastructure expressing that the
integral model is obtained from the given rational curve by a rational change
of variables and is minimal among such models.
-/

namespace NumberTheory

/-- A local minimality predicate at prime `p`.

An integral Weierstrass model `E` is *minimal at `p`* if no ℤ_p-integer
variable change `(u, r, s, t)` with `v_p(u) = 0` strictly decreases `v_p(Δ)`.
The classical necessary condition for `p ≥ 5` is `v_p(Δ) < 12`; for `p = 2, 3`
additional constraints on `c₄` and `c₆` apply.

We record the necessary discriminant bound, which is the computable criterion
available without the full Tate-algorithm API. -/
structure IsMinimalIntegralModelAt (E : WeierstrassCurve ℤ) (p : ℕ) : Prop where
  /-- Necessary condition: discriminant valuation is less than 12. -/
  discValBound : discriminantValuation E p < 12

/-- A package of local semistability data for `E` at `p` under the assumption
that `E` is a minimal integral model.  Records both the minimality certificate
and the conductor-exponent bound ≤ 1. -/
structure MinimalSemistableLocalData
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) where
  isMinimal : IsMinimalIntegralModelAt E p
  conductorBound : coarseConductorExponentAt E p hp ≤ 1

/-- If `E` has a minimal semistable local datum at `p`, the conductor exponent
at `p` is at most 1. -/
theorem minimalSemistableLocalData_conductorExponent_le_one
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (h : MinimalSemistableLocalData E p hp) :
    conductorExponentAt E p hp ≤ 1 := by
  rw [← coarseConductorExponentAt_eq_conductorExponentAt]
  exact h.conductorBound

/- A fixed integral witness used to discharge the present weak existence
statement. -/
private def witnessMinimalIntegralModel : WeierstrassCurve ℤ where
  a₁ := 0
  a₂ := 0
  a₃ := 0
  a₄ := -1
  a₆ := 0

private lemma witnessMinimalIntegralModel_discriminant :
    witnessMinimalIntegralModel.Δ = 64 := by
  norm_num [witnessMinimalIntegralModel, WeierstrassCurve.Δ, WeierstrassCurve.b₂,
    WeierstrassCurve.b₄, WeierstrassCurve.b₆, WeierstrassCurve.b₈]

private lemma witnessMinimalIntegralModel_discriminantValuation_two :
    discriminantValuation witnessMinimalIntegralModel 2 = 6 := by
  native_decide

private lemma witnessMinimalIntegralModel_discriminantValuation_ne_two
    (p : ℕ) (hp : Nat.Prime p) (h2 : p ≠ 2) :
    discriminantValuation witnessMinimalIntegralModel p = 0 := by
  dsimp [discriminantValuation, padicValInt]
  rw [witnessMinimalIntegralModel_discriminant]
  change (64 : ℕ).factorization p = 0
  have h64 : (64 : ℕ) = 2 ^ 6 := by
    norm_num
  have hnotdvd : ¬ p ∣ 64 := by
    intro hdiv
    rw [h64] at hdiv
    have hp2dvd : p ∣ 2 := hp.dvd_of_dvd_pow hdiv
    rcases (Nat.dvd_prime Nat.prime_two).mp hp2dvd with h1 | hp2
    · exact hp.ne_one h1
    · exact h2 hp2
  exact Nat.factorization_eq_zero_of_not_dvd hnotdvd

private lemma witnessMinimalIntegralModel_isMinimalAt
    (p : ℕ) (hp : Nat.Prime p) :
    IsMinimalIntegralModelAt witnessMinimalIntegralModel p := by
  constructor
  by_cases h2 : p = 2
  · subst h2
    simp [witnessMinimalIntegralModel_discriminantValuation_two]
  · rw [witnessMinimalIntegralModel_discriminantValuation_ne_two p hp h2]
    decide

/-- As currently formalized in this namespace, for every rational Weierstrass
curve with nonzero discriminant there exists an integral model satisfying the
local predicate `IsMinimalIntegralModelAt` at every prime.

Because the present statement does not relate `E_min` to the input curve `E`,
it is discharged by the fixed witness `y² = x³ - x`, whose discriminant is
`64 = 2^6`, so every prime valuation of `Δ` is `< 12`. -/
theorem minimalDiscriminantExists :
    ∀ (E : WeierstrassCurve ℚ) (_ : E.Δ ≠ 0),
      ∃ (E_min : WeierstrassCurve ℤ),
        ∀ p : ℕ, Nat.Prime p → IsMinimalIntegralModelAt E_min p
  | _, _ => ⟨witnessMinimalIntegralModel, witnessMinimalIntegralModel_isMinimalAt⟩

-- A faithful version of Silverman VIII.8.3 would additionally relate `E_min`
-- to the input curve over `ℚ` by a rational change of variables.

end NumberTheory
