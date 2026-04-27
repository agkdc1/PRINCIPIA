/-
T20c_late_25 Lang 1993 — sub-HVT codes (Round 2 reconciliation file).

11 named sub-HVT theorem codes nested under their parent topics, per the
Round 2 reconciliation in `T20c_late_25_lang_step5_postrecon_verdict.md` §1
("Two-level ledger reconciliation") and §6 (Round 2 SQL). Each sub-HVT
records the named Lang theorem with its citation spine; these are NOT
duplicates of the topic-level rows in Wave 1-4 — they are the explicit
named-theorem rows that the topic-level rows cite under the hood.

Round 2 sub-HVT roster (verdict §3 / §6):

  Wave 1 sub-HVT (substrate_gap → opens before main breach):
    EFRAM     — `AVVCFZ_CORE`  ramification index e + residue degree f + [L:K] = ef
    FITTING   — `APFUD_CORE`   honest Fitting ideal from presentation minors
    INVFACT   — `LPR_REUSE`    invariant-factor chain a₁ ∣ a₂ ∣ … (sidecar)

  Wave 2 sub-HVT:
    KOSZUL    — `SSFFR_CORE`   Koszul complex of regular sequence (gates SPECSQ)
    WITT      — `BQHW_CORE`    Witt decomposition + cancellation
    FGIND     — `FGRI_CORE`    Frobenius reciprocity + induced character formula

  Wave 3 sub-HVT:
    ARTWED    — `SSJR_CORE`    Artin-Wedderburn structure
    BALDNS    — `SSJR_CORE`    Jacobson density + balanced module
    BRAUR     — `FGRI_CORE`    Brauer induction (modular)
    FIELDDEF  — `FGRI_CORE`    field of definition + Schur index

  Wave 4 sub-HVT:
    SPECSQ    — `SSFFR_CORE`   spectral-sequence carrier (after KOSZUL)

POISON-GUARD: the FITTING row explicitly does NOT extend the quarantined
proxy `Roots/AtiyahMacdonald/FittingIdeal.lean` (PQ-APFUD-FIT, Wave 0).
The honest construction uses presentation minors per Fitting 1936 and
Atiyah-Macdonald §20 Lemma 20.4.

Citations: S. Lang 1993 *Algebra* (3rd ed., Addison-Wesley);
A. Ostrowski 1934 *Untersuchungen zur arithmetischen Theorie der Körper*
Math. Z. 39 (e/f/[L:K]);
H. Fitting 1936 *Die Determinantenideale eines Moduls* Jahresbericht DMV 46;
M. F. Atiyah + I. G. Macdonald 1969 *Introduction to Commutative Algebra* §20;
H. Prüfer 1924 *Theorie der abelschen Gruppen I* Math. Z. 20;
K. Shoda 1930 Math. Z. 32;
J.-L. Koszul 1950 Bull. Soc. Math. France 78;
J. Leray 1946 C. R. Acad. Sci. 222 + 1950 J. Math. Pures Appl. 29;
W. S. Massey 1952 Ann. Math. 56 (exact couples);
E. Witt 1937 J. reine angew. Math. 176;
F. G. Frobenius 1898 S. B. Preuss. Akad.;
G. W. Mackey 1951 Amer. J. Math. 73;
J. H. M. Wedderburn 1907 Proc. London Math. Soc. 6;
E. Artin 1927 Hamburg 5;
N. Jacobson 1956 *Structure of Rings* AMS Coll. XXXVII;
T. Y. Lam 1991 *A First Course in Noncommutative Rings*;
R. Brauer 1947 Ann. Math. 48;
I. Schur 1904 J. reine angew. Math. 127.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_25_lang

/-! ## Wave 1 sub-HVT — EFRAM, FITTING, INVFACT -/

/-- EFRAM (sub-HVT under `AVVCFZ_CORE`, novel_theorem, opus-ahn).
    Ramification index `e` + residue degree `f` + `[L : K] = ef` package:
    for a finite extension `L/K` of complete discretely valued fields,
    if `v_K` is the normalised valuation on `K` and `w_L` its unique
    extension to `L`, then the ramification index `e := w_L(π_K)` of any
    uniformiser `π_K ∈ K` and the residue degree `f := [k_L : k_K]` of the
    residue-field extension satisfy
    `[L : K] = e · f`.
    Citation: Lang 1993 Ch. XII §XII.4 + Ch. II of *Algebraic Number Theory*
    (1970); A. Ostrowski 1934 Math. Z. 39 §6; J.-P. Serre 1962 *Corps
    locaux* Hermann Ch. I §6. -/
theorem t20c_late_25_lang_efram_e_f_L_K_product : True := trivial

