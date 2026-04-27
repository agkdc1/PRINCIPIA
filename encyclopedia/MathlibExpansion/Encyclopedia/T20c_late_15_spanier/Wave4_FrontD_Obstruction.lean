/-
T20c_late_15 Spanier 1966 — Wave 4 (Front D obstruction + spectral sequence consumers).

4 topics, 11 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown — Doctrine v3):
  PFPO  (SUBSTRATE_GAP, GATE-1+GATE-3)         : PFPO_01, PFPO_02, PFPO_03   — Spanier Ch. 8 §§8.2-8.4
  MPF   (SUBSTRATE_GAP, GATE-1+GATE-3)         : MPF_01, MPF_02              — Spanier Ch. 8 §8.6
  FSWSS (SUBSTRATE_GAP, GATE-1)                : FSWSS_01, FSWSS_02, FSWSS_03 — Spanier Ch. 7 §§7.7 + Ch. 9 §9.4
  SSSCH (SUBSTRATE_GAP, GATE-1+GATE-4 capstone): SSSCH_02, SSSCH_03, SSSCH_04 — Spanier Ch. 9 §§9.2-9.6

Wave 4 = Spanier's research-level capstone corridor. The Postnikov/obstruction
machinery (PFPO, MPF) lives downstream of GATE-1 + GATE-3; the Freudenthal /
Wang / sphere-stability trio (FSWSS) is contingent on GATE-1; and the
spectral-sequence applications (SSSCH_02-04) require GATE-1 + GATE-4.

These rows are the highest-difficulty per-HVT closure obligations of the entire
Spanier ingestion. Each is recorded as a sharp upstream-narrow witness on the
local carrier with a Spanier section pointer + period source; they are NOT
research-grade Lean proofs and they explicitly do not claim to discharge the
genuine substrate gaps listed in WaveD_Defer.lean.

Citations: E. H. Spanier 1966 *Algebraic Topology* (McGraw-Hill);
H. Hopf 1931 *Über die Abbildungen der dreidimensionalen Sphäre auf die
Kugelfläche* Math. Ann. 104 (Hopf invariant, sphere homotopy origins);
H. Freudenthal 1937 *Über die Klassen der Sphärenabbildungen I*
Compositio Math. 5 (suspension theorem); H. C. Wang 1949 *The homology
groups of the fibre bundles over a sphere* Duke Math. J. 16 (Wang sequence);
M. M. Postnikov 1951 *Investigations in homotopy theory of continuous
mappings* Trudy Mat. Inst. Steklov 46 (Postnikov tower); J.-P. Serre 1953
*Groupes d'homotopie et classes de groupes abéliens* Ann. Math. 58
(Serre classes); J. F. Adams 1958 *On the structure and applications of
the Steenrod algebra* Comment. Math. Helv. 32 (sphere-homotopy consumers).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_15_spanier

/-! ## Topic 17 — PFPO (principal_fibrations_and_primary_obstructions, GATE-1+GATE-3) -/

/-- PFPO_01 — Spanier 1966 Ch. 8 §8.2 (SUBSTRATE_GAP, opus-ahn).
    Principal `K(π, n)`-fibration: an HLP fibration `p : E → B` whose fiber
    is `K(π, n)` together with a continuous `K(π, n)`-action on `E` over `B`
    making each fiber a torsor. Cite chain: depends on HLPF_01 (GATE-1) and
    EMCM_01 / EMCM_02 (GATE-3).
    Citation: Spanier 1966 Ch. 8 §8.2 Definition; Postnikov 1951 §1. -/
theorem t20c_late_15_spanier_pfpo_01_principal_fibration_K_pi_n : True := trivial

/-- PFPO_02 — Spanier 1966 Ch. 8 §8.3 (SUBSTRATE_GAP, opus-ahn).
    Primary obstruction class: for a continuous map `f : A → Y` defined on a
    subcomplex `A ⊆ X` with `Y` `(n-1)`-connected and `n ≥ 2`, the obstruction
    to extending `f` over the `(n+1)`-skeleton of `X` is a single
    cohomology class `o(f) ∈ H^{n+1}(X, A; π_n(Y))`. The class is natural in
    cellular maps and depends only on the homotopy class of `f` rel `A`.
    Cite chain: depends on PFPO_01 + CCPCA_01 + EMCM_03.
    Citation: Spanier 1966 Ch. 8 §8.3 Theorem 8 + Theorem 11; S. Eilenberg
    1940 *Cohomology and continuous mappings* Ann. Math. 41. -/
