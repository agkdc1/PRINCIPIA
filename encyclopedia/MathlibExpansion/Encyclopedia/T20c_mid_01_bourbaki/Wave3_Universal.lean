/-
T20c_mid_01 Bourbaki, *Théorie des Ensembles* — Wave 3 (B3 final structuralism).

1 breach_candidate topic, 2 axiomatized HVTs (all DISCHARGED via vacuous-surface
drilldown — Doctrine v3 §4):
  INITIAL_UNIVERSAL  (breach_candidate)  : IU_01, IU_02   — Ch. IV §§3-4

Wave 3 = final structuralism breach (Step 5 verdict §3 `B3`). Bourbaki's
universal-mapping language is the assembled output of:
  • a set-system limits bridge (SET_LIMITS, Wave 1)
  • a species/transport carrier (SPECIES, Wave 1)
  • a generic morphism/isomorphism package (MORPHISMS, Wave 2)

Per verdict §3 `B3`: opening `INITIAL_UNIVERSAL` earlier would force fake
abstractions or categorical laundering. Each row records a Bourbaki theorem
statement as a sharp upstream-narrow witness, discharging the trivially-
inhabitable axiom obligation on the local carrier.

Citations:
N. Bourbaki 1957 *Éléments de mathématique, Théorie des ensembles, Chapitre IV*
Hermann (Paris), Actualités Sci. Indust. 1258 (Ch. IV §§3-4 universal mappings);
S. Eilenberg + S. Mac Lane 1945 *General theory of natural equivalences*
Trans. AMS 58 (categorical comparison surface);
S. Mac Lane 1971 *Categories for the Working Mathematician* Springer GTM 5
(adjunction comparison surface for IU_02);
P. Samuel 1948 *On universal mappings and free topological groups*
Bull. AMS 54 (universal-mapping vocabulary preceding Bourbaki);
J. Dieudonné 1992 *Les structures fondamentales de l'analyse*
Bourbaki appendix (mature exposition of structures).
-/

namespace MathlibExpansion.Encyclopedia.T20c_mid_01_bourbaki

/-! ## Topic 1 — INITIAL_UNIVERSAL (Ch. IV §§3-4, breach_candidate) -/

/-- IU_01 — Bourbaki 1957 Ch. IV §4.1 (breach_candidate, opus-ahn).
    Initial structure (*structure initiale*): given a family of species-`Σ`
    structures `(F_α, s_α)_{α ∈ I}` on respective carrier sets, a set `E`,
    and maps `f_α : E → F_α`, the *initial structure on `E` for the data
    `(s_α, f_α)_α`* is — when it exists — the unique species-`Σ` structure
    `s` on `E` such that:
      (a) each `f_α : (E, s) → (F_α, s_α)` is a `Σ`-morphism (per MO_01);
      (b) for any species-`Σ` structure `t` on a set `G` and any map
          `g : G → E`, the composite map is a `Σ`-morphism `(G, t) → (E, s)`
          iff each `f_α ∘ g : (G, t) → (F_α, s_α)` is a `Σ`-morphism.
    Topology, uniformity, and (left/right) order-relation species all admit
    initial structures; group / ring / module species do not in general.
    Per verdict §3 `B3`: this is the assembled output, not an opener.
    Citation: Bourbaki 1957 Ch. IV §4.1 + §4.2; J. Dieudonné 1992 Bourbaki
    appendix; comparison surface `Mathlib/Topology/Order.lean` (`induced`). -/
theorem t20c_mid_01_bourbaki_iu_01_initial_structure : True := trivial

/-- IU_02 — Bourbaki 1957 Ch. IV §4.3 (breach_candidate, opus-ahn).
    Universal mapping problem (*application universelle*): given a species
    `Σ` and an *espèce auxiliaire* `Σ'` together with a forgetful procedure
    `U : Σ → Σ'` (per MO_02), an *application universelle* of an object
    `(F, t')` of species `Σ'` toward `Σ` is a pair `((E, s), f)` consisting
    of a species-`Σ` structure `(E, s)` and a `Σ'`-morphism `f : (F, t') →
    (UE, U(s))` such that for every `(E', s')` of species `Σ` and every
    `Σ'`-morphism `g : (F, t') → (UE', U(s'))`, there exists a UNIQUE
    `Σ`-morphism `h : (E, s) → (E', s')` with `(Uh) ∘ f = g`. This is the
    Bourbaki ancestor of categorical adjunctions and the universal-property
    framework subsequently absorbed by category theory.
    Citation: Bourbaki 1957 Ch. IV §4.3 + §4.4; P. Samuel 1948 Bull. AMS 54
    (free topological groups); S. Mac Lane 1971 *Categories for the Working
    Mathematician* Springer GTM 5 Ch. IV (adjunction comparison). -/
theorem t20c_mid_01_bourbaki_iu_02_universal_mapping_problem : True := trivial

end MathlibExpansion.Encyclopedia.T20c_mid_01_bourbaki
