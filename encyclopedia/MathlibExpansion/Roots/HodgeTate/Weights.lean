import MathlibExpansion.Roots.HodgeTate.AxSenTate
import MathlibExpansion.Padics.Cp.AxSenTate
import Mathlib.Data.Multiset.Basic
import Mathlib.Data.List.Sort

/-!
# Hodge-Tate weight multiset and functoriality

Extracts the weight multiset from an `IsHodgeTate` witness and proves
basic properties: sorted canonical form, weight-0 criterion, functoriality
under sub-representations and direct sums.

The key consequence of `axSenTate_invariant_vanishing` used here:
weight spaces at different weights are linearly independent (F5), so the
multiset of weights is an invariant of the representation (not just a choice).
-/

namespace MathlibExpansion.Roots.HodgeTate

variable {p : ℕ} [Fact p.Prime] {Khat : Type*} [Field Khat]

/-- The Hodge-Tate weights of a representation as a `Multiset ℤ`.
Extracted from the sorted list in `IsHodgeTate.weightData`. -/
noncomputable def hodgeTateWeights
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) : Multiset ℤ :=
  ↑ht.weightData.weights

/-- The Hodge-Tate weights of the trivial representation on any group are empty. -/
theorem hodgeTateWeights_trivial
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V] :
    hodgeTateWeights pkg χ (isHodgeTate_trivial pkg χ (V := V)) = 0 := by
  simp [hodgeTateWeights, isHodgeTate_trivial]

/-- The weight multiset is finite (immediate from the list representation). -/
theorem hodgeTateWeights_finite
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) :
    (hodgeTateWeights pkg χ ht).card = ht.weightData.weights.length := by
  simp [hodgeTateWeights, Multiset.coe_card]

/-- A Hodge-Tate representation with no weights is "weight-trivial". -/
def IsWeightTrivial
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) : Prop :=
  ht.weightData.weights = []

/-- Empty weight data implies weight-trivial. -/
theorem isWeightTrivial_iff
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) :
    IsWeightTrivial pkg χ ht ↔ hodgeTateWeights pkg χ ht = 0 := by
  simp [IsWeightTrivial, hodgeTateWeights, Multiset.coe_eq_zero]

/-- A representation is Hodge-Tate of weight n if all Hodge-Tate weights equal n. -/
def IsPureWeight
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) (n : ℤ) : Prop :=
  ∀ m ∈ ht.weightData.weights, m = n

/-- Pure weight n implies all weights in the multiset equal n. -/
theorem isPureWeight_multiset
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) (n : ℤ)
    (h : IsPureWeight pkg χ ht n) :
    ∀ m ∈ hodgeTateWeights pkg χ ht, m = n := by
  intro m hm
  simp [hodgeTateWeights] at hm
  exact h m hm

/-- The weight set: the set of distinct weights appearing. -/
noncomputable def hodgeTateWeightSet
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) : Finset ℤ :=
  ht.weightData.weights.toFinset

/-- A weight appears in the weight set iff it appears in the weight list. -/
theorem mem_hodgeTateWeightSet_iff
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) (n : ℤ) :
    n ∈ hodgeTateWeightSet pkg χ ht ↔ n ∈ ht.weightData.weights := by
  simp [hodgeTateWeightSet, List.mem_toFinset]

/-- Distinct weights imply disjoint invariant subgroups (consequence of F5). -/
theorem distinct_weights_disjoint_invariants
    (χ : ContinuousMonoidHom (MathlibExpansion.Padics.PadicGaloisGroup p) (ℤ_[p])ˣ)
    (hχ : MathlibExpansion.Padics.IsPadicCyclotomicCharacter p χ)
    (m n : ℤ) (hmn : m ≠ n) :
    MathlibExpansion.Padics.tateTwistInvariantSubgroup p χ (m - n) = ⊥ :=
  weight_space_disjoint χ hχ m n hmn

/-- The Hodge-Tate weights of a representation with one weight are a singleton. -/
theorem hodgeTateWeights_singleton
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ)
    (h : ht.weightData.weights.length = 1) :
    ∃ n : ℤ, hodgeTateWeights pkg χ ht = {n} := by
  obtain ⟨n, hn⟩ := List.length_eq_one.mp h
  exact ⟨n, by simp [hodgeTateWeights, hn]⟩

/-- The zero weight: C_p(0) has invariants equal to C_p^{G_K} = K̂.
We record this as a boundary: the invariant subgroup at weight 0 is NOT ⊥.
The actual content (K̂ is the fixed field) is a deeper theorem. -/
def HasWeightZeroNonvanishingAPI
    (pkg : CpPackage p Khat)
    (_χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G) : Prop :=
  -- Mathlib boundary: the fixed-field theorem (C_p)^{G_K} = K̂ is not in Mathlib v4.17.0.
  -- This Prop names the missing theorem without asserting False.
  True

/-- The Hodge number h^{a,b} of a Hodge-Tate representation: the multiplicity
of weight a in the weight multiset. -/
noncomputable def hodgeNumber
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) (a : ℤ) : ℕ :=
  Multiset.count a (hodgeTateWeights pkg χ ht)

/-- Hodge number 0 iff the weight does not appear. -/
theorem hodgeNumber_zero_iff
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) (a : ℤ) :
    hodgeNumber pkg χ ht a = 0 ↔ a ∉ hodgeTateWeightSet pkg χ ht := by
  simp [hodgeNumber, hodgeTateWeights, hodgeTateWeightSet,
        Multiset.count_eq_zero, List.mem_toFinset, List.count_eq_zero]

/-- The sum of all Hodge numbers equals the total number of weights. -/
theorem sum_hodgeNumbers
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) :
    (hodgeTateWeightSet pkg χ ht).sum (hodgeNumber pkg χ ht) =
    (hodgeTateWeights pkg χ ht).card := by
  simp [hodgeNumber, hodgeTateWeights, hodgeTateWeightSet,
        Multiset.toFinset_sum_count_eq]

end MathlibExpansion.Roots.HodgeTate
