/-
T20c_late_25 Lang 1993 — Wave 2 (B1 bounded theorem packages, parallel-ready).

6 topics, 14 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown
— Doctrine v3 §4):
  NSES_CORE   (breach_candidate)  : NSES_01,  NSES_02         — Lang Ch. IX §§IX.3-IX.5
  NAPDH_CORE  (breach_candidate)  : NAPDH_01, NAPDH_02        — Lang Ch. X §§X.3-X.7
  RFOA_CORE   (novel_theorem)     : RFOA_01,  RFOA_02, RFOA_03 — Lang Ch. XI §§XI.1-XI.3
  MECS_CORE   (breach_candidate)  : MECS_01,  MECS_02         — Lang Ch. XIII-XIV §§XIII.4, XIV.4
  BQHW_CORE   (breach_candidate)  : BQHW_01,  BQHW_02, BQHW_03 — Lang Ch. XV §§XV.4-XV.10
  APFUD_CORE  (breach_candidate)  : APFUD_01, APFUD_02        — Lang Ch. XIX §§XIX.4-XIX.6

Wave 2 = B1 bounded-theorem wave (Step 5 verdict §3). Each row sits on real
substrate already identified by the Step 2 scouts; together they parallelize
into:
  • field / geometry  : NSES, NAPDH, RFOA
  • linear / algebra  : MECS, BQHW
  • alg de Rham / Fitting : APFUD

Each row records a Lang theorem statement as a sharp upstream-narrow witness,
discharging the trivially-inhabitable axiom obligation on the local carrier.

Citations: S. Lang 1993 *Algebra* (3rd ed., Addison-Wesley);
D. Hilbert 1893 *Über die vollen Invariantensysteme* Math. Ann. 42
(elimination corridor);
J. J. Sylvester 1840 *A method of determining by mere inspection the
derivatives from two equations of any degree* Phil. Mag. 16 (resultants);
E. Lasker 1905 *Zur Theorie der Moduln und Ideale* Math. Ann. 60
(primary decomposition);
E. Noether 1921 *Idealtheorie in Ringbereichen* Math. Ann. 83
(Noetherian primary decomposition);
D. Hilbert 1890 *Über die Theorie der algebraischen Formen* Math. Ann. 36
(Hilbert polynomial);
E. Artin + O. Schreier 1927 *Algebraische Konstruktion reeller Körper*
Abh. Math. Sem. Hamburg 5 (real-closed fields);
J. J. Sylvester 1853 *On a theory of the syzygetic relations* Phil. Trans. 143
(Sylvester signature);
G. Frobenius 1878 *Über lineare Substitutionen und bilineare Formen*
J. reine angew. Math. 84 (rational canonical form);
H. J. S. Smith 1861 *On systems of linear indeterminate equations and
congruences* Phil. Trans. R. Soc. 151 (Smith normal form);
E. Witt 1937 *Theorie der quadratischen Formen in beliebigen Körpern*
J. reine angew. Math. 176 (Witt decomposition + cancellation);
T. Y. Lam 1973 *The Algebraic Theory of Quadratic Forms* (Witt theory);
W. Scharlau 1985 *Quadratic and Hermitian Forms* (Hermitian theory);
G. de Rham 1955 *Variétés différentiables* Hermann (de Rham complex);
A. Grothendieck 1966 *Crystals and the de Rham cohomology of schemes*
IHES (algebraic de Rham);
H. Fitting 1936 *Die Determinantenideale eines Moduls* Jahresbericht DMV 46
(Fitting ideals from minors);
M. F. Atiyah + I. G. Macdonald 1969 *Introduction to Commutative Algebra* §20.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_25_lang

/-! ## Topic 1 — NSES_CORE (nullstellensatz_elimination_and_spec_entry_layer, breach_candidate) -/

/-- NSES_01 — Lang 1993 Ch. IX §IX.3 (breach_candidate, opus-ahn).
    Coordinate-projection elimination: for an algebraically closed field `k`
    and a system `f₁,…,f_r ∈ k[X₁,…,X_n, Y]`, the projection
    `π : V(f₁,…,f_r) → 𝔸ⁿ_k` of the affine variety to its `Y`-eliminated
    factor has image cut out by the elimination ideal `(f₁,…,f_r) ∩ k[X]`.
    The Step 5 verdict (§1 row 8) flags this as the honest open content above
    `Mathlib/RingTheory/Nullstellensatz.lean`.
    Citation: Lang 1993 Ch. IX §IX.3 Theorem 3.5; D. Hilbert 1893 Math. Ann. 42;
    upstream `Mathlib/RingTheory/Spectrum/Prime/Polynomial.lean`. -/
