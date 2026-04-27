import Mathlib.SetTheory.Ordinal.FixedPoint
import Mathlib.SetTheory.Ordinal.Notation
import MathlibExpansion.SetTheory.Ordinal.SecondNumberClass

/-!
# Textbook-facing epsilon-zero endpoint

The existing Mathlib ordinal substrate already covers well-foundedness and
least fixed points of normal ordinal functions. This file exposes the
historical `epsilonZero` endpoint that the Hilbert-Bernays / Gentzen response
lane needs.
-/

namespace MathlibExpansion.SetTheory.Ordinal

/--
Gentzen's `ε₀`, implemented as the least fixed point of `a ↦ ω ^ a`.

This is the ordinal endpoint used in Gentzen (1936), "Die Widerspruchsfreiheit
der reinen Zahlentheorie", for transfinite induction below `ε₀`.
-/
noncomputable def epsilonZero : _root_.Ordinal.{0} :=
  _root_.Ordinal.nfp (fun a : _root_.Ordinal.{0} => _root_.Ordinal.omega0 ^ a) 0

/-- Gentzen notations are the ordinals explicitly kept below `ε₀`. -/
abbrev GentzenNotation := {o : _root_.Ordinal.{0} // o < epsilonZero}

/-- The inherited order on Gentzen notations. -/
def GentzenLess (a b : GentzenNotation) : Prop := a.1 < b.1

theorem gentzenNotation_wf : WellFounded GentzenLess := by
  simpa [GentzenLess] using
    (InvImage.wf (fun a : GentzenNotation => a.1) _root_.Ordinal.lt_wf)

/--
Closure boundary for the `ω`-power operation below `ε₀`, from the least
fixed-point construction of Gentzen (1936), "Die Widerspruchsfreiheit der
reinen Zahlentheorie".
-/
theorem omega_pow_lt_epsilonZero
    {a : _root_.Ordinal.{0}} (ha : a < epsilonZero) :
    _root_.Ordinal.omega0 ^ a < epsilonZero := by
  simpa [epsilonZero] using
    ((_root_.Ordinal.isNormal_opow _root_.Ordinal.one_lt_omega0).apply_lt_nfp).2 ha

/--
Fixed-point boundary for `ε₀`, from the least fixed-point construction of
Gentzen (1936), "Die Widerspruchsfreiheit der reinen Zahlentheorie".
-/
theorem epsilonZero_fixedPoint :
    _root_.Ordinal.omega0 ^ epsilonZero = epsilonZero := by
  simpa [epsilonZero] using
    (_root_.Ordinal.isNormal_opow _root_.Ordinal.one_lt_omega0).nfp_fp (0 : _root_.Ordinal.{0})

end MathlibExpansion.SetTheory.Ordinal
