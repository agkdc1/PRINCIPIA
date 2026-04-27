/-
T20c_late_20 Stein 1993 — DEFER + QUARANTINE.

2 DEFER topics — sharp upstream-narrow `axiom : True` per Doctrine v3 §4:

  EFS       — Ch. VI ambient Fourier-Schwartz substrate (COVERED upstream).
  COUNTEREX — Ch. X Besicovitch-set / maximal-counterexample culture (Claude
              Correction 2 from Step 5 verdict: avoid silent omission).

4 QUARANTINE topics (no Lean rows; documented in this header per Step 5):

  STEIN70_Q                — do not collapse Stein 1993 into Stein 1970 + ambient Fourier
  SURFACE_FALSE_FRIENDS_Q  — Hausdorff measure / GreenIdentity.surfaceIntegral / toSphere
                             ≠ general surface measure for Chs. VIII-XI
  HEISENBERG_FALSE_FRIENDS_Q — Uncertainty.lean / States.lean von-Neumann shells
                             ≠ honest Heisenberg / Cauchy-Szegő / dbar_b / box_b carriers
  GENERALITY_Q             — no vague restriction / FIO / CR statements before
                             explicit sphere / phase / CR carriers exist

Citations: E. M. Stein 1993 *Harmonic Analysis* Princeton Math 43, Chs. VI, X;
A. Besicovitch 1928 *On Kakeya's problem and a similar one* Math. Z. 27;
S. Kakeya 1917 *Some problems on maxima and minima regarding ovals* Tohoku
Sci. Reports 6; J. von Neumann 1955 *Mathematical Foundations of Quantum
Mechanics* Princeton (false-friend culture for Heisenberg shells); upstream
`Mathlib/Analysis/Fourier/*` and `Mathlib/Analysis/Distribution/*` for EFS.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_20

/-- EFS (DEFER) — Stein 1993 Ch. VI.
    Euclidean Fourier-Schwartz substrate: Schwartz space S(ℝⁿ), Fourier
    transform f̂(ξ) = ∫ f(x) e^{-2πi x · ξ} dx, Fourier inversion, Plancherel
    isometry on L²(ℝⁿ). Fully COVERED upstream in
    `Mathlib/Analysis/Fourier/FourierTransform.lean` and
    `Mathlib/Analysis/Distribution/SchwartzSpace.lean`. The only adjacent
    seams (Schwartz-convolution closure, tempered-distribution extension)
    are not opening breach budget here.
    Citation: Stein 1993 Ch. VI; upstream Mathlib Fourier + Schwartz substrate. -/
axiom t20c_late_20_efs_defer_cite_upstream : True

/-- COUNTEREX (DEFER) — Stein 1993 Ch. X (Claude C2 placeholder).
    Maximal-operator counterexample culture: Besicovitch / Kakeya sets in ℝⁿ
    of measure zero containing a unit segment in every direction; Kakeya
    maximal function K_δ f(x) = sup_{T tube of width δ through x} (1/|T|)
    ∫_T |f|; Stein-Wainger Kakeya conjecture (Hausdorff dim ≥ n).
    Sharp constants and counterexamples for differentiation bases.
    Per Claude Round 1 Correction 2: silent omission would falsely suggest
    Chapter X is covered. No scout was executed — placeholder only.
    Citation: S. Kakeya 1917 *Some problems on maxima and minima regarding
    ovals* Tohoku Sci. Reports 6; A. Besicovitch 1928 *On Kakeya's problem
    and a similar one* Math. Z. 27; Stein 1993 Ch. X. -/
axiom t20c_late_20_counterex_besicovitch_kakeya_defer : True

end MathlibExpansion.Encyclopedia.T20c_late_20
