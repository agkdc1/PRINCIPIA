import MathlibExpansion.Foundations.Dedekind.SimplyInfinite

/-!
# Hilbert-Bernays finitist arithmetic

This file keeps the finitist numeral boundary explicit by working with stroke
figures (`List Unit`) rather than identifying the carrier with ambient `Nat`.
-/

namespace MathlibExpansion.Foundations.HilbertBernays

open MathlibExpansion.Foundations.Dedekind

/-- Contentual numerals as explicit stroke figures. -/
abbrev StrokeNumeral := List Unit

/-- The initial finitist numeral. -/
def zeroNumeral : StrokeNumeral := []

/-- Successor by adjoining one more stroke. -/
def succNumeral : StrokeNumeral → StrokeNumeral
  | n => () :: n

/-- Predecessor away from zero, defined by deleting one leading stroke. -/
def predAwayFromZero : StrokeNumeral → StrokeNumeral
  | [] => []
  | _ :: n => n

@[simp] theorem predAwayFromZero_zero :
    predAwayFromZero zeroNumeral = zeroNumeral := rfl

@[simp] theorem predAwayFromZero_succ (n : StrokeNumeral) :
    predAwayFromZero (succNumeral n) = n := rfl

@[simp] theorem succNumeral_injective :
    Function.Injective succNumeral := by
  intro a b h
  simpa [succNumeral] using List.cons.inj h

theorem zero_not_mem_succ_range :
    zeroNumeral ∉ Set.range succNumeral := by
  intro h
  rcases h with ⟨n, hn⟩
  cases n <;> cases hn

/-- The finitist stroke numerals form a simply infinite system. -/
def strokeSystem : SimplyInfiniteSystem StrokeNumeral where
  zero := zeroNumeral
  succ := succNumeral
  succ_injective := succNumeral_injective
  zero_not_mem_range := zero_not_mem_succ_range
  induction := by
    intro s hzero hstep
    apply Set.eq_univ_of_forall
    intro n
    induction n with
    | nil =>
        simpa [zeroNumeral] using hzero
    | cons x xs ih =>
        cases x
        simpa [succNumeral] using hstep xs ih

/-- Any nonzero numeral has an explicit predecessor. -/
theorem exists_pred_of_ne_zero {n : StrokeNumeral} (hn : n ≠ zeroNumeral) :
    ∃ m, succNumeral m = n := by
  simpa [strokeSystem, zeroNumeral, succNumeral] using
    (strokeSystem.exists_pred_of_ne_zero hn)

theorem succ_pred_of_ne_zero {n : StrokeNumeral} (hn : n ≠ zeroNumeral) :
    succNumeral (predAwayFromZero n) = n := by
  cases n with
  | nil =>
      contradiction
  | cons x xs =>
      cases x
      simp [succNumeral, predAwayFromZero]

/-- Finitist induction over stroke numerals. -/
theorem finitistInduction {s : Set StrokeNumeral}
    (hzero : zeroNumeral ∈ s)
    (hstep : ∀ n, n ∈ s → succNumeral n ∈ s) :
    s = Set.univ :=
  strokeSystem.induction hzero hstep

/-- Textbook-facing `FM_01` shape. -/
theorem FM_01 {n : StrokeNumeral} (hn : n ≠ zeroNumeral) :
    ∃ m, succNumeral m = n :=
  exists_pred_of_ne_zero hn

/-- Textbook-facing `FM_02` induction shape. -/
theorem FM_02 {s : Set StrokeNumeral}
    (hzero : zeroNumeral ∈ s)
    (hstep : ∀ n, n ∈ s → succNumeral n ∈ s) :
    s = Set.univ :=
  finitistInduction hzero hstep

end MathlibExpansion.Foundations.HilbertBernays
