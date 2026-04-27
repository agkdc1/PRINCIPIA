import MathlibExpansion.FieldTheory.PurelyInseparable.PBasisRankOne
import Mathlib.FieldTheory.PrimitiveElement
import Mathlib.FieldTheory.Perfect

/-!
# Base-field criterion boundary

This chapter isolates Steinitz `PEFIF_BASE_CRIT`: primitive-element and
finite-intermediate-field behavior for all finite extensions over a fixed base
field.

Mathlib already covers the perfect-field branch. The missing surface is the
Steinitz exceptional imperfect rank-one branch and the combined theorem.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 14 IV`,
  p. 244.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.PrimitiveElement

open IntermediateField
open MathlibExpansion.FieldTheory.PurelyInseparable

variable {F : Type*} [Field F]
variable (q : ℕ) [Fact q.Prime] [CharP F q]

/-- Every finite extension over `F` is simple. -/
def AllFiniteExtensionsSimple : Prop :=
    (∀ {E : Type*} [Field E] [Algebra F E] [FiniteDimensional F E],
      ∃ α : E, IntermediateField.adjoin F ({α} : Set E) = ⊤)

/-- Perfect fields satisfy Steinitz's finite-extension primitive-element
condition.

This is the Mathlib-covered branch of E. Steinitz (1910), *Algebraische
Theorie der Koerper*, `Sec. 14 IV`, theorem IV, p. 244: finite extensions
over a perfect base are separable, hence simple by the primitive element
theorem. -/
theorem allFiniteExtensionsSimple_of_perfect [PerfectField F] :
    AllFiniteExtensionsSimple (F := F) := by
  intro E _ _ _
  simpa using Field.exists_primitive_element F E

/-- Steinitz's exceptional imperfect rank-one branch of the base-field
criterion.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 14 IV`, theorem IV, p. 244; this is exactly the case where the
Frobenius codimension boundary `[F : F^p] = p` still forces every finite
extension over `F` to be simple. -/
axiom allFiniteExtensionsSimple_of_pBasisRankOne :
    PBasisRankOne (F := F) (q := q) → AllFiniteExtensionsSimple (F := F)

/-- Steinitz's converse base-field classification.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 14 IV`, theorem IV, p. 244; if every finite extension over the
characteristic-`q` base field `F` is simple, then `F` is perfect or has the
exceptional rank-one Frobenius boundary `[F : F^p] = p`. -/
axiom perfect_or_pBasisRankOne_of_allFiniteExtensionsSimple :
    AllFiniteExtensionsSimple (F := F) → PerfectField F ∨ PBasisRankOne (F := F) (q := q)

/-- Steinitz's base-field criterion for when every finite extension over `F`
is simple.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 14 IV`, theorem IV, p. 244. -/
theorem primitive_element_base_criterion :
    AllFiniteExtensionsSimple (F := F) ↔
      (PerfectField F ∨ PBasisRankOne (F := F) (q := q)) := by
  constructor
  · exact perfect_or_pBasisRankOne_of_allFiniteExtensionsSimple (F := F) (q := q)
  · rintro (hperfect | hrank)
    · exact allFiniteExtensionsSimple_of_perfect (F := F)
    · exact allFiniteExtensionsSimple_of_pBasisRankOne (F := F) (q := q) hrank

end MathlibExpansion.FieldTheory.PrimitiveElement
