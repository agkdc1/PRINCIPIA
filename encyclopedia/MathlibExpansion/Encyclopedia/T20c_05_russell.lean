import MathlibExpansion.Logic.Russell.TypedNoClassShadow
import MathlibExpansion.Logic.Russell.PropositionalRules
import MathlibExpansion.Logic.Russell.ApparentVariables
import MathlibExpansion.Textbooks.Principia1910.Identity
import MathlibExpansion.Logic.Russell.ClassesShadow
import MathlibExpansion.Logic.Russell.ClassQuantifiers
import MathlibExpansion.Logic.Russell.UnitClassesAndCouples
import MathlibExpansion.Logic.Russell.Descriptions
import MathlibExpansion.Foundations.Russell.Similarity
import MathlibExpansion.Foundations.Russell.CardinalAbstraction
import MathlibExpansion.Logic.Russell.RelationDomain
import MathlibExpansion.Logic.Russell.DescriptiveFunction
import MathlibExpansion.Foundations.Relations.Selection
import MathlibExpansion.Logic.Russell.MultiplicativeAxiomBoundary
import MathlibExpansion.Foundations.Relations.Ancestral
import MathlibExpansion.Foundations.Russell.InequalityOfCardinals
import MathlibExpansion.Logic.Russell.RelationalTypeAscent
import MathlibExpansion.Quarantine.RussellReducibility
import MathlibExpansion.Logic.Russell.ViciousCircle
import MathlibExpansion.Logic.Russell.Significance
import MathlibExpansion.Logic.Russell.RamifiedTypes

/-!
# T20c_05 Russell + Whitehead — Principia Mathematica (1910) — Step 6 closure

Aggregator file collecting the W3a/W3b/W4a/W4b/W5/Q0/F1/F2/W1/W2 substrate
for the T20c_05 Step 6 breach dispatch.

## Topic-key inventory (15)

* TNCSB — Typed no-class shadow boundary (F1)
* RPD   — Russell propositional doctrine (F2)
* AVQ   — Apparent-variable quantifiers (W1a)
* IDEI  — Identity & indiscernibility (W1b)
* RCIS  — Russell classes as incomplete symbols (W1c)
* UCC   — Unit classes and couples (W1d)
* DDIS  — Definite descriptions as incomplete symbols (W2a)
* SCA   — Similarity & cardinal abstraction (W2b)
* DF    — Descriptive functions (W3a)
* RRP   — Relation domain/range/field/restriction/image (W3b)
* SELI  — Selection / transversals (W4a)
* MAB   — Multiplicative-axiom boundary (W4b)
* AR    — Ancestral relations (W5a)
* IRAA  — Inequality and reducibility of cardinals (W5d)
* RTTA  — Relation-theoretic type ascent (W5z)

## Quarantine (Q0)

* RussellReducibility, ViciousCircle, Significance, RamifiedTypes — held
  behind `Quarantine/` and `Logic/Russell/` walls; no `Type → Prop`
  extraction permitted.

## Sharp upstream-narrow axioms (genuine breaches)

* MAB-03 — multiplicative axiom (Zermelo 1904)
* MAB-05 — arbitrary-family choice (Zermelo 1908)
* IRAA-10 — Cantor-Bernstein (Cantor 1895/Schröder 1898/Bernstein 1898/PM `*117·6`)
* IRAA-11 — cardinal trichotomy schema (PM Vol II)
* IRAA-14 — limitation-of-size (Russell 1903 ch. X)
-/
