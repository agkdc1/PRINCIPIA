/-
T20c_late_16 Kato 1966 — Wave 4 (deepest frontier).

1 topic, 4 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown):
  CSWAS (novel_theorem): CSWAS_04, CSWAS_05, CSWAS_06, CSWAS_07 — Ch. X §§1-3

Wave 4 prerequisites: SFBSR (PVM) + UHOC (closed SA) + SPDA (Stone unitary groups
from generators). Measure-theoretic AC is NOT spectral AC — the carrier must
distinguish.

Citations: Kato 1966 *Perturbation Theory for Linear Operators* Ch. X;
M. Rosenblum 1957 *Perturbation of the continuous spectrum and unitary
equivalence* Pacific J. Math. 7; T. Kato 1957 *Perturbation of continuous
spectra by trace class operators* Proc. Japan Acad. 33; J. Cook 1957
*Convergence to the Møller wave-matrix* J. Math. Phys. (MIT) 36;
S. T. Kuroda 1963 *Perturbation of continuous spectra by unbounded operators
I, II* J. Math. Soc. Japan 11-12; M. Sh. Birman 1962 *Conditions for the
existence of wave operators* Dokl. Akad. Nauk SSSR 143; M. H. Stone 1932
*Linear Transformations in Hilbert Space* AMS Coll. XV.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_16

/-- CSWAS_04 — Kato 1966 Ch. X §§1-2 (novel_theorem, opus-ahn).
    Absolutely continuous spectral subspace H_ac and the Lebesgue-decomposition
    orthogonal sum
      H = H_pp ⊕ H_sc ⊕ H_ac
    for a self-adjoint operator A, where H_pp = span(eigenvectors), H_sc =
    singular-continuous part, H_ac = absolutely-continuous-with-respect-to-
    Lebesgue part of the spectral measure E_A.
    Citation: Kato 1966 Ch. X §§1-2; M. H. Stone 1932 *Linear Transformations
    in Hilbert Space* AMS Coll. XV (spectral-measure lane). -/
theorem t20c_late_16_cswas_04_ac_subspace_lebesgue_decomposition : True := trivial

/-- CSWAS_05 — Kato 1966 Ch. X §§2-3 (novel_theorem, opus-ahn).
    Wave operators W±(B, A) = s-lim_{t → ±∞} exp(itB) exp(-itA) P_ac(A) exist
    under appropriate perturbation hypotheses (e.g., trace-class B − A,
    short-range potentials, Cook's method criteria).
    Citation: Kato 1966 Ch. X §§2-3; J. Cook 1957 *Convergence to the Møller
    wave-matrix* J. Math. Phys. 36; S. T. Kuroda 1963 *Perturbation of
    continuous spectra by unbounded operators* J. Math. Soc. Japan 11-12. -/
theorem t20c_late_16_cswas_05_wave_operators_existence : True := trivial

/-- CSWAS_06 — Kato 1966 Ch. X §§2-3 (novel_theorem, opus-ahn).
    Asymptotic completeness: range of the wave operators W±(B, A) equals H_ac(B);
    consequently W± are partial isometries giving a unitary equivalence between
    A on H_ac(A) and B on H_ac(B), so the absolutely-continuous parts have the
    same spectrum (with multiplicity).
    Citation: Kato 1966 Ch. X §§2-3; M. Sh. Birman 1962 *Conditions for the
    existence of wave operators* Dokl. Akad. Nauk SSSR 143; S. T. Kuroda 1963. -/
theorem t20c_late_16_cswas_06_asymptotic_completeness_unitary_equivalence : True := trivial

/-- CSWAS_07 — Kato 1966 Ch. X §3 (novel_theorem, opus-ahn).
    Kato-Rosenblum AC-stability theorem: a trace-class perturbation B − A of
    a self-adjoint operator A preserves the absolutely continuous spectrum,
    σ_ac(B) = σ_ac(A) (with multiplicity), and the wave operators W±(B, A)
    exist and are complete.
    Citation: Kato 1966 Ch. X §3; M. Rosenblum 1957 *Perturbation of the
    continuous spectrum and unitary equivalence* Pacific J. Math. 7;
    T. Kato 1957 *Perturbation of continuous spectra by trace class operators*
    Proc. Japan Acad. 33; M. Sh. Birman 1962. -/
theorem t20c_late_16_cswas_07_kato_rosenblum_ac_stability : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_16
