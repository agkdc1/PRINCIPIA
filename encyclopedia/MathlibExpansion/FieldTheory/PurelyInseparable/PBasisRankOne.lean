import Mathlib.FieldTheory.Perfect

/-!
# Rank-one `p`-basis boundary

Steinitz's `Sec. 14 IV` singles out the imperfect base fields whose Frobenius
codimension is exactly one. Mathlib v4.17 has no packaged `p`-basis API for that
boundary, but it does have the Frobenius endomorphism and vector-space rank, so
we record the boundary directly as `[F : F^p] = p`.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 14 IV`,
  theorem IV, p. 244.
-/

namespace MathlibExpansion.FieldTheory.PurelyInseparable

variable {F : Type*} [Field F]
variable {q : ℕ} [Fact q.Prime] [CharP F q]

/-- The subfield `F^q` of `q`th powers, implemented as the field range of the
absolute Frobenius endomorphism. -/
abbrev frobeniusPowerSubfield : Subfield F :=
  (frobenius F q).fieldRange

/-- Steinitz's exceptional imperfect base-field boundary `[F : F^p] = p`.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 14 IV`, theorem IV, p. 244. In Lean this is the transparent rank
condition that `F` has vector-space rank `q` over the subfield `F^q`, the field
range of the absolute Frobenius. -/
def PBasisRankOne : Prop :=
  Module.rank (frobeniusPowerSubfield (F := F) (q := q)) F = q

/-- Unfold Steinitz's rank-one Frobenius boundary to the Mathlib rank condition. -/
theorem pBasisRankOne_iff :
    PBasisRankOne (F := F) (q := q) ↔
      Module.rank (frobeniusPowerSubfield (F := F) (q := q)) F = q :=
  Iff.rfl

#check @PBasisRankOne
#check @pBasisRankOne_iff

end MathlibExpansion.FieldTheory.PurelyInseparable
