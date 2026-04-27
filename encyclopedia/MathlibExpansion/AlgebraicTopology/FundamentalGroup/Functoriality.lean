import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup
import Mathlib.Topology.ContinuousMap.Basic

namespace MathlibExpansion
namespace AlgebraicTopology
namespace FundamentalGroup

open scoped ContinuousMap
open CategoryTheory

attribute [local instance] Path.Homotopic.setoid

/-- A continuous map induces a functor between fundamental groupoids. This is the
cross-universe form of `FundamentalGroupoid.fundamentalGroupoidFunctor.map`. -/
def fundamentalGroupoidMap
    {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (f : C(X, Y)) :
    FundamentalGroupoid X ⥤ FundamentalGroupoid Y where
  obj x := ⟨f x.as⟩
  map p := Path.Homotopic.Quotient.mapFn p f
  map_id x := by
    rw [FundamentalGroupoid.id_eq_path_refl, FundamentalGroupoid.id_eq_path_refl]
    change Path.Homotopic.Quotient.mapFn (⟦Path.refl x.as⟧) f =
      ⟦Path.refl (f x.as)⟧
    rw [← Path.Homotopic.map_lift]
    congr 1
  map_comp p q := by
    refine Quotient.inductionOn₂ p q fun a b => ?_
    simp only [FundamentalGroupoid.comp_eq, ← Path.Homotopic.map_lift,
      ← Path.Homotopic.comp_lift, Path.map_trans]

/-- A continuous map induces a morphism on fundamental groups. -/
def fundamentalGroupMap
    {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (f : C(X, Y)) (x : X) :
    FundamentalGroup X x →* FundamentalGroup Y (f x) :=
  Functor.mapAut (FundamentalGroupoid.mk x) (fundamentalGroupoidMap f)

end FundamentalGroup
end AlgebraicTopology
end MathlibExpansion
