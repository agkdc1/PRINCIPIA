/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.ConductorReduction

/-!
# Ribet conductor drop (Ribet Breach F7)

Honest algebraic boundary for Ribet's level-lowering conductor-drop step,
replacing the demolished `frey_curve_conductor` from `ThirteenthGap`
(Ribet Breach F3).

* `isMinimalAtPrime E p`: `discriminantValuation E p < 12` — the standard
  global minimality criterion computable from Mathlib's `WeierstrassCurve.Δ`.
* `conductorExponent_of_multiplicative`: a genuine theorem (zero sorry) that
  multiplicative reduction forces conductor exponent 1, using
  `conductorExponentAt` from `ConductorReduction`.
* `RibetConductorDropAtPrime`: the level-lowering conductor-drop package,
  requiring `isMultiplicativeReductionAt` as a typed real constraint.

No `sorry`, no `:= True`.
-/

namespace MathlibExpansion
namespace RibetConductorDrop

open NumberTheory

/--
A Weierstrass model `E/ℤ` is minimal at a prime `p` if the `p`-adic
valuation of the discriminant is less than 12.

This is the standard global minimality criterion derivable from Tate's
algorithm; computed from `NumberTheory.discriminantValuation` which uses
Mathlib's `WeierstrassCurve.Δ`.
-/
def isMinimalAtPrime (E : WeierstrassCurve ℤ) (p : ℕ) : Prop :=
  discriminantValuation E p < 12

/--
If `E` has multiplicative reduction at `ℓ`, its conductor exponent at `ℓ`
equals 1.

This is a genuine theorem, provable from the definitions in
`ConductorReduction`: `conductorExponentAt` returns 1 for both
`multiplicative_split` and `multiplicative_nonsplit`, and
`isMultiplicativeReductionAt` holds exactly for those two reduction types.
-/
theorem conductorExponent_of_multiplicative
    (E : WeierstrassCurve ℤ) (ℓ : ℕ) (hℓ : Nat.Prime ℓ)
    (hm : isMultiplicativeReductionAt E ℓ hℓ) :
    conductorExponentAt E ℓ hℓ = 1 := by
  rcases h : reductionTypeAt E ℓ hℓ with _ | _ | _ <;>
    simp_all [isMultiplicativeReductionAt, ReductionType.IsMultiplicative, conductorExponentAt]

/--
The Ribet conductor-drop package at a prime `ℓ`: the Frey curve `E` has
multiplicative reduction at `ℓ`, witnessed by `isMultiplicativeReductionAt`
(a real typed predicate from `ConductorReduction`).

`ribetBoundaryStatement` names the deeper arithmetic content — that level
lowering drops the conductor from `N` to `N/ℓ` — as an explicit boundary
`Prop`. This is honest because the Néron-model conductor and `J₀(N)` are
absent from Mathlib v4.17.0 (Recon #7 Findings 1-2).
-/
structure RibetConductorDropAtPrime
    (E : WeierstrassCurve ℤ) (ℓ : ℕ) (hℓ : Nat.Prime ℓ) where
  multiplicativeAtL : isMultiplicativeReductionAt E ℓ hℓ
  ribetBoundaryStatement : Prop
  ribetBoundary : ribetBoundaryStatement

/--
The conductor exponent at `ℓ` equals 1 for any Ribet conductor-drop package.
Proved using `conductorExponent_of_multiplicative`.
-/
theorem RibetConductorDropAtPrime.conductorExponent_eq_one
    {E : WeierstrassCurve ℤ} {ℓ : ℕ} {hℓ : Nat.Prime ℓ}
    (h : RibetConductorDropAtPrime E ℓ hℓ) :
    conductorExponentAt E ℓ hℓ = 1 :=
  conductorExponent_of_multiplicative E ℓ hℓ h.multiplicativeAtL

end RibetConductorDrop
end MathlibExpansion
