import Mathlib.Topology.Separation.Basic
import Mathlib.Topology.Separation.Hausdorff

namespace MathlibExpansion
namespace Topology
namespace HausdorffAxioms

open Filter Set

variable {X : Type*} [TopologicalSpace X] [T2Space X]

/--
Hausdorff's formula `(6)`: in a Hausdorff space the intersection of all
neighborhoods of a point is that singleton.
-/
theorem sInter_nhds_eq_singleton (x : X) :
    sInter { s : Set X | s ∈ nhds x } = ({x} : Set X) := by
  ext y
  constructor
  · intro hy
    by_cases h : y = x
    · simpa [h]
    · exfalso
      have hnhds : ({y}ᶜ : Set X) ∈ nhds x :=
        compl_singleton_mem_nhds (fun hxy => h hxy.symm)
      have hy' : y ∈ ({y}ᶜ : Set X) := Set.mem_sInter.mp hy _ hnhds
      simpa using hy'
  · intro hy
    rcases Set.mem_singleton_iff.mp hy with rfl
    refine Set.mem_sInter.mpr ?_
    intro s hs
    exact mem_of_mem_nhds hs

end HausdorffAxioms
end Topology
end MathlibExpansion
