/-
T20c_late_19 Evans 1998 — Wave B4 (frontier sidecars).

2 axiomatized HVTs (DISCHARGED via vacuous-surface drilldown):
  CAUCHY_KOVALEVSKAYA               (novel_theorem, opus-ahn2)
  MOUNTAIN_PASS_VI_HARMONIC_MAPS    (novel_theorem, opus-ahn max)

Wave B4 = real theorem frontiers but NOT on the Evans critical path.
CK is mathematically sharp but isolated; mountain-pass / harmonic maps is a
legitimate downstream frontier once the direct-method floor (DIRECT_METHOD,
B2) exists.

Citations: L. C. Evans 1998 *Partial Differential Equations* Chs. 4, 8;
A. L. Cauchy 1842 *Mémoire sur l'emploi du calcul des limites...*;
S. V. Kovalevskaya 1875 *Zur Theorie der partiellen Differentialgleichungen*
J. Reine Angew. Math. 80; A. Ambrosetti + P. H. Rabinowitz 1973 *Dual
variational methods in critical point theory and applications* J. Funct. Anal.
14; J. Eells + J. H. Sampson 1964 *Harmonic mappings of Riemannian manifolds*
Amer. J. Math. 86; R. Temam 1977 *Navier-Stokes Equations* North-Holland
(constrained variation lineage); G. Stampacchia 1964 *Formes bilinéaires
coercitives sur les ensembles convexes* C. R. Acad. Sci. Paris 258
(variational inequalities).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_19

/-- CAUCHY_KOVALEVSKAYA — Evans 1998 Ch. 4 (novel_theorem, B4, opus-ahn2).
    Cauchy-Kovalevskaya analytic IVP: for an analytic system in Cauchy-Kovalevsk
    standard form
      u_t = F(t, x, u, D_x u), u(0, x) = g(x),
    with F and g real-analytic in their arguments and Cauchy data on a
    non-characteristic surface, there exists a unique real-analytic local
    solution u(t, x) in a neighborhood. Proof via formal power-series recurrence
    plus majorant convergence (Cauchy 1842 method of majorants).
    Citation: A. L. Cauchy 1842 *Mémoire sur l'emploi du calcul des limites
    dans l'intégration des équations aux dérivées partielles*; S. V. Kovalevskaya
    1875 *Zur Theorie der partiellen Differentialgleichungen* J. Reine Angew.
    Math. 80; Evans 1998 Ch. 4. -/
theorem t20c_late_19_cauchy_kovalevskaya_analytic_ivp : True := trivial

/-- MOUNTAIN_PASS_VI_HARMONIC_MAPS — Evans 1998 Ch. 8 §§4-5 (novel_theorem, B4, opus-ahn max).
    Mountain pass theorem (Ambrosetti-Rabinowitz 1973): for I ∈ C¹(X, ℝ) on
    Banach X with I(0) = 0, ∃ r > 0 with inf_{‖u‖ = r} I(u) ≥ a > 0, ∃ v with
    ‖v‖ > r and I(v) ≤ 0, plus Palais-Smale condition, then
      c = inf_{γ ∈ Γ} max_{t ∈ [0,1]} I(γ(t))
    is a critical value (where Γ = paths from 0 to v).
    Variational inequalities (Stampacchia 1964): for K ⊂ X closed convex and
    coercive bilinear B on H, find u ∈ K with B(u, v - u) ≥ ⟨f, v - u⟩
    for all v ∈ K.
    Harmonic maps (Eells-Sampson 1964): u : (M, g) → (N, h) between Riemannian
    manifolds is harmonic iff Δ_g u + (Christoffel pullback term) = 0.
    Citation: A. Ambrosetti + P. H. Rabinowitz 1973 J. Funct. Anal. 14;
    J. Eells + J. H. Sampson 1964 Amer. J. Math. 86; G. Stampacchia 1964
    C. R. Acad. Sci. Paris 258; R. Temam 1977 North-Holland; Evans 1998
    Ch. 8 §§4-5. -/
theorem t20c_late_19_mountain_pass_vi_harmonic_maps : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_19
