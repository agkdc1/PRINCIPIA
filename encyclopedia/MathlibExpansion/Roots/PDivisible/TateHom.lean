import MathlibExpansion.Roots.PDivisible.Core
import MathlibExpansion.Roots.PDivisible.Height

/-!
# p-divisible groups: Tate-module fully-faithfulness certificate

Records a certificate interface for the Tate-module full-faithfulness theorem
for p-divisible groups and derives consequences from explicit evidence.

## Certificate

`TateHomFullFaithfulBoundary` carries the Tate-module map, equivariance, and an
explicit p-divisible hom lifting it.  The source theorem is Tate, J. (1967),
*p-divisible groups*, §4, in *Proc. Conf. Local Fields*, Springer, pp. 158–183;
see also Messing, W. (1972), *The Crystals Associated to Barsotti-Tate Groups*,
LNM 264.

## Derived theorems

- `pDivisibleHom_injective_of_tateHom_eq` — a p-divisible group hom is determined
  by its action on the Tate module once every finite-level point lifts to a
  compatible Tate-module section.
- `pDivisibleHom_levelMap_eq_of_tateHom_eq` — functional-equality strengthening of
  the above (function extensionality form).
- `ordinaryEllipticHeightOne_of_tateHom` — the Tate-module rank-1 criterion for
  ordinary reduction (height one).

## Phase 2 discharge (2026-04-23)

Real-theorem additions around the `tateHomFullFaithfulPDivisible` certificate:
- `PDivisibleHom.id` / `PDivisibleHom.comp` — category-of-pdivisible-groups structure.
- `TateHomFullFaithfulBoundary.idBoundary` — the certificate pattern is non-vacuous
  (identity case is trivially true).
- Identity/composition laws `tateHomFullFaithfulPDivisible_id_comp` and `_comp_id`.

Remaining moral gap: the **existence** of a `TateHomFullFaithfulBoundary` from an
arbitrary `Γ`-equivariant map on Tate modules. That is Tate (1967) §4 /
Faltings (1988) *p-adic Hodge theory* (Invent. Math. 73) / Fontaine-Messing (1987)
"p-adic periods and p-adic étale cohomology". Its Lean formalisation requires
finite-flat group schemes over `Spec O_K`, the native `ℤ_p` Tate module, and
Fontaine's crystalline-Dieudonné comparison — none of which are in Mathlib v4.17.
The `.lift` field of `TateHomFullFaithfulBoundary` stands in for this datum.
-/

namespace MathlibExpansion
namespace Roots
namespace PDivisible

/-! ## TateHomFullFaithfulBoundary -/

universe u v

/-- The honest boundary record for Tate's full-faithfulness theorem.

Fields record what Mathlib v4.17.0 cannot yet provide:
- `K` is a complete non-archimedean local field
- `GalK` is its absolute Galois group (profinite, continuous action)
- Two p-divisible group objects `G H` over the residue field
- A `GalK`-equivariant map on their Tate modules
- A p-divisible hom lifting that map

The lift field is the local certificate for Tate 1967, §4 (generic-fiber/Tate-module
full faithfulness), as developed further in Messing 1972. -/
structure TateHomFullFaithfulBoundary
    (Γ : Type u) [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    (p : ℕ) where
  G           : PDivisibleGroupObject Γ p
  H           : PDivisibleGroupObject Γ p
  sameHeight  : G.height = H.height
  /-- A Γ-equivariant map on Tate modules. -/
  tateMap     : TateModuleObject.{u, v} G.toGaloisProfiniteTower →
                TateModuleObject.{u, v} H.toGaloisProfiniteTower
  tateMapEquiv : ∀ (σ : Γ) (x : TateModuleObject.{u, v} G.toGaloisProfiniteTower),
      tateMap (σ • x) = σ • tateMap x
  /-- A p-divisible-group morphism lifting the Tate-module map. -/
  lift        : PDivisibleHom G H
  /-- The lift agrees with `tateMap` after projecting to every finite level. -/
  lift_tateMap : ∀ (x : TateModuleObject.{u, v} G.toGaloisProfiniteTower) (n : ℕ),
      lift.levelMap n (x.section_ n) = (tateMap x).section_ n

/-! ## Full-faithfulness projection -/

/-- Tate 1967, §4 / Messing 1972 full-faithfulness interface: a certified
`Γ`-equivariant map on `TateModuleObject`s lifts to a `PDivisibleHom`.

The current MathlibExpansion substrate does not yet contain finite-flat group schemes over
`Spec O_K` or the native `ℤ_p` Tate module, so the lift evidence is carried by
`TateHomFullFaithfulBoundary`. -/
def tateHomFullFaithfulPDivisible
    {Γ : Type u} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ}
    (B : TateHomFullFaithfulBoundary Γ p) :
    PDivisibleHom B.G B.H :=
  B.lift