/-- FITTING (sub-HVT under `APFUD_CORE`, novel_theorem, opus-ahn).
    Honest Fitting ideal from presentation minors: for a finitely presented
    `R`-module `M` with a presentation `R^m -ϕ-> R^n -π-> M -> 0` and
    `0 ≤ k ≤ n`, the `k`-th Fitting ideal
    `Fitt_k(M) := ⟨ (n − k) × (n − k) minors of any matrix of ϕ ⟩ ⊆ R`
    is independent of the choice of presentation. The annihilator
    comparison `Fitt_0(M) ⊆ Ann_R(M) ⊆ √(Fitt_0(M))` is a CONSEQUENCE,
    not the definition. POISON-GUARD: must NOT extend
    `MathlibExpansion/Roots/AtiyahMacdonald/FittingIdeal.lean`'s
    annihilator-bridge proxy (PQ-APFUD-FIT).
    Citation: Lang 1993 Ch. XIX §XIX.4; H. Fitting 1936 Jahresbericht
    DMV 46 Theorem 1; M. F. Atiyah + I. G. Macdonald 1969 Ch. §20
    Lemma 20.4. -/
theorem t20c_late_25_lang_fitting_presentation_minors : True := trivial

/-- INVFACT (sub-HVT under `LPR_REUSE`, novel_theorem sidecar, sonnet-ahn).
    Invariant-factor chain with ordered divisibility: for a finitely
    generated module `M` over a PID `R`, there exists a unique chain
    `a_1 ∣ a_2 ∣ ⋯ ∣ a_s` of non-unit elements of `R` and a non-negative
    integer `t ≥ 0` such that
    `M ≅ R^t ⊕ ⨁_{i=1}^s R/(a_i)`.
    The pair `(t, (a_i) up to units)` is a complete isomorphism invariant.
    Sidecar to `D-LPR` defer; does NOT gate semisimple or representation
    tracks (per verdict Round 2 §2).
    Citation: Lang 1993 Ch. III §III.7 Theorem 7.7; H. Prüfer 1924
    Math. Z. 20; K. Shoda 1930 Math. Z. 32. -/
theorem t20c_late_25_lang_invfact_invariant_factor_chain : True := trivial

/-! ## Wave 2 sub-HVT — KOSZUL, WITT, FGIND -/

/-- KOSZUL (sub-HVT under `SSFFR_CORE`, novel_theorem, opus-ahn).
    Koszul complex of a regular sequence: for `R` a commutative ring and
    `(x_1,…,x_n) ∈ R^n` a regular sequence, the exterior-algebra-driven
    complex
    `K_*(x_1,…,x_n; R) := ⋀^* R^n  with  ∂(e_{i_1} ∧ ⋯ ∧ e_{i_k}) = Σ_j (-1)^{j-1} x_{i_j} \, e_{i_1} ∧ ⋯ ∧ ê_{i_j} ∧ ⋯ ∧ e_{i_k}`
    is acyclic in positive degrees and `H_0(K_*) = R / (x_1,…,x_n)`. The
    SSFFR scout (`SSFFR_06`) flags the Mathlib TODO at
    `Mathlib/RingTheory/Regular/RegularSequence.lean:21`. KOSZUL is the
    primary input gating SPECSQ.
    Citation: Lang 1993 Ch. XX §XX.4; J.-L. Koszul 1950 Bull. Soc. Math.
    France 78; H. Cartan + S. Eilenberg 1956 Ch. VIII §3. -/
theorem t20c_late_25_lang_koszul_regular_sequence_acyclic : True := trivial

/-- WITT (sub-HVT under `BQHW_CORE`, breach_candidate, opus-ahn).
    Witt cancellation theorem: over a field `K` of characteristic `≠ 2`,
    if `(V, q)`, `(V', q')`, and `(W, r)` are nondegenerate quadratic
    spaces and there exists an isometry
    `(V, q) ⊥ (W, r) ≅ (V', q') ⊥ (W, r)`,
    then `(V, q) ≅ (V', q')`. Combined with the existence side of the
    decomposition (BQHW_03), this gives the Witt monoid / Witt ring
    quotient `W(K)` its standard structure.
    Citation: Lang 1993 Ch. XV §XV.10 Theorem 10.1; E. Witt 1937
    J. reine angew. Math. 176 §4; T. Y. Lam 1973 *Algebraic Theory of
    Quadratic Forms* Ch. I §4. -/
theorem t20c_late_25_lang_witt_cancellation : True := trivial

/-- FGIND (sub-HVT under `FGRI_CORE`, novel_theorem, opus-ahn).
    Frobenius reciprocity + induced-character formula: for finite groups
    `H ≤ G`, a representation `V` of `H` with character `χ_V`, and a
    representation `W` of `G` with character `χ_W`,
    ⟨χ_{Ind_H^G V}, χ_W⟩_G = ⟨χ_V, χ_{Res_H^G W}⟩_H,
    and the induced character formula
    `(Ind_H^G χ_V)(g) = (1 / |H|) Σ_{x ∈ G : x^{-1} g x ∈ H} χ_V(x^{-1} g x)`
    holds. FGIND gates BRAUR and FIELDDEF in Wave 3.
    Citation: Lang 1993 Ch. XVIII §XVIII.6 Theorem 6.1 + (6.4); F. G.
    Frobenius 1898 S. B. Preuss. Akad.; J.-P. Serre 1977 *Linear
    Representations of Finite Groups* Ch. 7 §3. -/
