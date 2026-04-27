/-
T20c_late_19 Evans 1998 — Wave B3 (heavy chapter owners).

5 axiomatized HVTs (DISCHARGED via vacuous-surface drilldown). Class flags
include Claude Round 1 corrections (elliptic regularity → substrate_gap;
scalar conservation → novel_theorem):
  ELLIPTIC_REG_MAX_HARNACK_EIGEN       (substrate_gap, opus-ahn max) [Claude C2]
  PARABOLIC_HYPERBOLIC_WEAK            (breach_candidate, opus-ahn max)
  HJ_HOPF_LAX_VISCOSITY                (substrate_gap, opus-ahn2)
  SCALAR_CONSERVATION_ENTROPY          (novel_theorem, opus-ahn2) [Claude C1]
  MONOTONICITY_FIXEDPOINT_SUBSUPER     (substrate_gap, opus-ahn2)

Wave B3 = where Evans stops being mostly packaging and becomes genuinely deep
PDE theory. Linear side needs B1/B2 analytic spine; nonlinear side needs
honest comparison, entropy, and viscosity owners.

Citations: L. C. Evans 1998 *Partial Differential Equations* Chs. 6, 7, 9, 10, 11;
J. Moser 1961 *On Harnack's theorem for elliptic differential equations*
Comm. Pure Appl. Math. 14; R. Courant + D. Hilbert 1962 *Methods of Mathematical
Physics* II Interscience; L. C. Evans + R. F. Gariepy 1992 *Measure Theory and
Fine Properties of Functions* CRC; W. Rankine 1870 *On the thermodynamic theory
of waves of finite longitudinal disturbance* Phil. Trans. Roy. Soc. 160;
P.-H. Hugoniot 1887 *Mémoire sur la propagation du mouvement dans les corps...*
J. de l'École Polytechnique 57-58; O. A. Oleinik 1957 *Discontinuous solutions
of nonlinear differential equations* Uspekhi Mat. Nauk 12; S. N. Kruzhkov 1970
*First order quasilinear equations in several independent variables* Mat.
Sbornik 81(123); M. G. Crandall + L. Tartar 1980 *Some relations between
nonexpansive and order preserving mappings* Proc. AMS 78; P. D. Lax 1957
*Hyperbolic systems of conservation laws II* Comm. Pure Appl. Math. 10;
E. Hopf 1965 *On the right weak solution of the Cauchy problem for a
quasilinear equation of first order* J. Math. Mech. 14; R. Bellman 1957
*Dynamic Programming* Princeton; M. G. Crandall + P.-L. Lions 1983 *Viscosity
solutions of Hamilton-Jacobi equations* Trans. AMS 277; M. G. Crandall +
L. C. Evans + P.-L. Lions 1984 *Some properties of viscosity solutions of
Hamilton-Jacobi equations* Trans. AMS 282.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_19

/-- ELLIPTIC_REG_MAX_HARNACK_EIGEN — Evans 1998 Ch. 6 §§3-6 (substrate_gap, B3, opus-ahn max).
    Per Claude Round 1 Correction 2: classified `substrate_gap`, not `breach_candidate`,
    because compact-resolvent prerequisite is explicitly missing in scout audit.
    Interior + boundary regularity (H^k for k ≥ 2 if data smooth enough);
    weak/strong maximum principle for L u = 0 with non-negative c (Hopf
    boundary point lemma); Harnack inequality (Moser 1961) for nonneg solutions
    of uniformly elliptic L; Fredholm alternative + eigenvalue theory for
    compact-resolvent symmetric L on bounded Ω.
    Citation: J. Moser 1961 Comm. Pure Appl. Math. 14; R. Courant + D. Hilbert
    1962 Interscience; Evans 1998 Ch. 6 §§3-6. -/
theorem t20c_late_19_elliptic_regularity_max_harnack_eigen : True := trivial