/-! ## PDivisibleHom category structure

Real-theorem content added 2026-04-23 (Phase 2 `tateHomFullFaithfulPDivisible`
discharge): identity + composition of `PDivisibleHom`, plus the identity
`TateHomFullFaithfulBoundary` witness showing the certificate pattern is
non-vacuous. No axioms introduced. -/

/-- The identity `PDivisibleHom` of a `PDivisibleGroupObject`. -/
def PDivisibleHom.id
    {Γ : Type*} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} (G : PDivisibleGroupObject Γ p) : PDivisibleHom G G where
  levelMap    := fun _ x => x
  continuous  := fun _ => continuous_id
  naturality  := fun _ _ => rfl
  equivariant := fun _ _ _ => rfl

/-- Composition of `PDivisibleHom`s. Preserves continuity, naturality under
transitions, and Γ-equivariance at every finite level. -/
def PDivisibleHom.comp
    {Γ : Type*} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} {G H K : PDivisibleGroupObject Γ p}
    (g : PDivisibleHom H K) (f : PDivisibleHom G H) : PDivisibleHom G K where
  levelMap    := fun n x => g.levelMap n (f.levelMap n x)
  continuous  := fun n => (g.continuous n).comp (f.continuous n)
  naturality  := fun n x => by
    show g.levelMap n (f.levelMap n (G.transition n x)) =
         K.transition n (g.levelMap (n + 1) (f.levelMap (n + 1) x))
    rw [f.naturality n x]
    exact g.naturality n (f.levelMap (n + 1) x)
  equivariant := fun n σ x => by
    show g.levelMap n (f.levelMap n ((G.levelAction n).toSMul.smul σ x)) =
         (K.levelAction n).toSMul.smul σ (g.levelMap n (f.levelMap n x))
    rw [f.equivariant n σ x]
    exact g.equivariant n σ (f.levelMap n x)

@[simp]
theorem PDivisibleHom.id_levelMap
    {Γ : Type*} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} (G : PDivisibleGroupObject Γ p) (n : ℕ) (x : G.level.obj (Opposite.op n)) :
    (PDivisibleHom.id G).levelMap n x = x := rfl

@[simp]
theorem PDivisibleHom.comp_levelMap
    {Γ : Type*} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} {G H K : PDivisibleGroupObject Γ p}
    (g : PDivisibleHom H K) (f : PDivisibleHom G H)
    (n : ℕ) (x : G.level.obj (Opposite.op n)) :
    (g.comp f).levelMap n x = g.levelMap n (f.levelMap n x) := rfl

/-! ## TateHomFullFaithfulBoundary — non-vacuous certificate witnesses

The `idBoundary` witness shows the certificate pattern is inhabited for every
`PDivisibleGroupObject`: Tate's full-faithfulness specialises to the identity
map on the identity p-divisible group. -/

/-- The identity `TateHomFullFaithfulBoundary` for a single `PDivisibleGroupObject`:
`G = H`, identity Tate map, identity lift. Proves the boundary/certificate pattern
is non-vacuous (Tate 1967 §4 is trivially true in the identity case). -/
def TateHomFullFaithfulBoundary.idBoundary
    {Γ : Type u} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} (G : PDivisibleGroupObject Γ p) :
    TateHomFullFaithfulBoundary.{u, v} Γ p where
  G            := G
  H            := G
  sameHeight   := rfl
  tateMap      := fun x => x
  tateMapEquiv := fun _ _ => rfl
  lift         := PDivisibleHom.id G
  lift_tateMap := fun _ _ => rfl

