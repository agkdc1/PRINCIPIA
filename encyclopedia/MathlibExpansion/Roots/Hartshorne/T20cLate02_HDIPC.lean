import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 HDIPC — Higher direct images / projective coherence (B3 breach_candidate, Ch. III)

**Classification.** `breach_candidate` / `B3` per Step 5 verdict. Coherence of
higher direct images is the reusable projective-family theorem package after
the carrier stack lands.

**Dispatch note.** Cycle-1 opens the B3 breach with marker axioms for `R^i f_*`
higher direct image functors, projective pushforward coherence, and the
Grothendieck spectral sequence. Sharp signatures deferred to cycle-2 once
PMTRP projective carrier + QCP coherent subcategory + SSHC derived functor
stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. III §§8–9,
pp. 249–268. Historical parent: Grothendieck, EGA III §§2.2–3.2; Serre,
"Faisceaux algébriques cohérents", Ann. Math. 61 (1955), §66. Modern:
Stacks Project Tag 02KF (higher direct images), Tag 087S (projective pushforward).
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_HDIPC

/-- **HDIPC_01** higher direct image carrier marker (2026-04-24). For a morphism
`f : X → Y` and an `O_X`-module `F`, `R^i f_* F` is the i-th right derived
functor of `f_*`. Marker reserves the B3 owner slot.

Citation: Hartshorne Ch. III §8, p. 250. -/
axiom higher_direct_image_derived_functor_marker : True

/-- **HDIPC_03** projective pushforward coherence marker (Serre) (2026-04-24).
For a projective morphism `f : X → Y` with `Y` Noetherian, and a coherent
sheaf `F` on `X`, each `R^i f_* F` is coherent on `Y`.

Citation: Hartshorne Ch. III Thm. 8.8, p. 252. -/
axiom projective_pushforward_coherent_marker : True

/-- **HDIPC_06** Grothendieck spectral sequence marker (2026-04-24). For a
composition `X → Y → Z` of schemes and a sheaf `F`, there is a convergent
spectral sequence `E_2^{p,q} = R^p g_* R^q f_* F ⟹ R^{p+q} (g∘f)_* F`.

Citation: Hartshorne Ch. III §8, Ex. 8.1, p. 252. -/
axiom grothendieck_spectral_sequence_marker : True

end T20cLate02_HDIPC
end Hartshorne
end Roots
end MathlibExpansion
