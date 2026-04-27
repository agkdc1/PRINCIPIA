/-
T20c_late_25 Lang 1993 — Wave 0 (DEFER + poison-quarantine umbrella).

4 DEFER topics — sharp upstream-narrow `axiom : True` per Doctrine v3 §4
("file sharp upstream-narrow axiom + citation-backed doc string"):

  D-GSC      — Groups, Sylow, profinite completion (Lang 1993 Ch. I §I.10).
               COVERED upstream: `Mathlib/Topology/Algebra/Category/ProfiniteGrp/Basic.lean`
               carries the abstract profinite-completion category. Hard boundary:
               only the bounded namespace bridge between Lang's `Ĝ = lim G/N` and
               the Mathlib `ProfiniteGrp` carrier remains; not a mainline Lang
               owner. The defer axiom marks the cite-upstream relationship.

  D-PFR      — Principal and factorial ring core (Lang 1993 Ch. II §§II.1-II.5).
               COVERED upstream: `Mathlib/RingTheory/PrincipalIdealDomain.lean`
               and `Mathlib/RingTheory/Localization/Defs.lean`. Hard boundary:
               no Lang-specific theorem extension is open. The defer axiom marks
               the cite-upstream relationship.

  D-LPR      — Modules over principal rings (Lang 1993 Ch. III §§III.7-III.8).
               COVERED upstream: `Mathlib/Algebra/Module/PID.lean` and
               `Mathlib/LinearAlgebra/FreeModule/PID.lean`. The structure theorem
               for finitely generated modules over a PID is closed. Hard
               boundary: the ordered-divisibility invariant-factor chain
               `a₁ ∣ a₂ ∣ ⋯` (Prüfer 1924, Shoda 1930) is the only open
               sidecar — recorded as INVFACT sub-HVT under Wave 4 / SubHVT.

  D-ACSIFP   — Algebraic closure, separability, finite fields (Lang 1993 Ch. V).
               COVERED upstream: `Mathlib/FieldTheory/AlgebraicClosure.lean`,
               `Mathlib/FieldTheory/SeparableClosure.lean`, and the
               finite-field chapter. Hard boundary: a single residual local
               finite-subfield `lcm`-closure axiom remains in
               `MathlibExpansion/FieldTheory/Finite/SubfieldLattice.lean:327`
               — quarantined as PQ-ACSIFP-LCM in the umbrella below.

QUARANTINE (no Lean axiom row, header doc only):

  PLACEHOLDER_POISON_Q — covers four local poison files / patterns documented
  exhaustively in `T20c_late_25_lang_step5_postrecon_verdict.md` §1 HVT table
  rows Q1-Q4 ("Union classification ledger" — `poison_quarantine = 4`):

    PQ-ACSIFP-LCM  `MathlibExpansion/FieldTheory/Finite/SubfieldLattice.lean:327`
                   — finite-subfield `lcm`-closure left as a local axiom.
                   Do not count as green Chapter V closure.

    PQ-AVVCFZ-VAL  `MathlibExpansion/FieldTheory/AlgebraicClosure/Valued.lean`
                   — valuation extension to algebraic closure hidden behind an
                   axiom-backed local shell.

    PQ-MECS-RCF    `MathlibExpansion/LinearAlgebra/Matrix/RationalCanonicalForm.lean`
                   — predicate "representative" defined as mere similarity, so
                   existence is vacuous. The honest rational canonical form is
                   recorded as MECS_01/MECS_02 in Wave 2 / Theorem.

    PQ-APFUD-FIT   `MathlibExpansion/Roots/AtiyahMacdonald/FittingIdeal.lean`
                   — `fittingIdeal := Module.annihilator` proxy bridge. The
                   honest Fitting-ideal theorem (FITTING sub-HVT, Wave 1 /
                   SubHVT) must NOT import or extend this file; it must be
                   built from presentation minors per Fitting 1936 and
                   Atiyah-Macdonald §20.

  Per Doctrine v3 §"Hard rules", poison_quarantine items SKIP — they are
  marker rows for the Step 5 verdict, not Lean obligations.

Citations (Lang 1993 explicitly): S. Lang 1993 *Algebra* (3rd ed., Addison-Wesley);
H. Prüfer 1924 *Theorie der abelschen Gruppen I* Math. Z. 20 (invariant-factor lineage);
K. Shoda 1930 *Über die Galoissche Theorie der algebraisch-abgeschlossenen
Körper* Math. Z. 32 (uniqueness lineage);
H. Fitting 1936 *Die Determinantenideale eines Moduls* Jahresbericht DMV 46
(presentation-minors, named in PQ-APFUD-FIT and FITTING);
M. F. Atiyah + I. G. Macdonald 1969 *Introduction to Commutative Algebra*
Ch. §20 (Fitting-ideal pedagogical reference);
A. Ostrowski 1934 *Untersuchungen zur arithmetischen Theorie der Körper*
Math. Z. 39 (e/f ramification lineage, used by Wave 1 EFRAM).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_25_lang

