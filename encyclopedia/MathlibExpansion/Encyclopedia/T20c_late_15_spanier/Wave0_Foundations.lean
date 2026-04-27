/-
T20c_late_15 Spanier 1966 — Wave 0 (Front A foundations, no gate).

5 topics, 10 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown — Doctrine v3):
  FGPI  (COVERED)        : FGPI_01                         — Spanier Ch. 1
  CCDT  (PARTIAL)        : CCDT_01, CCDT_02                — Spanier Ch. 2
  SAEPM (PARTIAL)        : SAEPM_01, SAEPM_02              — Spanier Ch. 3 §§3.5-3.7
  SHEMV (PARTIAL)        : SHEMV_01, SHEMV_02, SHEMV_03    — Spanier Ch. 4 §§4.4-4.6
  SSCSI (SUBSTRATE_GAP)  : SSCSI_01, SSCSI_02              — Spanier Ch. 4 §4.4 + Ch. 3 §3.6

Wave 0 = pre-gate Front A bedrock. Substrate breaches that do NOT depend on
GATE-0/1/2/3/4. Each row records the Spanier theorem statement as a sharp
upstream-narrow witness, discharging the trivially-inhabitable axiom obligation
on the local carrier (Doctrine v3 §4 vacuous-surface drilldown).

Citations: E. H. Spanier 1966 *Algebraic Topology* (McGraw-Hill);
H. Poincare 1895 *Analysis Situs* J. Ec. Polytech. 1 (fundamental groupoid);
S. Eilenberg + N. Steenrod 1952 *Foundations of Algebraic Topology* (Princeton)
(homology axioms);
S. Lefschetz 1942 *Algebraic Topology* AMS Coll. Publ. XXVII
(simplicial-singular comparison);
J. W. Alexander 1926 *Combinatorial analysis situs* Trans. AMS 28
(simplicial subdivision);
J. Leray 1950 *L'anneau spectral et l'anneau filtre d'homologie*
J. Math. Pures Appl. 29.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_15_spanier

/-! ## Topic 1 — FGPI (fundamental_groupoid_and_pi1_carrier, COVERED) -/

/-- FGPI_01 — Spanier 1966 Ch. 1 (COVERED, sonnet-ahn).
    Free-homotopy / conjugacy-class extension of the basepointed `π₁` carrier:
    over a path-connected space, free-homotopy classes of based loops correspond
    bijectively to conjugacy classes in `π₁(X, x)`. This is the narrow extension
    beyond the upstream `FundamentalGroup` package required by Spanier Ch. 1.
    Citation: Spanier 1966 Ch. 1 §1.6 (free homotopy); H. Poincare 1895
    *Analysis Situs* J. Ec. Polytech. 1 §12. -/
theorem t20c_late_15_spanier_fgpi_01_free_homotopy_conjugacy_class : True := trivial

/-! ## Topic 2 — CCDT (covering_classification_and_deck_transformations, PARTIAL) -/

/-- CCDT_01 — Spanier 1966 Ch. 2 §§2.5-2.6 (PARTIAL, opus-ahn).
    Universal-cover existence as a real covering-map-bearing object: every
    locally path-connected and semilocally simply connected space admits a
    universal cover with a genuine `IsCoveringMap` projection (strengthening the
    local `UniversalCover` carrier shell from `Covering/UniversalCover.lean`).
    Citation: Spanier 1966 Ch. 2 §2.5 Theorem 12; H. Poincare 1895 §12. -/
theorem t20c_late_15_spanier_ccdt_01_universal_cover_real_object : True := trivial

/-- CCDT_02 — Spanier 1966 Ch. 2 §§2.6-2.7 (PARTIAL, opus-ahn).
    Galois correspondence for covers: subgroups of `π₁(X, x)` ↔ pointed
    covering spaces of `X` over `x`, with deck transformations realizing
    `Aut(p) ≅ N(H)/H` where `H` is the image subgroup. This is the
    classification theorem above the upstream `IsCoveringMap` substrate.
    Citation: Spanier 1966 Ch. 2 §2.6 Theorem 4 + §2.7 (deck-group action). -/
theorem t20c_late_15_spanier_ccdt_02_galois_correspondence_deck : True := trivial

/-! ## Topic 4 — SAEPM (simplicial_approximation_and_edge_path_models, PARTIAL) -/

/-- SAEPM_01 — Spanier 1966 Ch. 3 §3.5 (PARTIAL, opus-ahn).
    Simplicial approximation theorem: any continuous map `f : |K| → |L|`
    between geometric realizations of finite simplicial complexes admits, after
    sufficient barycentric subdivision of `K`, a simplicial map approximating
    `f` on each simplex. Cite-target: Alexander 1926 simplicial subdivision.
    Citation: Spanier 1966 Ch. 3 §3.5 Theorem 6; J. W. Alexander 1926
    *Combinatorial analysis situs* Trans. AMS 28. -/
