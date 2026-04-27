import MathlibExpansion.Textbooks.Schlessinger1968.Chapter1.DualNumbers

/-!
# `IsArtinianRing (DualNumber k)` — Theorem (was axiom)

**Phase 2 Opener discharge** (2026-04-21): the former `axiom dualNumberArtinian`
is now a `theorem`, proved in
`MathlibExpansion.Textbooks.Schlessinger1968.Chapter1.DualNumbers` via:

1. Explicit `k`-linear equivalence `DualNumber k ≃ₗ[k] k × k`
   (`dualNumberLinearEquivProd`).
2. `Module.Finite k (DualNumber k)` via `Module.Finite.of_surjective`.
3. `IsArtinianRing.of_finite k (DualNumber k)`.

Axiom ledger impact: **−1** (named axiom removed, theorem introduced).
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u

open MathlibExpansion.Textbooks.Schlessinger1968.Chapter1

/-- **Theorem** (formerly budgeted axiom): `DualNumber k` is an Artinian ring.

Proved via `Module.Finite k (DualNumber k)` + `IsArtinianRing.of_finite`.
See `Textbooks.Schlessinger1968.Chapter1.DualNumbers` for the full proof. -/
theorem dualNumberArtinian (k : Type u) [Field k] :
    IsArtinianRing (DualNumber k) :=
  dualNumber_isArtinianRing_theorem k

/-- Instance form for typeclass resolution — same interface as before,
now backed by the theorem (not the axiom). -/
instance dualNumber_isArtinianRing (k : Type u) [Field k] :
    IsArtinianRing (DualNumber k) :=
  dualNumberArtinian k

end MathlibExpansion.Roots.Schlessinger
