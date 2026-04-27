import MathlibExpansion.Roots.HodgeTate.CpPackage
import Mathlib.Algebra.Field.Basic
import Mathlib.Topology.Algebra.Ring.Basic

/-!
# Tate twists: opaque wrapper with rigid Galois action

Defines the Tate twist `TateTwist Cp n` as an **opaque structure** (not a
`def`), preventing defeq collapse between `TateTwist Cp 0` and `TateTwist Cp 1`.

## Why opacity matters

`def TateTwist Cp (_n : ℤ) := Cp` makes all twists definitionally equal,
so any "theorem" about twisted invariants is secretly about the same type.
Using a `structure` wrapper gives each `n : ℤ` a nominally distinct type:
`TateTwist Cp 0` and `TateTwist Cp 1` carry different phantom indices and the
elaborator cannot unify them without an explicit coercion.

## Field and module instances

Instances are hand-rolled via the `val` projection. The twisted action is the
*separate datum* `tateTwistRepresentation` constructed concretely below using
the topological-ring substrate carried by `CpPackage`.

## Galois action

`g · ⟨x⟩ₙ = ⟨ε_p(g)^n · σ_g(x)⟩ₙ`

where `ε_p = χ.toMonoidHom : G →* (ℤ_[p])ˣ` is the cyclotomic character
(landing in `(ℤ_[p])ˣ`, not `Cp×`) and `σ_g = pkg.galoisAction g`. The integer
power `ε_p(g)^n` is computed in `(ℤ_[p])ˣ` via `zpow`, then embedded into Cp
via `pkg.algebraMap_zp`.

References: Tate (1967) §3; Fontaine-Ouyang §1.4; Brinon-Conrad §2.
-/

namespace MathlibExpansion.Roots.HodgeTate

/-- The n-th Tate twist of C_p: an opaque one-field wrapper distinguishing
each integer weight `n` as a nominally distinct type.

Do NOT unfold this to `Cp` — the phantom `n` index is the only thing preventing
defeq collapse of the Galois action at different weights. -/
@[ext]
structure TateTwist (Cp : Type*) (n : ℤ) where
  /-- The underlying C_p element. -/
  val : Cp

namespace TateTwist

variable {Cp : Type*} {n : ℤ}

/-- The canonical bijection TateTwist Cp n ≃ Cp (forgets the twist index). -/
def equivCp : TateTwist Cp n ≃ Cp where
  toFun := TateTwist.val
  invFun := TateTwist.mk
  left_inv := fun ⟨_⟩ => rfl
  right_inv := fun _ => rfl

/-- Injectivity of the val projection. -/
theorem val_injective : Function.Injective (TateTwist.val (Cp := Cp) (n := n)) :=
  fun a b h => TateTwist.ext h

section Instances

/-!
## Algebraic instances on TateTwist

Minimal instances to support continuous Galois representations:
- `Zero`, `Add`, `Neg`, `Sub`, `SMul ℕ`, `SMul ℤ` defined via `val` projection
- `AddCommGroup` transferred through the injective `val` map
- `TopologicalSpace` induced from `Cp`

The previously attempted transferred `Field` instance via `Function.Injective.field`
is dropped: downstream consumers (`ContinuousRepresentation`) only require
`AddCommGroup + TopologicalSpace`, not the full field structure.
-/

variable [AddCommGroup Cp]

instance instZero : Zero (TateTwist Cp n) := ⟨⟨0⟩⟩
instance instAdd : Add (TateTwist Cp n) := ⟨fun x y => ⟨x.val + y.val⟩⟩
instance instNeg : Neg (TateTwist Cp n) := ⟨fun x => ⟨-x.val⟩⟩
instance instSub : Sub (TateTwist Cp n) := ⟨fun x y => ⟨x.val - y.val⟩⟩
instance instNSMul : SMul ℕ (TateTwist Cp n) := ⟨fun k x => ⟨k • x.val⟩⟩
instance instZSMul : SMul ℤ (TateTwist Cp n) := ⟨fun k x => ⟨k • x.val⟩⟩

noncomputable instance instAddCommGroup : AddCommGroup (TateTwist Cp n) :=
  val_injective.addCommGroup TateTwist.val rfl
    (fun _ _ => rfl) (fun _ => rfl) (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ _ => rfl)

/-- The topology on `TateTwist Cp n`, induced from `Cp` via the `val` projection.
Makes `TateTwist.val` continuous and `TateTwist.mk` the inverse homeomorphism. -/
instance instTopSpace [TopologicalSpace Cp] : TopologicalSpace (TateTwist Cp n) :=
  TopologicalSpace.induced TateTwist.val inferInstance

