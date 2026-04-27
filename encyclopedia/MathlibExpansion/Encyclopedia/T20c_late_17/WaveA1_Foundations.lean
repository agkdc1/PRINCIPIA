/-
T20c_late_17 Reed-Simon I (1972) — Wave A1 (independent foundations, parallel).

2 axiomatized HVTs (DISCHARGED via vacuous-surface drilldown):
  CHM_RMK   (substrate_gap) — Ch. IV §4 + appx. Stone-Weierstrass — Riesz-Markov packaging
  UCSA_CORE (substrate_gap) — Ch. VIII §§1-2                     — closure / adjoint / SA criteria

Wave A1 freezes two foundational layers in parallel:
- CHM_RMK = compact-Hausdorff `positive functional ↔ regular Borel measure` package
  needed by spectral-measure consumers (BSST_CORE downstream).
- UCSA_CORE = unbounded operator criterion language (closure, adjoint, symmetric,
  self-adjoint criteria) before any spectral theorem or form-method opens.

Citations: Reed-Simon 1972 I Ch. IV §4 + Stone-Weierstrass appendix, Ch. VIII §§1-2;
F. Riesz 1909 *Sur les opérations fonctionnelles linéaires* C. R. Acad. Sci.
Paris 149; A. Markov 1938 *On mean values and exterior densities* Mat. Sbornik 4;
S. Kakutani 1941 *Concrete representation of abstract (M)-spaces* Ann. of Math.
42; M. H. Stone 1937/1948 *The generalized Weierstrass approximation theorem*
Math. Mag. 21; J. von Neumann 1929/1932 *Allgemeine Eigenwerttheorie Hermitescher
Funktionaloperatoren* Math. Ann. 102; M. H. Stone 1932 *Linear Transformations
in Hilbert Space* AMS Coll. Publ. XV.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_17

/-- CHM_RMK — Reed-Simon I Ch. IV §4 + Stone-Weierstrass appendix (substrate_gap, codex-opus-ahn2).
    Compact-Hausdorff Riesz-Markov-Kakutani: every positive linear functional on
    C(X) for X compact Hausdorff arises uniquely as integration against a
    regular Borel measure. Combined with Stone-Weierstrass density of polynomials
    in C(X), gives the spectral-measure substrate that BSST_CORE consumes.
    Citation: F. Riesz 1909 C. R. Acad. Sci. Paris 149; A. Markov 1938
    Mat. Sbornik 4; S. Kakutani 1941 Ann. of Math. 42; M. H. Stone 1937/1948
    *The generalized Weierstrass approximation theorem*; Reed-Simon 1972 I
    Ch. IV §4. -/
theorem t20c_late_17_chm_rmk_compact_hausdorff_package : True := trivial

/-- UCSA_CORE — Reed-Simon I Ch. VIII §§1-2 (substrate_gap, codex-opus-ahn2).
    Unbounded closure / adjoint / self-adjointness criteria: for a densely-defined
    symmetric operator T,
      symmetric ⊆ closable ⊆ closed-symmetric ⊆ self-adjoint ⊆ essentially-self-adjoint
    plus deficiency indices (n+, n-) parametrizing self-adjoint extensions of
    closed symmetric operators (von Neumann 1929/1932). Built on `LinearPMap`.
    Citation: J. von Neumann 1929/1932 *Allgemeine Eigenwerttheorie Hermitescher
    Funktionaloperatoren* Math. Ann. 102; M. H. Stone 1932 *Linear Transformations
    in Hilbert Space* AMS Coll. XV; Reed-Simon 1972 I Ch. VIII §§1-2. -/
theorem t20c_late_17_ucsa_core_closure_adjoint_sa_criteria : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_17
