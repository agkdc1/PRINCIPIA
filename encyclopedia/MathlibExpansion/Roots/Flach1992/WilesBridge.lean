import MathlibExpansion.Roots.Flach1992.Bound
import MathlibExpansion.Roots.Wiles1995.FlachSelmerBound

/-!
# Flach1992 — One-way bridge to Wiles1995 Nat wrappers

Shim-bridge from typed Flach1992 carriers to the existing degenerate
`Wiles1995.SelmerAdZero` / `Wiles1995.CongruenceLength` Nat wrappers.

## Bridge strategy

Two length-preserving projections map typed carriers to Wiles1995 wrappers:
* `toWilesSelmerAdZero`     : `SelmerAdZeroCarrier p O → Wiles1995.SelmerAdZero`
* `toWilesCongruenceLength` : `CongruenceModuleData R O → Wiles1995.CongruenceLength`

One bridge theorem derives the Wiles-level bound without touching the old axiom:
* `flachSelmerBound_ad0_from_typed` — the `flachSelmerBound_ad0` shape,
  now a **theorem** derived from `flachSelmerBound_typed` via the projections.

## Zero Wiles1995 edits

This file imports `Wiles1995.FlachSelmerBound` for the wrapper types only.
No file under `Roots/Wiles1995/` is modified.

## Axiom check

`#print axioms flachSelmerBound_ad0_from_typed` shows only the narrower
Flach1992 upstream axioms used by `flachSelmerBound_typed`.
`flachSelmerBound_ad0` does NOT appear — confirming the old Wiles1995
statement is redundant given the typed theorem.

## Axioms introduced by this file

**0.** No new axiom, no sorry.
-/

namespace MathlibExpansion.Roots.Flach1992

/-- **Project typed Selmer carrier to Wiles1995 Nat wrapper.**

Extracts `length` from `SelmerAdZeroCarrier p O` and wraps it in the
existing `Wiles1995.SelmerAdZero` record. Downstream Wiles consumers
(e.g., `NumericalCriterion`, `REqualsT`) receive this without modification. -/
def toWilesSelmerAdZero {p : ℕ} {O : Type*} [CommRing O]
    (S : SelmerAdZeroCarrier p O) : MathlibExpansion.Roots.Wiles1995.SelmerAdZero :=
  ⟨S.length⟩

/-- **Project typed congruence module to Wiles1995 Nat wrapper.**

Extracts `length` from `CongruenceModuleData R O` and wraps it in the
existing `Wiles1995.CongruenceLength` record. -/
def toWilesCongruenceLength {R O : Type*} [CommRing R] [CommRing O]
    (C : CongruenceModuleData R O) : MathlibExpansion.Roots.Wiles1995.CongruenceLength :=
  ⟨C.length⟩

/-- **Length preservation for Selmer projection.** -/
@[simp]
theorem toWilesSelmerAdZero_length {p : ℕ} {O : Type*} [CommRing O]
    (S : SelmerAdZeroCarrier p O) :
    (toWilesSelmerAdZero S).length = S.length := rfl

/-- **Length preservation for congruence projection.** -/
@[simp]
theorem toWilesCongruenceLength_length {R O : Type*} [CommRing R] [CommRing O]
    (C : CongruenceModuleData R O) :
    (toWilesCongruenceLength C).length = C.length := rfl

/-- **Bridge theorem: Wiles1995 Nat bound derived from typed Flach bound.**

The `Wiles1995.SelmerAdZero` / `Wiles1995.CongruenceLength` length inequality
(the shape of the old `flachSelmerBound_ad0` axiom) holds as a **theorem**
when the inputs come from typed Flach1992 carriers, derived via
`flachSelmerBound_typed` through the length-preserving projections.

`#print axioms flachSelmerBound_ad0_from_typed` shows only the Flach1992
upstream axioms behind `flachSelmerBound_typed` — `flachSelmerBound_ad0`
does not appear, confirming the Wiles1995 statement is redundant. -/
theorem flachSelmerBound_ad0_from_typed
    {p : ℕ} [Fact p.Prime]
    {R O : Type*} [CommRing R] [CommRing O]
    (S : SelmerAdZeroCarrier p O)
    (C : CongruenceModuleData R O) :
    (toWilesSelmerAdZero S).length ≤ (toWilesCongruenceLength C).length := by
  simp only [toWilesSelmerAdZero_length, toWilesCongruenceLength_length]
  exact flachSelmerBound_typed S C

end MathlibExpansion.Roots.Flach1992