/-- `val` is continuous by definition of the induced topology. -/
theorem continuous_val [TopologicalSpace Cp] :
    Continuous (TateTwist.val (Cp := Cp) (n := n)) :=
  continuous_induced_dom

/-- Continuity into `TateTwist Cp n` reduces to continuity after `val`. -/
theorem continuous_mk_comp [TopologicalSpace Cp] {α : Type*} [TopologicalSpace α]
    {f : α → Cp} (hf : Continuous f) :
    Continuous (fun a => (⟨f a⟩ : TateTwist Cp n)) :=
  continuous_induced_rng.mpr hf

end Instances

end TateTwist

/-- The twisted scalar `ε_p(g)^n` embedded into C_p, extracted for lemma use.

Uses `@` form on `ContinuousCyclotomicCharacter` because `pkg.G` does not have a
registered `Group` / `TopologicalSpace` instance — those live as bundled fields
on `pkg` and must be passed explicitly. -/
noncomputable def tateTwistScalar
    {p : ℕ} [Fact p.Prime] {Khat : Type*} [Field Khat]
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    (g : pkg.G) (n : ℤ) : pkg.Cp :=
  letI : Group pkg.G := pkg.instGroup_G
  letI : TopologicalSpace pkg.G := pkg.instTopSpace_G
  pkg.algebraMap_zp ((χ.toMonoidHom g ^ n : (ℤ_[p])ˣ).val)

/-- At twist weight 0, the scalar is always 1. -/
theorem tateTwistScalar_zero
    {p : ℕ} [Fact p.Prime] {Khat : Type*} [Field Khat]
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    (g : pkg.G) :
    letI : Field pkg.Cp := pkg.instField_Cp
    tateTwistScalar pkg χ g 0 = 1 := by
  letI : Group pkg.G := pkg.instGroup_G
  letI : TopologicalSpace pkg.G := pkg.instTopSpace_G
  letI : Field pkg.Cp := pkg.instField_Cp
  simp [tateTwistScalar, zpow_zero, pkg.algebraMap_zp_map_one]

/-- The underlying additive endomorphism at group element `g`.

`g · ⟨x⟩ = ⟨ε_p(g)^n · σ_g(x)⟩` where
- `ε_p(g)^n = pkg.algebraMap_zp (χ.zpow_val g n)` (cyclotomic scalar in Cp)
- `σ_g = pkg.galoisAction g` (Galois action on Cp)

Additivity follows from: `galoisAction` preserves `+`, and left-multiplication
by a fixed scalar distributes over `+` in any (semi)ring. -/
noncomputable def tateTwistActionEnd
    {p : ℕ} [Fact p.Prime] {Khat : Type*} [Field Khat]
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    (n : ℤ) (g : pkg.G) :
    letI : Field pkg.Cp := pkg.instField_Cp
    AddMonoid.End (TateTwist pkg.Cp n) :=
  letI : Field pkg.Cp := pkg.instField_Cp
  letI : Group pkg.G := pkg.instGroup_G
  letI : TopologicalSpace pkg.G := pkg.instTopSpace_G
  { toFun := fun v =>
      ⟨pkg.algebraMap_zp (χ.zpow_val g n) * pkg.galoisAction g v.val⟩
    map_zero' := by
      show TateTwist.mk _ = (0 : TateTwist pkg.Cp n)
      apply TateTwist.ext
      show pkg.algebraMap_zp (χ.zpow_val g n) * pkg.galoisAction g (0 : TateTwist pkg.Cp n).val = 0
      have h0 : (0 : TateTwist pkg.Cp n).val = (0 : pkg.Cp) := rfl
      rw [h0, pkg.galoisAction_map_zero, mul_zero]
    map_add' := by
      intro u w
      apply TateTwist.ext
      show pkg.algebraMap_zp (χ.zpow_val g n) *
            pkg.galoisAction g (u + w).val
          = (pkg.algebraMap_zp (χ.zpow_val g n) * pkg.galoisAction g u.val)
          + (pkg.algebraMap_zp (χ.zpow_val g n) * pkg.galoisAction g w.val)
      have hval : (u + w).val = u.val + w.val := rfl
      rw [hval, pkg.galoisAction_map_add, mul_add] }

