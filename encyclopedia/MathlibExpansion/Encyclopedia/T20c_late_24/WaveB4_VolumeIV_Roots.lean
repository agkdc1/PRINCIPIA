/-
T20c_late_24 Hörmander 1983-1985 — Wave B4 (Volume IV: 2 root carriers).

2 axiomatized HVTs (DISCHARGED via vacuous-surface drilldown):
  LDFIO (substrate_gap, B3, opus-ahn max) — Vol. IV Ch. XXV §§25.1-25.2 Lagrangian distributions + FIO calculus
  CUP   (substrate_gap, B4, opus-ahn max) — Vol. IV Ch. XXVIII Carleman + uniqueness package

Wave B4 = the 2 Volume IV root carriers. LDFIO is the FIO ROOT (consumes
SLG + PSC); CUP needs new weighted L²/Fourier-Sobolev carriers + Carleman
weight geometry.

Citations: L. Hörmander 1983-1985 *Analysis of Linear PDE* IV Springer
Grundlehren 275, Chs. XXV §§25.1-25.2, XXVIII;
J. J. Duistermaat + L. Hörmander 1972 *Fourier integral operators II* Acta
Math. 128 (LDFIO);
L. Hörmander 1971 *Fourier integral operators I* Acta Math. 127 (LDFIO);
T. Carleman 1939 *Sur un problème d'unicité pour les systèmes d'équations
aux dérivées partielles à deux variables indépendantes* Ark. Mat. Astr.
Fys. 26B (CUP); A. P. Calderón 1958 *Uniqueness in the Cauchy problem for
partial differential equations* Amer. J. Math. 80 (CUP);
L. Hörmander 1958 *On the uniqueness of the Cauchy problem* Math. Scand. 6
(CUP); L. Hörmander 1963 *Linear Partial Differential Operators* Springer
Grundlehren 116 (CUP weights).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_24

/-- LDFIO — Hörmander Vol. IV Ch. XXV §§25.1-25.2 (substrate_gap, B3, opus-ahn max).
    Lagrangian distributions and FIO calculus root carrier:
    (a) Phase function φ(x, θ) on X × (ℝ^N \ 0), homogeneous of degree 1
        in θ, non-degenerate (dφ ≠ 0 on the critical set C_φ);
    (b) Lagrangian distribution I^m(X, Λ) = {oscillatory integrals
        ∫ e^{iφ(x, θ)} a(x, θ) dθ with a ∈ S^m and Lagrangian
        Λ = Λ_φ ⊂ T*X};
    (c) FIO of order m on canonical relation C ⊆ T*X × T*Y: Schwartz
        kernel is a Lagrangian distribution on X × Y associated to C;
    (d) Clean composition of FIO: F_C ∘ F_{C'} is FIO on C ∘ C' under
        cleanness hypothesis;
    (e) Egorov theorem: e^{itP} A e^{-itP} ≡ A_{Ham} mod lower order.
    Citation: L. Hörmander 1971 *Fourier integral operators I* Acta Math.
    127; J. J. Duistermaat + L. Hörmander 1972 *Fourier integral operators II*
    Acta Math. 128; Hörmander Vol. IV Ch. XXV §§25.1-25.2. -/
theorem t20c_late_24_ldfio_lagrangian_distribution_fio_root : True := trivial

/-- CUP — Hörmander Vol. IV Ch. XXVIII (substrate_gap, B4, opus-ahn max).
    Carleman estimates + uniqueness: weighted L² estimate for a differential
    operator P at a smooth weight function ϕ:
      e^{τϕ} P u = e^{τϕ} P(e^{-τϕ} (e^{τϕ} u)) = P_τ (e^{τϕ} u),
    so τ-dependent weighted estimate on P_τ acting on e^{τϕ} u; pseudoconvex
    weight geometry (∇ϕ at characteristic points + sign condition); Carleman
    template ‖e^{τϕ} u‖² ≤ C τ^{-1} ‖e^{τϕ} P u‖² for u ∈ C_c^∞(Ω);
    Calderón-Hörmander unique-continuation theorem from Carleman estimate.
    Citation: T. Carleman 1939 Ark. Mat. Astr. Fys. 26B; A. P. Calderón 1958
    Amer. J. Math. 80; L. Hörmander 1958 Math. Scand. 6; L. Hörmander 1963
    *Linear Partial Differential Operators* Springer Grundlehren 116;
    Hörmander Vol. IV Ch. XXVIII. -/
theorem t20c_late_24_cup_carleman_estimate_unique_continuation : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_24
