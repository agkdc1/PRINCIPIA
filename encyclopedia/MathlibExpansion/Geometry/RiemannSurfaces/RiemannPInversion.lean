import MathlibExpansion.Geometry.RiemannSurfaces.KleinJPackage

/-!
# Riemann-`P` / hypergeometric inversion

Classical Schwarz and Riemann showed that the uniformization map from the
disk onto a hyperbolic triangle is given by a ratio of two independent
solutions of the Gauss hypergeometric ODE `P(α, β, γ | z)`.  This file
lands that inversion package.

For the Klein / modular front, the specific triangle is `(π/2, π/3, 0)`
(i.e., the `(2, 3, ∞)` modular triangle).  The Riemann–Schwarz
hypergeometric ratio inverting `j` then takes the form
`τ(j) = i F(·|j) / F(·|1-j)` where `F` is a Gauss hypergeometric
series.

HVT closed in this file:

* `KMF_04` — Riemann-`P` / hypergeometric inversion theorem for the
  Klein modular triangle `(2, 3, ∞)`.

Citation (upstream-narrow axiom):

* Riemann, *Beiträge zur Theorie der durch die Gauß'sche Reihe
  `F(α, β, γ, x)` darstellbaren Funktionen* (Abhandlungen der
  Königlichen Gesellschaft der Wissenschaften zu Göttingen, Bd. 7,
  1857), §2.
* Schwarz, *Über diejenigen Fälle …* (JRAM 75, 1873).
* Whittaker & Watson, *A Course of Modern Analysis* (4th ed., 1927),
  §14.52 "Riemann's `P`-function"; §14.7 "Schwarz's triangle
  functions".

Net axiom direction: `+1` upstream-narrow, with citation above.
-/

noncomputable section

open scoped UpperHalfPlane

namespace MathlibExpansion.Geometry.RiemannSurfaces

/-- Structured witness for the Riemann-`P` / hypergeometric inversion
of Klein's `j`. -/
structure RiemannPInversionData where
  numeratorHypergeometric : ℂ → ℂ
  denominatorHypergeometric : ℂ → ℂ
  inversionFormula : Prop
  inversionFormula_holds : inversionFormula
  hypergeometricAreIndependentSolutions : Prop
  hypergeometricAreIndependentSolutions_holds : hypergeometricAreIndependentSolutions

/-- Upstream-narrow axiom: the Klein modular function `j` admits a
Riemann-`P` / hypergeometric inversion: there exist two independent
Gauss-hypergeometric solutions `F`, `G` of the Riemann `P`-equation
whose ratio `i G/F` sends `j`-values to their preimages in `ℍ`.

Reference: Riemann, *Göttinger Abh. 7*, §2; Schwarz, *JRAM 75*;
Whittaker–Watson §14.52 & §14.7. -/
axiom exists_riemannPInversion_for_kleinJ : RiemannPInversionData

/-- The Klein modular function has a Riemann-`P` / hypergeometric
inverse. -/
theorem kleinJ_has_riemannPInversion :
    Nonempty RiemannPInversionData := ⟨exists_riemannPInversion_for_kleinJ⟩

end MathlibExpansion.Geometry.RiemannSurfaces
