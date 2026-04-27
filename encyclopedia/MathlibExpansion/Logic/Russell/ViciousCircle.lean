/-!
# T20c_05_RTTA — Vicious-circle principle (Q0 quarantine, part 1 of 3)

Russell + Whitehead, *Principia Mathematica* (1910), Introduction Ch. II §I.
Quarantine layer ONLY. The vicious-circle principle states that no totality
may contain elements defined in terms of that totality. PM uses this to
motivate ramified types.

This file does NOT identify PM totalities with Lean's `Type u` or with `Set α`.
PM's "totality" is an order-of-significance grouping, not a coherent Lean type.

References:
* Russell-Whitehead 1910, PM vol. I, Introduction Ch. II §I, pp. 37-44.
* Poincaré 1906, *Les mathématiques et la logique*, §§4-5
  (cited PM Footnote 12 as direct antecedent).
* Russell 1908, "Mathematical Logic as Based on the Theory of Types",
  *American J. Math.* 30, §I.
-/

namespace MathlibExpansion.Logic.Russell

/-- QUARANTINE: PM "collection" carrier. NOT a Lean type or set. Just an
opaque syntactic handle for the quarantine package. -/
structure PMCollection where
  /-- Opaque tag. PM-collection identity is not given by Lean equality. -/
  handle : Unit

/-- QUARANTINE: the predicate "this collection has a definite totality" in
PM's sense. NOT decidable, NOT extensional in the Lean sense; recorded as a
black-box `Prop`. -/
def HasTotal (_ : PMCollection) : Prop := True

/-- QUARANTINE: the vicious-circle principle, stated as a quarantine
contract. The hypothesis `mentionsTotality_self` is a stipulation that the
self-reference holds at the syntactic level (in PM's ramified syntax, NOT in
Lean). The conclusion `notLicensed` is the PM judgment that the construction
is illicit.

This is a quarantine package, not a Lean theorem about Lean values. -/
def viciousCircle_principle
    (C : PMCollection) (mentionsTotality_self : Prop)
    (notLicensed : Prop)
    (h : HasTotal C → mentionsTotality_self → notLicensed)
    (hT : HasTotal C) (hM : mentionsTotality_self) : notLicensed :=
  h hT hM

end MathlibExpansion.Logic.Russell
