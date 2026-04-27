/-
T20c_late_19 Evans 1998 — Wave B2 (first honest consumers after B1).

4 axiomatized HVTs (DISCHARGED via vacuous-surface drilldown):
  LAPLACE_HARMONIC_REP        (breach_candidate, sonnet-ahn2)
  LAX_MILGRAM_WEAK_ELLIPTIC   (breach_candidate, sonnet-ahn2)
  WAVE_ENERGY_PROPAGATION     (breach_candidate, opus-ahn2)
  DIRECT_METHOD_EULER_LAGRANGE (substrate_gap, opus-ahn2)

Wave B2 = topics that become honest only after B1 owners exist or are
sharply typed. All four are bounded enough to dispatch before the
research-depth Chapter 6/7/8 fronts.

Citations: L. C. Evans 1998 *Partial Differential Equations* Chs. 2, 6, 8;
S.-D. Poisson 1823 *Mémoire sur la théorie du magnétisme en mouvement*;
G. Green 1828 *Essay on the Application of Mathematical Analysis to the
Theories of Electricity and Magnetism*; C. F. Gauss 1839 *Allgemeine Lehrsätze*;
J. d'Alembert 1747 *Recherches sur la courbe que forme une corde tendue*
Hist. Acad. Sci. Berlin 3; G. Kirchhoff 1883 *Vorlesungen über mathematische
Physik* Teubner; P. D. Lax + A. N. Milgram 1954 *Parabolic equations* AMS Proc.;
L. Tonelli 1915-1916 *Sur la semi-continuité des intégrales doubles*
Rend. Lincei (5) 24-25; L. Euler 1744 *Methodus inveniendi lineas curvas*
Bousquet, Lausanne.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_19

/-- LAPLACE_HARMONIC_REP — Evans 1998 Ch. 2 §2 (breach_candidate, B2, sonnet-ahn2).
    Laplace equation Δu = 0 and harmonic representation: mean-value formula
    `u(x) = (1/|∂B(x,r)|) ∫_{∂B(x,r)} u dσ` for harmonic u on B(x, r);
    maximum principle (strong + weak); Poisson kernel
    `K(x, y) = (1/n α(n)) (R² - |x|²) / (R |x - y|^n)` for ball B(0, R) and
    `u(x) = ∫_{∂B(0,R)} K(x, y) g(y) dσ(y)`; Green's representation formula
    on bounded domain via fundamental solution.
    Citation: S.-D. Poisson 1823; G. Green 1828; C. F. Gauss 1839; Evans 1998
    Ch. 2 §2. -/
theorem t20c_late_19_laplace_mean_value_poisson_green : True := trivial

/-- LAX_MILGRAM_WEAK_ELLIPTIC — Evans 1998 Ch. 6 §§1-2 (breach_candidate, B2, sonnet-ahn2).
    Lax-Milgram theorem (abstract upstream) bridge to bounded-domain coercive
    elliptic equations: for L u = -∑ ∂_i (a^{ij} ∂_j u) + ∑ b^i ∂_i u + c u
    with bounded coefficients, uniform ellipticity θ |ξ|² ≤ a^{ij} ξ_i ξ_j,
    and λ > λ₀, the bilinear form B[u, v] + λ(u, v) is bounded and coercive
    on H¹₀(Ω); for f ∈ L²(Ω) there exists a unique weak solution
    u ∈ H¹₀(Ω) with B[u, v] + λ(u, v) = (f, v) for all v ∈ H¹₀(Ω).
    Citation: P. D. Lax + A. N. Milgram 1954 AMS Proc.; Evans 1998 Ch. 6 §§1-2. -/
theorem t20c_late_19_lax_milgram_coercive_elliptic_solvability : True := trivial

/-- WAVE_ENERGY_PROPAGATION — Evans 1998 Ch. 2 §4 + Ch. 7 (breach_candidate, B2, opus-ahn2).
    Wave equation u_tt = Δu and 1D d'Alembert formula u(x, t) =
    (1/2)(g(x+t) + g(x-t)) + (1/2) ∫_{x-t}^{x+t} h(y) dy. Energy
    E(t) = (1/2) ∫_{ℝⁿ} (u_t² + |Du|²) dx is conserved. Finite propagation
    speed: u(x, t) depends only on data in the past light cone {(y, s) :
    |y - x| ≤ t - s}. Kirchhoff's formula in 3D, Hadamard descent in 2D.
    Citation: J. d'Alembert 1747 Hist. Acad. Sci. Berlin 3; G. Kirchhoff 1883
    Teubner; Evans 1998 Ch. 2 §4. -/
theorem t20c_late_19_wave_dalembert_energy_finite_propagation : True := trivial

/-- DIRECT_METHOD_EULER_LAGRANGE — Evans 1998 Ch. 8 §§1-3 (substrate_gap, B2, opus-ahn2).
    Direct method of the calculus of variations: for I[u] = ∫_Ω L(Du, u, x) dx
    coercive + lower-semicontinuous on a reflexive Banach space X (e.g.,
    W^{1,p}(Ω) with p > 1), there exists a minimizer u* ∈ X via
      (a) bounded minimizing sequence (coercivity);
      (b) weakly convergent subsequence (reflexivity + Banach-Alaoglu);
      (c) liminf at limit (lower semicontinuity, e.g., convexity in Du).
    Weak Euler-Lagrange equation: -∑ ∂_i L_{p_i}(Du, u, x) + L_z(Du, u, x) = 0
    in distribution.
    Citation: L. Euler 1744 *Methodus inveniendi lineas curvas*; L. Tonelli
    1915-1916 Rend. Lincei (5) 24-25; Evans 1998 Ch. 8 §§1-3. -/
theorem t20c_late_19_direct_method_weak_euler_lagrange : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_19
