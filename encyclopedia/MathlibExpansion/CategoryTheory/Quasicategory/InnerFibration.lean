import Mathlib.AlgebraicTopology.SimplicialSet.Horn
import Mathlib.CategoryTheory.LiftingProperty.Basic

/-!
# Inner fibrations of simplicial sets  (LIF_02)

Defines the `InnerFibration` typeclass: a morphism of simplicial sets having the
right lifting property with respect to every inner horn inclusion
`Λ[n, i] ↪ Δ[n]` for `2 ≤ n` and `0 < i < n`.

**HVT**: LIF_02  (T21c_12 Lurie HTT, Topic 04 — left and inner fibrations)

**Upstream gap**: `HasLiftingProperty` is well-typed over `SSet`, but the
stability-under-base-change and composition properties that make the predicate
fully usable are not yet packaged.  This file is a carrier predicate for the
inner-fibration front.

**Sources**:
- J. Lurie, *Higher Topos Theory* (Princeton UP, 2009), §2.1.3, Def. 2.1.3.1.
- D.-C. Cisinski, *Higher Categories and Homotopical Algebra* (Cambridge UP,
  2019), §3.1.
-/

open CategoryTheory SSet

namespace MathlibExpansion.CategoryTheory.Quasicategory

/-- A morphism `p : X ⟶ S` of simplicial sets is an **inner fibration** if it
has the right lifting property with respect to every inner horn inclusion
`hornInclusion n i : Λ[n, i] ↪ Δ[n]` for `n ≥ 2` and `0 < i.val < n`.

Quasicategories are precisely the simplicial sets `X` for which `X ⟶ Δ[0]`
is an inner fibration (HTT Rem. 2.1.3.2).

Source: Lurie, HTT §2.1.3, Def. 2.1.3.1.
-/
class InnerFibration {X S : SSet} (p : X ⟶ S) : Prop where
  rlp_inner_horns : ∀ (n : ℕ) (hn : 2 ≤ n) (i : Fin (n + 1))
      (hi_pos : 0 < i.val) (hi_lt : i.val < n),
      HasLiftingProperty (SSet.hornInclusion n i) p

/-- Restatement of `InnerFibration` as a biconditional — unfolding the class. -/
theorem innerFibration_iff {X S : SSet} (p : X ⟶ S) :
    InnerFibration p ↔
    ∀ (n : ℕ) (_ : 2 ≤ n) (i : Fin (n + 1)) (_ : 0 < i.val) (_ : i.val < n),
      HasLiftingProperty (SSet.hornInclusion n i) p :=
  ⟨fun ⟨h⟩ => h, fun h => ⟨h⟩⟩

/-- There are no inner horns for `n < 2`, so any RLP condition against them is
vacuously satisfied. -/
theorem no_inner_horn_of_lt_two {n : ℕ} (hn : n < 2) (i : Fin (n + 1))
    (hi_pos : 0 < i.val) (hi_lt : i.val < n) : False := by omega

/-- An inner fibration restricted to a sub-horn condition: if `p` already has
`HasLiftingProperty` against every inner horn inclusion, it is an inner fibration. -/
theorem innerFibration_of_hasLiftingProperty
    {X S : SSet} (p : X ⟶ S)
    (h : ∀ (n : ℕ) (_ : 2 ≤ n) (i : Fin (n + 1))
        (_ : 0 < i.val) (_ : i.val < n),
        HasLiftingProperty (SSet.hornInclusion n i) p) :
    InnerFibration p :=
  ⟨h⟩

/--
**Upstream-narrow axiom** (LIF_05, deferred).

Inner fibrations are stable under base change: if `p : X ⟶ S` is an inner
fibration and `f : T ⟶ S` is any morphism, then the base-change
`X ×_S T ⟶ T` is also an inner fibration.

Blocked on: the pullback-stability lemma for `HasLiftingProperty` in `SSet`
(requires the corresponding lemma in `CategoryTheory.LiftingProperty.Basic`
plus `SSet`'s pullback-compatibility, which is not yet assembled).

Source: Lurie, HTT Prop. 2.1.3.4 (i).
-/
axiom innerFibration_baseChange
    {X S T : SSet} (p : X ⟶ S) (f : T ⟶ S) [InnerFibration p] :
    ∃ (P : SSet) (q : P ⟶ T), InnerFibration q

end MathlibExpansion.CategoryTheory.Quasicategory
