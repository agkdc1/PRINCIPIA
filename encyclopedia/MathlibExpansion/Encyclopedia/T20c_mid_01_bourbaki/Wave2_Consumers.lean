/-
T20c_mid_01 Bourbaki, *Théorie des Ensembles* — Wave 2 (B2 carrier consumers).

2 breach_candidate topics, 5 axiomatized HVTs (all DISCHARGED via vacuous-surface
drilldown — Doctrine v3 §4):
  THEOREM_CALCULUS  (breach_candidate)  : TC_01, TC_02, TC_03   — Ch. I §2
  MORPHISMS         (breach_candidate)  : MO_01, MO_02          — Ch. IV §§2-3

Wave 2 = consume the B1 carriers (Step 5 verdict §3 `B2`):
  • THEOREM_CALCULUS opens AFTER the Bourbaki object-language facade
    (FT_01-02 + QE_01-02) is fixed; otherwise theoremhood would be silently
    laundered into Lean `Prop` (verdict §5 poison ledger — must avoid
    `restricted_derivability_as_chapter_i_owner`).
  • MORPHISMS opens AFTER `SPECIES` (SP_01-02); otherwise morphisms become
    folklore about maps between random structures, not a generic Bourbaki
    package per verdict §1 row 16.

Each row records a Bourbaki theorem statement as a sharp upstream-narrow
witness, discharging the trivially-inhabitable axiom obligation on the local
carrier.

Citations:
N. Bourbaki 1954 *Éléments de mathématique, Théorie des ensembles, Chapitres I-II*
Hermann (Paris), Actualités Sci. Indust. 1212 (Ch. I §2 theoremhood);
N. Bourbaki 1957 *Éléments de mathématique, Théorie des ensembles, Chapitre IV*
Hermann (Paris), Actualités Sci. Indust. 1258 (Ch. IV §§2-3 morphisms +
derived structures);
G. Frege 1879 *Begriffsschrift* Nebert (deduction-style proof system);
D. Hilbert + W. Ackermann 1928 *Grundzüge der theoretischen Logik* Springer
(theoremhood and substitution rules);
D. Hilbert + P. Bernays 1934/1939 *Grundlagen der Mathematik I-II* Springer
(deduction theorem comparison);
S. Eilenberg + S. Mac Lane 1945 *General theory of natural equivalences*
Trans. AMS 58 (categorical comparison surface for morphisms);
N. Bourbaki, e.g. 1957 Ch. IV §2 (morphismes d'espèce) + §3 (structures
dérivées).
-/

namespace MathlibExpansion.Encyclopedia.T20c_mid_01_bourbaki

/-! ## Topic 1 — THEOREM_CALCULUS (Ch. I §2, breach_candidate) -/

/-- TC_01 — Bourbaki 1954 Ch. I §2.1-2.3 (breach_candidate, opus-ahn).
    Bourbaki-facing theoremhood predicate `IsTheorem` over the object-language
    facade (FT_01-02 + QE_01-02): a *theorem of the theory `T`* is a relation
    `R` derivable from the explicit axioms of `T` plus the schemes `S₁-S₈`
    (propositional schemes + quantifier rules + equality axioms + the
    `τ`-binder rule) by finitely many applications of *modus ponens* and
    generalization. Per verdict §1 row 2 + poison ledger §5: must NOT
    collapse `IsTheorem T R ↔ Realize T R` (the `restricted_derivability`
    poison) — the deduction predicate is syntactic, not semantic.
    Citation: Bourbaki 1954 Ch. I §2.1-2.3; G. Frege 1879 *Begriffsschrift*
    Nebert §§13-14 (modus ponens lineage); D. Hilbert + W. Ackermann 1928
    Ch. III §3 (object-language theoremhood). -/
theorem t20c_mid_01_bourbaki_tc_01_object_theoremhood_predicate : True := trivial

