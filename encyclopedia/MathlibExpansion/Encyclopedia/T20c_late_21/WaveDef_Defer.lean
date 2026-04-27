/-
T20c_late_21 Rudin 1987 — DEFER + QUARANTINE.

3 DEFER topics — sharp upstream-narrow `axiom : True` per Doctrine v3 §4
("file sharp upstream-narrow axiom + citation-backed doc string"):

  AIMM — Ch. 1 abstract integration / measurability (COVERED upstream)
  LPHH — Chs. 3-5 Lp / Hilbert / Hahn-Banach substrate (COVERED upstream)
  PMFC — Ch. 8 product measures / Fubini / convolution (COVERED upstream;
                wrapper-scale residual only)

2 QUARANTINE topics (no Lean rows; documented in this header per Step 5
§"Q1 poison quarantine and replacement routing"):

  RMNB — Ch. 14 Riemann mapping + normal families + boundary behavior.
         Local files lean on uniformization axioms, shell-backed boundary,
         and `True` annulus placeholders. Quarantined; Step 6 routes around
         existing local files. Step 7 must open fresh owners.
  ACMP — Ch. 16 analytic continuation + monodromy + Picard + modular function.
         Function-element + monodromy carriers are collapsed shells; modular
         endpoint returns zero-function placeholder. Quarantined.

Quarantines are doctrine guards on existing local poison shells. They produce
no Lean axiom rows but appear as `poison_quarantine` topic rows in the SQL
inventory.

Citations: W. Rudin 1987 *Real and Complex Analysis* 3rd ed. McGraw-Hill,
Chs. 1, 3-5, 8 (deferred); Chs. 14, 16 (quarantined);
H. Lebesgue 1904 *Leçons sur l'intégration et la recherche des fonctions
primitives* Gauthier-Villars (AIMM substrate);
S. Banach 1932 *Théorie des opérations linéaires* Monografje Mat. (LPHH substrate);
G. Fubini 1907 *Sugli integrali multipli* Atti Accad. Lincei (5) 16 (PMFC);
B. Riemann 1851 *Grundlagen für eine allgemeine Theorie der Functionen einer
veränderlichen complexen Größe* Gött. dissertation (RMNB original);
P. Koebe 1907 + H. Poincaré 1907 (uniformization);
E. Picard 1879 *Sur une propriété des fonctions entières* C. R. Acad. Sci.
Paris 88 (ACMP / Picard).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_21

/-- AIMM (DEFER) — Rudin 1987 Ch. 1.
    Abstract integration: σ-algebras, measurable functions, Lebesgue integral,
    monotone + dominated convergence, Egoroff, Lusin. Fully COVERED upstream
    in `Mathlib/MeasureTheory/Integral/*` and `Mathlib/MeasureTheory/Function/*`.
    Sharp upstream-narrow axiom marks cite-only relationship.
    Citation: H. Lebesgue 1904 *Leçons sur l'intégration et la recherche des
    fonctions primitives* Gauthier-Villars; Rudin 1987 Ch. 1; upstream Mathlib
    measure-theory hierarchy. -/
axiom t20c_late_21_aimm_defer_cite_upstream : True

/-- LPHH (DEFER) — Rudin 1987 Chs. 3-5.
    L^p spaces, Hilbert space geometry, Hahn-Banach extension, Baire category.
    Fully COVERED upstream in `Mathlib/MeasureTheory/Function/Lp*`,
    `Mathlib/Analysis/InnerProductSpace/*`, `Mathlib/Analysis/NormedSpace/HahnBanach.lean`,
    and `Mathlib/Topology/Baire/CategoryThm.lean`.
    Sharp upstream-narrow axiom marks cite-only relationship.
    Citation: Rudin 1987 Chs. 3-5; S. Banach 1932 *Théorie des opérations
    linéaires*; F. Riesz 1907 (Hilbert representation); upstream Mathlib. -/
axiom t20c_late_21_lphh_defer_cite_upstream : True

/-- PMFC (DEFER) — Rudin 1987 Ch. 8.
    Product measures, Fubini-Tonelli theorem, convolution. Core construction
    + Tonelli-Fubini fully COVERED upstream in `Mathlib/MeasureTheory/Measure/Prod.lean`
    and `Mathlib/MeasureTheory/Integral/Prod.lean`. Residual Chapter 8 work is
    completion / convolution / CDF packaging (wrapper-scale).
    Sharp upstream-narrow axiom marks cite-only relationship.
    Citation: G. Fubini 1907 *Sugli integrali multipli* Atti Accad. Lincei
    (5) 16; L. Tonelli 1909; Rudin 1987 Ch. 8; upstream Mathlib measure-product
    + convolution APIs. -/
axiom t20c_late_21_pmfc_defer_cite_upstream : True

end MathlibExpansion.Encyclopedia.T20c_late_21
