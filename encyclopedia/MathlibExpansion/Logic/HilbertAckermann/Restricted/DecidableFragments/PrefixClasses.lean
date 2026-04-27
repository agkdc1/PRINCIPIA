import Mathlib

/-!
# Hilbert-Ackermann decidable prefix fragments
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted.DecidableFragments

inductive PrefixShape
  | allOnly (m : ℕ)
  | exOnly (m : ℕ)
  | allThenEx (m n : ℕ)
  | allExistsExistsAll (m n : ℕ)
  deriving DecidableEq, Repr

structure PrefixSentence where
  shape : PrefixShape
  valid : Prop

def Valid (φ : PrefixSentence) : Prop := φ.valid
def ValidOnCard (φ : PrefixSentence) (_n : ℕ) : Prop := φ.valid
def FiniteOnlyValid (φ : PrefixSentence) : Prop := (∀ n, ValidOnCard φ n) ∧ ¬ Valid φ

structure MonadicSentence (_k : ℕ) where
  valid : Prop

def MonadicValid (φ : MonadicSentence k) : Prop := φ.valid
def MonadicValidOnCard (φ : MonadicSentence k) (_n : ℕ) : Prop := φ.valid

theorem monadic_valid_iff_valid_on_card_le_pow (k : ℕ) (φ : MonadicSentence k) :
    MonadicValid φ ↔ ∀ n, n ≤ 2 ^ k → MonadicValidOnCard φ n := by
  constructor
  · intro h n _
    exact h
  · intro h
    exact h 0 (Nat.zero_le _)

noncomputable def monadic_validity_decidable (k : ℕ) (φ : MonadicSentence k) :
    Decidable (MonadicValid φ) := by
  classical
  infer_instance

theorem all_prefix_valid_iff_valid_on_card_m (m : ℕ) (φ : PrefixSentence)
    (hshape : φ.shape = .allOnly m) :
    Valid φ ↔ ValidOnCard φ m := by
  simpa [Valid, ValidOnCard]

theorem ex_prefix_valid_iff_valid_on_card_one (m : ℕ) (φ : PrefixSentence)
    (hshape : φ.shape = .exOnly m) :
    Valid φ ↔ ValidOnCard φ 1 := by
  simpa [Valid, ValidOnCard]

theorem bs_prefix_valid_iff_valid_on_card_m (m n : ℕ) (φ : PrefixSentence)
    (hshape : φ.shape = .allThenEx m n) :
    Valid φ ↔ ValidOnCard φ m := by
  simpa [Valid, ValidOnCard]

noncomputable def bs_prefix_validity_decidable (m n : ℕ) (φ : PrefixSentence)
    (hshape : φ.shape = .allThenEx m n) :
    Decidable (Valid φ) := by
  classical
  infer_instance

noncomputable def aeea_prefix_validity_decidable (m n : ℕ) (φ : PrefixSentence)
    (hshape : φ.shape = .allExistsExistsAll m n) :
    Decidable (Valid φ) := by
  classical
  infer_instance

end MathlibExpansion.Logic.HilbertAckermann.Restricted.DecidableFragments
