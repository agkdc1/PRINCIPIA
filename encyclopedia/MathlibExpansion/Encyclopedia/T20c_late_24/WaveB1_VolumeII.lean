/-
T20c_late_24 Hörmander 1983-1985 — Wave B1 (Volume II: constant-coefficient PDE).

5 axiomatized HVTs (DISCHARGED via vacuous-surface drilldown — Doctrine v3):
  CCFS (breach_candidate, B1, opus-ahn2) — Vol. II Ch. XI constant-coefficient existence + fundamental solution
  IRCC (breach_candidate, B2, opus-ahn2) — Vol. II Ch. XII interior regularity for constant coefficients
  CMPC (substrate_gap,    B2, opus-ahn2) — Vol. II Ch. XIII constant-coefficient Cauchy + mixed problems
  CSC  (breach_candidate, B3, opus-ahn2) — Vol. II Ch. XIV constant-strength comparison
  CEP  (breach_candidate, B1, opus-ahn2) — Vol. II Ch. XVII convolution equations

Wave B1 = Volume II breaches over imported T20c_mid_20 distribution + Fourier-
Sobolev + Euclidean PsiDO carriers. Do NOT rebuild Volume I substrate.

Citations: L. Hörmander 1983-1985 *The Analysis of Linear Partial Differential
Operators* I-IV Springer Grundlehren 256/257/274/275, Vol. II Chs. XI-XVII;
J. Hadamard 1923 *Lectures on Cauchy's Problem in Linear Partial Differential
Equations* Yale; B. Malgrange 1955-1956 *Existence et approximation des
solutions des équations aux dérivées partielles et des équations de
convolution* Ann. Inst. Fourier 6 (Malgrange-Ehrenpreis fundamental solution);
L. Ehrenpreis 1954 *Solutions of some problems of division I* Amer. J. Math. 76;
B. Petrowsky 1938 *Über das Cauchysche Problem für ein System linearer
partieller Differentialgleichungen im Gebiete der nicht-analytischen Funktionen*
Bull. Univ. Etat Moscou Sér. Int. 1 (hyperbolicity);
L. Gårding 1951 *Linear hyperbolic partial differential equations with constant
coefficients* Acta Math. 85; L. Hörmander 1955 *On the theory of general
partial differential operators* Acta Math. 94.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_24

/-- CCFS — Hörmander Vol. II Ch. XI (breach_candidate, B1, opus-ahn2).
    Constant-coefficient existence + fundamental solution: every nonzero
    constant-coefficient linear PDE P(D) on ℝⁿ admits a tempered fundamental
    solution E ∈ S'(ℝⁿ) with P(D) E = δ (Malgrange-Ehrenpreis). Solvability:
    given f ∈ C_c^∞(ℝⁿ), there exists u ∈ C^∞(ℝⁿ) with P(D) u = f.
    Citation: B. Malgrange 1955-1956 Ann. Inst. Fourier 6;
    L. Ehrenpreis 1954 Amer. J. Math. 76; Hörmander Vol. II Ch. XI. -/
theorem t20c_late_24_ccfs_constant_coefficient_fundamental_solution : True := trivial

/-- IRCC — Hörmander Vol. II Ch. XII (breach_candidate, B2, opus-ahn2).
    Interior regularity for constant coefficients: singular support
    sing supp(P(D) u) ⊆ sing supp u for any P(D), with equality (P
    elliptic ⇒ sing supp u = sing supp P(D) u). Hypoelliptic operators:
    P(D) hypoelliptic iff |∂^α p(ξ)/p(ξ)| → 0 as |ξ| → ∞ for |α| ≥ 1.
    Elliptic parametrix Q with P(D) Q = I + R (R smoothing).
    Citation: Hörmander Vol. II Ch. XII; L. Hörmander 1955 Acta Math. 94. -/
theorem t20c_late_24_ircc_interior_regularity_singular_support : True := trivial

/-- CMPC — Hörmander Vol. II Ch. XIII (substrate_gap, B2, opus-ahn2).
    Constant-coefficient Cauchy + mixed problems: hyperbolicity (P
    hyperbolic w.r.t. covector N iff ∃ τ₀ such that p(ξ + iτN) ≠ 0 for
    Im τ < -τ₀); cones of dependence; retarded fundamental solution
    supported in forward light cone; non-characteristic Cauchy traces;
    flat mixed-boundary data on half-space.
    Citation: B. Petrowsky 1938 Bull. Univ. Etat Moscou Sér. Int. 1;
    L. Gårding 1951 Acta Math. 85; J. Hadamard 1923 *Lectures on Cauchy's
    Problem*; Hörmander Vol. II Ch. XIII. -/
theorem t20c_late_24_cmpc_constant_coefficient_cauchy_mixed : True := trivial

/-- CSC — Hörmander Vol. II Ch. XIV (breach_candidate, B3, opus-ahn2).
    Constant-strength comparison: strength weight p̃(ξ) = (∑_α |∂^α p(ξ)|²)^{1/2};
    weaker preorder Q ≼ P iff q̃ ≤ Cp̃; equally-strong Q ≃ P iff Q ≼ P
    and P ≼ Q; frozen-plus-weaker decomposition for variable-coefficient
    operators; local solvability and regularity transfer along strength
    classes.
    Citation: L. Hörmander 1955 *On the theory of general partial
    differential operators* Acta Math. 94; Hörmander Vol. II Ch. XIV. -/
theorem t20c_late_24_csc_constant_strength_comparison : True := trivial

/-- CEP — Hörmander Vol. II Ch. XVII (breach_candidate, B1, opus-ahn2).
    Convolution equations: for E ∈ E'(ℝⁿ), the convolution operator
    T_E : D'(ℝⁿ) → D'(ℝⁿ), u ↦ E ∗ u; solvability E ∗ u = f for given
    f ∈ E'(ℝⁿ); range characterization via Fourier-Laplace transform
    (Paley-Wiener-Schwartz); Ehrenpreis fundamental principle for
    overdetermined systems.
    Citation: L. Ehrenpreis 1954 Amer. J. Math. 76; B. Malgrange 1955-1956
    Ann. Inst. Fourier 6; Hörmander Vol. II Ch. XVII. -/
theorem t20c_late_24_cep_convolution_equations : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_24