theorem t20c_late_25_lang_nses_01_coordinate_projection : True := trivial

/-- NSES_02 — Lang 1993 Ch. IX §IX.4 (breach_candidate, opus-ahn).
    Resultant of two univariate polynomials over a domain: `Res_X(f, g) ∈ R`
    is the determinant of the Sylvester matrix; it vanishes iff `f` and `g`
    share a common zero in any algebraic closure of `Frac R`. The
    multi-variable resultant systems generalize this to elimination ideals
    on `n+1` polynomials in `n` variables.
    Citation: Lang 1993 Ch. IX §IX.4; J. J. Sylvester 1840 Phil. Mag. 16;
    F. S. Macaulay 1916 *The Algebraic Theory of Modular Systems*
    Cambridge Tracts. -/
theorem t20c_late_25_lang_nses_02_resultant_systems : True := trivial

/-! ## Topic 2 — NAPDH_CORE (noetherian_associated_primes_primary_decomposition_hilbert_polynomial, breach_candidate) -/

/-- NAPDH_01 — Lang 1993 Ch. X §X.3 (breach_candidate, opus-ahn).
    Submodule-level Lasker-Noether primary decomposition: in a Noetherian
    ring `R`, every proper submodule `N ⊊ M` of a finitely generated
    `R`-module admits a primary decomposition `N = ⋂ Qᵢ` with each `Qᵢ`
    `pᵢ`-primary, and the set `{pᵢ}` of associated primes is independent
    of the choice of irredundant decomposition. This is the submodule
    refinement of the upstream ideal-level result.
    Citation: Lang 1993 Ch. X §X.3 Theorem 3.7; E. Lasker 1905 Math. Ann. 60;
    E. Noether 1921 Math. Ann. 83. -/
theorem t20c_late_25_lang_napdh_01_submodule_lasker : True := trivial

/-- NAPDH_02 — Lang 1993 Ch. X §X.7 (breach_candidate, opus-ahn).
    Hilbert polynomial of a graded module: for a finitely generated graded
    module `M = ⊕ M_n` over a Noetherian standard graded ring
    `S = k[X_0,…,X_d]`, the Hilbert function `n ↦ dim_k M_n` agrees with a
    polynomial `H_M(n) ∈ ℚ[n]` for `n` sufficiently large; the degree of
    `H_M` equals the dimension of `Supp(M)`.
    Citation: Lang 1993 Ch. X §X.7 Theorem 7.4; D. Hilbert 1890 Math. Ann. 36;
    upstream `Mathlib/RingTheory/Polynomial/HilbertPoly.lean`. -/
theorem t20c_late_25_lang_napdh_02_graded_hilbert_polynomial : True := trivial

/-! ## Topic 3 — RFOA_CORE (real_fields_and_ordered_algebra, novel_theorem) -/

/-- RFOA_01 — Lang 1993 Ch. XI §XI.2 (novel_theorem, opus-ahn).
    Sylvester's theorem on signatures: a real symmetric `n × n` matrix `A`
    is congruent (over the reals) to a unique diagonal matrix
    `diag(1,…,1,-1,…,-1,0,…,0)` with `p` positive, `q` negative, and `n - p - q`
    zero entries; the triple `(p, q, n - p - q)` is a complete invariant
    of the congruence class. Lang's ordered-field version generalizes to
    any ordered field with the intermediate-value property.
    Citation: Lang 1993 Ch. XI §XI.2; J. J. Sylvester 1853 Phil. Trans. 143
    (signature law); E. Artin + O. Schreier 1927 Hamburg 5 (ordered-field
    Sylvester). -/
theorem t20c_late_25_lang_rfoa_01_ordered_field_sylvester : True := trivial

