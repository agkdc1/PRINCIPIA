import Mathlib.LinearAlgebra.Isomorphisms
import Mathlib.LinearAlgebra.Prod
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.RingTheory.Ideal.Height
import Mathlib.RingTheory.Ideal.Maps
import Mathlib.RingTheory.Finiteness.Basic
import MathlibExpansion.RingTheory.PowerSeries.LambdaNoetherian

/-!
# Honest pseudo-null calculus for `ℤ_[p]⟦X⟧`

This file introduces the honest height-based pseudo-null predicate for modules
over the one-variable Iwasawa algebra
`Λ = ℤ_[p]⟦X⟧ = PowerSeries ℤ_[p]`.

`IsPseudoNull p M` means that the annihilator of `M` has height at least `2`.
`IsPseudoIso p f` means that both `ker f` and `coker f` are pseudo-null.

Mathlib `v4.17.0` exposes the primitives `Ideal.height` and
`Module.annihilator`. The finite direct-sum and composition calculus below is
proved directly from the height definition and elementary annihilator estimates.
-/

open scoped Padic

namespace MathlibExpansion
namespace RingTheory
namespace PowerSeries

universe u v w

/-- The one-variable Iwasawa algebra `Λ = ℤ_[p]⟦X⟧`. -/
abbrev IwasawaAlgebra (p : ℕ) [Fact p.Prime] : Type :=
  _root_.PowerSeries ℤ_[p]

variable (p : ℕ) [Fact p.Prime]

/-- A `Λ`-module is pseudo-null when its annihilator ideal has height at least `2`. -/
def IsPseudoNull (M : Type u) [AddCommGroup M] [Module (IwasawaAlgebra p) M] : Prop :=
  (2 : ℕ∞) ≤ Ideal.height (Module.annihilator (IwasawaAlgebra p) M)

/-- A `Λ`-linear map is a pseudo-isomorphism when both its kernel and cokernel
are pseudo-null. -/
def IsPseudoIso
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (f : M →ₗ[IwasawaAlgebra p] N) : Prop :=
  IsPseudoNull (p := p) (LinearMap.ker f) ∧
    IsPseudoNull (p := p) (N ⧸ LinearMap.range f)

theorem isPseudoNull_iff
    (M : Type u) [AddCommGroup M] [Module (IwasawaAlgebra p) M] :
    IsPseudoNull (p := p) M ↔
      (2 : ℕ∞) ≤ Ideal.height (Module.annihilator (IwasawaAlgebra p) M) :=
  Iff.rfl

theorem isPseudoIso_iff
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (f : M →ₗ[IwasawaAlgebra p] N) :
    IsPseudoIso (p := p) f ↔
      IsPseudoNull (p := p) (LinearMap.ker f) ∧
        IsPseudoNull (p := p) (N ⧸ LinearMap.range f) :=
  Iff.rfl

theorem isPseudoNull_of_subsingleton
    (M : Type u) [AddCommGroup M] [Module (IwasawaAlgebra p) M] [Subsingleton M] :
    IsPseudoNull (p := p) M := by
  rw [IsPseudoNull,
    (Module.annihilator_eq_top_iff (R := IwasawaAlgebra p) (M := M)).2 inferInstance,
    Ideal.height_top]
  exact le_top

theorem isPseudoNull_punit : IsPseudoNull (p := p) PUnit :=
  isPseudoNull_of_subsingleton (p := p) PUnit

theorem LinearEquiv.isPseudoNull_iff
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (e : M ≃ₗ[IwasawaAlgebra p] N) :
    IsPseudoNull (p := p) M ↔ IsPseudoNull (p := p) N := by
  unfold IsPseudoNull
  rw [e.annihilator_eq]

theorem isPseudoNull_of_surjective
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (f : M →ₗ[IwasawaAlgebra p] N) (hf : Function.Surjective f)
    (hM : IsPseudoNull (p := p) M) :
    IsPseudoNull (p := p) N := by
  unfold IsPseudoNull at hM ⊢
  exact le_trans hM <| Ideal.height_mono <|
    LinearMap.annihilator_le_of_surjective f hf

