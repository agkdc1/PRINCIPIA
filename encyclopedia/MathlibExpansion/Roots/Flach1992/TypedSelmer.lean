import Mathlib

/-!
# Flach1992 — Typed Selmer carrier for ad⁰ ρ̄

Typed carrier replacing the degenerate `Wiles1995.SelmerAdZero` Nat wrapper.
Records the prime `p` and coefficient ring `O` explicitly; the `length : ℕ`
field is the finite-length quantity bounded by the Flach Euler-system argument.

The bound obligation is NOT a structure field (Doctrine v2 / Doctrine 7).
It lives as a named axiom in `Bound.lean`.

## Axioms introduced by this file

**0.** No axiom, no sorry.

## Reference

- Flach, *A finiteness theorem for the symmetric square of an elliptic curve*,
  Invent. Math. 109 (1992), 307–327.
- Wiles, *Modular elliptic curves and Fermat's Last Theorem*,
  Ann. Math. 141 (1995), §3.
-/

namespace MathlibExpansion.Roots.Flach1992

/-- **Typed Selmer carrier for `Sel(ℚ, ad⁰ ρ̄)` at prime `p`.**

Parameters:
* `p` — the residue characteristic prime;
* `O` — the coefficient ring (ring of integers of the local field at `p`).

The `length : ℕ` field is the finite length of the Selmer group, which
Flach's Euler-system argument bounds above by the congruence-module length.

Strictly richer than `Wiles1995.SelmerAdZero`: it names both the prime
and the coefficient ring, enabling typed bridge theorems. The inequality
`S.length ≤ C.length` lives in `Bound.lean` as a named axiom, NOT as a
`bound` field here (Doctrine 7). -/
structure SelmerAdZeroCarrier (p : ℕ) (O : Type*) [CommRing O] where
  /-- Finite length of `Sel(ℚ, ad⁰ ρ̄)` as an `O`-module. -/
  length : ℕ

end MathlibExpansion.Roots.Flach1992
