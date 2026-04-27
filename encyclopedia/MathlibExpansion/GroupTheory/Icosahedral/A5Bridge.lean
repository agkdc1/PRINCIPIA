import Mathlib.GroupTheory.SpecificGroups.Alternating
import MathlibExpansion.Geometry.Polyhedron.Icosahedron

/-!
# The icosahedral `A₅` bridge

This file installs the classical identification between the rotation group of
the regular icosahedron and `A₅`.

The underlying concrete icosahedron package is the single upstream-narrow
boundary introduced in `Geometry/Polyhedron/Icosahedron.lean`. The present file
adds the named multiplicative equivalence needed by later invariant-theory and
Möbius-action chapters.
-/

noncomputable section

namespace MathlibExpansion.GroupTheory.Icosahedral

open MathlibExpansion.Geometry.Polyhedron

/-- Upstream-narrow boundary package for Klein's identification of the
icosahedral rotation group with `A₅`. -/
structure IcosahedralA5Bridge where
  iso : IcosahedralRotationGroup ≃* alternatingGroup (Fin 5)

/-- The icosahedral `A₅` bridge, discharged by the concrete coset model in
`MathlibExpansion.Geometry.Polyhedron.Icosahedron`.

The cited classical statement is Klein (1884), *Vorlesungen über das Ikosaeder
und die Auflösung der Gleichungen vom fünften Grade*, Abschnitt I, Kapitel II:
the icosahedral rotation group is the simple group of order `60`, identified
with `A₅`. In this development, `IcosahedralRotationGroup` is definitionally
the `A₅` coset model, so the bridge is the reflexive multiplicative
equivalence. -/
noncomputable def icosahedralA5Bridge : IcosahedralA5Bridge where
  iso := MulEquiv.refl _

/-- The classical multiplicative equivalence between the icosahedral rotation
group and `A₅`. -/
noncomputable def icosahedralRotationGroupIsoA5 :
    IcosahedralRotationGroup ≃* alternatingGroup (Fin 5) :=
  icosahedralA5Bridge.iso

end MathlibExpansion.GroupTheory.Icosahedral
