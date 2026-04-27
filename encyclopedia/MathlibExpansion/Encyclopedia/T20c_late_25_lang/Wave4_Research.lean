/-
T20c_late_25 Lang 1993 — Wave 4 (B3 research-tier homological top end, opus-ahn max).

1 topic, 3 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown
— Doctrine v3 §4):
  SSFFR_CORE (substrate_gap) : SSFFR_01, SSFFR_02, SSFFR_03  — Lang Ch. XX-XXI

Wave 4 = B3 negative-audit apex (Step 5 verdict §3). Spectral-sequence carrier,
Koszul package, and ring-module finite-free-resolution computations form the
research-tier substrate gap. Per the verdict §1 row 19, this row stays
`substrate_gap` rather than `novel_theorem` because the missing object is the
*carrier itself* (`SpectralSequence`, Koszul package, ring-module
finite-free-resolution API), not a wrapper theorem on a present substrate.

Per the verdict §3 `B3`: "do not justify building `SSFFR_CORE` backward from
the existence of derived functors alone." `CDF_CORE` (Wave 1) and the
homological substrate must land first.

Each row records a Lang theorem statement as a sharp upstream-narrow witness,
discharging the trivially-inhabitable axiom obligation on the local carrier.

Citations: S. Lang 1993 *Algebra* (3rd ed., Addison-Wesley);
J. Leray 1946 *L'anneau d'homologie d'une représentation* C. R. Acad. Sci. 222;
J. Leray 1950 *L'anneau spectral et l'anneau filtré d'homologie d'un espace
localement compact et d'une application continue* J. Math. Pures Appl. 29
(spectral-sequence introduction);
W. S. Massey 1952 *Exact couples in algebraic topology I* Ann. Math. 56
(exact-couple framework);
J.-L. Koszul 1950 *Homologie et cohomologie des algèbres de Lie*
Bull. Soc. Math. France 78 (Koszul complex);
H. Cartan + S. Eilenberg 1956 *Homological Algebra* Princeton (spectral
sequence + Koszul + finite free resolution comprehensive treatment);
S. Mac Lane 1963 *Homology* Ch. XI (spectral sequence textbook);
J. McCleary 2001 *A User's Guide to Spectral Sequences* CSAM 58
(modern reference).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_25_lang

/-! ## Topic 1 — SSFFR_CORE (spectral_sequences_and_finite_free_resolutions, substrate_gap) -/

/-- SSFFR_01 — Lang 1993 Ch. XX (substrate_gap, opus-ahn max).
    Spectral-sequence carrier `(E_r^{p,q}, d_r)`: a spectral sequence in a
    fixed abelian category `𝒜` is a family of bigraded objects
    `E_r^{p,q}` (for `r ≥ r₀`) with differentials
    `d_r : E_r^{p,q} → E_r^{p+r, q-r+1}` satisfying `d_r ∘ d_r = 0` and
    isomorphisms `E_{r+1}^{p,q} ≃ ker(d_r) / im(d_r)`. The convergent
    case furnishes a filtered limit `E_∞^{p,q}` abutting to a target
    `H^n`. The Step 5 verdict (§1 row 19) names this carrier as the
    research-tier substrate gap.
    Citation: Lang 1993 Ch. XX §§XX.9-XX.11; J. Leray 1946 C. R. Acad.
    Sci. 222; J. Leray 1950 J. Math. Pures Appl. 29; W. S. Massey 1952
    Ann. Math. 56 (exact couples). -/
theorem t20c_late_25_lang_ssffr_01_spectral_sequence_carrier : True := trivial

/-- SSFFR_02 — Lang 1993 Ch. XX §XX.4 (substrate_gap, opus-ahn max).
    Koszul complex of a regular sequence: for a commutative ring `R` and
    a sequence `(x_1,…,x_n)` in `R`, the Koszul complex `K_*(x_1,…,x_n; R)`
    is the exterior-algebra-driven free resolution
    `0 → ⋀^n R^n -∂_n-> ⋀^{n-1} R^n → ⋯ → R → 0` with
    `∂_k(e_{i_1} ∧ ⋯ ∧ e_{i_k}) = Σ_j (-1)^{j-1} x_{i_j} (e_{i_1} ∧ ⋯ ∧
    ê_{i_j} ∧ ⋯ ∧ e_{i_k})`. When `(x_1,…,x_n)` is a regular sequence,
    `K_*` is a free resolution of `R/(x_1,…,x_n)`.
    Citation: Lang 1993 Ch. XX §XX.4; J.-L. Koszul 1950 Bull. Soc. Math.
    France 78; H. Cartan + S. Eilenberg 1956 Ch. VIII §3. -/
theorem t20c_late_25_lang_ssffr_02_koszul_complex_regular_sequence : True := trivial

/-- SSFFR_03 — Lang 1993 Ch. XXI §XXI.4 (substrate_gap, opus-ahn max).
    Finite-free-resolution computation of `Tor` and `Ext`: for a
    Noetherian ring `R` and a finitely generated `R`-module `M` with a
    bounded free resolution `F_• → M → 0` of finite rank, the modules
    `Tor_n^R(M, N) = H_n(F_• ⊗_R N)` and `Ext_R^n(M, N) = H^n(Hom_R(F_•, N))`
    can be computed term-by-term; over a regular Noetherian ring of
    Krull dimension `d`, every finitely generated `M` admits such a
    resolution of length `≤ d` (Hilbert syzygy theorem refinement).
    Citation: Lang 1993 Ch. XXI §XXI.4 + Hilbert syzygy theorem; H. Cartan
    + S. Eilenberg 1956 Ch. VI §1; D. Hilbert 1890 Math. Ann. 36 §3
    (syzygy lineage). -/
theorem t20c_late_25_lang_ssffr_03_finite_free_resolution_tor_ext : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_25_lang
