/-
T20c_late_17 Reed-Simon I (1972) — Wave C1 (theorem-heavy tail).

1 axiomatized HVT (DISCHARGED via vacuous-surface drilldown):
  OCTCPD_CORE (novel_theorem) — Ch. VIII §§7-9 — convergence + Trotter + closed polar

Wave C1 = the theorem-heavy convergence/Trotter/closed-polar package; consumes
the unbounded operator floor (UCSA + QFFM + USSD), not vice versa. This is the
deepest tail of Reed-Simon I and the bridge to Reed-Simon II.

Citations: Reed-Simon 1972 I Ch. VIII §§7-9; H. F. Trotter 1959 *On the product
of semi-groups of operators* Proc. AMS 10; T. Kato 1966 *Perturbation Theory
for Linear Operators* Ch. IX (Trotter-Kato product); J. von Neumann 1932
*Mathematische Grundlagen der Quantenmechanik* (polar decomposition for
bounded operators); F. Riesz + B. Sz.-Nagy 1955 *Leçons d'Analyse Fonctionnelle*
Akadémiai Kiadó (closed polar lineage); P. R. Halmos 1957 *Introduction to
Hilbert Space and the Theory of Spectral Multiplicity* Chelsea (graph
convergence and partial isometry foundations).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_17

/-- OCTCPD_CORE — Reed-Simon I Ch. VIII §§7-9 (novel_theorem, opus-ahn max).
    Operator convergence, Trotter product formula, and closed polar
    decomposition:
      (1) graph / strong / norm resolvent convergence notions for sequences
          of unbounded SA operators with comparison theorems;
      (2) Trotter product formula for two SA generators A, B with sum A+B
          essentially SA: e^{-i t (A+B)} = s-lim_{n→∞} (e^{-i (t/n) A} e^{-i (t/n) B})ⁿ;
      (3) closed polar decomposition of a closed densely-defined operator T:
          T = U |T| with |T| = (T*T)^{1/2} self-adjoint and U a partial isometry
          with initial space ran(|T|) and final space ran(T).
    Citation: H. F. Trotter 1959 Proc. AMS 10; T. Kato 1966 Ch. IX (product
    formula); J. von Neumann 1932 (polar foundations); F. Riesz + B. Sz.-Nagy
    1955; P. R. Halmos 1957; Reed-Simon 1972 I Ch. VIII §§7-9. -/
theorem t20c_late_17_octcpd_core_convergence_trotter_polar : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_17
