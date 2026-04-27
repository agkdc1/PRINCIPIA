import Mathlib.GroupTheory.QuotientGroup.Basic
import Mathlib.GroupTheory.Solvable
import Mathlib.GroupTheory.SpecificGroups.Cyclic
import Mathlib.Order.JordanHolder

namespace MathlibExpansion
namespace GroupTheory
namespace CompositionSeries

/--
Still upstream-narrow axiom. The checked `Mathlib` snapshot has the generic
`JordanHolderLattice` API and the submodule instance, but not the subgroup/group-with-operators
instance needed for textbook-facing group composition series. Citation target: Marco Riccardi,
2007, "The Jordan-Holder Theorem", Formalized Mathematics, GROUP_9:93 (Zassenhaus lemma),
GROUP_9:118 (Schreier refinement theorem), and GROUP_9:119 (Jordan-Holder theorem).
-/
axiom instJordanHolderLatticeSubgroup (G : Type*) [Group G] :
    JordanHolderLattice (Subgroup G)

attribute [instance] instJordanHolderLatticeSubgroup

/-- A composition series in the subgroup lattice of a group. -/
abbrev GroupCompositionSeries (G : Type*) [Group G] : Type _ :=
  CompositionSeries (Subgroup G)

/--
Still upstream-narrow axiom. Finite groups admit a Jordan-Holder composition series in subgroup
language once the subgroup `JordanHolderLattice` instance above is formalized. Citation target:
Marco Riccardi, 2007, "The Jordan-Holder Theorem", Formalized Mathematics, GROUP_9:def 28
(composition series), GROUP_9:def 30 (strictly decreasing series), GROUP_9:def 31
(Jordan-Holder series), and GROUP_9:110 (Jordan-Holder iff simple quotient factors).
-/
axiom exists_groupCompositionSeries (G : Type*) [Group G] [Finite G] :
    ∃ s : GroupCompositionSeries G, s.head = ⊥ ∧ s.last = ⊤

/-- Jordan-Hölder uniqueness in group language. -/
theorem group_jordan_holder {G : Type*} [Group G] {s₁ s₂ : GroupCompositionSeries G}
    (hb : s₁.head = s₂.head) (ht : s₁.last = s₂.last) :
    CompositionSeries.Equivalent s₁ s₂ :=
  CompositionSeries.jordan_holder s₁ s₂ hb ht

/-- Jordan-Hölder uniqueness specialized to full subgroup chains from `⊥` to `⊤`. -/
theorem group_jordan_holder_bot_top {G : Type*} [Group G] {s₁ s₂ : GroupCompositionSeries G}
    (hb₁ : s₁.head = ⊥) (ht₁ : s₁.last = ⊤) (hb₂ : s₂.head = ⊥) (ht₂ : s₂.last = ⊤) :
    CompositionSeries.Equivalent s₁ s₂ :=
  group_jordan_holder (hb := hb₁.trans hb₂.symm) (ht := ht₁.trans ht₂.symm)

/--
Jordan's intercalary-step wrapper: inserting a maximal intermediate subgroup can be compared with
the original chain through an equivalent refinement.
-/
theorem group_exists_last_eq_snoc_equivalent {G : Type*} [Group G] (s : GroupCompositionSeries G)
    (H : Subgroup G) (hm : JordanHolderLattice.IsMaximal H s.last) (hb : s.head ≤ H) :
    ∃ t : GroupCompositionSeries G,
      t.head = s.head ∧ t.length + 1 = s.length ∧
      ∃ htx : t.last = H,
        CompositionSeries.Equivalent s
          (t.snoc s.last (show JordanHolderLattice.IsMaximal t.last s.last from htx.symm ▸ hm)) := by
  simpa using CompositionSeries.exists_last_eq_snoc_equivalent s H hm hb

/--
A step witness saying that the corresponding factor can be represented by a prime-card cyclic
quotient of the upper subgroup.
-/
structure PrimeCyclicStep {G : Type*} [Group G] (H₁ H₂ : Subgroup G) where
  normalSubgroup : Subgroup H₂
  normal : normalSubgroup.Normal
  lower_le : Subgroup.comap H₂.subtype H₁ ≤ normalSubgroup
  cyclic : IsCyclic (H₂ ⧸ normalSubgroup)
  prime_card : (Nat.card (H₂ ⧸ normalSubgroup)).Prime

/-- Every successive step in the series admits a prime-cyclic factor witness. -/
def HasPrimeCyclicFactors {G : Type*} [Group G] (s : GroupCompositionSeries G) : Prop :=
  ∀ i : Fin s.length,
    Nonempty (PrimeCyclicStep (s (Fin.castSucc i)) (s (Fin.succ i)))

/--
Still upstream-narrow axiom. This is the finite-solvable specialization of composition factors:
a finite group is solvable exactly when its Jordan-Holder factors are cyclic of prime order.
Citation target: M. Bello, Mustapha Danjuma, Sani Musa, and Raliatu Mohammed Kashim, 2017,
"Construction of Transitive Supersolvable Permutation Groups", Journal of Natural Sciences
Research, Proposition 2.3, with the Jordan-Holder-factor substrate from Marco Riccardi, 2007,
"The Jordan-Holder Theorem", Formalized Mathematics, GROUP_9:def 13 (simple
group-with-operators) and GROUP_9:110 (Jordan-Holder iff simple quotient factors).
-/
axiom finite_isSolvable_iff_exists_prime_compositionSeries
    (G : Type*) [Group G] [Finite G] :
    IsSolvable G ↔
      ∃ s : GroupCompositionSeries G,
        s.head = ⊥ ∧ s.last = ⊤ ∧ HasPrimeCyclicFactors s

end CompositionSeries
end GroupTheory
end MathlibExpansion