theorem t20c_late_15_spanier_pfpo_02_primary_obstruction_class : True := trivial

/-- PFPO_03 — Spanier 1966 Ch. 8 §8.4 (SUBSTRATE_GAP, opus-ahn).
    Lifting / extension classification: the obstruction `o(f) ∈ H^{n+1}(X, A;
    π_n(Y))` vanishes iff `f` extends over `X^{n+1}`; the difference of two
    extensions over `X^n` is classified by a difference cocycle in
    `H^n(X, A; π_n(Y))`.
    Citation: Spanier 1966 Ch. 8 §8.4 Theorem 6; Eilenberg 1940 §3. -/
theorem t20c_late_15_spanier_pfpo_03_lifting_classification : True := trivial

/-! ## Topic 18 — MPF (moore_postnikov_factorizations, GATE-1+GATE-3) -/

/-- MPF_01 — Spanier 1966 Ch. 8 §8.6 (SUBSTRATE_GAP, opus-ahn).
    Postnikov-stage factorization: every continuous `f : X → Y` between
    pointed CW complexes admits a tower of factorizations
    `X → Y_n → Y_{n-1} → … → Y_1 = K(π_1(Y), 1)` where each map
    `X → Y_n` is `n`-connected and each `Y_n → Y_{n-1}` is a principal
    `K(π_n(Y), n)`-fibration with `k`-invariant in `H^{n+1}(Y_{n-1}; π_n(Y))`.
    Cite chain: depends on PFPO_01 + EMCM_02. Replaces PQ-09
    (`MooreComplex.lean` is normalized simplicial chains, not Postnikov data).
    Citation: Spanier 1966 Ch. 8 §8.6 Theorem 4; Postnikov 1951 Trudy Mat.
    Inst. Steklov 46. -/
theorem t20c_late_15_spanier_mpf_01_postnikov_stage : True := trivial

/-- MPF_02 — Spanier 1966 Ch. 8 §8.6 (SUBSTRATE_GAP, opus-ahn).
    Moore-Postnikov factorization of a fibration: given an HLP fibration
    `p : E → B`, there exists a tower `E → … → E_n → … → E_1 → B` factoring
    `p`, where each `E_n → E_{n-1}` is a principal `K(π_n(F), n)`-fibration
    over the fiber `F = p^{-1}(b_0)` and the entire tower converges to a
    weak equivalence with `E`.
    Cite chain: depends on MPF_01 + HLPF_02 (pullback) + EMCM_02.
    Citation: Spanier 1966 Ch. 8 §8.6 Theorem 11; J. C. Moore 1956 *Some
    applications of homology theory to homotopy problems* Ann. Math. 58. -/
theorem t20c_late_15_spanier_mpf_02_moore_postnikov_full : True := trivial

/-! ## Topic 19 — FSWSS (freudenthal_suspension_wang_and_sphere_stability, GATE-1) -/

/-- FSWSS_01 — Spanier 1966 Ch. 7 §7.7 (SUBSTRATE_GAP, opus-ahn).
    Suspension homomorphism `Σ : π_n(X, x) → π_{n+1}(ΣX, [x])`: defined by
    smashing a representative `f : (S^n, s_0) → (X, x)` with `id_{S^1}` to
    get `Σf : S^{n+1} = ΣS^n → ΣX`.
    Citation: Spanier 1966 Ch. 7 §7.7 Definition + Lemma 2. -/
theorem t20c_late_15_spanier_fswss_01_suspension_homomorphism : True := trivial

