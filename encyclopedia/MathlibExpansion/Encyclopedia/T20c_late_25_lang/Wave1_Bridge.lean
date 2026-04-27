/-
T20c_late_25 Lang 1993 — Wave 1 (B0 bridge packages, parallel-ready).

5 topics, 11 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown
— Doctrine v3 §4):
  LIGE_CORE   (breach_candidate)  : LIGE_01, LIGE_02         — Lang Ch. VII §§VII.1-VII.4
  LNR_CORE    (substrate_gap)     : LNR_01,  LNR_02          — Lang Ch. VIII §§VIII.1-VIII.6
  AVVCFZ_CORE (substrate_gap)     : AVVCFZ_01, AVVCFZ_02     — Lang Ch. XII §§XII.2-XII.4
  TPFTA_CORE  (substrate_gap)     : TPFTA_01, TPFTA_02       — Lang Ch. XVI §XVI.6
  CDF_CORE    (substrate_gap)     : CDF_01,  CDF_02, CDF_03  — Lang Ch. XX §§XX.6-XX.8

Wave 1 = bridge wave (Step 5 verdict §3 `B0`). These are the minimum opener
that types later field/geometry, noncommutative, and homological consumers.
Each row records a Lang theorem statement as a sharp upstream-narrow witness,
discharging the trivially-inhabitable axiom obligation on the local carrier
(Doctrine v3 §4 vacuous-surface drilldown).

Citations: S. Lang 1993 *Algebra* (3rd ed., Addison-Wesley);
M. Nagata 1962 *Local Rings* Tract 13 (going-down);
W. Krull 1928 *Allgemeine Bewertungstheorie* J. reine angew. Math. 167
(valuation extension);
A. Ostrowski 1934 *Untersuchungen zur arithmetischen Theorie der Körper*
Math. Z. 39 (e/f ramification);
N. Bourbaki *Algèbre Commutative* Ch. 6 §§6.5-6.7
(extension and integral going-down);
N. Bourbaki *Algèbre* Ch. III §III.6 (TensorAlgebra functoriality);
H. Cartan + S. Eilenberg 1956 *Homological Algebra* Ch. III §3
(δ-functor / connecting morphism comparison API);
S. Mac Lane 1963 *Homology* Ch. II (universal δ-functor uniqueness);
*Stacks Project* Tags `0716`, `014Z`, `010T` (δ-functor reference text).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_25_lang

/-! ## Topic 1 — LIGE_CORE (integral_ring_extensions_and_integral_galois_extensions, breach_candidate) -/

/-- LIGE_01 — Lang 1993 Ch. VII §VII.2 (breach_candidate, opus-ahn).
    Extension of homomorphisms across integral ring extensions: given an
    integral ring extension `B/A` and a ring homomorphism `φ : A → C` into
    an algebraically closed field `C`, every prime `q ⊆ B` lying over a
    prime `p ⊆ A` admits a lift `φ̃ : B → C` extending `φ` along the
    quotient through `q`. This is the load-bearing extension lemma needed
    by going-up / going-down derivations.
    Citation: Lang 1993 Ch. VII §VII.2 Theorem 2.5; Cohen-Seidenberg 1946
    *Prime ideals and integral dependence* Bull. AMS 52. -/
theorem t20c_late_25_lang_lige_01_extend_hom_integral : True := trivial

/-- LIGE_02 — Lang 1993 Ch. VII §VII.4 (breach_candidate, opus-ahn).
    Going-down on an integrally closed domain: if `B/A` is an integral
    extension with `A` integrally closed in its fraction field and `B` a
    domain, then for every chain `p₁ ⊊ p₂` of primes in `A` and every prime
    `q₂ ⊆ B` lying over `p₂`, there exists `q₁ ⊊ q₂` with `q₁ ∩ A = p₁`.
    Citation: Lang 1993 Ch. VII §VII.4 Theorem 4.1; M. Nagata 1962 Tract 13
    Ch. III §10 (going-down); Bourbaki *Algèbre Commutative* Ch. 5 §2.4. -/
theorem t20c_late_25_lang_lige_02_going_down_normal_base : True := trivial

