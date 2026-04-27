import Mathlib.Algebra.Colimit.DirectLimit
import Mathlib.Topology.Algebra.ContinuousMonoidHom
import Mathlib.Topology.Algebra.Group.Basic

/-!
# Topological direct limits of groups

This file packages the final topological-group structure on the existing
algebraic `DirectLimit` carrier of a directed system of topological groups. The
construction is deliberately minimal: we topologize the algebraic carrier using
`GroupTopology.coinduced` from the sigma of stages, then package the canonical
stage maps and the continuous universal property.
-/

open TopologicalSpace

namespace MathlibExpansion
namespace Topology
namespace Algebra
namespace Group

universe u v w

section DirectLimit

variable {ι : Type u} [Preorder ι] [IsDirected ι (· ≤ ·)] [Nonempty ι]
variable (G : ι → Type v) [∀ i, Group (G i)] [∀ i, TopologicalSpace (G i)]
variable [∀ i, IsTopologicalGroup (G i)]
variable (f : ∀ i j, i ≤ j → ContinuousMonoidHom (G i) (G j))
variable [DirectedSystem G fun i j hij => (f i j hij : G i → G j)]

local notation "DLim" => _root_.DirectLimit G (fun i j hij => f i j hij)

/-- The sigma-stage map into the algebraic direct limit. -/
def sigmaToDirectLimit : (Σ i, G i) → DLim
  | ⟨i, x⟩ => (⟦⟨i, x⟩⟧ : DLim)

/-- The final group topology on the algebraic direct-limit carrier. -/
noncomputable def groupTopology : GroupTopology DLim :=
  GroupTopology.coinduced (sigmaToDirectLimit G f)

noncomputable instance instTopologicalSpaceDirectLimit : TopologicalSpace DLim :=
  (groupTopology G f).toTopologicalSpace

instance instIsTopologicalGroupDirectLimit : IsTopologicalGroup DLim :=
  (groupTopology G f).toIsTopologicalGroup

/-- The canonical continuous homomorphism from a stage into the topological
direct limit. -/
noncomputable def of (i : ι) : ContinuousMonoidHom (G i) DLim where
  toFun x := (⟦⟨i, x⟩⟧ : DLim)
  map_one' := by
    simpa using (DirectLimit.one_def (G := G) (f := fun i j hij => f i j hij) i).symm
  map_mul' x y := by
    simpa using (DirectLimit.mul_def (G := G) (f := fun i j hij => f i j hij) i x y).symm
  continuous_toFun :=
    (GroupTopology.coinduced_continuous (sigmaToDirectLimit G f)).comp continuous_sigmaMk

@[simp]
theorem of_apply (i : ι) (x : G i) : of G f i x = (⟦⟨i, x⟩⟧ : DLim) :=
  rfl

@[simp]
theorem of_f {i j : ι} (hij : i ≤ j) (x : G i) :
    of G f j (f i j hij x) = of G f i x := by
  change (⟦⟨j, f i j hij x⟩⟧ : DLim) = ⟦⟨i, x⟩⟧
  exact (DirectLimit.eq_of_le (F := G) (f := fun i j hij => f i j hij) ⟨i, x⟩ j hij).symm

/-- The algebraic universal morphism out of the direct limit. -/
noncomputable def liftMonoidHom
    {A : Type w} [Group A] [TopologicalSpace A] [IsTopologicalGroup A]
    (g : ∀ i, ContinuousMonoidHom (G i) A)
    (hg : ∀ i j hij, (g j).comp (f i j hij) = g i) :
    DLim →* A where
  toFun :=
    _root_.DirectLimit.lift
      (f := fun i j hij => f i j hij)
      (fun i x => g i x)
      (fun i j hij x => by
        simpa using DFunLike.congr_fun (hg i j hij).symm x)
  map_one' := by
    let i : ι := Classical.arbitrary ι
    rw [DirectLimit.one_def (G := G) (f := fun i j hij => f i j hij) i]
    simp [DirectLimit.lift_def]
  map_mul' := by
    intro x y
    refine DirectLimit.induction₂
      (f := fun i j hij => f i j hij)
      (C := fun x y =>
        _root_.DirectLimit.lift
            (f := fun i j hij => f i j hij)
            (fun i x => g i x)
            (fun i j hij x => by
              simpa using DFunLike.congr_fun (hg i j hij).symm x)
            (x * y) =
          _root_.DirectLimit.lift
            (f := fun i j hij => f i j hij)
            (fun i x => g i x)
            (fun i j hij x => by
              simpa using DFunLike.congr_fun (hg i j hij).symm x)
            x *
          _root_.DirectLimit.lift
            (f := fun i j hij => f i j hij)
            (fun i x => g i x)
            (fun i j hij x => by
              simpa using DFunLike.congr_fun (hg i j hij).symm x)
            y)
      ?_ x y
    intro i x y
    simp [DirectLimit.lift_def, DirectLimit.mul_def, map_mul]

@[simp]
theorem liftMonoidHom_of
    {A : Type w} [Group A] [TopologicalSpace A] [IsTopologicalGroup A]
    (g : ∀ i, ContinuousMonoidHom (G i) A)
    (hg : ∀ i j hij, (g j).comp (f i j hij) = g i)
    (i : ι) (x : G i) :
    liftMonoidHom G f g hg (of G f i x) = g i x :=
  rfl

/-- Compatible continuous stage morphisms lift to a continuous homomorphism out
of the topological direct limit. -/
  noncomputable def lift
    {A : Type w} [Group A] [TopologicalSpace A] [IsTopologicalGroup A]
    (g : ∀ i, ContinuousMonoidHom (G i) A)
    (hg : ∀ i j hij, (g j).comp (f i j hij) = g i) :
    ContinuousMonoidHom DLim A where
  toMonoidHom := liftMonoidHom G f g hg
  continuous_toFun := by
    let ψ : DLim →* A := liftMonoidHom G f g hg
    let q : (Σ i, G i) → DLim := sigmaToDirectLimit G f
    have hqψ : Continuous fun x : Σ i, G i => ψ (q x) := by
      refine continuous_sigma ?_
      intro i
      simpa [q, ψ, sigmaToDirectLimit, liftMonoidHom, DirectLimit.lift_def] using (g i).continuous
    let τ : GroupTopology DLim :=
      { toTopologicalSpace := TopologicalSpace.induced ψ inferInstance
        toIsTopologicalGroup := topologicalGroup_induced ψ }
    have hτ : TopologicalSpace.coinduced q inferInstance ≤ τ.toTopologicalSpace := by
      exact (continuous_iff_coinduced_le.1 <| continuous_induced_rng.2 hqψ)
    have hGT : groupTopology G f ≤ τ := by
      rw [groupTopology, GroupTopology.coinduced]
      exact sInf_le hτ
    have hle : (groupTopology G f).toTopologicalSpace ≤ TopologicalSpace.induced ψ inferInstance :=
      GroupTopology.toTopologicalSpace_le.2 hGT
    exact continuous_iff_le_induced.2 hle

@[simp]
theorem lift_of
    {A : Type w} [Group A] [TopologicalSpace A] [IsTopologicalGroup A]
    (g : ∀ i, ContinuousMonoidHom (G i) A)
    (hg : ∀ i j hij, (g j).comp (f i j hij) = g i)
    (i : ι) (x : G i) :
    lift G f g hg (of G f i x) = g i x :=
  rfl

end DirectLimit

end Group
end Algebra
end Topology
end MathlibExpansion
