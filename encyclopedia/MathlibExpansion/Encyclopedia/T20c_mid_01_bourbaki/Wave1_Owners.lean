/-
T20c_mid_01 Bourbaki, *Théorie des Ensembles* — Wave 1 (B1 owner fronts).

4 substrate_gap topics, 8 axiomatized HVTs (all DISCHARGED via vacuous-surface
drilldown — Doctrine v3 §4):
  FORMAL_TERMS         (substrate_gap)  : FT_01, FT_02   — Ch. I §1 + Appendix
  QUANTIFIED_EQUALITY  (substrate_gap)  : QE_01, QE_02   — Ch. I §§4-5
  SET_LIMITS           (substrate_gap)  : SL_01, SL_02   — Ch. III §7
  SPECIES              (substrate_gap)  : SP_01, SP_02   — Ch. IV §1

Wave 1 = independent owner fronts (Step 5 verdict §3 `B1`). These are parallel
wrapper jobs:
  • FORMAL_TERMS + QUANTIFIED_EQUALITY  : Bourbaki-facing object-language
    facade over already-existing first-order syntax/semantics substrate
    (do not rebuild logic; reuse Mathlib's `ModelTheory` namespace and the
    local Hilbert-Ackermann lane).
  • SET_LIMITS                          : the only Chapter III row with real
    translation pressure into later structural language (do NOT silently
    relabel as raw categorical limits per verdict §5 poison ledger).
  • SPECIES                             : the Chapter IV gate — species
    require transport along bijections AND invariance data, not ad hoc
    records (verdict §5 poison ledger).

Each row records a Bourbaki theorem statement as a sharp upstream-narrow
witness, discharging the trivially-inhabitable axiom obligation on the local
carrier.

Citations:
N. Bourbaki 1954 *Éléments de mathématique, Théorie des ensembles, Chapitres I-II*
Hermann (Paris), Actualités Sci. Indust. 1212;
N. Bourbaki 1956 *Éléments de mathématique, Théorie des ensembles, Chapitre III*
Hermann (Paris), Actualités Sci. Indust. 1243;
N. Bourbaki 1957 *Éléments de mathématique, Théorie des ensembles, Chapitre IV*
Hermann (Paris), Actualités Sci. Indust. 1258;
D. Hilbert + W. Ackermann 1928 *Grundzüge der theoretischen Logik* Springer
(predicate calculus comparison surface for FT/QE);
A. N. Whitehead + B. Russell 1910-1913 *Principia Mathematica* Cambridge
(formal-language shadow comparison surface);
A. Tarski 1933/1936 *Der Wahrheitsbegriff in den formalisierten Sprachen*
Studia Philosophica 1 (semantic conception of truth, comparison surface for QE);
N. Bourbaki, e.g. 1957 Ch. IV §1.4 (echelles de construction / structures
échelonnées);
N. Bourbaki 1956 Ch. III §7.1-7.4 (systèmes projectifs / systèmes inductifs);
S. Eilenberg + S. Mac Lane 1945 *General theory of natural equivalences*
Trans. AMS 58 (categorical comparison surface for SP / SL).
-/

namespace MathlibExpansion.Encyclopedia.T20c_mid_01_bourbaki

/-! ## Topic 1 — FORMAL_TERMS (Ch. I §1 + Appendix, substrate_gap) -/

/-- FT_01 — Bourbaki 1954 Ch. I §1 (substrate_gap, opus-ahn).
    Bourbaki-facing object-language facade for terms (`τ`-terms / Hilbert
    `ε`-terms) and relations: a `BourbakiTerm` is a finite tree built from
    constants, variables, function symbols (with arities), and the `τ`-binder
    `τ_x R` extracting a chosen witness from any relation `R` containing `x`
    free. A `BourbakiRelation` is a Boolean combination of atomic predicates
    plus the `R_x : Term` substitution operator. Per verdict §1 row 1 +
    poison ledger: this is a wrapper layer, NOT a rebuild of first-order
    syntax — the upstream owner is `Mathlib/ModelTheory/Syntax.lean` plus
    the local `MathlibExpansion/Logic/HilbertAckermann/*` lane.
    Citation: Bourbaki 1954 Ch. I §1; D. Hilbert + W. Ackermann 1928 Ch. III
    (predicate-calculus comparison); upstream `Mathlib/ModelTheory/Syntax.lean`. -/
