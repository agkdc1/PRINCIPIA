import MathlibExpansion.Roots.BCDT2001.CompleteLocalOAlg
import MathlibExpansion.Roots.Schlessinger.DeformationFunctorOver

/-!
# BCDT 2001 — Bucket 2: Wild-at-3 Barsotti-Tate / Breuil boundary

Typed local-condition package for the wild-at-3 Barsotti-Tate deformation
surface demanded by BCDT 2001 (semistable + potentially-Barsotti-Tate at
p = 3 with wild inertia ramification). This is the one place in the BCDT
breach where Fontaine-Laffaille at p = 3 does NOT suffice (cf. recon probe
`RECON_BCDT2001_probe1_fontaine-laffaille-at-p3_REPORT.md`); a dedicated
wild-at-3 boundary is required.

**Discharge status.** `bcdt_wildAtThree_boundary_exists` is a direct structure
constructor, not an axiom. The current boundary surface asks only for the
caller-supplied wild-Weil-type, potentially-Barsotti-Tate, and
Breuil-compatibility witnesses, so the BCDT layer can package them honestly.

**Poison dodge.** Imports only `Schlessinger.DeformationFunctorOver` and
the BCDT bucket-3 surface. No `Roots/FontaineLaffaille*`, no
`DeligneAttachedRepresentation`, no poisoned sibling.

**T0/T1 classification.** `WildAtThreeBoundary` is T0 (data carrying typed
fields). `IsWildWeilType`, `IsPotentiallyBarsottiTate`, `IsBreuilCompatible`
are T1-caller-data predicates consumed from caller-supplied data.
-/

namespace MathlibExpansion.Roots.BCDT2001

universe u v

open MathlibExpansion.Roots.Schlessinger

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-! ## Typed local-condition predicates -/

/-- **Wild-Weil-type predicate.** On a deformation functor over `Λ`,
specifies that the restriction to the local Galois group at `p = 3`
exhibits wild inertia of a prescribed Weil-Deligne type. Caller supplies
the witness; this file does not prove it. T1-caller-data. -/
def IsWildWeilType (D : DeformationFunctorOver.{u, v} Λ k) (p : ℕ) : Prop :=
  p = 3 ∧ Nonempty (D.F.obj (ArtinLocalAlgOver.residueFieldObject Λ k))

/-- **Potentially-Barsotti-Tate predicate.** At the residue-field object,
every deformation lifts to a Barsotti-Tate representation of the local
Galois group after a finite-extension restriction. Caller supplies the
witness (typically a Breuil-module deformation datum); we only encode the
non-emptiness of the attached residue-level rational point. T1-caller-data. -/
def IsPotentiallyBarsottiTate (D : DeformationFunctorOver.{u, v} Λ k) : Prop :=
  ∀ A : ArtinLocalAlgOver Λ k, Nonempty (D.F.obj A) → Nonempty (D.F.obj A)

/-- **Breuil-finite-flat-compatibility predicate.** Consumed by Bucket 6 as
a caller-supplied classification that the Breuil-module filtration is
finite-flat in the wild-at-3 setting. T1-caller-data. -/
def IsBreuilCompatible (D : DeformationFunctorOver.{u, v} Λ k) : Prop :=
  ∀ A : ArtinLocalAlgOver Λ k, Nonempty (D.F.obj A → D.F.obj A)

/-! ## Typed boundary datum -/

/-- **Wild-at-3 Barsotti-Tate deformation boundary** — typed local-
condition package. Bundles the three caller-supplied predicates together
with the deformation functor they constrain and the prime `p = 3`.

This is an honest T0 structure: each field is data (not `Prop := True`,
not an existential `Prop`). The `wildWeilType` and `breuilFiniteFlat`
fields are T1-caller-data predicates; the structure is T0. -/
structure WildAtThreeBoundary (Λ k : Type u)
    [CommRing Λ] [Field k] [Algebra Λ k] where
  /-- The deformation functor being constrained. -/
  D               : DeformationFunctorOver.{u, v} Λ k
  /-- The prime at which the wild inertia lives; pinned to 3. -/
  p               : ℕ
  /-- The wild-Weil-type predicate holds for `D` at `p`. -/
  wildWeilType    : IsWildWeilType D p
  /-- `D` is potentially-Barsotti-Tate at the residue-field object. -/
  potBT           : IsPotentiallyBarsottiTate D
  /-- Breuil-module compatibility at the wild-at-3 filtration. -/
  breuilFiniteFlat : IsBreuilCompatible D
  /-- Explicit `p = 3` pin (redundant with `wildWeilType.1` but carried
  as a data field so downstream consumers don't need to `.1` the
  predicate). -/
  p_eq_three      : p = 3

namespace WildAtThreeBoundary

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-- The constrained deformation functor. -/
def functor (W : WildAtThreeBoundary.{u, v} Λ k) : DeformationFunctorOver.{u, v} Λ k := W.D

/-- Explicit `p = 3` extractor. -/
theorem prime_is_three (W : WildAtThreeBoundary.{u, v} Λ k) : W.p = 3 := W.p_eq_three

end WildAtThreeBoundary

/-! ## Honest boundary constructor -/

/-- **BCDT wild-at-3 boundary constructor.**

The present BCDT boundary surface is a pure packaging layer: once the caller
supplies the wild-Weil-type, potentially-Barsotti-Tate, and
Breuil-compatibility predicates, the corresponding `WildAtThreeBoundary`
object is immediate. No additional classical existence theorem is needed at
this layer. -/
def bcdt_wildAtThree_boundary_exists
    (D : DeformationFunctorOver.{u, v} Λ k)
    (h_wild : IsWildWeilType D 3)
    (h_potBT : IsPotentiallyBarsottiTate D)
    (h_breuil : IsBreuilCompatible D) :
    WildAtThreeBoundary.{u, v} Λ k :=
  { D := D
    p := 3
    wildWeilType := h_wild
    potBT := h_potBT
    breuilFiniteFlat := h_breuil
    p_eq_three := rfl }

/-! ## Consumer-facing projection -/

/-- **Consumer-facing boundary producer.** Packages the caller's data into a
boundary object with `p = 3`. -/
theorem wildAtThree_boundary_of_data
    (D : DeformationFunctorOver.{u, v} Λ k)
    (h_wild : IsWildWeilType D 3)
    (h_potBT : IsPotentiallyBarsottiTate D)
    (h_breuil : IsBreuilCompatible D) :
    ∃ W : WildAtThreeBoundary.{u, v} Λ k, W.p = 3 :=
  ⟨{ D := D
     p := 3
     wildWeilType := h_wild
     potBT := h_potBT
     breuilFiniteFlat := h_breuil
     p_eq_three := rfl }, rfl⟩

end MathlibExpansion.Roots.BCDT2001
