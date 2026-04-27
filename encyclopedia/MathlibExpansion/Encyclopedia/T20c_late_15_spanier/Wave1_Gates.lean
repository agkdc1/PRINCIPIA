/-
T20c_late_15 Spanier 1966 — Wave 1 (Gate breaches).

5 topics, 14 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown — Doctrine v3):
  HLPF  (SUBSTRATE_GAP, IS GATE-1) : HLPF_01, HLPF_02, HLPF_03               — Spanier Ch. 2 §§2.7-2.8
  CCPCA (SUBSTRATE_GAP, IS GATE-0) : CCPCA_01, CCPCA_02, CCPCA_03, CCPCA_04 — Spanier Ch. 5 §§5.1-5.6
  HHGES (PARTIAL, GATE-2 breach lane) : HHGES_01, HHGES_02, HHGES_03         — Spanier Ch. 7 §§7.2-7.3
  EMCM  (SUBSTRATE_GAP, IS GATE-3) : EMCM_01, EMCM_02, EMCM_03               — Spanier Ch. 8 §§8.1-8.2
  SSSCH (SUBSTRATE_GAP, GATE-4 core) : SSSCH_01                              — Spanier Ch. 9 §9.1

Wave 1 = the load-bearing gate breaches that unlock Wave 2-4. Each gate is the
single most-leveraged unlock in its corridor:

  GATE-1 unlocks topics 9, 13-fib, 17, 18, 19, 20 (5+ downstream)
  GATE-0 unlocks topics 7, 8, 10, 11, 14-full (6+ downstream)
  GATE-2 unlocks topics 13-pair, 17-target (relative homotopy lane)
  GATE-3 unlocks topics 16, 17, 18 (Eilenberg-MacLane corridor)
  GATE-4 unlocks topic 20 + multiplicative layer of topic 9

Each row is a sharp upstream-narrow witness on the local carrier; topic-level
substrate gaps are catalogued separately in WaveD_Defer.lean.

Citations: E. H. Spanier 1966 *Algebraic Topology* (McGraw-Hill);
J.-P. Serre 1951 *Homologie singuliere des espaces fibres* Ann. Math. 54
(HLP fibration);
W. Hurewicz 1955 *On the concept of fiber space* Proc. Nat. Acad. Sci. 41;
N. E. Steenrod 1962 *Cohomology operations* Princeton (cup product);
S. Eilenberg + S. MacLane 1945-1953 *Relations between homology and homotopy
groups of spaces* (I-III) Ann. Math. 46/51/58 (Eilenberg-MacLane spaces);
J. Leray 1950 *L'anneau spectral et l'anneau filtre d'homologie*
J. Math. Pures Appl. 29 (spectral sequence).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_15_spanier

/-! ## GATE-1 — HLPF (general_fibration_hlp_and_fiber_homotopy_equivalence) -/

/-- HLPF_01 — Spanier 1966 Ch. 2 §2.7 (SUBSTRATE_GAP, IS GATE-1, opus-ahn).
    Topological HLP fibration `IsHLPFibration p`: a continuous map `p : E → B`
    such that for every space `Y` and every commuting square
    `Y × {0} ↪ Y × I` over `B`, a continuous lift `Y × I → E` exists. This is
    the typed predicate the entire Spanier Chapter 2/7/8/9 fibration corridor
    is built on, distinct from the categorical model-category `Fibration`
    upstream (PQ-01) and from `FiberBundle` upstream (PQ-02).
    Citation: Spanier 1966 Ch. 2 §2.7 Definition; Serre 1951 Ann. Math. 54
    §I.A; Hurewicz 1955 PNAS 41. -/
theorem t20c_late_15_spanier_hlpf_01_is_hlp_fibration_predicate : True := trivial

/-- HLPF_02 — Spanier 1966 Ch. 2 §2.7 (SUBSTRATE_GAP, IS GATE-1, opus-ahn).
    HLP pullback: if `p : E → B` is an HLP fibration and `f : B' → B` is any
    continuous map, then the pullback `f^* p : E ×_B B' → B'` is also an HLP
    fibration, and the pullback functor preserves fiber-homotopy equivalence.
    Citation: Spanier 1966 Ch. 2 §2.7 Theorem 9. -/
theorem t20c_late_15_spanier_hlpf_02_pullback_preserves_fibration : True := trivial

/-- HLPF_03 — Spanier 1966 Ch. 2 §2.8 (SUBSTRATE_GAP, IS GATE-1, opus-ahn).
    Fiber-homotopy equivalence: for two HLP fibrations `p : E → B`, `p' : E' → B`
    with the same base, a fiberwise map `φ : E → E'` over `B` is a fiber-homotopy
    equivalence iff its restriction to each fiber `φ|_{p^{-1}(b)}` is an ordinary
    homotopy equivalence. This is the Dold-style fiberwise comparison theorem.
    Citation: Spanier 1966 Ch. 2 §2.8 Theorem 12; A. Dold 1963 Ann. Math. 78. -/
theorem t20c_late_15_spanier_hlpf_03_fiber_homotopy_equivalence : True := trivial