/-- The Tate-hom full-faithfulness projection is the identity lift on the identity boundary. -/
@[simp]
theorem tateHomFullFaithfulPDivisible_idBoundary
    {Γ : Type u} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} (G : PDivisibleGroupObject Γ p) :
    tateHomFullFaithfulPDivisible (TateHomFullFaithfulBoundary.idBoundary.{u, v} G) =
      PDivisibleHom.id G := rfl

/-! ## Derived theorems -/

/-- A morphism of p-divisible groups is determined by its effect on the Tate module.

The extra hypothesis is the precise finite-level projection-surjectivity input:
every point of `G[p^n]` is the `n`th projection of a compatible Tate-module section. -/
theorem pDivisibleHom_injective_of_tateHom_eq
    {Γ : Type u} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ}
    (G H : PDivisibleGroupObject Γ p)
    (f g : PDivisibleHom G H)
    (hsection_surjective : ∀ (n : ℕ) (x : G.level.obj (Opposite.op n)),
        ∃ tx : TateModuleObject.{u, v} G.toGaloisProfiniteTower, tx.section_ n = x)
    (htate : ∀ (x : TateModuleObject.{u, v} G.toGaloisProfiniteTower) (n : ℕ),
        f.levelMap n (x.section_ n) = g.levelMap n (x.section_ n)) :
    ∀ (n : ℕ) (x : G.level.obj (Opposite.op n)), f.levelMap n x = g.levelMap n x := by
  intro n x
  rcases hsection_surjective n x with ⟨tx, htx⟩
  simpa [htx] using htate tx n

/-- Functional-equality form of faithfulness: two p-divisible homs with equal Tate
projections (under finite-level section-surjectivity) have equal underlying level
maps. Strengthens `pDivisibleHom_injective_of_tateHom_eq` via function extensionality. -/
theorem pDivisibleHom_levelMap_eq_of_tateHom_eq
    {Γ : Type u} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ}
    (G H : PDivisibleGroupObject Γ p)
    (f g : PDivisibleHom G H)
    (hsection_surjective : ∀ (n : ℕ) (x : G.level.obj (Opposite.op n)),
        ∃ tx : TateModuleObject.{u, v} G.toGaloisProfiniteTower, tx.section_ n = x)
    (htate : ∀ (x : TateModuleObject.{u, v} G.toGaloisProfiniteTower) (n : ℕ),
        f.levelMap n (x.section_ n) = g.levelMap n (x.section_ n)) :
    f.levelMap = g.levelMap := by
  funext n x
  exact pDivisibleHom_injective_of_tateHom_eq G H f g hsection_surjective htate n x

/-- Left-identity for `PDivisibleHom.comp`: composing with `id` on the right leaves
the hom unchanged. -/
@[simp]
theorem tateHomFullFaithfulPDivisible_id_comp
    {Γ : Type u} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} {G H : PDivisibleGroupObject Γ p}
    (f : PDivisibleHom G H) :
    f.comp (PDivisibleHom.id G) = f := rfl

/-- Right-identity for `PDivisibleHom.comp`: composing with `id` on the left leaves
the hom unchanged. -/
@[simp]
theorem tateHomFullFaithfulPDivisible_comp_id
    {Γ : Type u} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} {G H : PDivisibleGroupObject Γ p}
    (f : PDivisibleHom G H) :
    (PDivisibleHom.id H).comp f = f := rfl

/-- Tate-module rank 1 implies height 1 (ordinary reduction).

If a `TateModuleRankCertificate` certifies rank 1 and matches the group's height,
the group has height 1. This follows from the certificate fields. -/
theorem ordinaryEllipticHeightOne_of_tateHom
    {Γ : Type u} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ}
    (G : PDivisibleGroupObject Γ p)
    (C : TateModuleRankCertificate)
    (hrank : C.tateRank = 1)
    (hheight : C.formalHeight = G.height) :
    G.height = 1 := by
  have heq : C.tateRank = C.formalHeight := C.rank_eq_height
  omega

end PDivisible
end Roots
end MathlibExpansion
