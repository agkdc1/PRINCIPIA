import MathlibExpansion.Roots.Iwasawa.Basic

/-!
# Iwasawa Pseudo-isomorphisms

Defines the pseudo-isomorphism relation for Λ-modules and bundles it as a
structure.  Includes the finite-module pseudo-zero calculus.

## Blindspot C gap wall

`IsPseudoIsomorphism` below uses `Finite` kernel/cokernel.  For the classical
Iwasawa algebra `Λ = ℤ_p[[T]]` (Krull dim 2, regular local ring), the correct
notion of pseudo-null is **finite-length as a Λ-module**, equivalently:
annihilator ideal has height ≥ 2.

`Module.Finite` over `Λ` is strictly weaker: `Λ/(p)` is Λ-finite but is NOT
pseudo-null (its annihilator `(p)` has height 1).  The gap is flagged:

  `HasProperPseudoNullCalculusAPI := False`

Until Mathlib exposes height-≥2 / finite-length theory for regular local rings
of Krull dimension 2, all pseudo-isomorphism arguments here are conditional on
this gap being filled.
-/

namespace MathlibExpansion
namespace Roots
namespace Iwasawa

universe u v

/-- A linear map is a (weak) pseudo-isomorphism when its kernel and cokernel
are both `Finite` as types.

**Gap wall**: see `HasProperPseudoNullCalculusAPI`. -/
def IsPseudoIsomorphism {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) : Prop :=
  Finite (LinearMap.ker f) ∧ Finite (N ⧸ LinearMap.range f)

/-- Gap wall: height-≥2 pseudo-null calculus for `Λ = ℤ_p[[T]]` is missing
from Mathlib.  `Λ/(p)` is `Module.Finite` but not pseudo-null.  The current
`IsPseudoIsomorphism` predicate does not enforce the height-≥2 condition.

Ref for the correct definition: Washington §13.1; Neukirch-Schmidt-Wingberg
§5.1; Bourbaki *Comm. Alg.* VII §4.4. -/
def HasProperPseudoNullCalculusAPI : Prop := False

theorem isPseudoIsomorphism_iff {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) :
    IsPseudoIsomorphism f ↔
      Finite (LinearMap.ker f) ∧ Finite (N ⧸ LinearMap.range f) :=
  Iff.rfl

/-- Bundled pseudo-isomorphism between two Λ-modules. -/
structure PseudoIsomorphism {R : Type u} [CommRing R]
    (M N : Type v) [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N] where
  hom : M →ₗ[Lambda R] N
  finite_kernel : Finite (LinearMap.ker hom)
  finite_cokernel : Finite (N ⧸ LinearMap.range hom)

namespace PseudoIsomorphism

theorem isPseudoIsomorphism {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : PseudoIsomorphism (R := R) M N) :
    IsPseudoIsomorphism f.hom :=
  ⟨f.finite_kernel, f.finite_cokernel⟩

def ofIsPseudoIsomorphism {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) (h : IsPseudoIsomorphism f) :
    PseudoIsomorphism (R := R) M N where
  hom := f
  finite_kernel := h.1
  finite_cokernel := h.2

@[simp] theorem ofIsPseudoIsomorphism_hom {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) (h : IsPseudoIsomorphism f) :
    (ofIsPseudoIsomorphism (R := R) f h).hom = f :=
  rfl

