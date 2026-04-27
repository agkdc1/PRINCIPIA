import Mathlib
import MathlibExpansion.Roots.Schlessinger.DualNumbers
import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver

/-!
# Dual Numbers — `IsArtinianRing (DualNumber k)` as a Theorem

This file **discharges** the `dualNumberArtinian` axiom from
`MathlibExpansion.Roots.Schlessinger.DualNumberArtinian` by providing a
constructive proof.

## Proof strategy

1. Build an explicit `k`-linear equivalence `DualNumber k ≃ₗ[k] k × k`.
   The SMul on `DualNumber k = TrivSqZeroExt k k` from its `Algebra k _`
   instance satisfies `r • ⟨a, b⟩ = ⟨r * a, r * b⟩`, matching `k × k`.

2. Transfer `Module.Finite k (k × k)` — known by `inferInstance` — to
   `Module.Finite k (DualNumber k)` via the equivalence.

3. Apply `IsArtinianRing.of_finite k (DualNumber k)`, using:
   - `IsArtinianRing k` — `inferInstance` from `DivisionSemiring.instIsArtinianRing`
   - `IsScalarTower k (DualNumber k) (DualNumber k)` — from the Algebra instance
   - `Module.Finite k (DualNumber k)` — step 2

## Axiom ledger impact

Replacing `axiom dualNumberArtinian` with this theorem yields **−1** on the
named-axiom ledger. No new axioms are introduced.
-/

namespace MathlibExpansion.Textbooks.Schlessinger1968.Chapter1

universe u

open TrivSqZeroExt

/-! ### Step 1: explicit linear equivalence `DualNumber k ≃ₗ[k] k × k` -/

/-- Explicit `k`-linear equivalence between the dual-number ring and the
product `k × k`.

The `k`-algebra structure on `DualNumber k = TrivSqZeroExt k k` has
`algebraMap k _ r = inl r = ⟨r, 0⟩`, so the scalar action satisfies
`r • ⟨a, b⟩ = ⟨r, 0⟩ * ⟨a, b⟩ = ⟨r * a, r * b⟩`, which agrees with
the product module action on `k × k`. The map `⟨a, b⟩ ↦ (a, b)` is
therefore `k`-linear. -/
noncomputable def dualNumberLinearEquivProd (k : Type u) [Field k] :
    DualNumber k ≃ₗ[k] k × k where
  toFun x      := (x.fst, x.snd)
  invFun p     := ⟨p.1, p.2⟩
  left_inv x   := TrivSqZeroExt.ext rfl rfl
  right_inv p  := Prod.ext rfl rfl
  map_add' x y := Prod.ext (fst_add x y) (snd_add x y)
  map_smul' r x := by
    simp only [RingHom.id_apply]
    exact Prod.ext (fst_smul r x) (snd_smul r x)

/-! ### Step 2: `Module.Finite k (DualNumber k)` -/

/-- `DualNumber k` is a finitely generated `k`-module.

Proof: `k × k` is finitely generated (it is a free `k`-module of rank 2),
and the linear equivalence transfers this to `DualNumber k`. -/
instance dualNumber_moduleFinite (k : Type u) [Field k] :
    Module.Finite k (DualNumber k) :=
  Module.Finite.of_surjective (dualNumberLinearEquivProd k).symm.toLinearMap
    (dualNumberLinearEquivProd k).symm.surjective

/-! ### Step 3: `IsArtinianRing (DualNumber k)` -/

/-- **Theorem** (was axiom): `DualNumber k` is an Artinian ring.

Applied path:
```
IsArtinianRing k         [DivisionSemiring.instIsArtinianRing]
Module.Finite k (DualNumber k)   [dualNumber_moduleFinite, step 2]
IsScalarTower k (DualNumber k) (DualNumber k)   [Algebra.isScalarTower_left]
─────────────────────────────────────────────────────────────────────────
IsArtinianRing (DualNumber k)    [IsArtinianRing.of_finite]
```
-/
theorem dualNumber_isArtinianRing_theorem (k : Type u) [Field k] :
    IsArtinianRing (DualNumber k) :=
  IsArtinianRing.of_finite k (DualNumber k)

/-- Instance form of the theorem, for typeclass resolution. -/
noncomputable instance dualNumber_isArtinianRing_inst (k : Type u) [Field k] :
    IsArtinianRing (DualNumber k) :=
  dualNumber_isArtinianRing_theorem k

/-! ### Packaging as an `ArtinLocalAlgOver` object -/

open MathlibExpansion.Roots.Schlessinger

/-- `DualNumber k` packaged as an `ArtinLocalAlgOver Λ k` object,
using the theorem-based Artinian instance (not the axiom).

This replaces `ProRepOver.dualNumberObjOver` once `DualNumberArtinian` is
rewritten to use the theorem. -/
noncomputable def dualNumberObjOver_theorem
    (Λ k : Type u) [CommRing Λ] [Field k] [Algebra Λ k] :
    ArtinLocalAlgOver Λ k where
  carrier       := DualNumber k
  instCommRing  := inferInstance
  instAlgebra   := Algebra.compHom (DualNumber k) (algebraMap Λ k)
  instIsArtinian := dualNumber_isArtinianRing_theorem k
  instIsLocal   := inferInstance
  residueEquiv  := (dualNumberResidueEquiv k).toRingEquiv

end MathlibExpansion.Textbooks.Schlessinger1968.Chapter1
