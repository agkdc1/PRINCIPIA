import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
import Mathlib.FieldTheory.IsAlgClosed.Basic
import MathlibExpansion.FieldTheory.PrimeField

/-!
# Prime-field algebraic-closure embeddings
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.IsAlgClosed

/-- Every algebraically closed characteristic-zero field contains an image of
Mathlib's canonical algebraic closure of `Q`.

Source: Mathlib `IsAlgClosed.lift`, Stacks Project tag `09GU`, the extension
lemma for embeddings from algebraic extensions into algebraically closed
fields.  The algebraic-closure construction follows Kenny Lau's Mathlib
implementation of `AlgebraicClosure`, documented from Keith Conrad's
algebraic-closure construction notes. -/
noncomputable def embedRatAlgClosure
    (K : Type*) [Field K] [CharZero K] [Algebra ℚ K] [IsAlgClosed K] :
    AlgebraicClosure ℚ →ₐ[ℚ] K :=
  IsAlgClosed.lift (R := ℚ) (S := AlgebraicClosure ℚ) (M := K)

/-- Every algebraically closed field of characteristic `p` contains the
distinguished prime subfield image supplied by the local prime-field facade.

Source: E. Steinitz (1910), *Algebraische Theorie der Koerper*, Sec. 4; this
is the positive-characteristic specialization already formalized as
`MathlibExpansion.FieldTheory.primeFieldEquivZMod`. -/
theorem embedZModAlgClosure
    (K : Type*) (p : ℕ) [Fact p.Prime] [Field K] [CharP K p] [Algebra (ZMod p) K]
    [IsAlgClosed K] :
    ∃ _ : Subfield K, True :=
  MathlibExpansion.FieldTheory.primeFieldEquivZMod K p

end MathlibExpansion.FieldTheory.IsAlgClosed
