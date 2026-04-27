/-
T20c_late_17 Reed-Simon I (1972) — DEFER + QUARANTINE.

4 DEFER topics — sharp upstream-narrow `axiom : True` per Doctrine v3 §4
("file sharp upstream-narrow axiom + citation-backed doc string"):

  HGB_REUSE     — Ch. II §§1-4 — Hilbert geometry / Riesz / orthonormal bases (COVERED upstream)
  BOCGUB_REUSE  — Ch. III §5    — Baire / open mapping / closed graph / uniform boundedness (COVERED)
  FPT_SIDECAR   — Ch. V §§5-6   — Brouwer / Schauder / Leray-Schauder fixed-point sidecar (NEW, deferred)
  BOTAS_REUSE   — Ch. VI §§1-4  — Bounded operator topology / adjoint / spectrum (COVERED)

5 QUARANTINE topics (no Lean rows; documented in this header only):

  EDITION_DRIFT_Q          — Lock to 1972 core Ch. I-VIII; quarantine 1980 Ch. IX Fourier + supplements
  WEAK_DUAL_FALSE_CLOSURE_Q — Banach-Alaoglu + WeakDual ≠ concrete weak criteria + Mackey-Arens
  FINITE_DIM_SPECTRAL_Q    — Finite-dim diagonalization ≠ compact / bounded SA spectral theorems
  SHELL_BOUNDARY_Q         — Theorem-shape shells (BoundedSelfAdjoint.lean PUnit, etc) ≠ closure
  BOUNDED_EXP_NOT_STONE_Q  — Bounded expUnitary / WOT/SOT vocabulary ≠ Stone or Trotter dynamics

Quarantines are doctrine guards on existing local poison shells and on edition-drift /
substrate-confusion errors. They produce no Lean axiom rows but appear in the SQL
inventory as `poison_quarantine` topics.

Citations: Reed-Simon 1972 *Methods of Modern Mathematical Physics* I (Functional Analysis)
Ch. II-VI (covered upstream); Reed-Simon 1980 *2nd ed.* (excluded — edition drift quarantine);
J. Schauder 1930 *Der Fixpunktsatz in Funktionalräumen* Studia Math. 2;
J. Leray + J. Schauder 1934 *Topologie et équations fonctionnelles* Ann. Sci. ENS 51.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_17

/-- HGB_REUSE (DEFER) — Reed-Simon I Ch. II §§1-4.
    Hilbert space geometry, F. Riesz representation, orthonormal bases — fully
    COVERED upstream in Mathlib (`Mathlib/Analysis/InnerProductSpace/Basic.lean`,
    `Mathlib/Analysis/InnerProductSpace/Dual.lean`, `Mathlib/Analysis/InnerProductSpace/HilbertBasis.lean`).
    Sharp upstream-narrow axiom marks cite-only relationship.
    Citation: Reed-Simon 1972 I Ch. II §§1-4; F. Riesz 1907 *Sur une espèce de
    géométrie analytique des systèmes de fonctions sommables* C. R. Acad. Sci.
    Paris 144; D. Hilbert 1906 *Grundzüge einer allgemeinen Theorie der linearen
    Integralgleichungen* Nachr. Ges. Wiss. Göttingen. -/
axiom t20c_late_17_hgb_reuse_defer : True

/-- BOCGUB_REUSE (DEFER) — Reed-Simon I Ch. III §5.
    Baire category, open mapping, closed graph, uniform boundedness — fully
    COVERED upstream in Mathlib (`Mathlib/Topology/Baire/CategoryThm.lean`,
    `Mathlib/Analysis/NormedSpace/Banach.lean`).
    Sharp upstream-narrow axiom marks cite-only relationship; Banach-side
    wrappers belong to the `T20c_21 Banach` queue, not this Reed breach.
    Citation: Reed-Simon 1972 I Ch. III §5; R. Baire 1899 *Sur les fonctions
    de variables réelles* Ann. Mat. Pura Appl. 3; S. Banach 1932 *Théorie des
    opérations linéaires*. -/
axiom t20c_late_17_bocgub_reuse_defer : True

/-- FPT_SIDECAR (DEFER) — Reed-Simon I Ch. V §§5-6.
    Fixed-point theorems for nonlinear analysis: Brouwer (finite-dim), Schauder
    (compact-convex in Banach), Leray-Schauder (degree-theoretic). Real
    mathematics but deliberately deferred from the Reed mainline; route via the
    later PDE/Gilbarg consumer if reopened. No current main-line Reed consumer.
    Citation: J. Schauder 1930 *Der Fixpunktsatz in Funktionalräumen* Studia
    Math. 2; J. Leray + J. Schauder 1934 *Topologie et équations fonctionnelles*
    Ann. Sci. ENS 51; L. E. J. Brouwer 1911 *Beweis der Invarianz der
    Dimensionenzahl* Math. Ann. 70; Reed-Simon 1972 I Ch. V §§5-6. -/
axiom t20c_late_17_fpt_sidecar_defer : True

/-- BOTAS_REUSE (DEFER) — Reed-Simon I Ch. VI §§1-4.
    Bounded operator topology (norm / strong / weak operator topologies),
    adjoint operator, bounded operator spectrum — fully COVERED upstream in
    Mathlib (`Mathlib/Analysis/NormedSpace/OperatorNorm.lean`,
    `Mathlib/Analysis/NormedSpace/Adjoint.lean`,
    `Mathlib/Analysis/Normed/Algebra/Spectrum.lean`).
    Bounded polar decomposition (`B = U|B|`) is a sub-row routed into the later
    polar-decomposition track (within OCTCPD_CORE), not a standalone Reed item.
    Citation: Reed-Simon 1972 I Ch. VI §§1-4; F. Riesz + B. Sz.-Nagy 1955
    *Leçons d'Analyse Fonctionnelle* Akadémiai Kiadó (bounded polar). -/
axiom t20c_late_17_botas_reuse_defer : True

end MathlibExpansion.Encyclopedia.T20c_late_17