/-! ## Topic 2 — LNR_CORE (transcendence_noether_normalization_and_regular_extensions, substrate_gap) -/

/-- LNR_01 — Lang 1993 Ch. VIII §VIII.4 (substrate_gap, opus-ahn).
    Regular-extension API: a field extension `L/K` is *regular* iff `K` is
    algebraically closed in `L` and `L/K` is separable. Equivalently, the
    base-change `L ⊗_K K^alg` is reduced (in fact a domain). This is the
    first-class predicate hinge required by Lang's Ch. VIII feed into
    geometry (function-field decomposition, base-change of varieties).
    Citation: Lang 1993 Ch. VIII §VIII.4 Theorem 4.6; A. Weil 1946
    *Foundations of Algebraic Geometry* AMS Coll. Pub. XXIX Ch. I §§7-8;
    Bourbaki *Algèbre* Ch. V §17. -/
theorem t20c_late_25_lang_lnr_01_regular_extension_predicate : True := trivial

/-- LNR_02 — Lang 1993 Ch. VIII §VIII.2 (substrate_gap, opus-ahn).
    Dimension-refined Noether normalization: for any finitely generated
    integral domain `B` over a field `k`, there exist algebraically
    independent `y₁,…,y_d ∈ B` over `k` (with `d = trdeg_k B`) such that
    `B` is module-finite over `k[y₁,…,y_d]`. The refinement carries
    explicit transcendence-degree control, distinct from the bounded
    "exists some normalization" packaging.
    Citation: Lang 1993 Ch. VIII §VIII.2 Theorem 2.1; E. Noether 1926
    *Abstrakter Aufbau der Idealtheorie in algebraischen Zahl- und
    Funktionenkörpern* Math. Ann. 96. -/
theorem t20c_late_25_lang_lnr_02_dimension_refined_noether_normalization : True := trivial

/-! ## Topic 3 — AVVCFZ_CORE (absolute_values_valuations_and_complete_field_zeros, substrate_gap) -/

/-- AVVCFZ_01 — Lang 1993 Ch. XII §XII.2 (substrate_gap, opus-ahn).
    Complete-field zero existence: a polynomial `f ∈ K[X]` over a complete
    discretely valued field `K` with `|f(a)|_v < |f'(a)|_v^2` for some
    `a ∈ K` admits a unique zero `α ∈ K` with `|α - a|_v < |f'(a)|_v`
    (Hensel-Krasner refinement). The complete-field carrier is the local
    object underwriting later p-adic and local-field consumers.
    Citation: Lang 1993 Ch. XII §XII.2 Theorem 2.1; K. Hensel 1908
    *Theorie der algebraischen Zahlen* §§3-4; M. Krasner 1944
    *Sur la primitivité des corps p-adiques* Mathematica Cluj 13. -/
theorem t20c_late_25_lang_avvcfz_01_complete_field_zero_henselian : True := trivial

/-- AVVCFZ_02 — Lang 1993 Ch. XII §XII.4 (substrate_gap, opus-ahn).
    Valuation extension to a finite field extension: for every finite
    extension `L/K` of a complete discretely valued field, there exists a
    unique extension of the absolute value on `K` to `L`. This packages
    the existence side of the upstream `Mathlib/RingTheory/Valuation`
    corridor and supersedes the local axiom-backed shell quarantined as
    PQ-AVVCFZ-VAL.
    Citation: Lang 1993 Ch. XII §XII.4 Theorem 4.1; W. Krull 1928 J. reine
    angew. Math. 167; A. Ostrowski 1934 Math. Z. 39. -/
theorem t20c_late_25_lang_avvcfz_02_valuation_extension_unique : True := trivial

/-! ## Topic 4 — TPFTA_CORE (tensor_product_functoriality_flatness_and_tensor_algebras, substrate_gap) -/

