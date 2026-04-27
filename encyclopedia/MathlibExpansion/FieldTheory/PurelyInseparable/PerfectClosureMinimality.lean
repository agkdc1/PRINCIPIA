import Mathlib.FieldTheory.PurelyInseparable.PerfectClosure

/-!
# Relative perfect closure minimality

This chapter records Steinitz `PFRPC_11`: inside a perfect ambient field, the
relative perfect closure is the least perfect intermediate field.

The surrounding relative perfect-closure machinery is upstream in Mathlib; the
missing surface is the textbook-facing leastness theorem. The statement below
is kept as a single upstream-narrow boundary.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, end of the
  `Wurzelkoerper` paragraph in `Sec. 12`, p. 229.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.PurelyInseparable

open IntermediateField

variable (F E : Type*) [Field F] [Field E] [Algebra F E]

private theorem perfectClosure_le_of_perfect
    (L : IntermediateField F E) [PerfectField L] :
    perfectClosure F E ≤ L := by
  let p := ringExpChar F
  haveI : ExpChar F p := ringExpChar.expChar F
  haveI : ExpChar E p := expChar_of_injective_algebraMap (algebraMap F E).injective p
  haveI : ExpChar L p := IntermediateField.expChar L p
  haveI : PerfectRing L p := PerfectField.toPerfectRing p
  intro x hx
  rcases (mem_perfectClosure_iff_pow_mem (F := F) (E := E) p).1 hx with ⟨n, y, hy⟩
  let z : L := (iterateFrobeniusEquiv L p n).symm (algebraMap F L y)
  have hzL : z ^ p ^ n = algebraMap F L y := by
    change iterateFrobeniusEquiv L p n z = algebraMap F L y
    simp [z]
  have hzE : ((z : L) : E) ^ p ^ n = algebraMap F E y := by
    change (algebraMap L E z) ^ (p ^ n) = algebraMap F E y
    rw [← map_pow (algebraMap L E) z (p ^ n), hzL]
    simp
  have hx_eq : x = (z : E) := by
    apply (iterateFrobenius_inj E p n)
    change x ^ p ^ n = ((z : L) : E) ^ p ^ n
    rw [← hy, hzE]
  rw [hx_eq]
  exact z.2

variable [PerfectField E]

/-- In a perfect ambient field, `perfectClosure F E` is the least perfect
intermediate field between `F` and `E`. -/
theorem perfectClosure_isLeast_perfectIntermediate :
    IsLeast {L : IntermediateField F E | PerfectField L} (perfectClosure F E) := by
  refine ⟨?_, ?_⟩
  · change PerfectField (perfectClosure F E)
    infer_instance
  intro L hL
  letI : PerfectField L := hL
  exact perfectClosure_le_of_perfect (F := F) (E := E) L

end MathlibExpansion.FieldTheory.PurelyInseparable
