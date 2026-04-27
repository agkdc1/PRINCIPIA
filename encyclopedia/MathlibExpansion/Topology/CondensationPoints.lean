import Mathlib.Topology.Perfect
import Mathlib.Topology.Bases
import Mathlib.Data.Set.Countable
import MathlibExpansion.MeasureTheory.Caratheodory1918.AxiomLedger

/-!
# Condensation points (Carathéodory 1918 §§63-65) — BWA package

Verdict signatures for the T20c_08 BWA HVT. Definitions inlined; proofs
delegated to upstream-narrow axioms where the argument chain (second-countable
Lindelöf + Bendixson kernel) exceeds this dispatch's budget.

**Citations** (Commander directive 2026-04-22):
- Cantor, Acta Math. 2 (1883)
- Bendixson, Acta Math. 2 (1883)
- Lindelöf, Acta Math. 29 (1906)

Upstream-narrow Mathlib pointers (per verdict §Upstream substrate):
- `Mathlib/Topology/Bases.lean:821` (`SecondCountableTopology.isLindelof`)
- `Mathlib/Topology/DerivedSet.lean:82` (`IsClosed.derivedSet`)
-/

namespace MathlibExpansion
namespace Caratheodory1918
namespace BWA

/-- A point `x` is a *condensation point* of `A` if every neighborhood of `x`
meets `A` in an uncountable set. -/
def IsCondensationPoint {X : Type*} [TopologicalSpace X] (x : X) (A : Set X) : Prop :=
  ∀ U ∈ nhds x, ¬ (A ∩ U).Countable

/-- The condensation-kernel of a set. -/
def condensationPoints {X : Type*} [TopologicalSpace X] (A : Set X) : Set X :=
  {x | IsCondensationPoint x A}

/-- **BWA_04** (Carathéodory 1918 §63). In a second-countable space, a set
with no condensation point is countable.

Proof route: for each `x ∈ A` with `¬ IsCondensationPoint x A`, pick a
neighborhood `V x` with `(A ∩ V x)` countable; cover `A` by these
neighborhoods; extract a countable subcover by second-countable Lindelöf;
conclude by countable union. Upstream-narrow axiom per Commander directive
2026-04-22. Citation: Cantor/Bendixson (Acta Math. 2, 1883); Lindelöf
(Acta Math. 29, 1906). -/
axiom countable_of_forall_not_isCondensationPoint
    {X : Type*} [TopologicalSpace X] [SecondCountableTopology X] {A : Set X}
    (hA : ∀ x ∈ A, ¬ IsCondensationPoint x A) : A.Countable

/-- **BWA_05** (Carathéodory 1918 §64). An uncountable set in a
second-countable space contains a condensation point. Contrapositive of
BWA_04. -/
theorem exists_mem_condensationPoints_of_not_countable
    {X : Type*} [TopologicalSpace X] [SecondCountableTopology X] {A : Set X}
    (hA : ¬ A.Countable) : ∃ x, x ∈ A ∧ IsCondensationPoint x A := by
  by_contra h
  push_neg at h
  exact hA (countable_of_forall_not_isCondensationPoint h)

/-- **BWA_06** (Carathéodory 1918 §65). The condensation-kernel of an
uncountable set in a T1 second-countable space is perfect. Upstream-narrow
axiom. Citation: Cantor/Bendixson (Acta Math. 2, 1883). -/
axiom isPerfect_condensationPoints_of_not_countable
    {X : Type*} [TopologicalSpace X] [T1Space X] [SecondCountableTopology X]
    {A : Set X} (hA : ¬ A.Countable) : Perfect {x | IsCondensationPoint x A}

end BWA
end Caratheodory1918
end MathlibExpansion
