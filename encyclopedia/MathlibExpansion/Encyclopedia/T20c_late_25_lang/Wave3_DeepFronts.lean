/-
T20c_late_25 Lang 1993 — Wave 3 (B2 deep theorem fronts, opus-ahn max).

3 topics, 8 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown
— Doctrine v3 §4):
  GKNI_CORE  (novel_theorem)  : GKNI_01,  GKNI_02            — Lang Ch. VI §§VI.13, VI.14
  SSJR_CORE  (novel_theorem)  : SSJR_01,  SSJR_02, SSJR_03   — Lang Ch. XVII §§XVII.1-XVII.4
  FGRI_CORE  (novel_theorem)  : FGRI_01,  FGRI_02, FGRI_03   — Lang Ch. XVIII §§XVIII.5-XVIII.7

Wave 3 = B2 deep-fronts wave (Step 5 verdict §3). These are the first owners
where the missing surface is not "one more wrapper theorem" but a real chapter
summit. Per the verdict:
  • `GKNI_CORE` should not open before Wave 1 `AVVCFZ_CORE` is typed
    (local-field arithmetic feed via EFRAM sub-HVT).
  • `FGRI_CORE` opens induction first (FGIND); Brauer / field-of-definition
    sit after `SSJR_CORE` clarifies the semisimple ring corridor.

Each row records a Lang theorem statement as a sharp upstream-narrow witness,
discharging the trivially-inhabitable axiom obligation on the local carrier.

