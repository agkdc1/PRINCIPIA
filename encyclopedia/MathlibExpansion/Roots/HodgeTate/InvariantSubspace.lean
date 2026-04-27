import MathlibExpansion.Roots.HodgeTate.ContinuousRepresentation
import Mathlib.Algebra.Group.Subgroup.Basic

/-!
# G-invariant subgroup of a continuous representation

Defines the fixed-point AddSubgroup of a ContinuousRepresentation and proves
the basic closure properties. This is the target object of the Ax-Sen-Tate
axiom in F5: for the Tate twist action at nonzero weight, this subgroup is ⊥.
-/

namespace MathlibExpansion.Roots.HodgeTate

variable {G : Type*} [Group G] [TopologicalSpace G]
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]

/-- The G-invariant subgroup of V under a continuous representation ρ:
the set of v ∈ V fixed by every g ∈ G. -/
def invariantSubgroup (ρ : ContinuousRepresentation G V) : AddSubgroup V where
  carrier := { v | ∀ g : G, ρ.smul g v = v }
  zero_mem' := by
    intro g
    exact ρ.smul_zero g
  add_mem' := by
    intro u w hu hw g
    rw [ρ.smul_add, hu g, hw g]
  neg_mem' := by
    intro v hv g
    rw [ρ.smul_neg, hv g]

namespace invariantSubgroup

variable (ρ : ContinuousRepresentation G V)

/-- v ∈ invariantSubgroup ρ iff ρ fixes v for all g. -/
theorem mem_iff (v : V) :
    v ∈ invariantSubgroup ρ ↔ ∀ g : G, ρ.smul g v = v :=
  Iff.rfl

/-- Zero is always in the invariant subgroup. -/
theorem zero_mem : (0 : V) ∈ invariantSubgroup ρ :=
  (invariantSubgroup ρ).zero_mem

/-- Invariant vectors are stable under addition. -/
theorem add_mem {u w : V}
    (hu : u ∈ invariantSubgroup ρ) (hw : w ∈ invariantSubgroup ρ) :
    u + w ∈ invariantSubgroup ρ :=
  (invariantSubgroup ρ).add_mem hu hw

/-- Invariant vectors are stable under negation. -/
theorem neg_mem {v : V} (hv : v ∈ invariantSubgroup ρ) :
    -v ∈ invariantSubgroup ρ :=
  (invariantSubgroup ρ).neg_mem hv

/-- The action of any g on an invariant vector is the identity. -/
theorem smul_eq_self {v : V} (hv : v ∈ invariantSubgroup ρ) (g : G) :
    ρ.smul g v = v :=
  hv g

/-- A nonzero invariant subgroup contains a nonzero vector. -/
theorem ne_bot_iff :
    invariantSubgroup ρ ≠ ⊥ ↔ ∃ v : V, v ≠ 0 ∧ v ∈ invariantSubgroup ρ := by
  rw [Ne, AddSubgroup.eq_bot_iff_forall]
  push_neg
  constructor
  · rintro ⟨v, hm, hn⟩; exact ⟨v, hn, hm⟩
  · rintro ⟨v, hn, hm⟩; exact ⟨v, hm, hn⟩

/-- If the invariant subgroup is ⊥ then every fixed point is zero. -/
theorem eq_bot_iff :
    invariantSubgroup ρ = ⊥ ↔
    ∀ v : V, (∀ g : G, ρ.smul g v = v) → v = 0 := by
  rw [AddSubgroup.eq_bot_iff_forall]
  simp [mem_iff]

/-- For the trivial representation, every vector is invariant. -/
theorem trivial_eq_top :
    invariantSubgroup (ContinuousRepresentation.trivial (G := G) (V := V)) = ⊤ := by
  ext v
  simp [mem_iff, ContinuousRepresentation.trivial]

/-- A nonzero vector is NOT in invariantSubgroup ρ iff some g moves it. -/
theorem not_mem_iff (v : V) :
    v ∉ invariantSubgroup ρ ↔ ∃ g : G, ρ.smul g v ≠ v := by
  simp [mem_iff]

end invariantSubgroup

end MathlibExpansion.Roots.HodgeTate