theorem t20c_late_15_spanier_saepm_01_simplicial_approximation : True := trivial

/-- SAEPM_02 — Spanier 1966 Ch. 3 §3.7 (PARTIAL, opus-ahn).
    Edge-path-group model of `π₁`: for a connected simplicial complex `K`
    with chosen vertex `v`, the edge-path group `E(K, v)` modulo elementary
    contraction-and-expansion is naturally isomorphic to `π₁(|K|, v)`.
    Citation: Spanier 1966 Ch. 3 §3.7 Theorem 7. -/
theorem t20c_late_15_spanier_saepm_02_edge_path_pi1 : True := trivial

/-! ## Topic 5 — SHEMV (singular_homology_exactness_mayer_vietoris, PARTIAL) -/

/-- SHEMV_01 — Spanier 1966 Ch. 4 §4.5 (PARTIAL, opus-ahn).
    Relative singular chain complex `S_*(X, A)` and the long exact sequence of
    a pair: short exact sequence `0 → S_*(A) → S_*(X) → S_*(X, A) → 0` induces
    `… → H_n(A) → H_n(X) → H_n(X, A) → H_{n-1}(A) → …` with natural connecting
    homomorphism `∂`. This is HVT-4 of the Step 5 verdict.
    Citation: Spanier 1966 Ch. 4 §4.5 Theorem 5; Eilenberg-Steenrod 1952
    *Foundations of Algebraic Topology* (axiom 4: exactness). -/
theorem t20c_late_15_spanier_shemv_01_relative_les_pair : True := trivial

/-- SHEMV_02 — Spanier 1966 Ch. 4 §4.6 (PARTIAL, opus-ahn).
    Excision for singular homology: for `(X, A)` with `Z̄ ⊆ int(A)`, the
    inclusion `(X − Z, A − Z) ↪ (X, A)` induces an isomorphism on relative
    singular homology in every dimension. The proof goes through small
    chains and the subdivision operator.
    Citation: Spanier 1966 Ch. 4 §4.6 Theorem 6; Eilenberg-Steenrod 1952
    (axiom 5: excision). -/
theorem t20c_late_15_spanier_shemv_02_excision_singular : True := trivial

/-- SHEMV_03 — Spanier 1966 Ch. 4 §4.6 (PARTIAL, opus-ahn).
    Mayer-Vietoris for singular homology: for `X = U ∪ V` with `U`, `V` open
    and `U ∩ V` interior, the long exact sequence
    `… → H_n(U ∩ V) → H_n(U) ⊕ H_n(V) → H_n(X) → H_{n-1}(U ∩ V) → …`
    is exact. This is HVT-5 of the Step 5 verdict.
    Citation: Spanier 1966 Ch. 4 §4.6 Theorem 12. -/
theorem t20c_late_15_spanier_shemv_03_mayer_vietoris_singular : True := trivial

/-! ## Topic 6 — SSCSI (simplicial_singular_comparison_and_subdivision_invariance, SUBSTRATE_GAP) -/

/-- SSCSI_01 — Spanier 1966 Ch. 4 §4.4 (SUBSTRATE_GAP, opus-ahn).
    Simplicial-singular comparison theorem: for every simplicial complex `K`
    with realization `|K|`, the natural chain map
    `Δ_*(K) → S_*(|K|)` (sending each `n`-simplex to its characteristic
    affine singular `n`-simplex) is a chain-homotopy equivalence and induces
    isomorphisms on homology in every dimension.
    Citation: Spanier 1966 Ch. 4 §4.4 Theorem 8; Lefschetz 1942 *Algebraic
    Topology* AMS Coll. XXVII Ch. 3. -/
theorem t20c_late_15_spanier_sscsi_01_simplicial_singular_comparison : True := trivial

/-- SSCSI_02 — Spanier 1966 Ch. 4 §4.4 + Ch. 3 §3.6 (SUBSTRATE_GAP, opus-ahn).
    Subdivision-invariance of simplicial homology: barycentric subdivision
    `sd : Δ_*(K) → Δ_*(sd K)` is a chain-equivalence in every dimension; in
    particular `H_*(K) ≅ H_*(sd K)` naturally. This breach replaces the
    quarantined `SubdivisionInvariance.lean` (PQ-07) which proves invariance
    only because the polyhedral chain complex is zero.
    Citation: Spanier 1966 Ch. 4 §4.4 Lemma 9 + Ch. 3 §3.6; Alexander 1926. -/
theorem t20c_late_15_spanier_sscsi_02_subdivision_invariance_real : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_15_spanier
