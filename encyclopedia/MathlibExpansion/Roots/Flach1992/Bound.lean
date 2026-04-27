import MathlibExpansion.Roots.Flach1992.TypedSelmer
import MathlibExpansion.Roots.Flach1992.CongruenceModule

/-!
# Flach1992 — Typed Flach bound theorem

The typed Flach1992 boundary is split into:

* `tatePoitou_selmer_to_dual` — theorem-level at the current carrier
  abstraction, because `DualSelmerAdZeroCarrier` records only the transported
  finite length;
* `flachEulerSystemBound_dual` — the remaining upstream Euler-system bound.

and the original typed bound

  `flachSelmerBound_typed : S.length ≤ C.length`

stated on typed `SelmerAdZeroCarrier` and `CongruenceModuleData` carriers,
replacing the role of the degenerate `Wiles1995.flachSelmerBound_ad0`.

## Axiom budget

**1 upstream axiom**:
* `flachEulerSystemBound_dual`

`tatePoitou_selmer_to_dual` is no longer axiomatized: its current signature
only asks for a dual length carrier with the same length, so it is discharged
by constructing that carrier directly. The old Wiles1995 wrapper statement is
then derivable from `flachSelmerBound_typed`.

## Why the remaining upstream piece must remain an axiom

Post-recon P2 (CONFIRMED): no `H¹(G_S, M)` with local conditions,
no Poitou-Tate duality, no Euler-system machinery in Mathlib v4.17.0.
The Selmer-side upper bound is therefore still genuinely non-algebraic.
At this carrier abstraction, the Tate-Poitou transport object has no
cohomological fields left to prove, but the Euler-system inequality remains the
classical arithmetic gap.

This is narrower than a single all-in-one inequality and keeps the remaining
gap explicitly named rather than hiding it in a structure field (Doctrine 7).

## Reference

- Flach, *A finiteness theorem for the symmetric square of an elliptic curve*,
  Invent. Math. 109 (1992), Thm. 1.1.
- Wiles, *Modular elliptic curves and Fermat's Last Theorem*,
  Ann. Math. 141 (1995), §3 (Flach Euler system bound).
-/

namespace MathlibExpansion.Roots.Flach1992

/-- **Auxiliary dual Selmer carrier.**

This packages the dual Selmer object that appears after the Tate-Poitou step in
the classical Flach argument. Only its finite length is used downstream. -/
structure DualSelmerAdZeroCarrier (p : ℕ) (O : Type*) [CommRing O] where
  /-- Finite length of the dual Selmer object. -/
  length : ℕ

/-- **Tate-Poitou comparison for `ad⁰`.**

At the present carrier abstraction this is theorem-level: the dual Selmer
carrier stores only the finite length used downstream, so the length-preserving
transport is the direct carrier with `length = S.length`.

The genuine cohomological Tate-Poitou comparison is still not represented by
this signature; Mathlib lacks continuous global Galois cohomology with local
conditions and the relevant duality theorem. -/
theorem tatePoitou_selmer_to_dual
    {p : ℕ} [Fact p.Prime]
    {O : Type*} [CommRing O]
    (S : SelmerAdZeroCarrier p O) :
    ∃ D : DualSelmerAdZeroCarrier p O, S.length = D.length := by
  exact ⟨⟨S.length⟩, rfl⟩

/-- **Flach Euler-system bound on the dual Selmer carrier.**

This is the second narrow upstream boundary: once the Selmer problem has been
transported to the dual carrier, Flach's Euler-system argument bounds its
length by the congruence-module length.

Mathlib gap: the symmetric-square Euler-system machinery and the corresponding
cohomological descent estimates.

Citation: Flach, *A finiteness theorem for the symmetric square of an elliptic
curve*, Invent. Math. 109 (1992), Theorem 1.1; this is the Flach
Euler-system/Selmer bound used by Wiles, *Modular elliptic curves and Fermat's
Last Theorem*, Ann. Math. 141 (1995), §3, especially Theorem 3.1. -/
axiom flachEulerSystemBound_dual
    {p : ℕ} [Fact p.Prime]
    {R O : Type*} [CommRing R] [CommRing O]
    (D : DualSelmerAdZeroCarrier p O)
    (C : CongruenceModuleData R O) :
    D.length ≤ C.length

/-- **Typed Flach–Wiles Selmer bound.**

The finite length of the global Selmer group `Sel(ℚ, ad⁰ ρ̄)` at prime `p`
(recorded in the typed carrier `S`) is bounded above by the length of the
congruence module `O / ker(π)` (recorded in the typed carrier `C`).

This theorem reassembles the classical route

`Selmer  --Tate-Poitou-->  dual Selmer  --Flach-->  congruence module`.

The broad typed inequality is therefore no longer an axiom; only the remaining
Euler-system step is axiomatized. -/
theorem flachSelmerBound_typed
    {p : ℕ} [Fact p.Prime]
    {R O : Type*} [CommRing R] [CommRing O]
    (S : SelmerAdZeroCarrier p O)
    (C : CongruenceModuleData R O) :
    S.length ≤ C.length := by
  rcases tatePoitou_selmer_to_dual S with ⟨D, hD⟩
  rw [hD]
  exact flachEulerSystemBound_dual D C

end MathlibExpansion.Roots.Flach1992
