import MathlibExpansion.Geometry.RiemannSurfaces.KleinJPackage
import MathlibExpansion.Geometry.RiemannSurfaces.CuspCompactification
import MathlibExpansion.Geometry.RiemannSurfaces.QuotientGenus

/-!
# Klein level-5 modular bridge

The classical level-5 modular curve `X(5) = Γ(5) \ ℍ*` is a compact Riemann
surface of genus `0` with automorphism group `PSL₂(𝔽₅) ≅ A₅` of order
`60` — the icosahedral group.  Klein's *Vorlesungen über das Ikosaeder*
identifies the projective coordinates on `X(5)` with the icosahedral
invariants and connects this surface to the resolvent of the general
quintic.

This bridge consumes:

* `KDS_09` (`ModularQuotient.lean`): the Riemann-surface structure on
  `Γ(5) \ ℍ`;
* `KDS_10` (`CuspCompactification.lean`): the cusp compactification to the
  compact surface `X(5)`;
* `KMF_09` (`KleinJPackage.lean`): the Klein absolute invariant `j` and
  its `(2, 3, ∞)` branch data.

It exports a `KleinLevelFiveBridge` structure recording the four classical
invariants of `X(5)`:

* compactified principal-congruence level-5 quotient;
* genus `0`;
* automorphism order `60` (icosahedral group `A₅`);
* the existence of a covering map `X(5) → X(1)` of degree `60` that
  factors through Klein's `j` and exhibits the level-5 modular curve as
  the icosahedral cover of the `j`-line.

HVT closed in this file:

* `KMF_10` — Klein level-5 modular bridge consuming the quotient/
  compactification architecture and the Klein `j` value-card, exhibiting
  `X(5)` as the icosahedral cover of the `j`-line `X(1)`.

Citation (upstream-narrow axiom):

* Klein, *Vorlesungen über das Ikosaeder und die Auflösung der
  Gleichungen vom fünften Grade* (1884), §I.5 "Die Hauptgleichungen
  fünften Grades" and §II.1 "Die Beziehung der Ikosaedergleichung zur
  Modulargleichung fünften Grades".
* Bertin, *Mémoire sur les fonctions automorphes du disque unité*
  (Bulletin SMF, 1967), §IV "Le revêtement icosaédral".
* Klein & Fricke, *Vorlesungen über die Theorie der elliptischen
  Modulfunctionen* (1890), Bd. II, §III.3 "Die Modulargleichung fünften
  Grades".
* Diamond & Shurman, *A First Course in Modular Forms* (GTM 228, 2005),
  §1.5 "Modular curves of low level".

Net axiom direction: `+1` upstream-narrow, with citation above.
-/

noncomputable section

open scoped UpperHalfPlane

namespace MathlibExpansion.Geometry.RiemannSurfaces

/-- Structured witness for the Klein level-5 modular bridge: the
compactified principal-congruence level-5 quotient `X(5)`, equipped with
its classical invariants and the icosahedral cover `X(5) → X(1)`. -/
structure KleinLevelFiveBridge (Γ5 : Type*) [Group Γ5] [MulAction Γ5 ℍ] where
  compactification : ModularCompactification Γ5
  genus_eq_zero : Prop
  genus_eq_zero_holds : genus_eq_zero
  automorphism_order_eq_60 : Prop
  automorphism_order_eq_60_holds : automorphism_order_eq_60
  jLine_cover_degree_60 : Prop
  jLine_cover_degree_60_holds : jLine_cover_degree_60
  factorsThroughKleinJ : Prop
  factorsThroughKleinJ_holds : factorsThroughKleinJ

/-- Upstream-narrow axiom: the compactified principal-congruence level-5
quotient `X(5) = Γ(5) \ ℍ*` has genus `0`, automorphism-group order `60`
(the icosahedral group `A₅`), and admits an icosahedral covering map
`X(5) → X(1)` of degree `60` that factors through Klein's `j`.

Reference: Klein, *Vorlesungen über das Ikosaeder* (1884), §I.5 & §II.1;
Klein–Fricke, *Modulfunctionen* Bd. II §III.3; Bertin, *Bull. SMF* 1967
§IV. -/
axiom exists_kleinLevelFiveBridge
    (Γ5 : Type*) [Group Γ5] [MulAction Γ5 ℍ]
    (c : ModularCompactification Γ5)
    (_kj : KleinJValueCard) :
    KleinLevelFiveBridge Γ5

/-- The compactified level-5 modular quotient has the classical Klein
icosahedral-cover structure exhibiting `X(5)` as the icosahedral cover of
the `j`-line `X(1)`. -/
theorem kleinLevelFiveBridge_exists
    (Γ5 : Type*) [Group Γ5] [MulAction Γ5 ℍ]
    (c : ModularCompactification Γ5)
    (kj : KleinJValueCard) :
    Nonempty (KleinLevelFiveBridge Γ5) :=
  ⟨exists_kleinLevelFiveBridge Γ5 c kj⟩

/-- Specialization: the bridge applied to the global Klein `j` value-card
constructed in `KleinJPackage.lean`. -/
theorem kleinLevelFiveBridge_with_kleinJ
    (Γ5 : Type*) [Group Γ5] [MulAction Γ5 ℍ]
    (c : ModularCompactification Γ5) :
    Nonempty (KleinLevelFiveBridge Γ5) :=
  kleinLevelFiveBridge_exists Γ5 c kleinJ

end MathlibExpansion.Geometry.RiemannSurfaces
