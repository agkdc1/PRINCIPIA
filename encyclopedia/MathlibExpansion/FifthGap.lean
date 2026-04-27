/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.FirstGap
import MathlibExpansion.FourthGap

/-!
# Galois representations attached to Hecke eigenforms

This file supplies the next interface after a Hecke eigenvalue system: an
assertion that a Galois representation is attached to a modular Hecke
eigenform. This is the fifth atomic bridge in the FLT modularity dependency
chain, representing the interface of Deligne's construction without proving
the construction.
-/

universe u v w

open scoped MatrixGroups

namespace NumberTheory

/--
A Galois representation is attached to a modular Hecke eigenform if it comes
with Frobenius elements indexed by the same labels as the Hecke operators and
a compatibility statement at every index.

The field `frobeniusCompatibility` is intentionally an indexed proposition:
later developments can instantiate it with the usual trace and determinant
relations between `ρ (Frob_l)` and the Hecke eigenvalues of `f` once the
required arithmetic coefficient and unramified-prime infrastructure is
available.
-/
structure GaloisRepresentationAttachedToEigenform {Γ : Subgroup SL(2, ℤ)}
    {k : ℤ} {ι : Type*} {G : Type u} {R : Type v} {M : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace R] [Semiring R]
    [TopologicalSpace M] [AddCommMonoid M] [Module R M]
    [TopologicalSpace (M ≃ₗ[R] M)]
    (T : ι → HeckeOperator Γ k) (f : ModularForm Γ k)
    (system : HeckeEigenvalueSystem T f)
    (ρ : GaloisRepresentation G R M) where
  frobenius : ι → G
  frobeniusCompatibility : ι → Prop
  compatible : ∀ i, frobeniusCompatibility i

/--
Recover the indexed Frobenius-Hecke compatibility statement from an attached
Galois representation interface.
-/
theorem GaloisRepresentationAttachedToEigenform.compatible_at
    {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {ι : Type*} {G : Type u} {R : Type v}
    {M : Type w} [TopologicalSpace G] [Monoid G] [TopologicalSpace R]
    [Semiring R] [TopologicalSpace M] [AddCommMonoid M] [Module R M]
    [TopologicalSpace (M ≃ₗ[R] M)] {T : ι → HeckeOperator Γ k}
    {f : ModularForm Γ k} {system : HeckeEigenvalueSystem T f}
    {ρ : GaloisRepresentation G R M}
    (h : GaloisRepresentationAttachedToEigenform T f system ρ) (i : ι) :
    h.frobeniusCompatibility i :=
  h.compatible i

/--
Reindex an attached Galois representation interface along a map of index
types. This lets later files restrict from all Hecke operators to a selected
family, such as primes away from the level.
-/
@[simps]
def GaloisRepresentationAttachedToEigenform.reindex {Γ : Subgroup SL(2, ℤ)}
    {k : ℤ} {ι κ : Type*} {G : Type u} {R : Type v} {M : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace R] [Semiring R]
    [TopologicalSpace M] [AddCommMonoid M] [Module R M]
    [TopologicalSpace (M ≃ₗ[R] M)] {T : ι → HeckeOperator Γ k}
    {f : ModularForm Γ k} {system : HeckeEigenvalueSystem T f}
    {ρ : GaloisRepresentation G R M}
    (h : GaloisRepresentationAttachedToEigenform T f system ρ) (e : κ → ι) :
    GaloisRepresentationAttachedToEigenform (fun j => T (e j)) f
      { eigenvalue := fun j => system.eigenvalue (e j)
        is_eigenform := fun j => system.is_eigenform (e j) } ρ where
  frobenius j := h.frobenius (e j)
  frobeniusCompatibility j := h.frobeniusCompatibility (e j)
  compatible j := h.compatible (e j)

end NumberTheory
