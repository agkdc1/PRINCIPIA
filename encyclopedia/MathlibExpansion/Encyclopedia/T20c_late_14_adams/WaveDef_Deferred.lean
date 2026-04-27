/-
T20c_late_14 Adams 1974 — DEFER (3 axiom rows).

3 DEFER topics — sharp upstream-narrow `axiom : True` per Doctrine v3 §4:

  KBU — k_theory_spectrum_and_connective_bu
         Fully inbound from T20c_late_13 Atiyah campaign.
         Adams Chs. 11+16-17 are consumers; do NOT reinvent.

  BP  — brown_peterson_spectrum_and_idempotents
         Blocked until MU + p-local spectra + Quillen idempotent (post GATE-2A/3).

  BU  — bu_module_calculus_and_pi_star_bu_smash_bu
         Terminal consumer; blocked until Atiyah lane delivers connective bu
         AND Adams SS machine lands (GATE-4).

Citations:
  J. F. Adams 1974 Parts II-III (Chs. 14-17)
  M. F. Atiyah 1967 *K-Theory* Benjamin (K-theory; inbound T20c_late_13)
  R. Bott 1959 *The stable homotopy of the classical groups* Ann. Math. 70
  E. H. Brown + F. P. Peterson 1966 *A spectrum whose Z/p homology is the algebra of
    reduced p-th powers* Topology 5 (BP spectrum)
  D. Quillen 1969 Bull. AMS 75 §3 (Quillen idempotent on MU_(p))
  A. K. Bousfield 1979 *The localization of spectra with respect to homology* Topology 18
  J. F. Adams + M. F. Atiyah 1966 *K-theory and the Hopf invariant* Quart. J. Math. 17
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_14_adams

/-- KBU (DEFER) — k_theory_spectrum_and_connective_bu.
    Adams 1974 Chs. 11, 16-17 consume: (1) complex topological K-theory KU as a
    represented generalized cohomology theory (Atiyah–Hirzebruch 1959 construction);
    (2) Bott periodicity as ring-spectrum level equivalence KU ≃ Σ²KU (Bott 1959);
    (3) connective cover bu = τ_{≥0}KU, DISTINCT from periodic KU (period-critical).
    DEFERRED: fully inbound from T20c_late_13 Atiyah campaign (*K-Theory*, Benjamin 1967).
    Adams cannot silently borrow K-theory; it must be delivered as typed Lean theory
    by the Atiyah lane before this sub-front opens.
    First upstream unit: complex vector bundles → Grothendieck group → KU ring spectrum
    → Bott periodicity equivalence → connective cover bu construction.
    Citation: M. F. Atiyah 1967 *K-Theory* Benjamin; R. Bott 1959 Ann. Math. 70;
    Atiyah–Hirzebruch 1961 Proc. Symp. Pure Math. 3; Adams 1974 Chs. 11, 16-17. -/
axiom t20c_late_14_adams_defer_kbu_k_theory_connective_bu : True

/-- BP (DEFER) — brown_peterson_spectrum_and_idempotents.
    At prime p, MU_(p) (p-localization of MU) splits as a wedge of suspensions of BP
    via Quillen's idempotent ε : MU_(p)^*(−) → MU_(p)^*(−) (Quillen 1969 §3).
    BP = image(ε); π_*(BP) ≅ ℤ_(p)[v₁,v₂,…] with |v_k| = 2(p^k−1).
    The BP-based Adams spectral sequence is the central chromatic tool for p-primary stems.
    DEFERRED: blocked by MU (GATE-2A, MU-01), p-local stable homotopy (Bousfield 1979),
    and the Quillen idempotent splitting (requires operations on MU_(p)).
    First upstream unit: p-local MU + Bousfield localization L_{H𝔽_p} + Quillen ε
    + BP coefficient ring π_*(BP) ≅ ℤ_(p)[v₁,v₂,…].
    Citation: E. H. Brown + F. P. Peterson 1966 Topology 5; Quillen 1969 §3;
    Adams 1974 §II.15; Bousfield 1979 Topology 18. -/
axiom t20c_late_14_adams_defer_bp_brown_peterson : True

/-- BU (DEFER) — bu_module_calculus_and_pi_star_bu_smash_bu.
    Adams 1974 Chs. 16-17: π_*(bu ∧ bu) as a K[x,y]-module (K = ℤ/(2));
    the Adams bu-resolution as a tool for 2-primary stable stems via the e-invariant;
    bu ∧ bu splits as a direct sum of copies of bu (bu-module structure).
    DEFERRED: terminal consumer; blocked by BOTH:
    (1) Atiyah campaign delivering connective bu (inbound KBU, DEFER above), and
    (2) Adams SS machine landing (GATE-4, ASS-01/ASS-02).
    First upstream unit: bu as connective K-theory cover + bu ∧ bu as bu-module
    + K[x,y]-module structure theorem (Adams 1974 Ch. 16).
    Citation: Adams 1974 §III.16-17; Adams + Atiyah 1966 Quart. J. Math. 17;
    Atiyah 1967 *K-Theory* Benjamin. -/
axiom t20c_late_14_adams_defer_bu_module_calculus : True

end MathlibExpansion.Encyclopedia.T20c_late_14_adams