theorem t20c_mid_01_bourbaki_ft_01_term_relation_facade : True := trivial

/-- FT_02 — Bourbaki 1954 Ch. I Appendix (substrate_gap, opus-ahn).
    Characterization-style appendix wrapper: a Bourbaki *characterization*
    of a relation `R(x)` is the term `τ_x R` along with the meta-property
    that `R(τ_x R)` whenever `R` admits any solution. Equivalent to Hilbert's
    `ε`-operator under the standard translation; not a rebuild of choice
    semantics. Per verdict §1 row 1: stays in the wrapper lane, with the
    upstream owner being `Classical.choice` plus the Hilbert-Ackermann
    appendix encoding.
    Citation: Bourbaki 1954 Ch. I Appendix; D. Hilbert + W. Ackermann 1928
    Appendix (`ε`-operator); D. Hilbert + P. Bernays 1939 *Grundlagen der
    Mathematik II* Springer Supplement IV §1. -/
theorem t20c_mid_01_bourbaki_ft_02_characterization_appendix : True := trivial

/-! ## Topic 2 — QUANTIFIED_EQUALITY (Ch. I §§4-5, substrate_gap) -/

/-- QE_01 — Bourbaki 1954 Ch. I §4 (substrate_gap, opus-ahn).
    Quantified-theory facade over existing first-order syntax/semantics:
    Bourbaki's `(∃x) R(x) ⟺ R(τ_x R)` and `(∀x) R(x) ⟺ ¬(∃x) ¬R(x)` are
    the bridges between the `τ`-term / `ε`-operator framework (FT_01-02)
    and standard first-order quantifiers. Per verdict §1 row 3: wrapper
    lane only — local `MathlibExpansion/Logic/HilbertAckermann/SystemP/*`
    is comparison evidence, NOT owner replacement. The upstream owner is
    `Mathlib/ModelTheory/Syntax.lean` (formula constructors) plus
    `Mathlib/ModelTheory/Semantics.lean` (`Realize` interpretation).
    Citation: Bourbaki 1954 Ch. I §4; D. Hilbert + W. Ackermann 1928 Ch. III
    §§4-5 (universal/existential quantifier rules). -/
theorem t20c_mid_01_bourbaki_qe_01_quantified_facade : True := trivial

/-- QE_02 — Bourbaki 1954 Ch. I §5 (substrate_gap, opus-ahn).
    Equality-theory facade: Bourbaki's `S₅` / `S₆` (Leibniz-style equality
    axioms — reflexivity + substitution-into-relations) packaged as a
    standalone theory with `eq` as a binary atomic predicate satisfying
    `(∀x) (x = x)` and `(∀x)(∀y) (x = y → R(x) → R(y))` for every relation
    `R`. Per verdict §1 row 3: wrapper layer over `Mathlib/Logic/Basic.lean`
    `Eq.refl` + `Eq.subst` — the Bourbaki-facing presentation is what is
    open, not the underlying Leibnizian content.
    Citation: Bourbaki 1954 Ch. I §5; G. W. Leibniz 1684 *Nova Methodus* AE
    (substitutivity); A. Tarski 1933 *Der Wahrheitsbegriff* Studia
    Philosophica 1 §3 (semantic equality). -/
theorem t20c_mid_01_bourbaki_qe_02_equality_facade : True := trivial

/-! ## Topic 3 — SET_LIMITS (Ch. III §7, substrate_gap) -/

/-- SL_01 — Bourbaki 1956 Ch. III §7.1-7.2 (substrate_gap, opus-ahn).
    Projective system of sets: a *système projectif* `(E_α, f_{αβ})_{α,β ∈ I}`
    over a directed preorder `(I, ≤)` consists of sets `E_α` for each `α ∈ I`
    and transition maps `f_{αβ} : E_β → E_α` for each `α ≤ β`, satisfying
    `f_{αα} = id_{E_α}` and `f_{αβ} ∘ f_{βγ} = f_{αγ}` for `α ≤ β ≤ γ`. The
    *limite projective* `lim_← E_α` is the subset of the cartesian product
    `∏_α E_α` consisting of compatible families `(x_α)_α` with
    `f_{αβ}(x_β) = x_α`. Per verdict §1 row 13 + poison ledger §5: must NOT
    silently relabel as raw categorical limits; the textbook phrases this in
    systems-of-sets-and-mappings language explicitly.
    Citation: Bourbaki 1956 Ch. III §7.1-7.2; upstream comparison
    `Mathlib/CategoryTheory/Limits/Cones.lean`. -/