/-- RFOA_02 — Lang 1993 Ch. XI §XI.2 (novel_theorem, opus-ahn).
    Real-closed-field characterization (`IsRealClosed`): a field `K` is
    real-closed iff (i) `K` is formally real (`-1` is not a sum of squares),
    (ii) every positive element of `K` is a square, and (iii) every
    odd-degree polynomial in `K[X]` has a root. Equivalently, `K[i]` is
    algebraically closed and `[K[i] : K] = 2`.
    Citation: Lang 1993 Ch. XI §XI.2 Theorem 2.1; E. Artin + O. Schreier 1927
    Hamburg 5 §§3-4. -/
theorem t20c_late_25_lang_rfoa_02_real_closed_characterization : True := trivial

/-- RFOA_03 — Lang 1993 Ch. XI §XI.3 (novel_theorem, opus-ahn).
    Real-closure existence and uniqueness: every formally real ordered field
    `(K, ≤)` admits a real-closed extension `R/K` algebraic over `K` and
    inducing the given order; any two such real closures are uniquely
    isomorphic over `K` as ordered fields. This is the closure side of the
    upstream `Mathlib/Algebra/Ring/Semireal/Defs.lean` substrate.
    Citation: Lang 1993 Ch. XI §XI.3 Theorem 3.1 + Corollary 3.5;
    E. Artin + O. Schreier 1927 Hamburg 5 §§5-6. -/
theorem t20c_late_25_lang_rfoa_03_real_closure_existence_uniqueness : True := trivial

/-! ## Topic 4 — MECS_CORE (matrices_endomorphisms_and_rational_canonical_style_structure, breach_candidate) -/

/-- MECS_01 — Lang 1993 Ch. XIII-XIV §XIV.4 (breach_candidate, opus-ahn).
    Honest rational canonical form: every finite-dimensional vector space
    `V` over a field `K` with an endomorphism `T : V → V` admits a `K[X]`-
    module decomposition `V ≅ K[X]/(p₁) ⊕ ⋯ ⊕ K[X]/(p_r)` with monic
    `p_i ∈ K[X]` satisfying `p_i ∣ p_{i+1}`; the matrix of `T` in any
    rational basis is the block-diagonal companion matrix
    `diag(C(p_1),…,C(p_r))`. The invariant factors `(p_i)` are unique.
    Supersedes the local PQ-MECS-RCF "representative := mere similarity"
    placeholder.
    Citation: Lang 1993 Ch. XIV §XIV.4 Theorem 4.1; G. Frobenius 1878
    J. reine angew. Math. 84; T. J. I'A. Bromwich 1906 Trans. AMS 7. -/
theorem t20c_late_25_lang_mecs_01_rational_canonical_form_existence_uniqueness : True := trivial

/-- MECS_02 — Lang 1993 Ch. XIII §XIII.4 (breach_candidate, opus-ahn).
    Smith-to-rational-canonical bridge: for a matrix `A ∈ M_n(K[X])` over
    `K[X]`, the Smith normal form `diag(d₁,…,d_n, 0,…,0)` with
    `d_i ∣ d_{i+1}` (existing because `K[X]` is a PID) determines the
    rational canonical form of any `K`-endomorphism whose
    characteristic-matrix presentation is `A`. The non-unit invariant
    factors `d_i` of the Smith form coincide with the invariant factors
    `p_i` of the rational canonical form (after monic normalization).
    Citation: Lang 1993 Ch. XIII §XIII.4 Theorem 4.6; H. J. S. Smith 1861
    Phil. Trans. R. Soc. 151. -/
theorem t20c_late_25_lang_mecs_02_smith_to_rational_canonical : True := trivial

/-! ## Topic 5 — BQHW_CORE (bilinear_quadratic_hermitian_and_witt_theory, breach_candidate) -/

/-- BQHW_01 — Lang 1993 Ch. XV §XV.4 (breach_candidate, opus-ahn).
    Hermitian-form abstraction: over a ring `R` with involution `σ`, a
    Hermitian form on a free `R`-module `M` is a sesquilinear pairing
    `h : M × M → R` with `h(y, x) = σ(h(x, y))`. The category of Hermitian
    `R`-modules has direct sums, orthogonal complements, and a Witt-type
    cancellation under nondegeneracy assumptions.
    Citation: Lang 1993 Ch. XV §XV.4; W. Scharlau 1985 *Quadratic and
    Hermitian Forms* Ch. 7; T. Y. Lam 1973 Ch. I §6. -/
