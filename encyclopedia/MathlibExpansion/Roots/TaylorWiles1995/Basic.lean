import Mathlib

/-!
# Taylor-Wiles 1995 — Basic compatibility record (scope A)

Minimal typed data used to state the Taylor-Wiles patching lemma: a
compatible tower of finite modules over a Noetherian local ring, indexed
by `ℕ`, together with `R`-linear transition maps `stage n → stage m` for
every `m ≤ n` satisfying the identity / composition axioms of an inverse
system.

## What this file provides

* `TowerStage R`   — a bundled finite `R`-module (carrier + typeclass
  witnesses), so a tower can be indexed by `ℕ` without threading
  instances through every dependent type.
* `CompatibleFiniteTower R` — the actual inverse system: `ℕ`-indexed
  `TowerStage R` with `R`-linear transitions and inverse-system laws.

## Non-goals (explicit, scope A)

* No categorical inverse limit (`CategoryTheory.Limits`).
* No `Module.InverseLimit` API.
* No existence statement for the patched module (see `PatchingLemma.lean`).
* No coupling to `Roots/Wiles1995` — this file imports only `Mathlib`.

## Axiom count introduced by this file

**0 new axioms, 0 sorry.**  Pure data.

## Reference

- Taylor–Wiles, *Ring-theoretic properties of certain Hecke algebras*,
  Ann. of Math. 141 (1995), Lemma 1.
- Wiles 1995 §3 ("Patching"), read together with the Taylor–Wiles
  construction.
-/

namespace MathlibExpansion.Roots.TaylorWiles1995

universe u

/-- **Stage of a Taylor-Wiles tower.**

A finite `R`-module bundled with its typeclass witnesses as fields so
that an `ℕ`-indexed family of stages has a single carrier function
`ℕ → TowerStage R`, and the instance fields become available via
`attribute [instance]` below.  This avoids threading
`[AddCommGroup (stage n)]`, `[Module R (stage n)]`, and
`[Module.Finite R (stage n)]` through every dependent context. -/
structure TowerStage (R : Type u) [CommRing R] where
  /-- Carrier type of this stage of the tower. -/
  carrier : Type u
  /-- AddCommGroup structure on the carrier. -/
  [instAdd : AddCommGroup carrier]
  /-- `R`-module structure on the carrier. -/
  [instMod : Module R carrier]
  /-- The stage is a finite `R`-module. -/
  [instFin : Module.Finite R carrier]

attribute [instance] TowerStage.instAdd
                     TowerStage.instMod
                     TowerStage.instFin

/-- **Compatible tower of finite `R`-modules.**

Data used to state the patching lemma: a family of finite `R`-module
stages `stage : ℕ → TowerStage R`, together with `R`-linear transition
maps `transition : stage n → stage m` for every `m ≤ n`, satisfying
identity and composition laws making the whole thing an inverse system
indexed by `(ℕ, ≤)`. -/
structure CompatibleFiniteTower
    (R : Type u) [CommRing R] [IsNoetherianRing R] where
  /-- Stage-`n` finite `R`-module in the tower. -/
  stage : ℕ → TowerStage R
  /-- `R`-linear transition `stage n → stage m` when `m ≤ n`. -/
  transition : ∀ {m n : ℕ}, m ≤ n →
                 (stage n).carrier →ₗ[R] (stage m).carrier
  /-- Identity axiom: the transition along `n ≤ n` is the identity. -/
  trans_id : ∀ n, transition (le_refl n) = LinearMap.id
  /-- Composition axiom: transitions compose along `m ≤ n ≤ k`. -/
  trans_comp : ∀ {m n k : ℕ} (hmn : m ≤ n) (hnk : n ≤ k),
                 transition hmn ∘ₗ transition hnk
                   = transition (le_trans hmn hnk)

end MathlibExpansion.Roots.TaylorWiles1995