/-- **Concrete `tateTwistRepresentation`**: the Galois group acts on
`TateTwist pkg.Cp n` via the Tate twist `g · ⟨x⟩ = ⟨ε_p(g)^n · σ_g(x)⟩`,
yielding a continuous representation.

Uses the substrate now carried by `CpPackage`:
- `instTopRing_Cp` / `instTopGroup_G` for joint continuity
- `algebraMap_zp_continuous` for continuity of the scalar map
- `galoisAction_fixes_zp` for the monoid-hom property `map_mul'`
- `ContinuousCyclotomicCharacter.continuous_zpow_val` for continuity of
  the integer power of the character

Citations: Tate (1967) §3; Fontaine-Ouyang §1.4; Brinon-Conrad §2. -/
noncomputable def tateTwistRepresentation
    {p : ℕ} [Fact p.Prime] {Khat : Type*} [Field Khat]
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    (n : ℤ) :
    letI : Field pkg.Cp := pkg.instField_Cp
    letI : TopologicalSpace pkg.Cp := pkg.instTopSpace_Cp
    letI : Group pkg.G := pkg.instGroup_G
    letI : TopologicalSpace pkg.G := pkg.instTopSpace_G
    ContinuousRepresentation pkg.G (TateTwist pkg.Cp n) := by
  letI : Field pkg.Cp := pkg.instField_Cp
  letI : TopologicalSpace pkg.Cp := pkg.instTopSpace_Cp
  letI : IsTopologicalRing pkg.Cp := pkg.instTopRing_Cp
  letI : Group pkg.G := pkg.instGroup_G
  letI : TopologicalSpace pkg.G := pkg.instTopSpace_G
  letI : IsTopologicalGroup pkg.G := pkg.instTopGroup_G
  refine
    { smul :=
        { toFun := tateTwistActionEnd pkg χ n
          map_one' := ?_
          map_mul' := ?_ }
      continuous_smul := ?_ }
  · -- map_one': the action of 1 ∈ G is the identity endomorphism.
    apply AddMonoidHom.ext
    intro v
    apply TateTwist.ext
    show pkg.algebraMap_zp (χ.zpow_val 1 n) * pkg.galoisAction 1 v.val = v.val
    have h1 : χ.zpow_val 1 n = 1 := by
      simp [ContinuousCyclotomicCharacter.zpow_val, χ.map_one]
    rw [h1, pkg.algebraMap_zp_map_one, one_mul, pkg.galoisAction_one]
  · -- map_mul': the action of (g*h) equals the composition of actions.
    intro g h
    apply AddMonoidHom.ext
    intro v
    apply TateTwist.ext
    show pkg.algebraMap_zp (χ.zpow_val (g * h) n)
          * pkg.galoisAction (g * h) v.val
        = pkg.algebraMap_zp (χ.zpow_val g n)
          * pkg.galoisAction g
              (pkg.algebraMap_zp (χ.zpow_val h n) * pkg.galoisAction h v.val)
    rw [χ.zpow_val_mul, pkg.algebraMap_zp_map_mul,
        pkg.galoisAction_mul,
        pkg.galoisAction_map_mul,
        pkg.galoisAction_fixes_zp g (χ.zpow_val h n),
        mul_assoc]
  · -- continuous_smul: the joint map (g, v) ↦ g · v is continuous.
    show Continuous (fun gv : pkg.G × TateTwist pkg.Cp n =>
      tateTwistActionEnd pkg χ n gv.1 gv.2)
    -- Unfold to the induced topology on TateTwist.
    apply TateTwist.continuous_mk_comp
    -- Now: Continuous (fun gv => algebraMap_zp (χ.zpow_val gv.1 n) * galoisAction gv.1 gv.2.val)
    apply Continuous.mul
    · -- scalar part: algebraMap_zp ∘ χ.zpow_val ∘ fst
      have hscalar : Continuous (fun g : pkg.G => pkg.algebraMap_zp (χ.zpow_val g n)) :=
        Continuous.comp pkg.algebraMap_zp_continuous (χ.continuous_zpow_val n)
      exact hscalar.comp continuous_fst
    · -- galoisAction part: galoisAction (gv.1) (gv.2.val)
      have hval : Continuous (fun v : TateTwist pkg.Cp n => v.val) :=
        TateTwist.continuous_val
      have hpair : Continuous
          (fun gv : pkg.G × TateTwist pkg.Cp n => (gv.1, gv.2.val)) :=
        continuous_fst.prod_mk (hval.comp continuous_snd)
      exact pkg.galoisAction_continuous.comp hpair

end MathlibExpansion.Roots.HodgeTate
