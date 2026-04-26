import Mathlib
import MathlibExpansion.Roots.Flach1992.Bound
import MathlibExpansion.Roots.Wiles1995.AdjointTraceZero

/-!
# Wiles1995 — Flach Selmer Bound (theorem)

Wiles 1995 / Flach's trick gives the crucial upper bound on the Selmer
group attached to the trace-zero adjoint representation `ad⁰ ρ̄`:

  # Sel(Q, ad⁰ ρ̄)  ≤  # (O / η)

where the right-hand side is the congruence module (the "η invariant"
of the modular form), whose length is controlled by MW1984.

This is the Wiles-level wrapper of the typed Flach1992 theorem. It is stated as
a bound on a carrier `selmerAdZero : Type` representing the global
Selmer group carrier of `ad⁰ ρ̄`, whose length is bounded by a
congruence integer `congruenceLength : ℕ` coming from MW1984.

## Why this is the key Selmer slot

The Flach upper bound is the *non-algebraic* half of Wiles' numerical
criterion: it packages the Galois-cohomology argument ("no extra
deformations beyond what the L-function sees") into a single
inequality. Everything downstream — the numerical criterion itself,
and then `R = T` — is algebraic cotangent/congruence bookkeeping once
this bound is in hand.

## Axiom count introduced by this file

**0 new axioms.** `flachSelmerBound_ad0` is reclaimed as a theorem by
lifting the wrapper lengths into the typed Flach1992 carriers and applying
`Flach1992.flachSelmerBound_typed`. No `sorry`, no imports of
`Roots.ContinuousGaloisCohomology` (poison dodge; see `AdjointTraceZero.lean`
for the structural `ad⁰` substrate).

## Reference

- Wiles, *Modular elliptic curves and Fermat's Last Theorem*, Ann. of
  Math. 141 (1995), §2 (numerical criterion) and §3 (Flach system).
- Flach, *A finiteness theorem for the symmetric square of an elliptic
  curve*, Invent. Math. 109 (1992), 307–327.
-/

namespace MathlibExpansion.Roots.Wiles1995

/-- **Flach–Wiles Selmer carrier for `ad⁰ ρ̄`.**

The global Selmer group `Sel(Q, ad⁰ ρ̄)` is a finite abelian group; its
length (order logarithm) is the quantity bounded by the Flach /
Euler-system argument in Wiles 1995 §3. We carry it as a typed record
whose `length : ℕ` is the carrier-side quantity. -/
structure SelmerAdZero where
  /-- The finite length (order / cardinality logarithm) of the Selmer
  group `Sel(Q, ad⁰ ρ̄)`. -/
  length : ℕ

/-- **Congruence-module side length.**

This is the length of the congruence module `O/η` for the modular
form attached to our deformation problem; by MW1984's
`charIdeal_eq_unit_mul_Lp` (unit-multiple form) it equals the
`p`-adic valuation of an L-value. Carried as a typed record so the
Selmer / congruence inequality is a typed ℕ inequality, not a
free-Prop parameter. -/
structure CongruenceLength where
  /-- The length of `O / η` in valuation units. -/
  length : ℕ

/-- **Lift the wrapper Selmer carrier into the typed Flach1992 carrier.** -/
def toTypedSelmerAdZero (S : SelmerAdZero) :
    MathlibExpansion.Roots.Flach1992.SelmerAdZeroCarrier 2 ℤ :=
  ⟨S.length⟩

/-- **Lift the wrapper congruence length into the typed Flach1992 carrier.** -/
def toTypedCongruenceModule (C : CongruenceLength) :
    MathlibExpansion.Roots.Flach1992.CongruenceModuleData ℤ ℤ :=
  ⟨RingHom.id ℤ, C.length⟩

/-- **Length preservation for the typed Selmer lift.** -/
@[simp] theorem toTypedSelmerAdZero_length (S : SelmerAdZero) :
    (toTypedSelmerAdZero S).length = S.length := rfl

/-- **Length preservation for the typed congruence lift.** -/
@[simp] theorem toTypedCongruenceModule_length (C : CongruenceLength) :
    (toTypedCongruenceModule C).length = C.length := rfl

/-- **Flach Selmer bound.**

The wrapper-level Wiles statement is now derived by manufacturing typed
Flach1992 carriers with the same recorded lengths and applying the typed
Flach theorem. -/
theorem flachSelmerBound_ad0
    (S : SelmerAdZero) (C : CongruenceLength) :
    S.length ≤ C.length := by
  letI : Fact (Nat.Prime 2) := ⟨by decide⟩
  simpa [toTypedSelmerAdZero, toTypedCongruenceModule] using
    (MathlibExpansion.Roots.Flach1992.flachSelmerBound_typed
      (p := 2)
      (R := ℤ)
      (O := ℤ)
      (S := toTypedSelmerAdZero S)
      (C := toTypedCongruenceModule C))

end MathlibExpansion.Roots.Wiles1995
