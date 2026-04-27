import MathlibExpansion.Roots.HodgeTate.ContinuousRepresentation
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.Algebra.Algebra.Equiv
import Mathlib.Topology.Algebra.Group.Basic
import Mathlib.Topology.Algebra.Ring.Basic

/-!
# The C_p package and the cyclotomic character

Bundles the data of C_p (the completed algebraic closure of ℚ_p), its absolute
Galois group action, and the cyclotomic character into explicit structures.

## Key design: galoisAction via AlgEquiv[Khat]

`galoisAction` lands in `Cp ≃ₐ[Khat] Cp` (Khat-algebra automorphisms), NOT
in bare ring automorphisms. This makes `galoisAction_fixes_khat` a *theorem*
that follows from `AlgEquiv.commutes` — no extra axiom required, and no
Phantom-Arity vacuity from an unconstrained action.

## Key design: cyclotomic character into (ℤ_[p])ˣ

The cyclotomic character `χ : G →* (ℤ_[p])ˣ` lands in the p-adic integer
units, not in Cp×. This makes `χ(g)^n` for `n : ℤ` well-defined via `zpow`
on the group `(ℤ_[p])ˣ`, and the embedding `(ℤ_[p])ˣ ↪ Cp×` is separate.

References: Washington §6.3; Serre "Local Fields" §II; Neukirch-Schmidt-Wingberg.
-/

namespace MathlibExpansion.Roots.HodgeTate

/-- The package of data representing the p-adic period ring C_p and its Galois
symmetry over a p-adic base field Khat.

Fields marked `[...]` are bundled instances that consumers activate locally via
`haveI := pkg.instField_Cp` etc. -/
structure CpPackage (p : ℕ) [Fact p.Prime] (Khat : Type*) [Field Khat] where
  /-- The carrier type for C_p. Mathlib has no native C_p in v4.17.0. -/
  Cp : Type*
  /-- C_p is a field. -/
  instField_Cp : Field Cp
  /-- C_p is a Khat-algebra: the embedding Khat ↪ C_p. Using `Algebra Khat Cp`
      rather than a bare ring map means `galoisAction` (as AlgEquiv[Khat])
      automatically fixes Khat images — see `galoisAction_fixes_khat`. -/
  instAlgebra_Khat_Cp : Algebra Khat Cp
  /-- Topology on C_p (ultrametric p-adic topology). -/
  instTopSpace_Cp : TopologicalSpace Cp
  /-- The absolute Galois group G_K (Gal(K̄/K)). -/
  G : Type*
  /-- G is a group. -/
  instGroup_G : Group G
  /-- G carries a topology (profinite). -/
  instTopSpace_G : TopologicalSpace G
  /-- The Galois action: each g ∈ G acts as a Khat-algebra automorphism of C_p.
      The AlgEquiv[Khat] type forces the action to fix Khat automatically. -/
  galoisAction : G →* (Cp ≃ₐ[Khat] Cp)
  /-- Joint continuity of the Galois action on C_p. -/
  galoisAction_continuous : Continuous (fun gv : G × Cp => galoisAction gv.1 gv.2)
  /-- The ring embedding ℤ_[p] →+* C_p, used to define Tate twist scalars.
      Kept separate from Algebra Khat Cp to avoid requiring ℤ_p ⊆ Khat
      as a typeclass dependency. -/
  algebraMap_zp : ℤ_[p] →+* Cp
  /-- `G` is a topological group. Required for joint continuity of the
      twist action `(g, v) ↦ ε_p(g)^n · σ_g(v)`. -/
  instTopGroup_G : @IsTopologicalGroup G instTopSpace_G instGroup_G
  /-- `Cp` is a topological ring. Required to compose continuity of the
      twist action across multiplication `ε_p(g)^n · σ_g(v)`. -/
  instTopRing_Cp :
    letI := instField_Cp
    letI := instTopSpace_Cp
    IsTopologicalRing Cp
  /-- The embedding `ℤ_[p] →+* Cp` is continuous. -/
  algebraMap_zp_continuous :
    @Continuous ℤ_[p] Cp _ instTopSpace_Cp algebraMap_zp
  /-- The Galois action fixes the image of `algebraMap_zp`. This is the
      arithmetic fact that the `ℤ_p`-scalars lie in the Galois-fixed subring
      (concretely: they lie in `Khat`, which is fixed by the AlgEquiv action). -/
  galoisAction_fixes_zp :
    letI := instField_Cp
    ∀ (g : G) (y : ℤ_[p]), galoisAction g (algebraMap_zp y) = algebraMap_zp y