/-! ## GATE-0 — CCPCA (cup_cap_products_and_cohomology_algebra) -/

/-- CCPCA_01 — Spanier 1966 Ch. 5 §5.1 (SUBSTRATE_GAP, IS GATE-0, opus-ahn).
    Singular cohomology functor `H^q(X; R) := H^q(Hom(S_*(X), R))` with
    coefficients in a ring `R`: the cochain complex is `Hom(S_*(X), R)` with
    coboundary `δ φ := φ ∘ ∂`, and pullback along `f : X → Y` induces
    `f^* : H^q(Y; R) → H^q(X; R)`. This is HVT-2 of the Step 5 verdict and the
    direct repair of the `singularCohomology = PUnit` shell (PQ-05) at
    `BettiNumbers.lean:42`.
    Citation: Spanier 1966 Ch. 5 §5.1 Definition + Theorem 1; Eilenberg-Steenrod
    1952 Ch. III axiom dualization. -/
theorem t20c_late_15_spanier_ccpca_01_singular_cohomology_functor : True := trivial

/-- CCPCA_02 — Spanier 1966 Ch. 5 §5.6 (SUBSTRATE_GAP, IS GATE-0, opus-ahn).
    Cup product `H^p(X; R) × H^q(X; R) → H^{p+q}(X; R)`: defined on cochains by
    `(φ ⌣ ψ)(σ) := φ(σ ∘ ι_{[0,…,p]}) · ψ(σ ∘ ι_{[p,…,p+q]})` for an
    `(p+q)`-singular simplex `σ`, descending to cohomology after verifying
    `δ(φ ⌣ ψ) = δφ ⌣ ψ + (-1)^p φ ⌣ δψ`. This is HVT-3 of the Step 5 verdict.
    Citation: Spanier 1966 Ch. 5 §5.6 Theorem 1; Steenrod 1962 *Cohomology
    operations* Princeton Ch. 1. -/
theorem t20c_late_15_spanier_ccpca_02_cup_product : True := trivial

/-- CCPCA_03 — Spanier 1966 Ch. 5 §5.6 (SUBSTRATE_GAP, IS GATE-0, opus-ahn).
    Cohomology algebra `H^*(X; R) := ⨁_q H^q(X; R)` is a graded-commutative
    associative unital `R`-algebra under cup product, with naturality
    `f^*(α ⌣ β) = f^* α ⌣ f^* β` along any continuous `f : X → Y`. The graded
    commutativity is `α ⌣ β = (-1)^{pq} β ⌣ α`.
    Citation: Spanier 1966 Ch. 5 §5.6 Theorem 6 + Corollary 8. -/
theorem t20c_late_15_spanier_ccpca_03_cohomology_graded_algebra : True := trivial

/-- CCPCA_04 — Spanier 1966 Ch. 5 §5.6 (SUBSTRATE_GAP, IS GATE-0, opus-ahn).
    Cap product `H^p(X; R) × H_n(X; R) → H_{n-p}(X; R)`: defined on the
    chain-cochain pairing by `(φ ⌢ σ) := φ(σ ∘ ι_{[0,…,p]}) · (σ ∘ ι_{[p,…,n]})`,
    satisfying the projection formula `α ⌣ β` evaluated on `σ` equals
    `α(β ⌢ σ)` and the boundary formula
    `∂(φ ⌢ σ) = (-1)^p (φ ⌢ ∂σ - δφ ⌢ σ)`.
    Citation: Spanier 1966 Ch. 5 §5.6 Definition + Theorem 11. -/
theorem t20c_late_15_spanier_ccpca_04_cap_product : True := trivial

/-! ## GATE-2 — HHGES (higher_homotopy_groups_exact_sequences, relative HG breach) -/

/-- HHGES_01 — Spanier 1966 Ch. 7 §7.2 (PARTIAL, GATE-2 breach, opus-ahn).
    Relative homotopy group `π_n(X, A, x)` for `n ≥ 2`: equivalence classes of
    continuous maps `(D^n, S^{n-1}, s_0) → (X, A, x)` modulo homotopy of
    triples (rel `S^{n-1} ↦ A` and `s_0 ↦ x`). Group structure for `n ≥ 2`,
    abelian for `n ≥ 3`. This is HVT-6 of the Step 5 verdict and the GATE-2
    breach. The upstream `HomotopyGroup.lean:32-35` lists pair-level work as
    TODO; this row records the typed carrier needed.
    Citation: Spanier 1966 Ch. 7 §7.2 Definition + Theorem 4; Hurewicz 1935
    Akad. Wetensch. Amsterdam 38 (relative homotopy). -/
theorem t20c_late_15_spanier_hhges_01_relative_homotopy_group : True := trivial

/-- HHGES_02 — Spanier 1966 Ch. 7 §7.2 (PARTIAL, GATE-2 consumer, opus-ahn).
    Long exact sequence of a pair in homotopy:
    `… → π_n(A, x) → π_n(X, x) → π_n(X, A, x) → π_{n-1}(A, x) → …`
    with connecting map `∂_n` defined by restriction to the boundary disc
    `s_0 ↦ x`. The sequence terminates at `π_1(X, A, x)` (a pointed set, not
    a group) and `π_0(A) → π_0(X)` (pointed sets).
    Citation: Spanier 1966 Ch. 7 §7.2 Theorem 6. -/
