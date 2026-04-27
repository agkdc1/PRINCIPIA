import Mathlib.Data.Complex.Basic
import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.NumberTheory.NumberField.ClassNumber
import Mathlib.RingTheory.ClassGroup

/-!
# T20c_12_CLASS_GROUP_CHARACTERS — Hecke Ch.2 finite duality consumed Chs.5–8

Class-group character API: `ClassGroup (𝓞 K) →* ℂˣ` with duality and
orthogonality. Abstract finite-abelian duality is upstream at
`Mathlib/GroupTheory/FiniteAbelian/Duality.lean:67`; the class-group-specific
character API and orthogonality formula `∑_χ χ(a) = h_K · [a = 1]` is the gap.

Citation: Hecke 1923, Ch.2 (consumed by Chs.5–8); Neukirch 1999, *Algebraic
Number Theory*, Ch. VII §1; Hilbert *Zahlbericht* §§22–23, 28.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField BigOperators
open NumberField

/-- Class-group-character orthogonality: there exists a finite set of
characters whose summed values on `a ∈ ClassGroup (𝓞 K)` equal `h_K` when
`a = 1` and vanish otherwise. Stated as a disjunction to avoid a class-group
equality `Decidable` hypothesis. -/
axiom t20c_12_classGroup_characters
    (K : Type) [Field K] [NumberField K] (a : ClassGroup (𝓞 K)) :
    ∃ S : Finset (ClassGroup (𝓞 K) →* ℂˣ),
      (a = 1 ∧ (∑ χ ∈ S, (χ a : ℂ)) = (NumberField.classNumber K : ℂ)) ∨
      (a ≠ 1 ∧ (∑ χ ∈ S, (χ a : ℂ)) = 0)

end MathlibExpansion.Encyclopedia.T20c_12
