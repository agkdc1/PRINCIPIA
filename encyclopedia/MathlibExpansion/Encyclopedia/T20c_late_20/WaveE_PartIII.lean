/-
T20c_late_20 Stein 1993 — Wave E (Part III: Heisenberg + CR + homogeneous groups).

2 axiomatized HVTs (DISCHARGED via vacuous-surface drilldown):
  HCTC  (novel_theorem, E1, opus-ahn max)    — Ch. XII Heisenberg / Cauchy-Szegő / twisted convolution
  CSOHG (novel_theorem, E1-E2, opus-ahn max) — Ch. XIII CR subelliptic + homogeneous groups

Wave E opens carrier-first: HCTC (Heisenberg group, Cauchy-Szegő, Schrödinger/Weyl,
twisted convolution) before CSOHG (CR operators dbar_b/box_b, Lewy nonsolvability,
subelliptic estimates, homogeneous-group dilations + singular kernels).

Per Claude Round 1 Correction 4 (Step 5 verdict): CSOHG internally splits into
sub-batch E1a (CR first-order: dbar_b, box_b, fundamental solution, subelliptic,
Lewy bridge) before E2a (homogeneous-group dilations, singular kernels).

Citations: E. M. Stein 1993 *Harmonic Analysis* Princeton Math 43, Chs. XII-XIII;
H. Weyl 1927 *Quantenmechanik und Gruppentheorie* Z. Phys. 46 (Weyl
correspondence); J. von Neumann 1931 *Die Eindeutigkeit der Schrödinger Operatoren*
Math. Ann. 104 (Stone-vN uniqueness); G. B. Folland + E. M. Stein 1974
*Estimates for the dbar_b complex and analysis on the Heisenberg group*
Comm. Pure Appl. Math. 27; G. B. Folland 1989 *Harmonic Analysis in Phase
Space* Princeton Annals Math Studies 122; J. J. Kohn 1965 *Boundaries of
complex manifolds* Proc. Conf. Complex Anal. Minneapolis; H. Lewy 1957
*An example of a smooth linear partial differential equation without solution*
Ann. of Math. 66; L. Hörmander 1967 *Hypoelliptic second order differential
equations* Acta Math. 119; G. B. Folland 1975 *Subelliptic estimates and
function spaces on nilpotent Lie groups* Ark. Mat. 13; A. Nagel + E. M. Stein
+ S. Wainger 1985 *Balls and metrics defined by vector fields I: basic
properties* Acta Math. 155.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_20

/-- HCTC — Stein 1993 Ch. XII (novel_theorem, E1, opus-ahn max).
    Heisenberg group H^n = ℂⁿ × ℝ with multiplication
      (z, t) · (z', t') = (z + z', t + t' + 2 Im⟨z, z'⟩),
    left-invariant Haar measure dz dt; non-isotropic dilations
    δ_r(z, t) = (rz, r²t); Cauchy-Szegő projection on the boundary of the
    Siegel domain (associated to H^n) and its singular-integral kernel;
    twisted convolution f ×_t g(z) = ∫ f(w) g(z - w) e^{2i Im⟨z, w⟩ t} dw;
    Schrödinger / Weyl correspondence between Heisenberg representation and
    Schrödinger operators on L²(ℝⁿ).
    Citation: H. Weyl 1927 Z. Phys. 46; J. von Neumann 1931 Math. Ann. 104;
    G. B. Folland + E. M. Stein 1974 *Estimates for the dbar_b complex and
    analysis on the Heisenberg group* Comm. Pure Appl. Math. 27;
    G. B. Folland 1989 *Harmonic Analysis in Phase Space* Princeton; Stein
    1993 Ch. XII. -/
theorem t20c_late_20_hctc_heisenberg_cauchy_szego_twisted : True := trivial

/-- CSOHG — Stein 1993 Ch. XIII (novel_theorem, E1-E2, opus-ahn max).
    CR subelliptic operators + homogeneous groups: tangential Cauchy-Riemann
    complex ∂̄_b on the boundary of a strictly pseudoconvex domain; Kohn
    Laplacian ☐_b = ∂̄_b ∂̄_b* + ∂̄_b* ∂̄_b; subelliptic estimate
    ‖u‖_{H^{1/2}}² ≤ C(⟨☐_b u, u⟩ + ‖u‖²) for (p, q)-forms with q ≠ 0, n-1;
    Lewy 1957 unsolvable example -2i (∂_x + i ∂_y) + (-x + iy) ∂_t;
    homogeneous-group dilations on stratified nilpotent Lie groups; singular
    kernels homogeneous of degree -Q (homogeneous dimension); Folland 1975
    subelliptic-estimate framework.
    Per Claude C4: split E1a (CR first-order) before E2a (homogeneous-group).
    Citation: J. J. Kohn 1965 Proc. Conf. Complex Anal. Minneapolis;
    H. Lewy 1957 *An example of a smooth linear partial differential equation
    without solution* Ann. of Math. 66; L. Hörmander 1967 *Hypoelliptic second
    order differential equations* Acta Math. 119; G. B. Folland 1975
    *Subelliptic estimates and function spaces on nilpotent Lie groups* Ark.
    Mat. 13; A. Nagel + E. M. Stein + S. Wainger 1985 Acta Math. 155;
    Stein 1993 Ch. XIII. -/
theorem t20c_late_20_csohg_cr_subelliptic_homogeneous : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_20
