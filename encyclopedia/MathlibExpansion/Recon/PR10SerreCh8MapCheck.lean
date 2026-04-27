import Mathlib.GroupTheory.Index
import Mathlib.GroupTheory.QuotientGroup.Basic
import Mathlib.Topology.Algebra.OpenSubgroup

#check Subgroup.finiteIndex_ker
#check QuotientGroup.quotientKerEquivRange
#check QuotientGroup.lift
#check QuotientGroup.lift_mk
#check isOpen_discrete

section

variable {G A : Type*} [Group G] [TopologicalSpace G] [ContinuousMul G]
variable [Group A] [TopologicalSpace A] [DiscreteTopology A] [Finite A]

theorem continuousMonoidHom_factorsThroughOpenNormalFiniteQuotient
    (ρ : G →* A) (hρ : Continuous ρ) :
    ∃ N : OpenNormalSubgroup G, ∃ ρBar : G ⧸ N.toSubgroup →* A,
      ∀ g : G, ρBar (QuotientGroup.mk g) = ρ g := by
  let N : OpenNormalSubgroup G :=
    { toOpenSubgroup := ⟨ρ.ker, by
        simpa [MonoidHom.mem_ker] using (isOpen_discrete ({1} : Set A)).preimage hρ⟩ }
  refine ⟨N, ?_⟩
  refine ⟨QuotientGroup.lift N.toSubgroup ρ (by intro x hx; exact hx), ?_⟩
  intro g
  simp [N]

end