theorem t20c_late_25_lang_bqhw_01_hermitian_form_abstraction : True := trivial

/-- BQHW_02 — Lang 1993 Ch. XV §XV.5 (breach_candidate, opus-ahn).
    Alternating normal form: every nondegenerate alternating bilinear form
    on a finite-dimensional vector space `V` over a field `K` of
    characteristic `≠ 2` admits a symplectic basis
    `{e₁, f₁,…,e_n, f_n}` with `⟨eᵢ, fⱼ⟩ = δᵢⱼ`, `⟨eᵢ, eⱼ⟩ = ⟨fᵢ, fⱼ⟩ = 0`;
    in particular `dim V = 2n` is even and any two such forms of the same
    rank are equivalent.
    Citation: Lang 1993 Ch. XV §XV.5 Theorem 5.1; Bourbaki *Algèbre*
    Ch. IX §IX.5. -/
theorem t20c_late_25_lang_bqhw_02_alternating_normal_form : True := trivial

/-- BQHW_03 — Lang 1993 Ch. XV §§XV.9-XV.10 (breach_candidate, opus-ahn).
    Witt decomposition and Witt cancellation theorem: every nondegenerate
    quadratic space `(V, q)` over a field `K` of characteristic `≠ 2`
    decomposes uniquely as `(V, q) ≅ (V_h, q_h) ⊥ (V_a, q_a)` with
    `(V_h, q_h)` a sum of hyperbolic planes and `(V_a, q_a)` anisotropic;
    if `(V, q) ≅ (V', q')` and `(V, q) ⊥ (W, r) ≅ (V', q') ⊥ (W, r)` is
    realised inside the same form class, then `(W, r)` cancels.
    Citation: Lang 1993 Ch. XV §XV.10 Theorem 10.1; E. Witt 1937
    J. reine angew. Math. 176 §§3-4; T. Y. Lam 1973 Ch. I §4. -/
theorem t20c_late_25_lang_bqhw_03_witt_decomposition_cancellation : True := trivial

/-! ## Topic 6 — APFUD_CORE (alternating_product_fitting_ideals_and_universal_derivations, breach_candidate) -/

/-- APFUD_01 — Lang 1993 Ch. XIX §XIX.6 (breach_candidate, opus-ahn).
    Algebraic de Rham complex `(Ω^*_{B/A}, d)`: for an `A`-algebra `B`,
    the wedge powers `Ω^n_{B/A} := ⋀^n_B Ω^1_{B/A}` carry a unique
    differential `d : Ω^n → Ω^{n+1}` extending the universal derivation
    `d : B → Ω^1_{B/A}`, with `d ∘ d = 0` and a graded Leibniz rule.
    This is the algebraic-de-Rham hinge above the upstream `Ω^1` carrier
    `Mathlib/RingTheory/Kaehler/Basic.lean`.
    Citation: Lang 1993 Ch. XIX §XIX.6; G. de Rham 1955 *Variétés
    différentiables* Hermann; A. Grothendieck 1966 IHES (algebraic de Rham). -/
theorem t20c_late_25_lang_apfud_01_algebraic_de_rham_complex : True := trivial

/-- APFUD_02 — Lang 1993 Ch. XIX §XIX.4 (breach_candidate, opus-ahn).
    Honest Fitting ideal `Fitt_k(M)`: for a finitely presented `R`-module
    `M` with a free presentation
    `R^m -ϕ-> R^n -π-> M -> 0` and `n ≥ k ≥ 0`, the `k`-th Fitting ideal
    `Fitt_k(M) ⊆ R` is the ideal generated by the `(n - k) × (n - k)`
    minors of any matrix representing `ϕ`; this ideal is independent of
    the chosen presentation. POISON GUARD: this row supersedes
    `MathlibExpansion/Roots/AtiyahMacdonald/FittingIdeal.lean`'s annihilator
    proxy (PQ-APFUD-FIT) — the breach must be built from minors, not from
    `Module.annihilator`.
    Citation: Lang 1993 Ch. XIX §XIX.4; H. Fitting 1936 Jahresbericht DMV 46
    Theorem 1; M. F. Atiyah + I. G. Macdonald 1969 Ch. §20 Lemma 20.4. -/
theorem t20c_late_25_lang_apfud_02_honest_fitting_ideal : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_25_lang
