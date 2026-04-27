import Mathlib
import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver
import MathlibExpansion.Textbooks.Schlessinger1968.Chapter1.CLambda

/-!
# Small Extensions in C_Λ(k)

A **small extension** over `Λ` is a surjective `Λ`-algebra homomorphism
`p : A' → A` whose kernel is square-zero and rank-1 over `Λ`.

These are the inductive building blocks of the hull construction in
Schlessinger's pro-representability theorem (1968, §2).
-/

namespace MathlibExpansion.Textbooks.Schlessinger1968.Chapter2

universe u

open MathlibExpansion.Roots.Schlessinger
open MathlibExpansion.Textbooks.Schlessinger1968.Chapter1
open IsLocalRing

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-! ### Kernel of a morphism -/

/-- Kernel ideal of a `Λ`-algebra map, as an ideal of the source carrier. -/
def algHomKer {A B : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] B.carrier) : Ideal A.carrier :=
  RingHom.ker f.toRingHom

@[simp]
theorem mem_algHomKer {A B : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] B.carrier) (x : A.carrier) :
    x ∈ algHomKer f ↔ f x = 0 :=
  RingHom.mem_ker

/-! ### Small extension structure -/

/-- A **small extension** over `Λ`: a surjective `C_Λ`-morphism `A' → A`
with square-zero, `Λ`-rank-1 kernel. -/
structure SmallExtensionOver
    (A' A : ArtinLocalAlgOver Λ k) where
  toAlgHom     : A'.carrier →ₐ[Λ] A.carrier
  surj         : Function.Surjective toAlgHom.toFun
  ker_sqZero   : (algHomKer toAlgHom) ^ 2 = ⊥
  ker_rank_one : Module.finrank Λ ↥(algHomKer toAlgHom) = 1

namespace SmallExtensionOver

variable {A' A : ArtinLocalAlgOver Λ k}

theorem surjective (s : SmallExtensionOver A' A) :
    Function.Surjective s.toAlgHom.toFun := s.surj

theorem kernel_sq_zero (s : SmallExtensionOver A' A) :
    (algHomKer s.toAlgHom) ^ 2 = ⊥ := s.ker_sqZero

theorem kernel_rank (s : SmallExtensionOver A' A) :
    Module.finrank Λ ↥(algHomKer s.toAlgHom) = 1 := s.ker_rank_one

/-- Elements of `ker(p)` are non-units. -/
theorem ker_nonunit (s : SmallExtensionOver A' A) {x : A'.carrier}
    (hx : x ∈ algHomKer s.toAlgHom) : ¬IsUnit x := by
  intro hu
  have h0 : IsUnit (s.toAlgHom x) := hu.map s.toAlgHom
  rw [(mem_algHomKer s.toAlgHom x).mp hx] at h0
  exact not_isUnit_zero h0

/-- `ker(p) ⊆ m_{A'}`: the kernel is contained in the maximal ideal. -/
theorem ker_le_maximalIdeal (s : SmallExtensionOver A' A) :
    algHomKer s.toAlgHom ≤ maximalIdeal A'.carrier := by
  intro x hx
  exact (mem_maximalIdeal x).mpr (s.ker_nonunit hx)

/-- A surjection between local rings is a local ring hom.

**Proof**: Choose `b` with `f(b) = f(a)⁻¹`. Then `a * b - 1 ∈ ker(f) ⊆ m_{A'}`.
Hence `a * b ∉ m_{A'}`, so `a * b` is a unit, forcing `a` to be a unit. -/
theorem isLocalHom (s : SmallExtensionOver A' A) :
    IsLocalHom s.toAlgHom.toRingHom := by
  constructor
  intro a hu
  obtain ⟨u, hu_eq⟩ := hu
  obtain ⟨b, hb⟩ := s.surj (↑u⁻¹ : A.carrier)
  -- Definitional equalities bridge .toRingHom/.toFun and direct application
  have h_fa : s.toAlgHom a = ↑u := hu_eq.symm
  have h_fb : s.toAlgHom b = ↑u⁻¹ := hb
  -- f(a * b) = 1
  have hab1 : s.toAlgHom (a * b) = 1 := by
    rw [map_mul, h_fa, h_fb]
    simp
  -- a * b - 1 ∈ ker ⊆ m_{A'}
  have hker : a * b - 1 ∈ algHomKer s.toAlgHom := by
    rw [mem_algHomKer, map_sub, hab1, map_one, sub_self]
  have hmem : a * b - 1 ∈ maximalIdeal A'.carrier :=
    s.ker_le_maximalIdeal hker
  -- a * b is a unit
  have hab_unit : IsUnit (a * b) := by
    by_contra h_nu
    have h_ab_mem : a * b ∈ maximalIdeal A'.carrier :=
      (mem_maximalIdeal _).mpr h_nu
    have h1 : (1 : A'.carrier) ∈ maximalIdeal A'.carrier := by
      have heq : (1 : A'.carrier) = a * b - (a * b - 1) := by ring
      rw [heq]
      exact Ideal.sub_mem _ h_ab_mem hmem
    exact (mem_maximalIdeal _).mp h1 isUnit_one
  -- a is a unit (product a * b is a unit, so a must be)
  by_contra ha_nu
  have ha_mem : a ∈ maximalIdeal A'.carrier :=
    (mem_maximalIdeal _).mpr ha_nu
  exact (mem_maximalIdeal _).mp (Ideal.mul_mem_right b _ ha_mem) hab_unit

/-- Package a small extension as a `ResidueFixedHom`. -/
noncomputable def toResidueFixedHom (s : SmallExtensionOver A' A) :
    ResidueFixedHom A' A :=
  ⟨s.toAlgHom, s.isLocalHom⟩

end SmallExtensionOver

end MathlibExpansion.Textbooks.Schlessinger1968.Chapter2