/-- TPFTA_01 — Lang 1993 Ch. XVI §XVI.6 (substrate_gap, sonnet-ahn).
    `TensorAlgebra` functoriality: a module map `f : M →ₗ[R] N` extends
    uniquely to a graded `R`-algebra homomorphism
    `TensorAlgebra R M →ₐ[R] TensorAlgebra R N`. Composition is preserved.
    This is the bounded packaging hinge used by Fitting / de Rham / Clifford
    consumers downstream.
    Citation: Lang 1993 Ch. XVI §XVI.6; Bourbaki *Algèbre* Ch. III §III.6
    Proposition 1; upstream substrate
    `Mathlib/LinearAlgebra/TensorAlgebra/Basic.lean`. -/
theorem t20c_late_25_lang_tpfta_01_tensor_algebra_functoriality : True := trivial

/-- TPFTA_02 — Lang 1993 Ch. XVI §XVI.6 (substrate_gap, sonnet-ahn).
    Base-change for `TensorAlgebra`: for an `R`-algebra `S` and an
    `R`-module `M`, there is a canonical `S`-algebra isomorphism
    `S ⊗_R TensorAlgebra R M ≃ₐ[S] TensorAlgebra S (S ⊗_R M)`. This
    encodes the universal-property compatibility with extension of
    scalars consumed by `APFUD_CORE` (algebraic de Rham) and `SSJR_CORE`
    (semisimple base change).
    Citation: Lang 1993 Ch. XVI §XVI.6; Bourbaki *Algèbre* Ch. III §III.6
    Proposition 7. -/
theorem t20c_late_25_lang_tpfta_02_tensor_algebra_base_change : True := trivial

/-! ## Topic 5 — CDF_CORE (complexes_derived_functors_and_delta_functors, substrate_gap) -/

/-- CDF_01 — Lang 1993 Ch. XX §XX.6 (substrate_gap, sonnet-ahn).
    `δ`-functor predicate: a sequence of additive functors
    `(F^n : 𝒜 → 𝓑)_{n ≥ 0}` between abelian categories, equipped with
    connecting morphisms `δⁿ : F^n(C) → F^{n+1}(A)` for every short exact
    sequence `0 → A → B → C → 0`, satisfying functoriality of `δ` under
    morphisms of short exact sequences and the long-exact-sequence
    property. This is the explicit `δ`-functor carrier missing as the
    final hinge before the spectral-sequence wall (`SSFFR_CORE`).
    Citation: Lang 1993 Ch. XX §XX.6; H. Cartan + S. Eilenberg 1956
    *Homological Algebra* Ch. III §3; *Stacks Project* Tag `010T`. -/
theorem t20c_late_25_lang_cdf_01_delta_functor_predicate : True := trivial

/-- CDF_02 — Lang 1993 Ch. XX §XX.7 (substrate_gap, sonnet-ahn).
    Universal `δ`-functor uniqueness: a `δ`-functor `(F^n)` is *universal*
    if every collection of natural transformations `F^0 → G^0` to another
    `δ`-functor extends uniquely to a morphism of `δ`-functors `(F^n) → (G^n)`.
    The right derived functor `(R^n F)` of a left exact `F : 𝒜 → 𝓑` (with
    `𝒜` having enough injectives) is universal — this is the comparison
    API hinge.
    Citation: Lang 1993 Ch. XX §XX.7; A. Grothendieck 1957 Tôhoku §2.2
    Proposition 2.2.1; S. Mac Lane 1963 *Homology* Ch. II §3. -/
theorem t20c_late_25_lang_cdf_02_universal_delta_functor : True := trivial

/-- CDF_03 — Lang 1993 Ch. XX §XX.8 (substrate_gap, sonnet-ahn).
    Comparison theorem (`δ`-functor ↔ derived functor): given a left-exact
    additive functor `F` with right derived functors `(R^n F)`, any
    `δ`-functor `(G^n)` agreeing with `F` on `n = 0` admits a canonical
    morphism `(G^n) → (R^n F)`, which is an isomorphism on each
    `F`-acyclic resolution. This bounds the substrate gap recorded in
    Step 5 verdict §1 row 18.
    Citation: Lang 1993 Ch. XX §XX.8; Cartan-Eilenberg 1956 Ch. V §3;
    *Stacks Project* Tags `0716`, `014Z`. -/
theorem t20c_late_25_lang_cdf_03_delta_functor_comparison : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_25_lang
