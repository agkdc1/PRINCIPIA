/-!
# T20c_05_RTTA — PM significance / ranges of significance (Q0 quarantine, 2/3)

Russell + Whitehead, *Principia Mathematica* (1910), Introduction Ch. II §III.
Quarantine layer ONLY. PM treats every propositional function as having a
"range of significance" — the set of arguments for which the function is
"significant" (true or false). Outside that range, the function is neither
true nor false; it is meaningless. This is structurally distinct from Lean's
`Sort u` typing, which classifies *types*, not predicate-significance.

This file does NOT use Lean's universe metavariables or typeclass synthesis
to model significance. Both would silently validate ramification by the
wrong mechanism.

References:
* Russell-Whitehead 1910, PM vol. I, Introduction Ch. II §III, pp. 47-52.
* Russell 1908 "Mathematical Logic as Based on the Theory of Types",
  *American J. Math.* 30, §II.
* SEP "Principia Mathematica" §3 (2020).
-/

namespace MathlibExpansion.Logic.Russell

/-- QUARANTINE: a PM propositional function in the ramified syntax. NOT a
Lean predicate; just a syntactic handle. -/
structure PMPropFun where
  /-- Opaque tag. -/
  handle : Unit

/-- QUARANTINE: the PM "is significant" judgment. Recorded as a `Prop`
black box. -/
def Significant (_ : PMPropFun) : Prop := True

/-- QUARANTINE: PM's prohibition on self-application — packaged as a
contract that consumes a "self-apply not significant" hypothesis and
returns the corresponding non-significance judgment. The substantive
content (that self-application is illicit) is supplied by the consumer in
the ramified-syntax layer; here we only NAME the contract. -/
def not_significant_self_apply
    (φ : PMPropFun) (selfApplyNotSig : Prop)
    (h : selfApplyNotSig) : selfApplyNotSig := h

/-- QUARANTINE: every PM propositional function admits the trivial
significance judgment in our quarantine bookkeeping. This is a TAUTOLOGY in
the bookkeeping; it does NOT discharge PM's substantive significance
analysis, which lives in the ramified syntax. -/
theorem trivial_significant (φ : PMPropFun) : Significant φ := trivial

end MathlibExpansion.Logic.Russell
