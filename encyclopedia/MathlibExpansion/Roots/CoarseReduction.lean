import MathlibExpansion.ConductorReduction

/-!
# Coarse three-constructor reduction type

Defines `CoarseReductionType {good, multiplicative, additive}`, the
three-way classifier adequate for conductor-exponent semistability arguments.
The split/nonsplit distinction inside the multiplicative branch is
conductor-irrelevant (both give exponent 1) and is deferred to a future
residue-field package.

The key theorem `coarseConductorExponentAt_le_one_iff_good_or_multiplicative`
is a real sorry-free proof from the underlying valuation classifier.
-/

namespace NumberTheory

/-- Three-constructor coarse reduction type, collapsing the Kodaira
split/nonsplit distinction into a single `multiplicative` constructor.
Per the W8-R5 fire-spec: `{good, multiplicative, additive}`. -/
inductive CoarseReductionType where
  | good
  | multiplicative
  | additive
  deriving DecidableEq, Repr

namespace CoarseReductionType

def IsMultiplicative : CoarseReductionType → Prop
  | multiplicative => True
  | _ => False

end CoarseReductionType

/-- Collapse the project-local `ReductionType` (which has `multiplicative_nonsplit`
as the single coarse multiplicative constructor after W8-R5) into the canonical
three-way `CoarseReductionType`. -/
def toCoarseReductionType : ReductionType → CoarseReductionType
  | ReductionType.good                => CoarseReductionType.good
  | ReductionType.multiplicative_nonsplit => CoarseReductionType.multiplicative
  | ReductionType.additive            => CoarseReductionType.additive

/-- The coarse reduction type of `E` at prime `p`. -/
def coarseReductionTypeAt (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    CoarseReductionType :=
  toCoarseReductionType (reductionTypeAt E p hp)

/-- The coarse conductor exponent at `p` — definitionally equal to
`conductorExponentAt` (both give 0/1/2). -/
def coarseConductorExponentAt (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) : ℕ :=
  conductorExponentAt E p hp

theorem coarseReductionTypeAt_eq_good_iff
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    coarseReductionTypeAt E p hp = CoarseReductionType.good ↔
      reductionTypeAt E p hp = ReductionType.good := by
  unfold coarseReductionTypeAt toCoarseReductionType
  cases reductionTypeAt E p hp <;> decide

theorem coarseReductionTypeAt_eq_multiplicative_iff
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    coarseReductionTypeAt E p hp = CoarseReductionType.multiplicative ↔
      reductionTypeAt E p hp = ReductionType.multiplicative_nonsplit := by
  unfold coarseReductionTypeAt toCoarseReductionType
  cases reductionTypeAt E p hp <;> decide

theorem coarseReductionTypeAt_eq_additive_iff
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    coarseReductionTypeAt E p hp = CoarseReductionType.additive ↔
      reductionTypeAt E p hp = ReductionType.additive := by
  unfold coarseReductionTypeAt toCoarseReductionType
  cases reductionTypeAt E p hp <;> decide

/-- The fundamental semistability criterion: conductor exponent ≤ 1 iff the
coarse reduction type is good or multiplicative.
Real sorry-free theorem from the underlying valuation classifier. -/
theorem coarseConductorExponentAt_le_one_iff_good_or_multiplicative
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    coarseConductorExponentAt E p hp ≤ 1 ↔
      coarseReductionTypeAt E p hp = CoarseReductionType.good ∨
      coarseReductionTypeAt E p hp = CoarseReductionType.multiplicative := by
  unfold coarseConductorExponentAt coarseReductionTypeAt toCoarseReductionType
    conductorExponentAt
  cases reductionTypeAt E p hp <;> decide

theorem coarseConductorExponentAt_eq_conductorExponentAt
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p) :
    coarseConductorExponentAt E p hp = conductorExponentAt E p hp := rfl

theorem coarseConductorExponentAt_le_one_of_semistable
    (E : WeierstrassCurve ℤ) (p : ℕ) (hp : Nat.Prime p)
    (hss : isSemistable E) :
    coarseConductorExponentAt E p hp ≤ 1 := by
  rw [coarseConductorExponentAt_eq_conductorExponentAt]
  exact conductorExponentAt_le_one_of_semistable E p hp hss

end NumberTheory