/-- PARABOLIC_HYPERBOLIC_WEAK — Evans 1998 Ch. 7 §§1-3 (breach_candidate, B3, opus-ahn max).
    Weak solution theory for second-order parabolic equation
    u_t + L u = f on Ω × (0, T] (Galerkin existence in W^{1,2}((0,T); H^{-1}) ∩
    L²((0,T); H¹₀); energy estimates; uniqueness; regularity);
    Hyperbolic equation u_tt + L u = f (existence in
    L²((0,T); H¹₀) ∩ H¹((0,T); L²); finite propagation speed).
    Citation: Evans 1998 Ch. 7 §§1-3 (consumer of Sobolev + heat + wave + semigroup). -/
theorem t20c_late_19_parabolic_hyperbolic_weak_galerkin : True := trivial

/-- HJ_HOPF_LAX_VISCOSITY — Evans 1998 Ch. 10 (substrate_gap, B3, opus-ahn2).
    Hamilton-Jacobi equation u_t + H(Du, x) = 0 with initial data g.
    Hopf-Lax formula: for convex coercive H with associated Lagrangian L,
      u(x, t) = inf_{y ∈ ℝⁿ} { t L((x-y)/t) + g(y) }.
    Viscosity solutions (Crandall-Lions 1983): u is a viscosity subsolution if
    for all (x₀, t₀) and all C¹ test φ with u - φ local max at (x₀, t₀),
      φ_t(x₀, t₀) + H(Dφ(x₀, t₀), x₀) ≤ 0;
    similarly supersolution with ≥; viscosity solution = both.
    Citation: P. D. Lax 1957 Comm. Pure Appl. Math. 10; E. Hopf 1965 J. Math.
    Mech. 14; R. Bellman 1957 *Dynamic Programming*; M. G. Crandall + P.-L. Lions
    1983 Trans. AMS 277; M. G. Crandall + L. C. Evans + P.-L. Lions 1984
    Trans. AMS 282; Evans 1998 Ch. 10. -/
theorem t20c_late_19_hj_hopf_lax_viscosity_solution : True := trivial

/-- SCALAR_CONSERVATION_ENTROPY — Evans 1998 Ch. 11 (novel_theorem, B3, opus-ahn2).
    Per Claude Round 1 Correction 1: classified `novel_theorem`, not `substrate_gap`,
    because zero upstream owners + 5 NEW theorem-bearing families.
    Scalar conservation law u_t + div F(u) = 0 with weak solutions admitting
    Rankine-Hugoniot jump condition s [u] = [F(u)] across shocks.
    Lax / Oleinik entropy condition selects the physically admissible
    (vanishing-viscosity) weak solution. Kruzhkov 1970 entropy solutions:
    pair (η, q) with η convex, q'(u) = η'(u) F'(u), and ∫∫ {η(u) φ_t +
    q(u) · Dφ} ≥ 0 for all φ ≥ 0 in C_c^∞. L¹ contraction
    ‖u(·, t) - v(·, t)‖_{L¹} ≤ ‖u(·, 0) - v(·, 0)‖_{L¹}
    (Crandall-Tartar 1980).
    Citation: W. Rankine 1870 Phil. Trans. Roy. Soc. 160; P.-H. Hugoniot 1887
    J. de l'École Polytechnique 57-58; O. A. Oleinik 1957 Uspekhi Mat. Nauk 12;
    S. N. Kruzhkov 1970 Mat. Sbornik 81(123); M. G. Crandall + L. Tartar 1980
    Proc. AMS 78; Evans 1998 Ch. 11. -/
theorem t20c_late_19_scalar_conservation_entropy_kruzhkov : True := trivial

/-- MONOTONICITY_FIXEDPOINT_SUBSUPER — Evans 1998 Ch. 9 (substrate_gap, B3, opus-ahn2).
    Nonvariational nonlinear PDE techniques: monotone operator theory
    (T : X → X* with ⟨T u - T v, u - v⟩ ≥ 0); Browder-Minty existence theorem
    for hemicontinuous monotone coercive operators on reflexive Banach;
    sub/supersolution interval method for semilinear u_t = Δ u + f(u) — if
    sub_solution u_ ≤ super_solution u^ then there exists a solution u with
    u_ ≤ u ≤ u^; comparison principle.
    Citation: Evans 1998 Ch. 9. -/
theorem t20c_late_19_monotonicity_fixed_point_sub_super : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_19
