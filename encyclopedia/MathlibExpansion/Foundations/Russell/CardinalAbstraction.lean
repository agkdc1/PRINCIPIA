import MathlibExpansion.Foundations.Russell.Similarity

/-!
# T20c_05_SCA — Cardinal abstraction (W2b part 2)

Russell + Whitehead, *Principia Mathematica* (1910), `*52` and `*54`. PM's
cardinals 0 and 1 are abstracted from the empty class and unit-class
similarity classes. The wrappers here name the carriers and the obvious
small theorems.

References:
* Russell-Whitehead 1910, PM vol. I, `*52·01` (cardinal one).
* Russell-Whitehead 1910, PM vol. I, `*54·01`-`*54·26`.
-/

universe u

namespace MathlibExpansion.Foundations.Russell

/-- SCA-06 (`*52·01` `RussellCardinalOne`): the abstract carrier for PM's
cardinal `1` — types similar to `Unit`. -/
def RussellCardinalOne (α : Type u) : Prop := russell_similar α Unit

/-- SCA-07 (`*54·01` `RussellCardinalZero`): the abstract carrier for PM's
cardinal `0` — types similar to `Empty`. -/
def RussellCardinalZero (α : Type u) : Prop := russell_similar α Empty

/-- SCA-08 (`*54·101`): `Empty` itself has cardinal zero. -/
theorem russell_empty_isCardinalZero : RussellCardinalZero Empty :=
  russell_similar_refl Empty

/-- SCA-09 (`*54·101'`): `Unit` itself has cardinal one. -/
theorem russell_unit_isCardinalOne : RussellCardinalOne Unit :=
  russell_similar_refl Unit

/-- SCA-10 (`*54·26` cardinal-one is symmetric): if `α` has cardinal one,
so does `Unit` w.r.t. `α`. -/
theorem russell_isCardinalOne_symm {α : Type u}
    (h : RussellCardinalOne α) : russell_similar Unit α :=
  russell_similar_symm h

end MathlibExpansion.Foundations.Russell