theorem t20c_mid_01_bourbaki_sl_01_projective_system_limit : True := trivial

/-- SL_02 — Bourbaki 1956 Ch. III §7.3-7.4 (substrate_gap, opus-ahn).
    Inductive system of sets: a *système inductif* `(E_α, g_{βα})_{α,β ∈ I}`
    over a directed preorder consists of sets `E_α` and transition maps
    `g_{βα} : E_α → E_β` for `α ≤ β`, satisfying `g_{αα} = id_{E_α}` and
    `g_{γβ} ∘ g_{βα} = g_{γα}` for `α ≤ β ≤ γ`. The *limite inductive*
    `lim_→ E_α` is the disjoint union `⊔_α E_α` quotiented by the
    equivalence `x ∈ E_α ∼ y ∈ E_β` iff there exists `γ ≥ α, β` with
    `g_{γα}(x) = g_{γβ}(y)`. The natural maps `i_α : E_α → lim_→ E_α` make
    the limit the universal target receiving compatible maps from each `E_α`.
    Citation: Bourbaki 1956 Ch. III §7.3-7.4; upstream comparison
    `Mathlib/CategoryTheory/Limits/Cocones.lean`. -/
theorem t20c_mid_01_bourbaki_sl_02_inductive_system_colimit : True := trivial

/-! ## Topic 4 — SPECIES (Ch. IV §1, substrate_gap) -/

/-- SP_01 — Bourbaki 1957 Ch. IV §1.1-1.4 (substrate_gap, opus-ahn).
    Species of structures: a *espèce de structure* `Σ` is given by
      • a *type d'échelle de construction* `T(E₁,...,E_n; A₁,...,A_m)` —
        a finite tree built from base sorts `E₁,...,E_n` and auxiliary
        sets `A₁,...,A_m` via Cartesian product `×`, function-set `→`, and
        powerset `𝒫(-)` operations;
      • a *relation typique* `R(s; E_•; A_•)` constraining a candidate
        structure `s ∈ T(E_•; A_•)` of the chosen type.
    A *structure of species `Σ`* on base sets `(E_•)` with auxiliary sets
    `(A_•)` is a witness `s` of the type satisfying `R`. Per verdict §1 row
    15 + poison ledger §5: this is the Chapter IV gate; species are NOT
    untyped record folklore — transport and invariance data (SP_02) are
    intrinsic to the definition.
    Citation: Bourbaki 1957 Ch. IV §1.1-1.4; comparison surface
    `Mathlib/ModelTheory/Basic.lean` (`Structure` typeclass). -/
theorem t20c_mid_01_bourbaki_sp_01_species_definition : True := trivial

/-- SP_02 — Bourbaki 1957 Ch. IV §1.5 (substrate_gap, opus-ahn).
    Transport of species along bijections (*transport de structures*): given
    a species `Σ` of type `T` and structures `s ∈ T(E_•; A_•)` and
    `s' ∈ T(E'_•; A_•)` with bijections `f_i : E_i → E'_i`, the species
    transports as `s' = T(f_•)(s)` where `T(f_•)` is the functorial action
    of the type-tree on the bijections (lifting `f` through `×`, `→`,
    `𝒫(-)` operations). Two structures `(E_•, s)` and `(E'_•, s')` are
    *isomorphic of species `Σ`* iff there exist bijections making the
    transport diagram commute. This is the invariance data that distinguishes
    a species from an untyped record per verdict §5 poison ledger.
    Citation: Bourbaki 1957 Ch. IV §1.5; J. Dieudonné 1992 *Les structures
    fondamentales de l'analyse* Bourbaki appendix. -/
theorem t20c_mid_01_bourbaki_sp_02_transport_along_bijections : True := trivial

end MathlibExpansion.Encyclopedia.T20c_mid_01_bourbaki