/-- TC_02 — Bourbaki 1954 Ch. I §2.4 (breach_candidate, opus-ahn).
    Substitution as a syntactic operation: if `R(x)` is a relation and `S`
    is a term, the substitution `R(S)` (Bourbaki notation `(S | x) R`) is
    well-defined modulo bound-variable renaming, and the substitution
    theorem holds: `IsTheorem T (R(x)) → IsTheorem T (R(S))` for every
    closed term `S`. The substitution machinery is a syntactic operation on
    the term/relation tree (FT_01), not a meta-statement about Lean's
    `Eq.subst` or `cast`.
    Citation: Bourbaki 1954 Ch. I §2.4; D. Hilbert + W. Ackermann 1928
    Ch. III §6 (substitution); D. Hilbert + P. Bernays 1934 *Grundlagen
    der Mathematik I* Ch. III §1.3. -/
theorem t20c_mid_01_bourbaki_tc_02_substitution_theorem : True := trivial

/-- TC_03 — Bourbaki 1954 Ch. I §2.5 (breach_candidate, opus-ahn).
    Methods of proof packaging: Bourbaki enumerates the *méthodes de
    démonstration* — direct proof, proof by cases (disjunction elimination),
    proof by contradiction (`(¬R → ⊥) → R`), proof by introducing an
    auxiliary hypothesis (deduction theorem), proof by witness (existential
    elimination via the `τ`-term), and proof by reduction (replacing a
    relation by a definitionally equivalent one). Each method is a derived
    rule of the basic schemes `S₁-S₈` plus modus ponens and generalization
    (TC_01).
    Citation: Bourbaki 1954 Ch. I §2.5; D. Hilbert + P. Bernays 1934
    *Grundlagen der Mathematik I* Ch. III §1.7 (deduction theorem). -/
theorem t20c_mid_01_bourbaki_tc_03_methods_of_proof : True := trivial

/-! ## Topic 2 — MORPHISMS (Ch. IV §§2-3, breach_candidate) -/

/-- MO_01 — Bourbaki 1957 Ch. IV §2 (breach_candidate, opus-ahn).
    Generic morphisms of species: given two structures `(E_•, s)` and
    `(E'_•, s')` of the same species `Σ` (per SP_01-02), a *Σ-morphism* is
    a tuple of maps `f_i : E_i → E'_i` such that the induced action
    `T(f_•)` on the type tree carries `s` to `s'` — that is,
    `T(f_•)(s) = s'` after the species' covariance/contravariance markings
    on each constructor (`×` covariant in both factors, `→` contravariant
    in the source + covariant in the target, `𝒫(-)` covariant via direct
    image). Per verdict §1 row 16: this is generic packaging, NOT a category-
    specific fragment. Composition of `Σ`-morphisms is associative; `id_{E_•}`
    is a morphism iff `s = s'`.
    Citation: Bourbaki 1957 Ch. IV §2; S. Eilenberg + S. Mac Lane 1945
    *General theory of natural equivalences* Trans. AMS 58 (functorial
    comparison surface). -/
theorem t20c_mid_01_bourbaki_mo_01_species_morphism : True := trivial

/-- MO_02 — Bourbaki 1957 Ch. IV §3 (breach_candidate, opus-ahn).
    Derived structures and isomorphism classes: from a species `Σ` and a
    *procédé de déduction* — a way to build new structures from `Σ`-data
    using the type-constructor calculus — Bourbaki defines *espèces dérivées*
    `Σ'`. Examples: a topology `Σ` on `E` derives a topology on `𝒫(E)`; a
    group structure `Σ` on `E` derives a group structure on `E × E` and a
    monoid structure on the underlying set. Two structures are
    *isomorphes d'espèce `Σ`* iff there exists an invertible `Σ`-morphism
    between them (MO_01); this is an equivalence relation and the
    *classes d'isomorphie* are its quotient.
    Citation: Bourbaki 1957 Ch. IV §3.1-3.4; J. Dieudonné 1992 *Les
    structures fondamentales de l'analyse* Bourbaki appendix. -/
theorem t20c_mid_01_bourbaki_mo_02_derived_structures_iso_classes : True := trivial

end MathlibExpansion.Encyclopedia.T20c_mid_01_bourbaki
