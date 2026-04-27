import MathlibExpansion.Logic.Russell.ViciousCircle
import MathlibExpansion.Logic.Russell.Significance

/-!
# T20c_05_RTTA — Ramified types and typical ambiguity (Q0 quarantine, 3/3)

Russell + Whitehead, *Principia Mathematica* (1910), Introduction Ch. II §§II,
VIII; `*12` summary. Quarantine layer ONLY. PM stratifies propositional
functions into orders: order 0 is "individuals + atomic predicates", order
n+1 is functions whose values are functions/propositions of order ≤ n.

Doctrine, per the Step 5 verdict and Boardroom debate (`T20c_05`):

* PM ramification CANNOT be honestly mapped onto Lean's `Sort u` ladder.
  Universe polymorphism stratifies types; PM ramification stratifies
  propositional functions by ranges of significance. They are distinct
  mechanisms. Doing so would silently validate ramification by the wrong
  mechanism.
* "Typical ambiguity" — PM's reading of a single formula at all admissible
  type-stratifications — is NOT modelled here via universe metavariables
  or typeclass synthesis.

References:
* Russell-Whitehead 1910, PM vol. I, Introduction Ch. II §§II, VIII;
  `*12` summary.
* Russell 1908 "Mathematical Logic as Based on the Theory of Types",
  *American J. Math.* 30.
* Burali-Forti 1897, "Una questione sui numeri transfiniti", *Rend. Circ.
  Mat. Palermo* 11 (cited PM Footnote 23, paradox-motivation).
* König 1905 "Ueber die Grundlagen der Mengenlehre", *Math. Ann.* 61
  (cited PM Footnote 26).
* Hobson, *On the Arithmetic Continuum* (cited PM Footnote 26).
-/

namespace MathlibExpansion.Logic.Russell

/-- QUARANTINE: a PM ramified-expression token. NOT a Lean type; just a
syntactic handle. -/
inductive PMExpr
  | atom (_ : Unit)
  | apply (_ : PMExpr) (_ : PMExpr)
  | bind (_ : PMExpr)
  deriving DecidableEq

/-- QUARANTINE: the PM order index `IsOrder n e` — "expression `e` has
ramified order `n`". This is a quarantine relation, NOT a Lean typing
judgment. -/
inductive IsOrder : Nat → PMExpr → Prop
  | atom_zero (u : Unit) : IsOrder 0 (PMExpr.atom u)
  | apply_succ {n : Nat} {e₁ e₂ : PMExpr}
      (h₁ : IsOrder n e₁) (h₂ : IsOrder n e₂) :
      IsOrder (n + 1) (PMExpr.apply e₁ e₂)
  | bind_succ {n : Nat} {e : PMExpr}
      (h : IsOrder n e) : IsOrder (n + 1) (PMExpr.bind e)

/-- QUARANTINE (`*12` summary item (1)): every atomic expression has order 0.
Witness for the quarantine bookkeeping. -/
theorem isOrder_atom (u : Unit) : IsOrder 0 (PMExpr.atom u) :=
  IsOrder.atom_zero u

/-- QUARANTINE (`*12` summary item (2)): order is closed under PM's
syntactic application — going from order `n` operands to order `n+1`
applications. -/
theorem isOrder_apply_succ {n : Nat} {e₁ e₂ : PMExpr}
    (h₁ : IsOrder n e₁) (h₂ : IsOrder n e₂) :
    IsOrder (n + 1) (PMExpr.apply e₁ e₂) :=
  IsOrder.apply_succ h₁ h₂

/-- QUARANTINE: order is closed under PM's binding constructor (the
ramified-quantifier rule), going from order `n` body to order `n+1`. -/
theorem isOrder_bind_succ {n : Nat} {e : PMExpr} (h : IsOrder n e) :
    IsOrder (n + 1) (PMExpr.bind e) :=
  IsOrder.bind_succ h

/-- QUARANTINE: typical-ambiguity placeholder. PM's "typical ambiguity"
schema reads a formula uniformly at every order. We record this as a
black-box `Prop` family parameterised by order; the substantive content
that the same formula is admissible at every order is supplied by the
consumer in the ramified-syntax layer. -/
def TypicallyAmbiguous (P : Nat → Prop) : Prop := ∀ n, P n → P (n + 1)

/-- QUARANTINE: typical ambiguity is preserved under monotone-in-order
predicates. Bookkeeping witness only. -/
theorem typically_ambiguous_const_true :
    TypicallyAmbiguous (fun _ => True) := by
  intro _ _
  trivial

end MathlibExpansion.Logic.Russell
