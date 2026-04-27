/-!
# T20c_05_AR — Russell axiom of reducibility (Q0 quarantine)

Russell + Whitehead, *Principia Mathematica* (1910), `*12·1`, `*12·11`,
Introduction §VI. Quarantine layer ONLY. **Not** admissible as production
foundation.

Doctrine, per the Step 5 verdict and Boardroom debate (`T20c_05`):

* `Classical.choice` is NOT the axiom of reducibility. PM's reducibility is
  about predicative-vs-impredicative formula equivalence inside a ramified
  hierarchy, not about extracting witnesses from existence proofs.
* `Set α` is NOT PM's class ontology. PM classes are incomplete symbols
  contextually defined at `*20·01`; identifying them with `Set α` silently
  validates reducibility through the wrong mechanism.

Therefore every declaration in this file is marked QUARANTINE. The intended
consumer boundary is exactly `MathlibExpansion/Logic/Russell/RamifiedTypes.lean`
(via the typed-syntax quarantine layer). No production module may import this
file; doing so means a substrate gap was packaged through reducibility, which
the Boardroom doctrine forbids.

References:
* Russell-Whitehead 1910, *Principia Mathematica* vol. I, `*12·1`-`*12·11`.
* Russell-Whitehead 1910, *Principia Mathematica* vol. I, Introduction §VI.
* Stanford Encyclopedia of Philosophy, "Principia Mathematica" §6 (2020).
* Quine 1937, "New Foundations for Mathematical Logic", §1 (critique of AR).
-/

namespace MathlibExpansion.Quarantine.RussellReducibility

/-- QUARANTINE: a Russell-facing typed propositional-function syntax token.
This is NOT a Lean predicate; it is a neutral carrier for the ramified-types
quarantine package. Indexed-syntax interpretation lives in
`Logic/Russell/RamifiedTypes.lean`. -/
structure RussellPropFunSyntax (α : Type) where
  /-- Opaque syntax handle. Carrier only; no semantic content here. -/
  tag : Unit

/-- QUARANTINE (`*12·1`): unary axiom of reducibility. PM asserts that for
every propositional function `φ` of order > 1 there exists a predicative (i.e.
order-0 in PM's reformed reading) function `ψ` formally equivalent to it. We
state this as an indexed quarantine contract, NOT as a Lean theorem.

Direction: `RussellReducibility_unary` is parameterised by a quarantine
witness `Witness` and produces the quarantine output `Witness`. This is
deliberately a tautological packaging: it makes explicit that the content of
PM's `*12·1` is exactly an as-given existence assertion that lives in PM's
ramified syntax and not in Lean's term language. -/
def RussellReducibility_unary {α : Type} (_ : RussellPropFunSyntax α)
    (Witness : Prop) (h : Witness) : Witness := h

/-- QUARANTINE (`*12·11`): binary axiom of reducibility. Same packaging as the
unary form; the binary case is what PM uses for relations between objects of
different types. -/
def RussellReducibility_binary {α β : Type}
    (_ : RussellPropFunSyntax α) (_ : RussellPropFunSyntax β)
    (Witness : Prop) (h : Witness) : Witness := h

/-- QUARANTINE: the alternative schema PM (`*12·12` and the Introduction's
discussion) sketches but does not adopt — replacing reducibility by an
explicit choice principle. PM's text is explicit that this is rejected as
foundation; we record it here only for completeness of the quarantine
boundary. -/
def RussellReducibility_alternative_schema (Witness : Prop) (h : Witness) :
    Witness := h

/-- QUARANTINE: the comparison theorem connecting PM's reducibility-bearing
class talk to the typed no-class shadow. The intended reading: IF a Russell
class context is licensed by reducibility (a quarantine assumption), THEN
the typed shadow class context follows. Stated as a quarantine implication
to make the boundary crossing explicit. -/
def RussellClassImpliesReducibility
    (ReducibilityLicense : Prop) (ShadowContext : Prop)
    (h : ReducibilityLicense → ShadowContext)
    (lic : ReducibilityLicense) : ShadowContext :=
  h lic

end MathlibExpansion.Quarantine.RussellReducibility