theorem isPseudoNull_quotient
    {M : Type u} [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    (S : Submodule (IwasawaAlgebra p) M)
    (hM : IsPseudoNull (p := p) M) :
    IsPseudoNull (p := p) (M ⧸ S) :=
  isPseudoNull_of_surjective (p := p) (Submodule.mkQ S)
    (Submodule.mkQ_surjective S) hM

private theorem height_mul_ge_of_height_ge
    {R : Type*} [CommRing R] {I J : Ideal R}
    (hI : (2 : ℕ∞) ≤ I.height) (hJ : (2 : ℕ∞) ≤ J.height) :
    (2 : ℕ∞) ≤ (I * J).height := by
  rw [Ideal.height]
  apply le_iInf₂
  intro P hP
  have hPprime := Ideal.minimalPrimes_isPrime hP
  haveI : P.IsPrime := hPprime
  have hle : I * J ≤ P := hP.1.2
  rcases (hPprime.mul_le).1 hle with hIP | hJP
  · have hheight : (2 : ℕ∞) ≤ P.height := le_trans hI (Ideal.height_mono hIP)
    simpa [Ideal.height_eq_primeHeight P] using hheight
  · have hheight : (2 : ℕ∞) ≤ P.height := le_trans hJ (Ideal.height_mono hJP)
    simpa [Ideal.height_eq_primeHeight P] using hheight

private theorem isPseudoNull_of_mul_le_annihilator
    {M : Type u} [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    {I J : Ideal (IwasawaAlgebra p)}
    (hI : (2 : ℕ∞) ≤ I.height) (hJ : (2 : ℕ∞) ≤ J.height)
    (hle : I * J ≤ Module.annihilator (IwasawaAlgebra p) M) :
    IsPseudoNull (p := p) M := by
  unfold IsPseudoNull
  exact le_trans (height_mul_ge_of_height_ge hI hJ) (Ideal.height_mono hle)

private theorem annihilator_mul_le_prod
    {R : Type*} [CommRing R]
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N] :
    Module.annihilator R M * Module.annihilator R N ≤
      Module.annihilator R (M × N) := by
  rw [Ideal.mul_le]
  intro a ha b hb
  rw [Module.mem_annihilator] at ha hb ⊢
  intro x
  ext
  · simp [mul_smul, ha]
  · simp [mul_smul, hb]

theorem isPseudoIso_ofLinearEquiv
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (e : M ≃ₗ[IwasawaAlgebra p] N) :
    IsPseudoIso (p := p) e.toLinearMap := by
  constructor
  ·
    have hsub : Subsingleton (LinearMap.ker e.toLinearMap) := by
      refine ⟨fun x y => ?_⟩
      apply Subtype.ext
      apply e.injective
      have hx := x.property
      have hy := y.property
      rw [LinearMap.mem_ker] at hx hy
      simp [hx, hy]
    letI : Subsingleton (LinearMap.ker e.toLinearMap) := hsub
    exact isPseudoNull_of_subsingleton (p := p) (LinearMap.ker e.toLinearMap)
  ·
    have hrange : LinearMap.range e.toLinearMap = ⊤ := by
      rw [LinearMap.range_eq_top]
      exact e.surjective
    have hsub : Subsingleton (N ⧸ LinearMap.range e.toLinearMap) := by
      rw [hrange]
      infer_instance
    letI : Subsingleton (N ⧸ LinearMap.range e.toLinearMap) := hsub
    exact isPseudoNull_of_subsingleton (p := p) (N ⧸ LinearMap.range e.toLinearMap)

@[simp] theorem isPseudoIso_id
    (M : Type u) [AddCommGroup M] [Module (IwasawaAlgebra p) M] :
    IsPseudoIso (p := p) (LinearMap.id : M →ₗ[IwasawaAlgebra p] M) := by
  simpa using isPseudoIso_ofLinearEquiv (p := p)
    (LinearEquiv.refl (IwasawaAlgebra p) M)

theorem isPseudoIso_mkQ
    {M : Type u} [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    (S : Submodule (IwasawaAlgebra p) M)
    (hS : IsPseudoNull (p := p) S) :
    IsPseudoIso (p := p) (Submodule.mkQ S) := by
  constructor
  ·
    rw [Submodule.ker_mkQ]
    exact hS
  ·
    have hrange : LinearMap.range (Submodule.mkQ S) = ⊤ := by
      rw [LinearMap.range_eq_top]
      exact Submodule.mkQ_surjective S
    have hsub : Subsingleton ((M ⧸ S) ⧸ LinearMap.range (Submodule.mkQ S)) := by
      rw [hrange]
      infer_instance
    letI : Subsingleton ((M ⧸ S) ⧸ LinearMap.range (Submodule.mkQ S)) := hsub
    exact isPseudoNull_of_subsingleton (p := p)
      ((M ⧸ S) ⧸ LinearMap.range (Submodule.mkQ S))

/-- Bundled honest pseudo-isomorphism over `Λ = ℤ_[p]⟦X⟧`. -/
structure PseudoIsomorphism
    (M : Type u) (N : Type v)
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N] where
  hom : M →ₗ[IwasawaAlgebra p] N
  pseudoNull_kernel : IsPseudoNull (p := p) (LinearMap.ker hom)
  pseudoNull_cokernel : IsPseudoNull (p := p) (N ⧸ LinearMap.range hom)

namespace PseudoIsomorphism

theorem isPseudoIso
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (f : PseudoIsomorphism (p := p) M N) :
    IsPseudoIso (p := p) f.hom :=
  ⟨f.pseudoNull_kernel, f.pseudoNull_cokernel⟩

def ofIsPseudoIso
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (f : M →ₗ[IwasawaAlgebra p] N) (h : IsPseudoIso (p := p) f) :
    PseudoIsomorphism (p := p) M N where
  hom := f
  pseudoNull_kernel := h.1
  pseudoNull_cokernel := h.2

@[simp] theorem ofIsPseudoIso_hom
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (f : M →ₗ[IwasawaAlgebra p] N) (h : IsPseudoIso (p := p) f) :
    (ofIsPseudoIso (p := p) f h).hom = f :=
  rfl

theorem exists_with_hom_iff
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (f : M →ₗ[IwasawaAlgebra p] N) :
    (∃ e : PseudoIsomorphism (p := p) M N, e.hom = f) ↔ IsPseudoIso (p := p) f := by
  constructor
  · rintro ⟨e, rfl⟩
    exact e.isPseudoIso
  · intro h
    exact ⟨ofIsPseudoIso (p := p) f h, rfl⟩

def ofLinearEquiv
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N]
    (e : M ≃ₗ[IwasawaAlgebra p] N) :
    PseudoIsomorphism (p := p) M N :=
  ofIsPseudoIso (p := p) e.toLinearMap (isPseudoIso_ofLinearEquiv (p := p) e)

