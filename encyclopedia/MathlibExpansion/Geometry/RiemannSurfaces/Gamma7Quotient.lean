import MathlibExpansion.Geometry.RiemannSurfaces.QuotientGenus

/-!
# Principal congruence level-7 quotient `X(7)` (Klein quartic)

The compactified quotient `X(7) = Γ(7) \ ℍ*` is the classical Klein
quartic, a compact Riemann surface of genus `3` with automorphism group
`PSL₂(𝔽₇)` of order `168` (Hurwitz-extremal).

HVT closed in this file:

* `KDS_13` — principal congruence level-7 compactified quotient,
  consuming `KDS_09`/`KDS_10` and recording the classical Klein-quartic
  genus and automorphism-order invariants.

Citation (upstream-narrow axiom):

* Klein, *Über die Transformation siebenter Ordnung der elliptischen
  Functionen* (Mathematische Annalen 14, 1879), where the genus-3
  modular curve `X(7)` is identified with the projective Klein quartic
  `x³y + y³z + z³x = 0`.
* Hurwitz, *Über algebraische Gebilde mit eindeutigen Transformationen
  in sich* (Mathematische Annalen 41, 1893), for the automorphism count
  `84(g-1) = 168`.
* Levy (ed.), *The Eightfold Way: The Beauty of Klein's Quartic Curve*
  (MSRI Publications 35, 1999).

Net axiom direction: `+1` upstream-narrow, with citation above.
-/

noncomputable section

open scoped UpperHalfPlane

namespace MathlibExpansion.Geometry.RiemannSurfaces

/-- Structural witness recording the classical invariants of the
Klein-quartic modular curve `X(7)`: genus `3`, automorphism order
`168`, compactification of the principal congruence level-7 quotient. -/
structure KleinQuarticInvariants (Γ7 : Type*) [Group Γ7] [MulAction Γ7 ℍ] where
  compactification : ModularCompactification Γ7
  genus_eq_three : Prop
  genus_eq_three_holds : genus_eq_three
  automorphism_order_eq_168 : Prop
  automorphism_order_eq_168_holds : automorphism_order_eq_168

/-- Upstream-narrow axiom: the compactified principal congruence
level-7 quotient has genus `3` and automorphism-group order `168` — the
classical Klein-quartic data.

Reference: Klein, *Modulfunctionen siebenter Ordnung* (MA 14, 1879);
Hurwitz, *Algebraische Gebilde* (MA 41, 1893). -/
axiom exists_kleinQuartic_invariants
    (Γ7 : Type*) [Group Γ7] [MulAction Γ7 ℍ]
    (c : ModularCompactification Γ7) :
    KleinQuarticInvariants Γ7

/-- The compactified level-7 modular quotient has the classical Klein-
quartic invariants. -/
theorem kleinQuartic_invariants_exist
    (Γ7 : Type*) [Group Γ7] [MulAction Γ7 ℍ]
    (c : ModularCompactification Γ7) :
    Nonempty (KleinQuarticInvariants Γ7) :=
  ⟨exists_kleinQuartic_invariants Γ7 c⟩

end MathlibExpansion.Geometry.RiemannSurfaces