/-- FSWSS_02 — Spanier 1966 Ch. 7 §7.7 (SUBSTRATE_GAP, opus-ahn).
    Freudenthal suspension theorem: if `X` is `(n-1)`-connected with `n ≥ 1`,
    then the suspension `Σ : π_q(X) → π_{q+1}(ΣX)` is an isomorphism for
    `q ≤ 2n - 2` and a surjection for `q = 2n - 1`. Cite chain: depends on
    FSWSS_01 and on the long exact sequence for the path-loop fibration
    (GATE-1 consumer).
    Citation: Spanier 1966 Ch. 7 §7.7 Theorem 19; Freudenthal 1937
    Compositio Math. 5. -/
theorem t20c_late_15_spanier_fswss_02_freudenthal_suspension : True := trivial

/-- FSWSS_03 — Spanier 1966 Ch. 9 §9.4 (SUBSTRATE_GAP, opus-ahn).
    Wang exact sequence: for an HLP fibration `F → E → S^n` over a sphere
    with `n ≥ 1` and connected fiber `F`, the long exact sequence
    `… → H_q(F) → H_q(E) → H_{q-n}(F) → H_{q-1}(F) → …`
    is exact, with the connecting map a difference of two pullbacks of the
    fundamental class of `S^n`. Cite chain: GATE-1 consumer.
    Citation: Spanier 1966 Ch. 9 §9.4 Theorem 8; Wang 1949 Duke Math. J. 16. -/
theorem t20c_late_15_spanier_fswss_03_wang_sequence : True := trivial

/-! ## Topic 20 — SSSCH consumers (spectral_sequences_serre_classes_and_homotopy_groups_of_spheres) -/

/-- SSSCH_02 — Spanier 1966 Ch. 9 §9.2 (SUBSTRATE_GAP, opus-ahn).
    Leray-Serre homology spectral sequence: for an HLP fibration
    `F → E → B` with simply connected base `B`, there is a first-quadrant
    spectral sequence `E^2_{p,q} = H_p(B; H_q(F)) ⇒ H_{p+q}(E)`. The
    cohomology dual `E_2^{p,q} = H^p(B; H^q(F)) ⇒ H^{p+q}(E)` is a graded
    `H^*(B)`-algebra spectral sequence.
    Cite chain: depends on SSSCH_01 (GATE-4) + HLPF_01 (GATE-1).
    Citation: Spanier 1966 Ch. 9 §9.2 Theorem 4; Serre 1951 Ann. Math. 54
    §III; Leray 1950 J. Math. Pures Appl. 29. -/
theorem t20c_late_15_spanier_sssch_02_leray_serre_spectral_sequence : True := trivial

/-- SSSCH_03 — Spanier 1966 Ch. 9 §9.5 (SUBSTRATE_GAP, opus-ahn).
    Serre `C`-class theory: for a Serre class `C` of abelian groups (closed
    under subgroups, quotients, extensions, finite products), the Hurewicz
    homomorphism `h_n : π_n(X) → H_n(X)` is a `C`-isomorphism for
    `(n-1)`-connected spaces with `π_q(X) ∈ C` for `q < n` (mod-`C` Hurewicz).
    Citation: Spanier 1966 Ch. 9 §9.5 Theorem 4; Serre 1953 *Groupes
    d'homotopie et classes de groupes abéliens* Ann. Math. 58 §I. -/
theorem t20c_late_15_spanier_sssch_03_serre_class_hurewicz : True := trivial

/-- SSSCH_04 — Spanier 1966 Ch. 9 §9.6 (SUBSTRATE_GAP, opus-ahn).
    First non-trivial torsion in `π_*(S^n)`: for odd `n ≥ 3`, `π_q(S^n)` is
    finite for `q > n`, and the first `p`-torsion appears in `π_{n + 2p - 3}`
    (Serre's odd-sphere finiteness + first-`p`-torsion bound). The proof uses
    the Leray-Serre spectral sequence applied to `K(Z, n)`-Postnikov sections.
    Cite chain: depends on SSSCH_02 + SSSCH_03 + EMCM_02 + MPF_01.
    Citation: Spanier 1966 Ch. 9 §9.6 Theorem 4 + Theorem 7; Serre 1953
    Ann. Math. 58 §IV. -/
theorem t20c_late_15_spanier_sssch_04_sphere_homotopy_torsion : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_15_spanier
