import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_03 FCGSD_CORE — Finite commutative group scheme / Cartier duality (B1 substrate_gap)

**Classification.** `substrate_gap` / `B1` per Step 5 verdict. First honest
finite-flat commutative group-scheme and Cartier-duality owner; cannot be
laundered from `PDivisible`. Assigned to `opus-ahn max` tier.

**Dispatch note.** Cycle-1 opens the B1 substrate_gap with marker axioms for the
finite commutative group-scheme carrier, Cartier dual `G^D = Hom(G, 𝔾_m)`, and
Cartier biduality `(G^D)^D ≅ G`. FCGSD_03 (Cartier biduality) is the explicit
B1 obligation that DAV_06 (abelian biduality) depends on at B3 junction.

**Citation.** Mumford, *Abelian Varieties*, TIFR Studies in Mathematics 5
(Oxford, 1974), §§14, 15, pp. 123–146. Historical parent: Cartier,
"Groupes algébriques et groupes formels", Colloque de Bruxelles (1962);
Oort, *Commutative Group Schemes*, LNM 15 (Springer, 1966). Modern: Tate,
"Finite flat group schemes", in *Modular Forms and Fermat's Last Theorem*
(Springer, 1997), pp. 121–154; Stacks Project Tag 0B7R.
-/

namespace MathlibExpansion
namespace Roots
namespace Mumford
namespace T20cLate03_FCGSD

/-- **FCGSD_01** finite commutative group scheme carrier marker (2026-04-24).
A finite commutative group scheme `G/S` is an `S`-group scheme whose structure
morphism `G → S` is finite locally-free with commutative multiplication. Marker
reserves the B1 substrate_gap slot.

Citation: Mumford §14, p. 123. -/
axiom finite_commutative_group_scheme_carrier_marker : True

/-- **FCGSD_02** Cartier dual construction marker (2026-04-24). For a finite
commutative group scheme `G` over `S`, the Cartier dual `G^D := Hom_{S-gp}(G, 𝔾_m)`
is again a finite commutative group scheme over `S`.

Citation: Mumford §14, Thm. 1, p. 127. -/
axiom cartier_dual_construction_marker : True

/-- **FCGSD_03** Cartier biduality marker (2026-04-24). For a finite commutative
group scheme `G/S`, the natural map `G → (G^D)^D` is an isomorphism. Explicit B1
obligation required by DAV_06 (abelian biduality) at the B3 closure.

Citation: Mumford §14, Thm. 1, p. 127. -/
axiom cartier_biduality_marker : True

/-- **FCGSD_04** duality exactness marker (2026-04-24). Cartier duality
`G ↦ G^D` is an exact contravariant functor on the category of finite
commutative group schemes.

Citation: Mumford §14, p. 131. -/
axiom cartier_duality_exactness_marker : True

end T20cLate03_FCGSD
end Mumford
end Roots
end MathlibExpansion