theorem exists_pseudoIsomorphism_with_hom_iff {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (f : M →ₗ[Lambda R] N) :
    (∃ e : PseudoIsomorphism (R := R) M N, e.hom = f) ↔ IsPseudoIsomorphism f := by
  constructor
  · rintro ⟨e, rfl⟩; exact e.isPseudoIsomorphism
  · intro h; exact ⟨ofIsPseudoIsomorphism f h, rfl⟩

noncomputable def ofLinearEquiv {R : Type u} [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N]
    (e : M ≃ₗ[Lambda R] N) : PseudoIsomorphism (R := R) M N where
  hom := e.toLinearMap
  finite_kernel := by
    have hsub : Subsingleton (LinearMap.ker e.toLinearMap) := by
      refine ⟨fun x y => ?_⟩
      apply Subtype.ext
      have hx : (x : M) = 0 := by
        apply e.injective
        have hp := x.property; rw [LinearMap.mem_ker] at hp; rw [map_zero]; exact hp
      have hy : (y : M) = 0 := by
        apply e.injective
        have hp := y.property; rw [LinearMap.mem_ker] at hp; rw [map_zero]; exact hp
      rw [hx, hy]
    haveI : Subsingleton (LinearMap.ker e.toLinearMap) := hsub
    haveI : Fintype (LinearMap.ker e.toLinearMap) := Fintype.ofSubsingleton 0
    infer_instance
  finite_cokernel := by
    have hrange : LinearMap.range e.toLinearMap = ⊤ := by
      ext y; constructor
      · intro _; exact Submodule.mem_top
      · intro _; exact ⟨e.symm y, by simp⟩
    have hsub : Subsingleton (N ⧸ LinearMap.range e.toLinearMap) := by
      rw [hrange]; infer_instance
    haveI : Subsingleton (N ⧸ LinearMap.range e.toLinearMap) := hsub
    haveI : Fintype (N ⧸ LinearMap.range e.toLinearMap) := Fintype.ofSubsingleton 0
    infer_instance

noncomputable def refl {R : Type u} [CommRing R]
    (M : Type v) [AddCommGroup M] [Module (Lambda R) M] :
    PseudoIsomorphism (R := R) M M :=
  ofLinearEquiv (LinearEquiv.refl (Lambda R) M)

end PseudoIsomorphism

/-! ## Finite module pseudo-zero calculus -/

/-- Any finite Λ-module maps pseudo-isomorphically to zero. -/
noncomputable def finiteModulePseudoToZero (R : Type u) [CommRing R]
    (M : Type v) [AddCommGroup M] [Module (Lambda R) M] [Finite M] :
    PseudoIsomorphism (R := R) M PUnit where
  hom := 0
  finite_kernel := by
    haveI : Fintype M := Fintype.ofFinite M
    haveI : Fintype (LinearMap.ker (0 : M →ₗ[Lambda R] PUnit)) :=
      Fintype.ofInjective Subtype.val (fun _ _ h => Subtype.ext h)
    infer_instance
  finite_cokernel := by
    haveI : Fintype (PUnit ⧸ LinearMap.range (0 : M →ₗ[Lambda R] PUnit)) :=
      Submodule.Quotient.fintype (LinearMap.range (0 : M →ₗ[Lambda R] PUnit))
    infer_instance

theorem finiteModuleMap_isPseudoIsomorphism (R : Type u) [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N] [Finite M] [Finite N]
    (f : M →ₗ[Lambda R] N) : IsPseudoIsomorphism f := by
  constructor
  · haveI : Fintype M := Fintype.ofFinite M
    haveI : Fintype (LinearMap.ker f) :=
      Fintype.ofInjective Subtype.val (fun _ _ h => Subtype.ext h)
    infer_instance
  · haveI : Fintype N := Fintype.ofFinite N
    haveI : Fintype (N ⧸ LinearMap.range f) := Submodule.Quotient.fintype (LinearMap.range f)
    infer_instance

def finiteModuleMapPseudoIsomorphism (R : Type u) [CommRing R]
    {M N : Type v} [AddCommGroup M] [Module (Lambda R) M]
    [AddCommGroup N] [Module (Lambda R) N] [Finite M] [Finite N]
    (f : M →ₗ[Lambda R] N) : PseudoIsomorphism (R := R) M N where
  hom := f
  finite_kernel := (finiteModuleMap_isPseudoIsomorphism R f).1
  finite_cokernel := (finiteModuleMap_isPseudoIsomorphism R f).2

noncomputable def finiteModulePseudoFromZero (R : Type u) [CommRing R]
    (M : Type v) [AddCommGroup M] [Module (Lambda R) M] [Finite M] :
    PseudoIsomorphism (R := R) PUnit M :=
  finiteModuleMapPseudoIsomorphism R (0 : PUnit →ₗ[Lambda R] M)

theorem finiteModules_pseudoEquivalent (R : Type u) [CommRing R]
    (M N : Type v) [AddCommGroup M] [Module (Lambda R) M] [Finite M]
    [AddCommGroup N] [Module (Lambda R) N] [Finite N] :
    Nonempty (PseudoIsomorphism (R := R) M N) ∧
      Nonempty (PseudoIsomorphism (R := R) N M) :=
  ⟨⟨finiteModuleMapPseudoIsomorphism R (0 : M →ₗ[Lambda R] N)⟩,
    ⟨finiteModuleMapPseudoIsomorphism R (0 : N →ₗ[Lambda R] M)⟩⟩

end Iwasawa
end Roots
end MathlibExpansion
