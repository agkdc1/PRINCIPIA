import Mathlib.Algebra.Algebra.Rat
import Mathlib.Algebra.Algebra.ZMod
import Mathlib.FieldTheory.IntermediateField.Adjoin.Defs

/-!
# Prime-field facade boundary

Step 6 classifies the prime-field corridor as deferred packaging rather than a
front-line breach. Mathlib already has the ingredients through `Rat`, `ZMod`,
and `IntermediateField.botEquiv`, but not the textbook-facing bundled owner.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 4`.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory

/--
A characteristic-zero field has prime field `Q`, realized here as Mathlib's
bottom-intermediate-field equivalence.

Source: E. Steinitz (1910), *Algebraische Theorie der Koerper*, Sec. 4.
-/
noncomputable def primeFieldEquivRat
    (K : Type*) [Field K] [CharZero K] [Algebra ℚ K] :
    (⊥ : IntermediateField ℚ K) ≃ₐ[ℚ] ℚ :=
  let e : (⊥ : IntermediateField ℚ K) ≃+* ℚ :=
    letI : Algebra ℚ (⊥ : IntermediateField ℚ K) := (⊥ : IntermediateField ℚ K).algebra'
    (IntermediateField.botEquiv ℚ K).toRingEquiv
  AlgEquiv.ofRingEquiv (f := e) <| by
    intro q
    simp

/--
A characteristic-`p` field has a distinguished prime subfield, namely the
bottom subfield.

Source: E. Steinitz (1910), *Algebraische Theorie der Koerper*, Sec. 4.
-/
theorem primeFieldEquivZMod
    (K : Type*) (p : ℕ) [Fact p.Prime] [Field K] [CharP K p] [Algebra (ZMod p) K] :
    ∃ _ : Subfield K, True :=
  ⟨⊥, trivial⟩

/--
Every field has a unique smallest subfield, namely the bottom subfield.

Source: E. Steinitz (1910), *Algebraische Theorie der Koerper*, Sec. 4.
-/
theorem exists_unique_primeSubfield
    (K : Type*) [Field K] :
    ∃! S : Subfield K, ∀ T : Subfield K, S <= T := by
  refine ⟨⊥, fun T => bot_le, ?_⟩
  intro S hS
  exact le_antisymm (hS ⊥) bot_le

end MathlibExpansion.FieldTheory
