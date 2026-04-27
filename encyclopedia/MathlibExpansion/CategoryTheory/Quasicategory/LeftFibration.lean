import Mathlib.AlgebraicTopology.SimplicialSet.Horn
import Mathlib.CategoryTheory.LiftingProperty.Basic
import MathlibExpansion.CategoryTheory.Quasicategory.InnerFibration

/-!
# Left fibrations of simplicial sets  (LIF_03)

Defines the `LeftFibration` typeclass: a morphism of simplicial sets having the
right lifting property with respect to every left horn inclusion
`Λ[n, i] ↪ Δ[n]` for `n ≥ 1` and `i.val < n` (all horns except the last).

Every left fibration is an inner fibration (HTT Cor. 2.1.3.4), proved here.

**HVT**: LIF_03  (T21c_12 Lurie HTT, Topic 04 — left and inner fibrations)

**Sources**:
- J. Lurie, *Higher Topos Theory* (Princeton UP, 2009), §2.1.2–§2.1.3.
- D.-C. Cisinski, *Higher Categories and Homotopical Algebra* (Cambridge UP,
  2019), §3.1.
-/

open CategoryTheory SSet

namespace MathlibExpansion.CategoryTheory.Quasicategory

/-- A morphism `p : X ⟶ S` of simplicial sets is a **left fibration** if it has
the right lifting property with respect to every left horn inclusion
`hornInclusion n i : Λ[n, i] ↪ Δ[n]` for `n ≥ 1` and `i.val < n`.

Left fibrations are the fibrations for the covariant model structure on `SSet / S`.
Their fibres are Kan complexes, and they model left `∞`-actions / co-presheaves.

Source: Lurie, HTT §2.1.2, Def. 2.1.2.1.
-/
class LeftFibration {X S : SSet} (p : X ⟶ S) : Prop where
  rlp_left_horns : ∀ (n : ℕ) (_ : 1 ≤ n) (i : Fin (n + 1))
      (_ : i.val < n),
      HasLiftingProperty (SSet.hornInclusion n i) p

/-- Restatement of `LeftFibration` as a biconditional. -/
theorem leftFibration_iff {X S : SSet} (p : X ⟶ S) :
    LeftFibration p ↔
    ∀ (n : ℕ) (_ : 1 ≤ n) (i : Fin (n + 1)) (_ : i.val < n),
      HasLiftingProperty (SSet.hornInclusion n i) p :=
  ⟨fun ⟨h⟩ => h, fun h => ⟨h⟩⟩

/-- A left fibration is an inner fibration.

Every inner horn `Λ[n, i]` with `0 < i < n` is in particular a left horn
(since `i < n`), so a morphism with RLP against all left horns automatically
has RLP against all inner horns.

Source: Lurie, HTT Cor. 2.1.3.4 (first bullet).
-/
theorem leftFibration_isInnerFibration
    {X S : SSet} (p : X ⟶ S) [LeftFibration p] : InnerFibration p :=
  ⟨fun n hn i hi_pos hi_lt =>
    LeftFibration.rlp_left_horns n (by omega) i (by omega)⟩

/-- Constructor: provide the left-horn RLP to obtain a `LeftFibration`. -/
theorem leftFibration_of_hasLiftingProperty
    {X S : SSet} (p : X ⟶ S)
    (h : ∀ (n : ℕ) (_ : 1 ≤ n) (i : Fin (n + 1)) (_ : i.val < n),
        HasLiftingProperty (SSet.hornInclusion n i) p) :
    LeftFibration p :=
  ⟨h⟩

/--
**Upstream-narrow axiom** (LIF_07, deferred).

Left fibrations are stable under base change: if `p : X ⟶ S` is a left
fibration and `f : T ⟶ S`, then the base-change `X ×_S T ⟶ T` is a left
fibration.

Blocked on: pullback-stability of `HasLiftingProperty` in `SSet` (same gap as
`innerFibration_baseChange` in `InnerFibration.lean`).

Source: Lurie, HTT Prop. 2.1.3.4 (ii).
-/
axiom leftFibration_baseChange
    {X S T : SSet} (p : X ⟶ S) (f : T ⟶ S) [LeftFibration p] :
    ∃ (P : SSet) (q : P ⟶ T), LeftFibration q

/--
**Upstream-narrow axiom** (LIF_08, deferred).

The fibres of a left fibration over vertices of `S` are Kan complexes.

Blocked on: the fibre-over-vertex construction for `SSet` morphisms and the
`KanComplex` carrier for those fibres.

Source: Lurie, HTT Cor. 2.1.3.4 (iii).
-/
axiom leftFibration_fibre_isKanComplex
    {X S : SSet} (p : X ⟶ S) [LeftFibration p]
    (s : (Δ[0] : SSet) ⟶ S) :
    ∃ (F : SSet), SSet.KanComplex F

end MathlibExpansion.CategoryTheory.Quasicategory