def refl
    (M : Type u) [AddCommGroup M] [Module (IwasawaAlgebra p) M] :
    PseudoIsomorphism (p := p) M M :=
  ofLinearEquiv (p := p) (LinearEquiv.refl (IwasawaAlgebra p) M)

end PseudoIsomorphism

/-! ## Pseudo-null calculus -/

/-- Honest pseudo-nullity over `ℤ_[p]⟦X⟧` is stable under finite direct sums. -/
theorem isPseudoNull_prod
    {M : Type u} {N : Type v}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M] [Module.Finite (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N] [Module.Finite (IwasawaAlgebra p) N]
    (hM : IsPseudoNull (p := p) M) (hN : IsPseudoNull (p := p) N) :
    IsPseudoNull (p := p) (M × N) := by
  exact isPseudoNull_of_mul_le_annihilator (p := p) hM hN annihilator_mul_le_prod

/-- Honest pseudo-isomorphisms over `ℤ_[p]⟦X⟧` are stable under composition. -/
theorem isPseudoIso_comp
    {M : Type u} {N : Type v} {P : Type w}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M] [Module.Finite (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N] [Module.Finite (IwasawaAlgebra p) N]
    [AddCommGroup P] [Module (IwasawaAlgebra p) P] [Module.Finite (IwasawaAlgebra p) P]
    {f : M →ₗ[IwasawaAlgebra p] N} {g : N →ₗ[IwasawaAlgebra p] P}
    (hg : IsPseudoIso (p := p) g) (hf : IsPseudoIso (p := p) f) :
    IsPseudoIso (p := p) (g.comp f) := by
  constructor
  · refine isPseudoNull_of_mul_le_annihilator (p := p) hf.1 hg.1 ?_
    rw [Ideal.mul_le]
    intro a ha b hb
    rw [Module.mem_annihilator] at ha hb ⊢
    intro x
    apply Subtype.ext
    change (a * b) • (x : M) = 0
    rw [mul_smul]
    have hxg : f (x : M) ∈ LinearMap.ker g := by
      rw [LinearMap.mem_ker]
      exact x.property
    have hbzero : b • f (x : M) = 0 := by
      simpa using congrArg (fun y : LinearMap.ker g => (y : N)) (hb ⟨f (x : M), hxg⟩)
    have hkerf : b • (x : M) ∈ LinearMap.ker f := by
      simp [LinearMap.mem_ker, map_smul, hbzero]
    have hazero : a • (b • (x : M)) = 0 := by
      simpa using congrArg (fun y : LinearMap.ker f => (y : M))
        (ha ⟨b • (x : M), hkerf⟩)
    simpa using hazero
  · refine isPseudoNull_of_mul_le_annihilator (p := p) hf.2 hg.2 ?_
    rw [Ideal.mul_le]
    intro a ha b hb
    rw [Module.mem_annihilator] at ha hb ⊢
    intro yq
    refine Submodule.Quotient.induction_on _ yq ?_
    intro y
    change
      (Submodule.Quotient.mk ((a * b) • y) :
        P ⧸ LinearMap.range (g.comp f)) = 0
    rw [Submodule.Quotient.mk_eq_zero]
    have hy_range_g : b • y ∈ LinearMap.range g := by
      have hbzero :
          (Submodule.Quotient.mk (b • y) : P ⧸ LinearMap.range g) = 0 := by
        simpa [Submodule.Quotient.mk_smul] using
          hb (Submodule.Quotient.mk y : P ⧸ LinearMap.range g)
      exact (Submodule.Quotient.mk_eq_zero (LinearMap.range g)).mp hbzero
    obtain ⟨n, hn⟩ := hy_range_g
    have hn_range_f : a • n ∈ LinearMap.range f := by
      have hazero :
          (Submodule.Quotient.mk (a • n) : N ⧸ LinearMap.range f) = 0 := by
        simpa [Submodule.Quotient.mk_smul] using
          ha (Submodule.Quotient.mk n : N ⧸ LinearMap.range f)
      exact (Submodule.Quotient.mk_eq_zero (LinearMap.range f)).mp hazero
    obtain ⟨m, hm⟩ := hn_range_f
    refine ⟨m, ?_⟩
    calc
      (g.comp f) m = g (f m) := rfl
      _ = g (a • n) := by rw [hm]
      _ = a • g n := by rw [map_smul]
      _ = a • (b • y) := by rw [hn]
      _ = (a * b) • y := by rw [mul_smul]

/-- Honest pseudo-isomorphisms over `ℤ_[p]⟦X⟧` are stable under binary direct sums. -/
theorem isPseudoIso_prodMap
    {M₁ : Type u} {M₂ : Type v} {N₁ : Type w} {N₂ : Type*}
    [AddCommGroup M₁] [Module (IwasawaAlgebra p) M₁] [Module.Finite (IwasawaAlgebra p) M₁]
    [AddCommGroup M₂] [Module (IwasawaAlgebra p) M₂] [Module.Finite (IwasawaAlgebra p) M₂]
    [AddCommGroup N₁] [Module (IwasawaAlgebra p) N₁] [Module.Finite (IwasawaAlgebra p) N₁]
    [AddCommGroup N₂] [Module (IwasawaAlgebra p) N₂] [Module.Finite (IwasawaAlgebra p) N₂]
    {f : M₁ →ₗ[IwasawaAlgebra p] N₁} {g : M₂ →ₗ[IwasawaAlgebra p] N₂}
    (hf : IsPseudoIso (p := p) f) (hg : IsPseudoIso (p := p) g) :
    IsPseudoIso (p := p) (LinearMap.prodMap f g) := by
  constructor
  · refine isPseudoNull_of_mul_le_annihilator (p := p) hf.1 hg.1 ?_
    rw [Ideal.mul_le]
    intro a ha b hb
    rw [Module.mem_annihilator] at ha hb ⊢
    intro x
    apply Subtype.ext
    change (a * b) • (x : M₁ × M₂) = 0
    ext
    · rw [Prod.smul_fst, mul_smul]
      have hx1 : f (x : M₁ × M₂).1 = 0 := by
        have hxpair : (f (x : M₁ × M₂).1, g (x : M₁ × M₂).2) = (0, 0) :=
          x.property
        exact congrArg Prod.fst hxpair
      have hkerf : b • (x : M₁ × M₂).1 ∈ LinearMap.ker f := by
        simp [LinearMap.mem_ker, map_smul, hx1]
      have hazero : a • (b • (x : M₁ × M₂).1) = 0 := by
        simpa using congrArg (fun y : LinearMap.ker f => (y : M₁))
          (ha ⟨b • (x : M₁ × M₂).1, hkerf⟩)
      exact hazero
    · rw [Prod.smul_snd, mul_smul]
      have hx2 : g (x : M₁ × M₂).2 = 0 := by
        have hxpair : (f (x : M₁ × M₂).1, g (x : M₁ × M₂).2) = (0, 0) :=
          x.property
        exact congrArg Prod.snd hxpair
      have hkerg : (x : M₁ × M₂).2 ∈ LinearMap.ker g :=
        hx2
      have hbzero : b • (x : M₁ × M₂).2 = 0 := by
        simpa using congrArg (fun y : LinearMap.ker g => (y : M₂))
          (hb ⟨(x : M₁ × M₂).2, hkerg⟩)
      simp [hbzero]
  · refine isPseudoNull_of_mul_le_annihilator (p := p) hf.2 hg.2 ?_
    rw [Ideal.mul_le]
    intro a ha b hb
    rw [Module.mem_annihilator] at ha hb ⊢
    intro yq
    refine Submodule.Quotient.induction_on _ yq ?_
    intro y
    change
      (Submodule.Quotient.mk ((a * b) • y) :
        (N₁ × N₂) ⧸ LinearMap.range (LinearMap.prodMap f g)) = 0
    rw [Submodule.Quotient.mk_eq_zero]
    have hy1_range_f : a • y.1 ∈ LinearMap.range f := by
      have hazero :
          (Submodule.Quotient.mk (a • y.1) : N₁ ⧸ LinearMap.range f) = 0 := by
        simpa [Submodule.Quotient.mk_smul] using
          ha (Submodule.Quotient.mk y.1 : N₁ ⧸ LinearMap.range f)
      exact (Submodule.Quotient.mk_eq_zero (LinearMap.range f)).mp hazero
    have hy2_range_g : b • y.2 ∈ LinearMap.range g := by
      have hbzero :
          (Submodule.Quotient.mk (b • y.2) : N₂ ⧸ LinearMap.range g) = 0 := by
        simpa [Submodule.Quotient.mk_smul] using
          hb (Submodule.Quotient.mk y.2 : N₂ ⧸ LinearMap.range g)
      exact (Submodule.Quotient.mk_eq_zero (LinearMap.range g)).mp hbzero
    have hy1 : (a * b) • y.1 ∈ LinearMap.range f := by
      rw [mul_comm, mul_smul]
      exact Submodule.smul_mem _ b hy1_range_f
    have hy2 : (a * b) • y.2 ∈ LinearMap.range g := by
      rw [mul_smul]
      exact Submodule.smul_mem _ a hy2_range_g
    obtain ⟨m₁, hm₁⟩ := hy1
    obtain ⟨m₂, hm₂⟩ := hy2
    refine ⟨(m₁, m₂), ?_⟩
    ext <;> simp [hm₁, hm₂]

theorem isPseudoIso_assoc
    {M : Type u} {N : Type v} {P : Type w} {Q : Type*}
    [AddCommGroup M] [Module (IwasawaAlgebra p) M] [Module.Finite (IwasawaAlgebra p) M]
    [AddCommGroup N] [Module (IwasawaAlgebra p) N] [Module.Finite (IwasawaAlgebra p) N]
    [AddCommGroup P] [Module (IwasawaAlgebra p) P] [Module.Finite (IwasawaAlgebra p) P]
    [AddCommGroup Q] [Module (IwasawaAlgebra p) Q] [Module.Finite (IwasawaAlgebra p) Q]
    {f : M →ₗ[IwasawaAlgebra p] N}
    {g : N →ₗ[IwasawaAlgebra p] P}
    {h : P →ₗ[IwasawaAlgebra p] Q}
    (hh : IsPseudoIso (p := p) h)
    (hg : IsPseudoIso (p := p) g)
    (hf : IsPseudoIso (p := p) f) :
    IsPseudoIso (p := p) (h.comp (g.comp f)) := by
  simpa [LinearMap.comp_assoc] using
    isPseudoIso_comp (p := p) hh (isPseudoIso_comp (p := p) hg hf)

end PowerSeries
end RingTheory
end MathlibExpansion