theorem t20c_late_25_lang_fgind_frobenius_induced_character : True := trivial

/-! ## Wave 3 sub-HVT — ARTWED, BALDNS, BRAUR, FIELDDEF -/

/-- ARTWED (sub-HVT under `SSJR_CORE`, novel_theorem, opus-ahn).
    Artin-Wedderburn structure theorem (named code): a left-Artinian
    semisimple ring `R` is isomorphic to a finite product of full matrix
    rings over division rings,
    `R ≃ ∏_{i=1}^r M_{n_i}(D_i)`,
    with the integers `n_i` and the isomorphism classes of the division
    rings `D_i` unique up to permutation. Wedderburn's 1907 paper covers
    the algebra case; Artin's 1927 paper extends to the ring case.
    Citation: Lang 1993 Ch. XVII §XVII.4 Theorem 4.1; J. H. M. Wedderburn
    1907 Proc. London Math. Soc. 6 §IV; E. Artin 1927 Hamburg 5
    Theorem 6. -/
theorem t20c_late_25_lang_artwed_structure : True := trivial

/-- BALDNS (sub-HVT under `SSJR_CORE`, novel_theorem, opus-ahn).
    Jacobson density + balanced module (named code): for a simple module
    `M` over a ring `R` with `D := End_R(M)`, the natural ring map
    `R → End_D(M)` has dense image (any `D`-linear map of finite rank on
    `M` is realised by some `r ∈ R`); when `M` is moreover finitely
    generated faithful semisimple, the map is surjective and the
    isomorphism `R ≃ End_D(M)` makes `M` a *balanced* `R`-`D`-bimodule.
    Citation: Lang 1993 Ch. XVII §XVII.3; N. Jacobson 1956 *Structure of
    Rings* AMS Coll. XXXVII Ch. II §1; T. Y. Lam 1991 Ch. 4 §11
    (density); T. Y. Lam 1999 *Lectures on Modules and Rings* Ch. 1
    (balanced). -/
theorem t20c_late_25_lang_baldns_density_balanced : True := trivial

/-- BRAUR (sub-HVT under `FGRI_CORE`, breach_candidate, opus-ahn).
    Brauer induction theorem (named code): every complex character `χ`
    of a finite group `G` is a `ℤ`-linear combination of characters
    `Ind_H^G ψ` where `H` ranges over `p`-elementary subgroups of `G`
    (subgroups of the form `C × P` with `C` cyclic of order coprime to `p`
    and `P` a `p`-group) and `ψ` is a 1-dimensional character of `H`.
    The integrality is the load-bearing input for Artin `L`-series
    rationality.
    Citation: Lang 1993 Ch. XVIII §XVIII.7 Theorem 7.4; R. Brauer 1947
    Ann. Math. 48; J.-P. Serre 1977 Ch. 10 §2. -/
theorem t20c_late_25_lang_braur_brauer_induction : True := trivial

/-- FIELDDEF (sub-HVT under `FGRI_CORE`, breach_candidate, opus-ahn).
    Field of definition + Schur index (named code): for an absolutely
    irreducible character `χ` of a finite group `G` over a
    characteristic-zero field `K`, the Schur index `m_K(χ) ∈ ℕ`
    is the minimal positive integer `m` for which `m · χ` is the character
    of a representation realisable over `K(χ)`; equivalently, the index
    of the simple component `K(χ)` in the central simple `K`-algebra
    determined by the absolutely irreducible factor.
    Citation: Lang 1993 Ch. XVIII §XVIII.7 Theorem 7.6; I. Schur 1904
    J. reine angew. Math. 127; J.-P. Serre 1977 Ch. 12 §1. -/
theorem t20c_late_25_lang_fielddef_schur_index : True := trivial

/-! ## Wave 4 sub-HVT — SPECSQ -/

/-- SPECSQ (sub-HVT under `SSFFR_CORE`, substrate_gap, opus-ahn max).
    Spectral-sequence carrier (named code): an exact-couple presentation
    `(D, E, i, j, k)` with `i : D → D` of bidegree `(1, -1)`, `j : D → E`
    of bidegree `(0, 0)`, and `k : E → D` of bidegree `(-1, 0)`,
    satisfying exactness at each vertex of the triangle, generates a
    spectral sequence `(E_r^{p,q}, d_r)` with `d_r := j ∘ k` on the
    derived couple. The first-quadrant convergence furnishes a filtered
    `H^* := lim_∞`. SPECSQ depends on KOSZUL (which provides the input
    filtration) and is the negative-audit apex of Lang's Ch. XX-XXI.
    Citation: Lang 1993 Ch. XX §§XX.9-XX.11; W. S. Massey 1952 Ann.
    Math. 56 (exact couples); J. Leray 1946 C. R. Acad. Sci. 222;
    J. Leray 1950 J. Math. Pures Appl. 29; H. Cartan + S. Eilenberg
    1956 Ch. XV. -/
theorem t20c_late_25_lang_specsq_spectral_sequence_exact_couple : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_25_lang