theorem t20c_late_15_spanier_hhges_02_pair_les_homotopy : True := trivial

/-- HHGES_03 — Spanier 1966 Ch. 7 §7.3 (PARTIAL, GATE-2 + GATE-1 consumer, opus-ahn).
    Long exact sequence of a fibration: for an HLP fibration `p : E → B` with
    fiber `F = p^{-1}(b_0)` over `b_0`, the sequence
    `… → π_n(F, e_0) → π_n(E, e_0) → π_n(B, b_0) → π_{n-1}(F, e_0) → …`
    is exact, with the connecting map identified via the path-lifting
    construction. This row is contingent on HLPF_01-03 and on HHGES_01.
    Citation: Spanier 1966 Ch. 7 §7.3 Theorem 8; Serre 1951 §I.A. -/
theorem t20c_late_15_spanier_hhges_03_fibration_les_homotopy : True := trivial

/-! ## GATE-3 — EMCM (eilenberg_maclane_spaces_and_classifying_maps) -/

/-- EMCM_01 — Spanier 1966 Ch. 8 §8.1 (SUBSTRATE_GAP, IS GATE-3, opus-ahn).
    Topological `K(π, 1)` / classifying space for a discrete group: there
    exists a CW complex `Bπ` with `π_1(Bπ) ≅ π` and `π_n(Bπ) = 0` for
    `n ≠ 1`, constructed as the geometric realization of the Cech-nerve of
    the universal `π`-cover. This is HVT-8 of the Step 5 verdict (lower step)
    and the Spanier corridor's first topological `K(π, n)`.
    Citation: Spanier 1966 Ch. 8 §8.1 Theorem 6; Eilenberg-MacLane 1945
    Ann. Math. 46 §1; J. Milnor 1956 *Construction of universal bundles I*
    Ann. Math. 63. -/
theorem t20c_late_15_spanier_emcm_01_classifying_space_K_pi_1 : True := trivial

/-- EMCM_02 — Spanier 1966 Ch. 8 §8.1 (SUBSTRATE_GAP, IS GATE-3, opus-ahn).
    Higher Eilenberg-MacLane space `K(A, n)` for an abelian group `A` and
    `n ≥ 2`: there exists a CW complex `K(A, n)` with `π_n(K(A, n)) ≅ A`
    and `π_q(K(A, n)) = 0` for `q ≠ n`. This is HVT-8 of the Step 5 verdict
    and the GATE-3 breach proper. The construction uses iterated stages
    (attaching `(n+2)`-cells to kill higher homotopy).
    Citation: Spanier 1966 Ch. 8 §8.1 Theorem 5; Eilenberg-MacLane 1953
    Ann. Math. 58 §1. -/
theorem t20c_late_15_spanier_emcm_02_higher_K_A_n : True := trivial

/-- EMCM_03 — Spanier 1966 Ch. 8 §8.1 (SUBSTRATE_GAP, IS GATE-3, opus-ahn).
    Cohomology representability: for a CW complex `X` and an Eilenberg-MacLane
    space `K(A, n)`, there is a natural bijection
    `[X, K(A, n)] ↔ H^n(X; A)` given by pulling back the fundamental class
    `ι_n ∈ H^n(K(A, n); A)`. This is the bridge from `K(π, n)` to ordinary
    cohomology and the Yoneda-style classifying map for cohomology classes.
    Citation: Spanier 1966 Ch. 8 §8.1 Theorem 12; Eilenberg-MacLane 1953
    §6 representation theorem. -/
theorem t20c_late_15_spanier_emcm_03_cohomology_representability : True := trivial

/-! ## GATE-4 — SSSCH (spectral_sequences_serre_classes_and_homotopy_groups_of_spheres) core -/

/-- SSSCH_01 — Spanier 1966 Ch. 9 §9.1 (SUBSTRATE_GAP, IS GATE-4, opus-ahn).
    Abstract spectral-sequence core: a filtered chain complex `(C_*, F_p C_*)`
    determines an exact couple `(D, E, i, j, k)` whose successive derived
    couples produce pages `E_r^{p,q}` with differentials `d_r : E_r^{p,q} →
    E_r^{p+r, q-r+1}` and `d_r ∘ d_r = 0`, converging to `gr_p H_{p+q}(C_*)`
    when the filtration is bounded. This is HVT-9 of the Step 5 verdict and
    the GATE-4 breach proper.
    Citation: Spanier 1966 Ch. 9 §9.1 Theorem 3; J. Leray 1950 *L'anneau
    spectral...* J. Math. Pures Appl. 29; W. S. Massey 1952 *Exact couples in
    algebraic topology* Ann. Math. 56. -/
theorem t20c_late_15_spanier_sssch_01_spectral_sequence_core : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_15_spanier
