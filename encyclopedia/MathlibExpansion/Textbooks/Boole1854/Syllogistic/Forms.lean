import Mathlib

/-!
# Boole 1854 syllogistic forms

This is the typed categorical shell for Boole's Chapter XV, together with the
small conversion examples the Step 5 verdict asked to land before the general
syllogistic rule package.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Boole1854
namespace Syllogistic

/-- A class term together with Boole's positive/negative subject convention. -/
structure SignedTerm (α : Type*) where
  carrier : Set α
  positive : Bool

/-- The semantic extent of a signed term. -/
def SignedTerm.extent {α : Type*} (T : SignedTerm α) : Set α :=
  if T.positive then T.carrier else T.carrierᶜ

/-- Boole's four categorical shapes, now allowed to use signed terms. -/
inductive CategoricalForm (α : Type*)
  | universalAffirmative (S P : SignedTerm α)
  | universalNegative (S P : SignedTerm α)
  | particularAffirmative (S P : SignedTerm α)
  | particularNegative (S P : SignedTerm α)

/-- Set-theoretic semantics for the categorical shell. -/
def CategoricalForm.Holds {α : Type*} : CategoricalForm α → Prop
  | .universalAffirmative S P => S.extent ⊆ P.extent
  | .universalNegative S P => Disjoint S.extent P.extent
  | .particularAffirmative S P => (S.extent ∩ P.extent).Nonempty
  | .particularNegative S P => (S.extent ∩ P.extentᶜ).Nonempty

theorem particular_conversion {α : Type*} {X Y : Set α}
    (h : (Y ∩ X).Nonempty) : (X ∩ Y).Nonempty := by
  rcases h with ⟨a, haY, haX⟩
  exact ⟨a, haX, haY⟩

theorem conversion_per_accidens {α : Type*} {X Y : Set α}
    (hYX : Y ⊆ X) (hY : Y.Nonempty) : (X ∩ Y).Nonempty := by
  rcases hY with ⟨a, haY⟩
  exact ⟨a, hYX haY, haY⟩

theorem negative_subject_example {α : Type*} {X Y Z : Set α}
    (hYX : Y ⊆ X) (hNotY : Yᶜ ⊆ Z) : Xᶜ ⊆ Z := by
  intro a haX
  apply hNotY
  intro haY
  exact haX (hYX haY)

end Syllogistic
end Boole1854
end Textbooks
end MathlibExpansion
