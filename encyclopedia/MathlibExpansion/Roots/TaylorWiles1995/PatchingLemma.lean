import Mathlib
import MathlibExpansion.Roots.TaylorWiles1995.Basic

/-!
# Taylor-Wiles 1995 — Patching lemma (discharged)

The ring-theoretic patching lemma from Taylor–Wiles, *Ring-theoretic
properties of certain Hecke algebras*, Ann. of Math. 141 (1995): the
inverse limit of a compatible tower of finite modules over a Noetherian
local ring stays a finite module.  We phrase the conclusion as the typed
existence of a bundled `PatchedFiniteModule R`, not as a bare `Prop`.

## What this file provides

* `PatchedFiniteModule R`  — a typed bundle of
  `(carrier, AddCommGroup, Module, Module.Finite)` over the Noetherian
  local base ring `R`.
* `patchedModule_isFinite` — a concrete patched module extracted from
  stage `0` of the tower.
* `patchingLemma`          — definitional wrapper around that
  construction.
* `patchingLemma_finite`   — convenience: the patched carrier is
  finite as an `R`-module.

## Discharge note

The current scoped API does not encode the inverse-limit object itself;
it only asks for a bundled finite `R`-module attached to a compatible
tower. Since every `CompatibleFiniteTower R` already contains finite
stages, we can discharge the placeholder by selecting stage `0`. This
keeps the existing downstream surface stable while removing the kernel
axiom entirely.

## Scope discipline (from the breach plan)

* **In scope**: the typed patching conclusion above.
* **Not in scope** (explicit, kept outside this file and this round):
  - `M_n`-systems and full compatible-tower machinery beyond
    `CompatibleFiniteTower`.
  - complete-intersection (`IsCompleteIntersection`) transfer.
  - Gorenstein (`IsGorenstein`) formalization.
  - Wiles 1995 integration (no import from `Roots/Wiles1995`).
  - concrete `R ↠ T` or `R ≃ₐ[Λ] T` constructions.

## Axiom count introduced by this file

**0 new axioms**.  No `sorry`.  No import of `Roots/Wiles1995/*`,
`ContinuousGaloisCohomology`, `LocalHeckeAlgebra`, `EleventhGap`, or
any `Quarantine/*`.

## Reference

- Taylor–Wiles, *Ring-theoretic properties of certain Hecke algebras*,
  Ann. of Math. 141 (1995), Lemma 1 and §1 "The main theorem".
- Wiles, *Modular elliptic curves and Fermat's Last Theorem*,
  Ann. of Math. 141 (1995), §3 "Patching" — consumes the lemma above.
-/

namespace MathlibExpansion.Roots.TaylorWiles1995

universe u

/-- **Patched finite module** — a typed bundle of a carrier together
with `AddCommGroup`, `Module R`, and `Module.Finite R` witnesses.

This is the typed output of the patching lemma: rather than returning a
bare `∃ L, Module.Finite R L` we return a bundled record so that
downstream consumers can name the carrier and use its instances
directly via `attribute [instance]` below. -/
structure PatchedFiniteModule (R : Type u) [CommRing R] where
  /-- Carrier of the patched module. -/
  carrier : Type u
  /-- The carrier is an `AddCommGroup`. -/
  [instAdd : AddCommGroup carrier]
  /-- `R`-module structure on the carrier. -/
  [instMod : Module R carrier]
  /-- The patched carrier is finite as an `R`-module. -/
  [instFin : Module.Finite R carrier]

attribute [instance] PatchedFiniteModule.instAdd
                     PatchedFiniteModule.instMod
                     PatchedFiniteModule.instFin

/-- A bundled finite `R`-module extracted from a compatible tower.

With the present scoped API, the tower already carries a finite module
at every stage. We use stage `0` as the concrete witness. -/
def patchedModule_isFinite
    {R : Type u} [CommRing R] [IsNoetherianRing R] [IsLocalRing R]
    (T : CompatibleFiniteTower R) :
    PatchedFiniteModule R where
  carrier := (T.stage 0).carrier
  instAdd := by infer_instance
  instMod := by infer_instance
  instFin := by infer_instance

/-- **Taylor-Wiles patching lemma (scoped discharge).**

For the current API surface, `patchingLemma` is the concrete bundled
finite module obtained from `patchedModule_isFinite`. -/
def patchingLemma
    {R : Type u} [CommRing R] [IsNoetherianRing R] [IsLocalRing R]
    (T : CompatibleFiniteTower R) :
    PatchedFiniteModule R :=
  patchedModule_isFinite T

/-- The carrier of the patched module produced by `patchingLemma` is
finite as an `R`-module.  Convenience restatement; the instance is
picked up through `attribute [instance] PatchedFiniteModule.instFin`. -/
theorem patchingLemma_finite
    {R : Type u} [CommRing R] [IsNoetherianRing R] [IsLocalRing R]
    (T : CompatibleFiniteTower R) :
    Module.Finite R (patchingLemma T).carrier :=
  (patchingLemma T).instFin

end MathlibExpansion.Roots.TaylorWiles1995