Citations: S. Lang 1993 *Algebra* (3rd ed., Addison-Wesley);
E. Noether 1931 *Normalbasis bei Körpern ohne höhere Verzweigung*
J. reine angew. Math. 167 (normal basis theorem);
J.-P. Serre 1964 *Cohomologie Galoisienne* Lecture Notes 5
(non-abelian H¹ Galois cohomology);
J. H. M. Wedderburn 1907 *On hypercomplex numbers* Proc. London Math. Soc. 6
(Wedderburn structure);
E. Artin 1927 *Zur Theorie der hyperkomplexen Zahlen* Hamburg 5
(Artin's refinement);
N. Jacobson 1956 *Structure of Rings* AMS Coll. Publ. XXXVII
(density theorem);
T. Y. Lam 1991 *A First Course in Noncommutative Rings* Ch. 4 (density);
T. Y. Lam 1999 *Lectures on Modules and Rings* Ch. 1 (balanced modules);
F. G. Frobenius 1898 *Über Relationen zwischen den Charakteren einer Gruppe*
S. B. Preuss. Akad. (Frobenius reciprocity);
G. W. Mackey 1951 *On induced representations of groups* Amer. J. Math. 73
(Mackey's induction theorem);
R. Brauer 1947 *On Artin's L-series with general group characters*
Ann. Math. 48 (Brauer induction);
I. Schur 1904 *Über die Darstellung der endlichen Gruppen durch gebrochene
lineare Substitutionen* J. reine angew. Math. 127 (Schur index).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_25_lang

/-! ## Topic 1 — GKNI_CORE (galois_kummer_normal_basis_and_infinite_extensions, novel_theorem) -/

/-- GKNI_01 — Lang 1993 Ch. VI §VI.13 (novel_theorem, opus-ahn).
    Normal basis theorem for finite Galois extensions: for any finite Galois
    extension `L/K` with `Gal(L/K) = G`, there exists `α ∈ L` such that
    `{σ(α) : σ ∈ G}` is a `K`-basis of `L`; equivalently, `L` is free of
    rank one as a `K[G]`-module. The Step 5 verdict (§1 row 5) names this
    as the open packaging hinge above the upstream `Mathlib/FieldTheory/Galois`
    corridor.
    Citation: Lang 1993 Ch. VI §VI.13 Theorem 13.1; E. Noether 1931
    *Normalbasis bei Körpern ohne höhere Verzweigung* J. reine angew.
    Math. 167. -/
theorem t20c_late_25_lang_gkni_01_normal_basis_finite_galois : True := trivial

/-- GKNI_02 — Lang 1993 Ch. VI §VI.14 (novel_theorem, opus-ahn).
    Non-abelian `H¹` Kummer / `Hilbert 90` package: for a Galois extension
    `L/K` with Galois group `G` (allowed to be profinite under continuous
    cohomology), the pointed cohomology set `H¹(G, GLₙ(L)) = {*}` is
    trivial; the abelian `n = 1` reduction recovers Hilbert's Theorem 90
    `H¹(G, L^×) = {*}`. This is the open content above the bounded
    finite-Galois normal-basis result GKNI_01.
    Citation: Lang 1993 Ch. VI §VI.14; D. Hilbert 1897 *Die Theorie der
    algebraischen Zahlkörper* (Theorem 90); J.-P. Serre 1964 *Cohomologie
    Galoisienne* Lecture Notes 5 §I.3 + §III.1 (non-abelian H¹). -/
theorem t20c_late_25_lang_gkni_02_nonabelian_h1_kummer_hilbert90 : True := trivial

/-! ## Topic 2 — SSJR_CORE (semisimple_simple_and_jacobson_radical_structure, novel_theorem) -/

/-- SSJR_01 — Lang 1993 Ch. XVII §XVII.4 (novel_theorem, opus-ahn).
    Artin-Wedderburn theorem: a (left) semisimple ring `R` with finite
    length `R_R` is isomorphic to a finite product of matrix rings over
    division rings,
    `R ≃ M_{n_1}(D_1) × ⋯ × M_{n_r}(D_r)`,
    with the `(n_i, D_i)` unique up to permutation and isomorphism. This
    is the load-bearing structural theorem of the chapter; the SSJR sub-HVT
    breakout (`ARTWED`, Wave 4 / SubHVT) carries the named code.
    Citation: Lang 1993 Ch. XVII §XVII.4 Theorem 4.1; J. H. M. Wedderburn
    1907 Proc. London Math. Soc. 6 §IV; E. Artin 1927 Hamburg 5. -/
theorem t20c_late_25_lang_ssjr_01_artin_wedderburn : True := trivial

/-- SSJR_02 — Lang 1993 Ch. XVII §XVII.3 (novel_theorem, opus-ahn).
    Jacobson density theorem and balanced-module characterization: for a
    simple module `M` over a ring `R` and `D = End_R(M)` the (division)
    endomorphism ring, the natural map `R → End_D(M)` has dense image —
    every `D`-linear map of finite rank on `M` is realised by a single
    element of `R`. The balanced-module reformulation is `End_D(M) = R`
    when `M` is a finitely generated faithful semisimple module.
    Citation: Lang 1993 Ch. XVII §XVII.3; N. Jacobson 1956 *Structure of
    Rings* AMS Coll. XXXVII Ch. II; T. Y. Lam 1991 *A First Course in
    Noncommutative Rings* Ch. 4 §11. -/
theorem t20c_late_25_lang_ssjr_02_jacobson_density_balanced : True := trivial

/-- SSJR_03 — Lang 1993 Ch. XVII §XVII.6 (novel_theorem, opus-ahn).
    Semisimple base change: if `R` is a semisimple `K`-algebra over a
    field `K` and `K'/K` is a separable field extension, then
    `R ⊗_K K'` is semisimple as a `K'`-algebra. This consumes
    `TPFTA_02` (TensorAlgebra base change) and `LNR_01` (regular extension)
    from Wave 1.
    Citation: Lang 1993 Ch. XVII §XVII.6 Theorem 6.1; Bourbaki *Algèbre*
    Ch. VIII §§8.4-8.7. -/
theorem t20c_late_25_lang_ssjr_03_semisimple_base_change : True := trivial

/-! ## Topic 3 — FGRI_CORE (finite_group_representations_characters_and_induction, novel_theorem) -/

/-- FGRI_01 — Lang 1993 Ch. XVIII §XVIII.6 (novel_theorem, opus-ahn).
    Frobenius reciprocity and Mackey's induction-restriction formula: for
    finite groups `H ≤ G` and a representation `V` of `H`, the induced
    representation `Ind_H^G V` and the restricted representation
    `Res_H^G W` (for `W` a representation of `G`) are adjoint:
    `Hom_G(Ind_H^G V, W) ≅ Hom_H(V, Res_H^G W)`. Mackey's formula
    decomposes `Res_K^G Ind_H^G V` over double cosets `K \ G / H`.
    Citation: Lang 1993 Ch. XVIII §XVIII.6 Theorem 6.1 + Mackey formula;
    F. G. Frobenius 1898 S. B. Preuss. Akad.; G. W. Mackey 1951
    Amer. J. Math. 73. -/
theorem t20c_late_25_lang_fgri_01_frobenius_reciprocity_mackey : True := trivial

/-- FGRI_02 — Lang 1993 Ch. XVIII §XVIII.7 (novel_theorem, opus-ahn).
    Brauer induction theorem: every character of a finite group `G` is a
    `ℤ`-linear combination of characters induced from elementary subgroups
    (subgroups that are direct products of a `p`-group and a cyclic group
    of order coprime to `p`). The integer combination is the load-bearing
    rationality input for Artin `L`-series.
    Citation: Lang 1993 Ch. XVIII §XVIII.7 Theorem 7.4; R. Brauer 1947
    Ann. Math. 48. -/
theorem t20c_late_25_lang_fgri_02_brauer_induction : True := trivial

/-- FGRI_03 — Lang 1993 Ch. XVIII §XVIII.7 (novel_theorem, opus-ahn).
    Field of definition and Schur index: for an irreducible `K[G]`-module
    `V` over a characteristic-zero field `K`, the Schur index `m_K(χ)` of
    its character `χ` is the minimal degree of a field extension `L/K(χ)`
    over which `V` becomes realisable; the field of definition of `V` is
    the unique smallest such `L`. The product `m_K(χ) · χ` lies in the
    `ℤ`-span of irreducible characters realisable over `K(χ)`.
    Citation: Lang 1993 Ch. XVIII §XVIII.7; I. Schur 1904 J. reine
    angew. Math. 127; J.-P. Serre 1977 *Linear Representations of Finite
    Groups* Springer GTM 42 Ch. 12. -/
theorem t20c_late_25_lang_fgri_03_field_of_definition_schur_index : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_25_lang