namespace CpPackage

variable {p : ℕ} [Fact p.Prime] {Khat : Type*} [Field Khat]

/-- The Galois action fixes every element of Khat embedded into C_p. -/
theorem galoisAction_fixes_khat (pkg : CpPackage p Khat) (g : pkg.G) (x : Khat) :
    letI := pkg.instField_Cp
    letI := pkg.instAlgebra_Khat_Cp
    pkg.galoisAction g (algebraMap Khat pkg.Cp x) = algebraMap Khat pkg.Cp x := by
  letI := pkg.instField_Cp
  letI := pkg.instAlgebra_Khat_Cp
  exact (pkg.galoisAction g).commutes x

/-- The Galois automorphism at g preserves addition. -/
theorem galoisAction_map_add (pkg : CpPackage p Khat) (g : pkg.G) (x y : pkg.Cp) :
    letI := pkg.instField_Cp
    pkg.galoisAction g (x + y) = pkg.galoisAction g x + pkg.galoisAction g y := by
  letI := pkg.instField_Cp
  exact map_add (pkg.galoisAction g) x y

/-- The Galois automorphism at g preserves multiplication. -/
theorem galoisAction_map_mul (pkg : CpPackage p Khat) (g : pkg.G) (x y : pkg.Cp) :
    letI := pkg.instField_Cp
    pkg.galoisAction g (x * y) = pkg.galoisAction g x * pkg.galoisAction g y := by
  letI := pkg.instField_Cp
  exact map_mul (pkg.galoisAction g) x y

/-- The identity group element acts as the identity on C_p. -/
theorem galoisAction_one (pkg : CpPackage p Khat) (x : pkg.Cp) :
    letI := pkg.instField_Cp
    letI := pkg.instGroup_G
    pkg.galoisAction 1 x = x := by
  letI := pkg.instField_Cp
  letI := pkg.instGroup_G
  have h : pkg.galoisAction 1 = 1 := pkg.galoisAction.map_one
  simp [h]

/-- The Galois action is multiplicative (composition of automorphisms). -/
theorem galoisAction_mul (pkg : CpPackage p Khat) (g h : pkg.G) (x : pkg.Cp) :
    letI := pkg.instField_Cp
    letI := pkg.instGroup_G
    pkg.galoisAction (g * h) x = pkg.galoisAction g (pkg.galoisAction h x) := by
  letI := pkg.instField_Cp
  letI := pkg.instGroup_G
  have heq : pkg.galoisAction (g * h) = pkg.galoisAction g * pkg.galoisAction h :=
    pkg.galoisAction.map_mul g h
  simp only [heq, AlgEquiv.mul_apply]

/-- The Galois automorphism maps zero to zero. -/
theorem galoisAction_map_zero (pkg : CpPackage p Khat) (g : pkg.G) :
    letI := pkg.instField_Cp
    pkg.galoisAction g 0 = 0 := by
  letI := pkg.instField_Cp
  exact map_zero (pkg.galoisAction g)

/-- The algebraMap_zp embedding preserves addition. -/
theorem algebraMap_zp_map_add (pkg : CpPackage p Khat) (x y : ℤ_[p]) :
    letI := pkg.instField_Cp
    pkg.algebraMap_zp (x + y) = pkg.algebraMap_zp x + pkg.algebraMap_zp y := by
  letI := pkg.instField_Cp
  exact pkg.algebraMap_zp.map_add x y

