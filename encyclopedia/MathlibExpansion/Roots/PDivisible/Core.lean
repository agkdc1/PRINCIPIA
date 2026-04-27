import Mathlib.Topology.Category.Profinite.Basic
import Mathlib.CategoryTheory.Opposites
import Mathlib.Topology.Algebra.Group.Basic
import Mathlib.Topology.Algebra.ContinuousMonoidHom

/-!
# p-divisible groups: Core structures

Defines `GaloisProfiniteTower`, `TateModuleObject` (compatible inverse-limit sequences),
`PDivisibleGroupObject`, and `PDivisibleHom`.

The carrier of each profinite level lives in `Profinite.{0}` (not `ProfiniteGrp`) to avoid
`MulAction`-instance unification issues with the levelwise group law.
`IsTopologicalGroup Γ` is required so that joint continuity of Γ multiplication is available.
-/

namespace MathlibExpansion
namespace Roots
namespace PDivisible

open CategoryTheory Opposite

/-! ## GaloisProfiniteTower -/

structure GaloisProfiniteTower
    (Γ : Type*) [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ] where
  level          : ℕᵒᵖ ⥤ Profinite.{0}
  levelAction    : ∀ n : ℕ, MulAction Γ (level.obj (op n))
  levelSMulCts   : ∀ n : ℕ,
      @ContinuousSMul Γ (level.obj (op n)) (levelAction n).toSMul _ _
  map_smul       : ∀ {i j : ℕᵒᵖ} (f : i ⟶ j) (σ : Γ) (x : level.obj i),
      level.map f ((levelAction i.unop).toSMul.smul σ x) =
      (levelAction j.unop).toSMul.smul σ (level.map f x)
  levelIsGroup   : ∀ n : ℕ, Group (level.obj (op n))
  map_mul        : ∀ {i j : ℕᵒᵖ} (f : i ⟶ j) (x y : level.obj i),
      level.map f ((levelIsGroup i.unop).toMul.mul x y) =
      (levelIsGroup j.unop).toMul.mul (level.map f x) (level.map f y)

variable {Γ : Type*} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]

def GaloisProfiniteTower.transition (T : GaloisProfiniteTower Γ) (n : ℕ)
    (x : T.level.obj (op (n + 1))) : T.level.obj (op n) :=
  T.level.map ((homOfLE (Nat.le_succ n)).op) x

/-! ## TateModuleObject -/

structure TateModuleObject (T : GaloisProfiniteTower Γ) : Type* where
  section_   : ∀ n : ℕ, T.level.obj (op n)
  compatible : ∀ n : ℕ, T.transition n (section_ (n + 1)) = section_ n

namespace TateModuleObject

variable {T : GaloisProfiniteTower Γ}

@[ext]
theorem ext {x y : TateModuleObject T} (h : ∀ n, x.section_ n = y.section_ n) : x = y := by
  cases x; cases y; simp only [mk.injEq]; funext n; exact h n

instance instTopologicalSpace : TopologicalSpace (TateModuleObject T) :=
  TopologicalSpace.induced (fun x => x.section_) inferInstance

instance instSMul : SMul Γ (TateModuleObject T) where
  smul σ x :=
    { section_   := fun n => (T.levelAction n).toSMul.smul σ (x.section_ n)
      compatible := fun n => by
        show T.level.map ((homOfLE (Nat.le_succ n)).op)
            ((T.levelAction (n + 1)).toSMul.smul σ (x.section_ (n + 1))) =
            (T.levelAction n).toSMul.smul σ (x.section_ n)
        exact (T.map_smul ((homOfLE (Nat.le_succ n)).op) σ (x.section_ (n + 1))).trans
          (congrArg ((T.levelAction n).toSMul.smul σ) (x.compatible n)) }

@[simp]
theorem smul_section_ (σ : Γ) (x : TateModuleObject T) (n : ℕ) :
    (σ • x).section_ n = (T.levelAction n).toSMul.smul σ (x.section_ n) :=
  rfl

instance instMulAction : MulAction Γ (TateModuleObject T) where
  one_smul x := by
    ext n; simp only [smul_section_]
    exact @one_smul Γ _ inferInstance (T.levelAction n) (x.section_ n)
  mul_smul σ τ x := by
    ext n; simp only [smul_section_]
    exact @mul_smul Γ _ inferInstance (T.levelAction n) σ τ (x.section_ n)

/-- Γ-action on `TateModuleObject T` is continuous (induced topology + levelwise hypothesis). -/
instance instContinuousSMul : ContinuousSMul Γ (TateModuleObject T) := by
  constructor
  -- section_ : TateModuleObject T → Π n, T.level.obj (op n) is the inducing map
  have hdom : Continuous (fun x : TateModuleObject T => x.section_) := continuous_induced_dom
  -- It suffices to show each component is continuous
  apply continuous_induced_rng.mpr
  apply continuous_pi; intro n
  show Continuous (fun p : Γ × TateModuleObject T =>
      (T.levelAction n).toSMul.smul p.1 (p.2.section_ n))
  exact (T.levelSMulCts n).continuous_smul.comp
    (continuous_fst.prod_mk ((continuous_apply n).comp (hdom.comp continuous_snd)))

end TateModuleObject

/-! ## PDivisibleGroupObject -/

structure PDivisibleGroupObject
    (Γ : Type*) [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    (p : ℕ) extends GaloisProfiniteTower Γ where
  prime        : Nat.Prime p
  height       : ℕ
  height_pos   : 0 < height
  levelFintype : ∀ n : ℕ, Fintype (level.obj (op n))
  level_order  : ∀ n : ℕ,
      @Fintype.card (level.obj (op n)) (levelFintype n) = p ^ (height * (n + 1))

namespace PDivisibleGroupObject

variable {Γ : Type*} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ] {p : ℕ}
variable (G : PDivisibleGroupObject Γ p)

theorem level_zero_card :
    @Fintype.card (G.level.obj (op 0)) (G.levelFintype 0) = p ^ G.height := by
  have h := G.level_order 0; simp only [Nat.zero_add, mul_one] at h; exact h

end PDivisibleGroupObject

/-! ## PDivisibleHom -/

structure PDivisibleHom
    {Γ : Type*} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} (G H : PDivisibleGroupObject Γ p) where
  levelMap    : ∀ n : ℕ, G.level.obj (op n) → H.level.obj (op n)
  continuous  : ∀ n : ℕ, Continuous (levelMap n)
  naturality  : ∀ (n : ℕ) (x : G.level.obj (op (n + 1))),
      levelMap n (G.transition n x) = H.transition n (levelMap (n + 1) x)
  equivariant : ∀ (n : ℕ) (σ : Γ) (x : G.level.obj (op n)),
      levelMap n ((G.levelAction n).toSMul.smul σ x) =
      (H.levelAction n).toSMul.smul σ (levelMap n x)

end PDivisible
end Roots
end MathlibExpansion
