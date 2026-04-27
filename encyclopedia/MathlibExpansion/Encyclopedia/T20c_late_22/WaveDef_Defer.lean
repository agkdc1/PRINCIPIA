/-
T20c_late_22 Folland 1999 — DEFER (6 cite-and-absorb topics).

6 DEFER topics — sharp upstream-narrow `axiom : True` per Doctrine v3 §4
("file sharp upstream-narrow axiom + citation-backed doc string"):

  COME — Ch. I §§1.4-1.5  Caratheodory outer measure extension       (COVERED)
  PMFT — Ch. II §§2.3-2.4 product measure / Tonelli / Fubini          (COVERED)
  SMRN — Ch. III §§1-3   signed measure + Radon-Nikodym corridor      (COVERED)
  LCHC — Ch. IV §§5-8    LCH topology + compactness technology        (COVERED)
  FAC  — Ch. V §§1-5     functional analysis core (Hahn-Banach, etc.) (COVERED)
  HMD  — Ch. XI §2       Hausdorff measure + Hausdorff dimension      (COVERED)

NO topic-level poison_quarantine per Codex Round 1; the file-level
poison_obligations (PCS LLN/Lévy/Kolmogorov shells; IMF Geometry/Riemannian/*
shells) are tracked in the SQL `poison_obligations` table, not at topic level.

Citations: G. B. Folland 1999 *Real Analysis: Modern Techniques and Their
Applications* 2nd ed. Wiley, Chs. I, II, III, IV, V, XI;
C. Carathéodory 1914 *Über das lineare Maß von Punktmengen* Nachr. Ges.
Wiss. Göttingen (Caratheodory outer-measure extension);
G. Fubini 1907 *Sugli integrali multipli* Atti Accad. Lincei (5) 16;
L. Tonelli 1909 *Sull'integrazione per parti* Rend. Lincei (5) 18;
H. Lebesgue 1910 *Sur l'intégration des fonctions discontinues* Ann. Sci.
ENS 27 (signed-measure substrate); J. Radon 1913 *Theorie und Anwendungen
der absolut additiven Mengenfunktionen* Sitzungsber. Akad. Wiss. Wien 122;
O. Nikodym 1930 *Sur une généralisation des intégrales de M. J. Radon* Fund.
Math. 15;
P. Urysohn 1925 *Über die Mächtigkeit der zusammenhängenden Mengen* Math.
Ann. 94 (Urysohn lemma); A. Tychonoff 1930 *Über die topologische Erweiterung
von Räumen* Math. Ann. 102 (Tychonoff product theorem);
H. Hahn 1927 *Über lineare Gleichungssysteme in linearen Räumen* J. Reine
Angew. Math. 157; S. Banach 1932 *Théorie des opérations linéaires*
Monografje Mat.; R. Baire 1899 *Sur les fonctions de variables réelles*
Ann. Mat. Pura Appl. 3;
F. Hausdorff 1918 *Dimension und äußeres Maß* Math. Ann. 79.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_22

/-- COME (DEFER) — Folland 1999 Ch. I §§1.4-1.5.
    Caratheodory outer-measure extension: an outer measure μ* on X restricts
    to a measure on the σ-algebra of μ*-measurable sets. Fully COVERED
    upstream in `Mathlib/MeasureTheory/OuterMeasure/Caratheodory.lean`.
    Citation: C. Carathéodory 1914 Nachr. Ges. Wiss. Göttingen; Folland 1999
    Ch. I §§1.4-1.5; upstream Mathlib. -/
axiom t20c_late_22_come_defer_cite_upstream : True

/-- PMFT (DEFER) — Folland 1999 Ch. II §§2.3-2.4.
    Product measure construction; Tonelli (non-negative) and Fubini
    (integrable) interchange theorems for iterated integrals. Fully COVERED
    upstream in `Mathlib/MeasureTheory/Measure/Prod.lean` and
    `Mathlib/MeasureTheory/Integral/Prod.lean`.
    Citation: G. Fubini 1907 Atti Accad. Lincei (5) 16; L. Tonelli 1909
    Rend. Lincei (5) 18; Folland 1999 Ch. II §§2.3-2.4; upstream Mathlib. -/
axiom t20c_late_22_pmft_defer_cite_upstream : True

/-- SMRN (DEFER) — Folland 1999 Ch. III §§1-3.
    Signed/complex measures: Hahn decomposition (signed μ ⇒ X = P ⊔ N with
    μ⁺ on P and μ⁻ on N); Jordan decomposition μ = μ⁺ - μ⁻; Lebesgue
    decomposition (any signed μ on (X, 𝓢) wrt σ-finite ν decomposes as
    μ = μ_ac + μ_s with μ_ac ≪ ν and μ_s ⊥ ν); Radon-Nikodym (μ ≪ ν
    σ-finite ⇒ ∃! f ∈ L¹(ν) with dμ = f dν). Fully COVERED upstream.
    Citation: H. Lebesgue 1910 Ann. Sci. ENS 27; J. Radon 1913
    Sitzungsber. Akad. Wiss. Wien 122; O. Nikodym 1930 Fund. Math. 15;
    Folland 1999 Ch. III §§1-3; upstream Mathlib. -/
axiom t20c_late_22_smrn_defer_cite_upstream : True

/-- LCHC (DEFER) — Folland 1999 Ch. IV §§5-8.
    Locally compact Hausdorff topology + compactness technology: Urysohn
    lemma, Tietze extension, one-point compactification, Tychonoff product
    theorem, Stone-Weierstrass density. Fully COVERED upstream in
    `Mathlib/Topology/*` (LCH lemmas, Tychonoff, Stone-Weierstrass).
    Citation: P. Urysohn 1925 Math. Ann. 94; A. Tychonoff 1930 Math.
    Ann. 102; M. H. Stone 1937/1948 Math. Mag. 21 (Stone-Weierstrass);
    Folland 1999 Ch. IV §§5-8; upstream Mathlib. -/
axiom t20c_late_22_lchc_defer_cite_upstream : True

/-- FAC (DEFER) — Folland 1999 Ch. V §§1-5.
    Functional analysis core: Hahn-Banach extension, Baire category,
    Banach-Steinhaus uniform-boundedness, open-mapping theorem,
    Banach-Alaoglu, Hilbert-space duality. Fully COVERED upstream in
    `Mathlib/Analysis/NormedSpace/HahnBanach.lean`,
    `Mathlib/Topology/Baire/CategoryThm.lean`, `Mathlib/Analysis/NormedSpace/Banach.lean`,
    `Mathlib/Analysis/NormedSpace/WeakDual.lean`,
    `Mathlib/Analysis/InnerProductSpace/Dual.lean`.
    Local `Prop` shells in this corridor are not load-bearing.
    Citation: H. Hahn 1927 J. Reine Angew. Math. 157; S. Banach 1932
    *Théorie des opérations linéaires* Monografje Mat.; R. Baire 1899
    Ann. Mat. Pura Appl. 3; L. Alaoglu 1940 Ann. of Math. 41;
    Folland 1999 Ch. V §§1-5; upstream Mathlib. -/
axiom t20c_late_22_fac_defer_cite_upstream : True

/-- HMD (DEFER) — Folland 1999 Ch. XI §2.
    Hausdorff measure H^s (s ≥ 0) on a metric space; Hausdorff dimension
    dim_H(E) = inf{s : H^s(E) = 0} = sup{s : H^s(E) = ∞}. Fully COVERED
    upstream in `Mathlib/MeasureTheory/Measure/Hausdorff.lean`.
    Citation: F. Hausdorff 1918 *Dimension und äußeres Maß* Math. Ann. 79;
    Folland 1999 Ch. XI §2; upstream Mathlib. -/
axiom t20c_late_22_hmd_defer_cite_upstream : True

end MathlibExpansion.Encyclopedia.T20c_late_22
