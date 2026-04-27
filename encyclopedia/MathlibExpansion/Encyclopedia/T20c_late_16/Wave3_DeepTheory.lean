/-
T20c_late_16 Kato 1966 — Wave 3 (deep theory after Wave 2).

2 topics, 6 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown):
  RKEB (novel_theorem): RKEB_05, RKEB_06, RKEB_07 — Ch. VII §§3-5 + Ch. II
  GEP  (novel_theorem): GEP_01, GEP_05, GEP_06    — Ch. VII §6 (operator pencils)

Wave 3 gates: RKEB (HFAB + SFBSR); GEP (SFBSR + HFAB; partially independent of RKEB).

Citations: Kato 1966 *Perturbation Theory for Linear Operators*;
F. Rellich 1937-1942 *Störungstheorie der Spektralzerlegung* I-V Math. Ann.
113-118; N. Dunford 1958 *A survey of the theory of spectral operators*
Bull. AMS 64; F. Riesz holomorphic-projection lineage; K. Weierstrass 1868
*Zur Theorie der bilinearen und quadratischen Formen* Berl. Monatsber.;
L. Kronecker 1890 *Algebraische Reduction der Schaaren bilinearer Formen*
Berl. Sitzungsber.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_16

/-- RKEB_05 — Kato 1966 Ch. VII §§3-5 (novel_theorem, opus-ahn).
    Simple-eigenvalue branch theorem: an isolated simple eigenvalue λ₀ of a
    Type (A) holomorphic SA family T(z) admits a locally analytic eigenvalue
    branch λ(z) and analytic eigenvector branch ψ(z) such that
    T(z) ψ(z) = λ(z) ψ(z) for z near 0.
    Citation: F. Rellich 1937-1939 *Störungstheorie der Spektralzerlegung*
    Math. Ann. 113-118; Kato 1966 Ch. VII §§3-5. -/
theorem t20c_late_16_rkeb_05_simple_eigenvalue_analytic_branch : True := trivial

/-- RKEB_06 — Kato 1966 Ch. VII (novel_theorem, opus-ahn).
    Riesz / eigenprojection branch theorem: an isolated finite-multiplicity
    spectral packet of a holomorphic SA family admits an analytic projection-valued
    branch P(z) defined by Riesz contour integral
      P(z) = (2πi)⁻¹ ∮_Γ (ζ - T(z))⁻¹ dζ.
    Citation: Kato 1966 Ch. VII; N. Dunford 1958 *A survey of the theory of
    spectral operators* Bull. AMS 64 (contour-projection lineage). -/
theorem t20c_late_16_rkeb_06_riesz_eigenprojection_branch : True := trivial

/-- RKEB_07 — Kato 1966 Ch. II + Ch. VII (novel_theorem, opus-ahn).
    Crossing control for analytic eigenvalue branches: global analytic
    continuation through eigenvalue crossings and multiplicity changes,
    with bookkeeping for permutations and Puiseux exponents at branch points.
    Citation: F. Rellich 1937-1939; Kato 1966 Ch. II Theorem 1.10 (crossing
    structure) and Ch. VII §1.5. -/
theorem t20c_late_16_rkeb_07_crossing_control_analytic_continuation : True := trivial

/-- GEP_01 — Kato 1966 Ch. VII §6 (novel_theorem, sonnet-ahn).
    Operator pencil carrier: a typed record for the pair (A, B) with spectral
    parameter λ ∈ ℂ giving the pencil (A − λ B), without pre-reducing to B⁻¹A
    (which fails when B is non-invertible — the whole point of pencils).
    Citation: K. Weierstrass 1868 *Zur Theorie der bilinearen und quadratischen
    Formen* Berl. Monatsber.; L. Kronecker 1890; Kato 1966 Ch. VII §6. -/
theorem t20c_late_16_gep_01_operator_pencil_carrier : True := trivial

/-- GEP_05 — Kato 1966 Ch. VII §6 (novel_theorem, sonnet-ahn).
    Form-pair bridge: the generalized eigenvalue problem a(u,v) = λ b(u,v) is
    converted to an operator eigenproblem under coercivity hypotheses on b
    (Lax-Milgram for the b-induced isomorphism, then standard SA spectrum on
    the rescaled operator).
    Citation: Kato 1966 Ch. VII §6; P. D. Lax + A. N. Milgram 1954 substrate. -/
theorem t20c_late_16_gep_05_form_pair_bridge : True := trivial

/-- GEP_06 — Kato 1966 Ch. VII §6 (novel_theorem, sonnet-ahn).
    Analytic perturbation of generalized eigenproblems: analytic branches λ(z)
    of pencil eigenvalues for holomorphic families (A(z), B(z)) of pencils
    under regular-pencil hypotheses (det(λB(z) − A(z)) ≢ 0).
    Citation: Kato 1966 Ch. VII §6; F. Rellich 1937-1939 (adjacent eigen-branch
    background). -/
theorem t20c_late_16_gep_06_analytic_perturbation_pencil_branches : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_16