/-! ## D-GSC (DEFER, codex-sonnet-ahn2) — Lang 1993 Ch. I §I.10 -/

/-- D-GSC (DEFER) — Lang 1993 Ch. I §I.10 (Sylow theorems + profinite completion).
    Topic-level row `T20c_late_25_GSC_REUSE`. COVERED upstream in
    `Mathlib/Topology/Algebra/Category/ProfiniteGrp/Basic.lean`. Hard boundary:
    only generic profinite-completion packaging remains; not a mainline Lang
    owner. The local axiom row exists only as a sharp citation marker per
    Doctrine v3 §4.
    Citation: Lang 1993 Ch. I §I.10; Sylow 1872 Math. Ann. 5; upstream
    `Mathlib/GroupTheory/Sylow.lean` + `Mathlib/Topology/Algebra/Category/ProfiniteGrp`. -/
axiom t20c_late_25_lang_d_gsc_defer_cite_upstream : True

/-! ## D-PFR (DEFER, codex-sonnet-ahn2) — Lang 1993 Ch. II §§II.1-II.5 -/

/-- D-PFR (DEFER) — Lang 1993 Ch. II §§II.1-II.5 (PID/UFD/localization).
    Topic-level row `T20c_late_25_PFR_REUSE`. COVERED upstream in
    `Mathlib/RingTheory/PrincipalIdealDomain.lean`,
    `Mathlib/RingTheory/UniqueFactorizationDomain/Basic.lean`, and
    `Mathlib/RingTheory/Localization/Defs.lean`. Hard boundary: the entire
    PID/UFD corridor is closed upstream; no Lang-specific extension remains.
    The local axiom row exists only as a sharp citation marker per
    Doctrine v3 §4.
    Citation: Lang 1993 Ch. II; B. L. van der Waerden 1930 *Moderne Algebra* §16;
    upstream `Mathlib/RingTheory/PrincipalIdealDomain.lean`. -/
axiom t20c_late_25_lang_d_pfr_defer_cite_upstream : True

/-! ## D-LPR (DEFER, codex-sonnet-ahn2) — Lang 1993 Ch. III §§III.7-III.8 -/

/-- D-LPR (DEFER) — Lang 1993 Ch. III §§III.7-III.8 (modules over PID).
    Topic-level row `T20c_late_25_LPR_REUSE`. COVERED upstream in
    `Mathlib/Algebra/Module/PID.lean` and
    `Mathlib/LinearAlgebra/FreeModule/PID.lean`. The structure theorem for
    finitely generated modules over a PID is closed. Hard boundary: only the
    ordered-divisibility invariant-factor chain `a₁ ∣ a₂ ∣ ⋯` (Prüfer 1924,
    Shoda 1930) is open; recorded as INVFACT sub-HVT in Wave 4 / SubHVT.
    Citation: Lang 1993 Ch. III §§III.7-III.8; H. Prüfer 1924 Math. Z. 20;
    K. Shoda 1930 Math. Z. 32; upstream `Mathlib/Algebra/Module/PID.lean`. -/
axiom t20c_late_25_lang_d_lpr_defer_cite_upstream : True

/-! ## D-ACSIFP (DEFER, codex-sonnet-ahn2) — Lang 1993 Ch. V -/

/-- D-ACSIFP (DEFER) — Lang 1993 Ch. V (algebraic closure, separability,
    inseparability, finite fields). Topic-level row
    `T20c_late_25_ACSIFP_REUSE`. COVERED upstream in
    `Mathlib/FieldTheory/AlgebraicClosure.lean`,
    `Mathlib/FieldTheory/SeparableClosure.lean`, and the finite-field package.
    Hard boundary: a single residual local finite-subfield `lcm`-closure axiom
    remains in `MathlibExpansion/FieldTheory/Finite/SubfieldLattice.lean:327`
    — quarantined as PQ-ACSIFP-LCM. The local axiom row exists only as a
    sharp citation marker per Doctrine v3 §4.
    Citation: Lang 1993 Ch. V; E. Steinitz 1910 J. reine angew. Math. 137;
    upstream `Mathlib/FieldTheory/AlgebraicClosure.lean`. -/
axiom t20c_late_25_lang_d_acsifp_defer_cite_upstream : True

end MathlibExpansion.Encyclopedia.T20c_late_25_lang
