import Mathlib.FieldTheory.IsAlgClosed.Classification

/-!
# Prime-field classification facade

Step 6 defers the direct Steinitz class theorem by characteristic and absolute
transcendence degree. Mathlib already has the basis-indexed classification
engine; the missing surface is the prime-field-facing wrapper.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 23(5)-(6)`.
- Historical finite-characteristic note cited by Steinitz nearby:
  L. E. Dickson (1907), *Transactions of the American Mathematical Society* 8,
  p. 389.
-/

noncomputable section

universe u v

namespace MathlibExpansion.FieldTheory.IsAlgClosed

/-- The canonical algebra structure from a field's explicit characteristic base. -/
private abbrev charBaseAlgebra (p : ℕ) (K : Type u) [Field K] [CharP K p] :
    Algebra (ZMod p) K :=
  ZMod.algebra _ _

/-- Existence of a transcendence basis over the explicit characteristic prime
base `ZMod p`.

Source: E. Steinitz (1910), *Algebraische Theorie der Koerper*, Sec. 23(3),
printed p. 299, for existence/maximality of transcendence bases; Mathlib
provides this as `exists_isTranscendenceBasis'`. -/
private theorem exists_transcendenceBasis_over_charBase
    (p : ℕ) (K : Type u) [Field K] [CharP K p] :
    ∃ (ι : Type u) (x : ι → K),
      @IsTranscendenceBasis ι (ZMod p) K _ _ (charBaseAlgebra p K) x := by
  letI : Algebra (ZMod p) K := charBaseAlgebra p K
  simpa [charBaseAlgebra] using
    (@exists_isTranscendenceBasis' (ZMod p) K _ _ (charBaseAlgebra p K)
      (show Function.Injective (algebraMap (ZMod p) K) from
        ZMod.castHom_injective K))

/-- Boundary carrier for a transcendence basis over an explicit characteristic
base. This is the sharpened upstream-facing carrier: consumers pass the common
characteristic `p` instead of asking Lean to transport through `ringChar`
equalities. -/
def BasisIndexOverChar (p : ℕ) (K : Type u) [Field K] [CharP K p] : Type u :=
  Classical.choose (exists_transcendenceBasis_over_charBase p K)

/-- Boundary carrier for an absolute prime-field transcendence basis, specialized
to `p = ringChar K`. -/
def BasisIndexOverPrimeField (K : Type u) [Field K] : Type u :=
  letI : CharP K (ringChar K) := ringChar.charP K
  BasisIndexOverChar (ringChar K) K

/-- The chosen characteristic-base transcendence basis. -/
private def basisOverChar (p : ℕ) (K : Type u) [Field K] [CharP K p] :
    BasisIndexOverChar p K → K :=
  Classical.choose (Classical.choose_spec (exists_transcendenceBasis_over_charBase p K))

/-- The chosen basis is a Mathlib transcendence basis over `ZMod p`. -/
private theorem basisOverChar_isTranscendenceBasis
    (p : ℕ) (K : Type u) [Field K] [CharP K p] :
    @IsTranscendenceBasis (BasisIndexOverChar p K) (ZMod p) K _ _
      (charBaseAlgebra p K) (basisOverChar p K) :=
  Classical.choose_spec
    (Classical.choose_spec (exists_transcendenceBasis_over_charBase p K))

/-- Sharpened Steinitz class theorem: algebraically closed fields of a common
explicit characteristic `p` are classified by absolute transcendence degree over
that characteristic prime base.

Source: E. Steinitz (1910), *Algebraische Theorie der Koerper*, Sec. 23(5)-(6),
printed pp. 300-301. The proof is Mathlib's basis-indexed classification
`IsAlgClosed.equivOfTranscendenceBasis`, specialized to `ZMod p`. -/
theorem ringEquiv_of_char_eq_of_abs_trdeg_eq
    (p : ℕ) (K : Type u) (L : Type v) [Field K] [Field L] [CharP K p] [CharP L p]
    [IsAlgClosed K] [IsAlgClosed L]
    (htrdeg : Nonempty (BasisIndexOverChar p K ≃ BasisIndexOverChar p L)) :
    Nonempty (K ≃+* L) := by
  letI : Algebra (ZMod p) K := charBaseAlgebra p K
  letI : Algebra (ZMod p) L := charBaseAlgebra p L
  obtain ⟨e⟩ := htrdeg
  exact ⟨_root_.IsAlgClosed.equivOfTranscendenceBasis
    (R := ZMod p) (K := K) (L := L)
    (v := basisOverChar p K) (w := basisOverChar p L)
    e (basisOverChar_isTranscendenceBasis p K) (basisOverChar_isTranscendenceBasis p L)⟩

end MathlibExpansion.FieldTheory.IsAlgClosed