theorem algebraMap_zp_map_mul (pkg : CpPackage p Khat) (x y : ℤ_[p]) :
    letI := pkg.instField_Cp
    pkg.algebraMap_zp (x * y) = pkg.algebraMap_zp x * pkg.algebraMap_zp y := by
  letI := pkg.instField_Cp
  exact pkg.algebraMap_zp.map_mul x y

theorem algebraMap_zp_map_one (pkg : CpPackage p Khat) :
    letI := pkg.instField_Cp
    pkg.algebraMap_zp 1 = 1 := by
  letI := pkg.instField_Cp
  exact pkg.algebraMap_zp.map_one

end CpPackage

/-- The p-adic cyclotomic character: a continuous homomorphism G → (ℤ_[p])ˣ.

The target is the units of the p-adic integers, not C_p×, so that integer
powers `χ(g)^n` for `n : ℤ` are well-defined via `zpow` on the group `(ℤ_[p])ˣ`.
The embedding `(ℤ_[p])ˣ ↪ C_p×` is a separate datum in each CpPackage.

Reference: Washington "Introduction to Cyclotomic Fields" §6.3. -/
structure ContinuousCyclotomicCharacter (p : ℕ) [Fact p.Prime]
    (G : Type*) [Group G] [TopologicalSpace G] where
  /-- The underlying group homomorphism G →* (ℤ_[p])ˣ. -/
  toMonoidHom : G →* (ℤ_[p])ˣ
  /-- Continuity of the character (p-adic topology on ℤ_[p]). -/
  continuous_toFun : Continuous (fun g => ((toMonoidHom g : (ℤ_[p])ˣ) : ℤ_[p]))
  /-- Continuity of each integer power `g ↦ (χ(g)^n : ℤ_[p])`. This is needed
      to compose with the continuous embedding `algebraMap_zp : ℤ_[p] → Cp`
      when building the Tate-twist action's joint continuity. -/
  continuous_zpow_val :
    ∀ n : ℤ, Continuous (fun g : G => (((toMonoidHom g) ^ n : (ℤ_[p])ˣ) : ℤ_[p]))

namespace ContinuousCyclotomicCharacter

variable {p : ℕ} [Fact p.Prime] {G : Type*} [Group G] [TopologicalSpace G]
    (χ : ContinuousCyclotomicCharacter p G)

/-- Character at identity is 1. -/
theorem map_one : χ.toMonoidHom 1 = 1 := χ.toMonoidHom.map_one

/-- Character is multiplicative. -/
theorem map_mul (g h : G) :
    χ.toMonoidHom (g * h) = χ.toMonoidHom g * χ.toMonoidHom h :=
  χ.toMonoidHom.map_mul g h

/-- The n-th integer power of the character at g, as an element of (ℤ_[p])ˣ. -/
noncomputable def zpow_val (g : G) (n : ℤ) : ℤ_[p] :=
  ((χ.toMonoidHom g ^ n : (ℤ_[p])ˣ) : ℤ_[p])

/-- At n = 0 the power is 1. -/
theorem zpow_val_zero (g : G) : χ.zpow_val g 0 = 1 := by
  simp [zpow_val, zpow_zero]

/-- Integer power is multiplicative in n. -/
theorem zpow_val_add (g : G) (m n : ℤ) :
    χ.zpow_val g (m + n) = χ.zpow_val g m * χ.zpow_val g n := by
  simp [zpow_val, zpow_add, Units.val_mul]

/-- Integer power is multiplicative in g. -/
theorem zpow_val_mul (g h : G) (n : ℤ) :
    χ.zpow_val (g * h) n = χ.zpow_val g n * χ.zpow_val h n := by
  simp [zpow_val, χ.map_mul, mul_zpow, Units.val_mul]

end ContinuousCyclotomicCharacter

end MathlibExpansion.Roots.HodgeTate
