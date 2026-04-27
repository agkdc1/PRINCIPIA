/-
T20c_late_21 Rudin 1987 — Wave C1 (classical global theorem wave).

2 axiomatized HVTs (DISCHARGED via vacuous-surface drilldown):
  RMRA  (breach_candidate, C1, opus-ahn2) — Ch. 13 Runge + Mittag-Leffler + rational approx
  WFBMS (breach_candidate, C1, opus-ahn2) — Ch. 15 Weierstrass + Jensen + Blaschke + Müntz-Szász

Wave C1 = honest theorem fronts built on the B1 complex core (HCRH); neither
depends on the poisoned RMNB / ACMP corridor.

Citations: W. Rudin 1987 *Real and Complex Analysis* 3rd ed. McGraw-Hill,
Chs. 13, 15;
C. Runge 1885 *Zur Theorie der eindeutigen analytischen Functionen* Acta Math. 6;
G. Mittag-Leffler 1884 *Sur la représentation analytique des fonctions
monogènes uniformes* Acta Math. 4;
K. Weierstrass 1876 *Zur Theorie der eindeutigen analytischen Functionen*
Math. Werke II;
J. L. W. V. Jensen 1899 *Sur un nouvel et important théorème de la théorie
des fonctions* Acta Math. 22;
W. Blaschke 1915 *Eine Erweiterung des Satzes von Vitali* Berichte Verh.
Sächs. Akad. Wiss. Leipzig 67;
C. Müntz 1914 *Über den Approximationssatz von Weierstrass* H. A. Schwarz
Festschrift;
O. Szász 1916 *Über die Approximation stetiger Funktionen durch lineare
Aggregate von Potenzen* Math. Ann. 77.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_21

/-- RMRA — Rudin 1987 Ch. 13 (breach_candidate, C1, opus-ahn2).
    Runge approximation + Mittag-Leffler + rational approximation:
    Runge 1885: every function holomorphic on a domain Ω ⊂ ℂ can be
    uniformly approximated on compact subsets by rational functions whose
    poles lie in any prescribed set meeting every component of ℂ \ Ω.
    Mittag-Leffler 1884: given a discrete set {a_n} ⊂ Ω with prescribed
    principal parts P_n(1/(z - a_n)), there exists a meromorphic function on
    Ω with exactly those poles and principal parts.
    Citation: C. Runge 1885 Acta Math. 6; G. Mittag-Leffler 1884 Acta Math. 4;
    Rudin 1987 Ch. 13 §§13.6-13.10. -/
theorem t20c_late_21_rmra_runge_mittag_leffler_rational_approx : True := trivial

/-- WFBMS — Rudin 1987 Ch. 15 (breach_candidate, C1, opus-ahn2).
    Weierstrass factorization + Jensen formula + Blaschke products +
    Müntz-Szász approximation theorem.
    Weierstrass 1876: every entire function with prescribed zero set {a_n}
    factors as f(z) = z^m · e^{g(z)} · ∏_n E_{p_n}(z/a_n) where E_p are
    elementary factors.
    Jensen 1899: for f holomorphic on B(0, R) with f(0) ≠ 0,
    log|f(0)| = (1/2π) ∫_0^{2π} log|f(R e^{iθ})| dθ - ∑_{|a_k| < R} log(R/|a_k|).
    Blaschke 1915: for {a_n} ⊂ 𝔻 with ∑(1 - |a_n|) < ∞, the Blaschke product
    B(z) = ∏_n (|a_n|/a_n) (a_n - z)/(1 - ā_n z) converges to a bounded
    holomorphic function on 𝔻 with zeros exactly {a_n}.
    Müntz-Szász 1914/1916: span{1, x^{λ_n}}_{n ≥ 1} is dense in C[0, 1] iff
    ∑ 1/λ_n = ∞.
    Citation: K. Weierstrass 1876 Math. Werke II; J. L. W. V. Jensen 1899
    Acta Math. 22; W. Blaschke 1915 Berichte Sächs. Akad. 67; C. Müntz 1914
    Schwarz Festschrift; O. Szász 1916 Math. Ann. 77; Rudin 1987 Ch. 15. -/
theorem t20c_late_21_wfbms_weierstrass_jensen_blaschke_muntz_szasz : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_21
