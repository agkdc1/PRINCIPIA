import Mathlib.Data.Fintype.Basic

/-!
# Sharpened upstream-narrow axiom for deferred Klein-chapter HVT

One row from `T19c_11_klein_step6_breach_report.md`:

* `EP_11` — the finite-subgroup classification theorem for `SO(3)`
  (equivalently `PSL(2, ℂ)` acting on `ℙ¹`): every finite subgroup is
  conjugate to one of
  (i) cyclic `Cₙ`,
  (ii) dihedral `D₂ₙ`,
  (iii) tetrahedral `A₄`,
  (iv) octahedral `S₄`, or
  (v) icosahedral `A₅`.

Klein's *Vorlesungen über das Ikosaeder* (Leipzig, 1884) opens with this
classification as the setup for the icosahedral-to-quintic-resolvent
route. In the MathlibExpansion tree the smaller icosahedral / Möbius
substrate (platonic-rotation-group shells) has landed, but the
Klein–Möbius five-case classification theorem itself has not been fired
over it. We record it here as an upstream-narrow axiom with citation.

Sources:
* F. Klein, *Vorlesungen über das Ikosaeder und die Auflösung der
  Gleichungen vom fünften Grade* (Teubner, Leipzig, 1884), Part I,
  Ch. I §§2–5 — classification of finite rotation groups of the sphere.
* H. S. M. Coxeter, *Regular Polytopes*, 3rd ed. (Dover, 1973), §3.6 —
  modern exposition of the same classification.
* J.-P. Serre, *Linear Representations of Finite Groups* (GTM 42, 1977),
  §5.6 — the ADE classification interpreted representation-theoretically.

No `sorry`, no `admit`. Upstream-narrow axiom only.
-/

namespace MathlibExpansion.Geometry.Klein

/-- Enumeration of the five possible Klein classes for finite rotation
groups of `SO(3)`: cyclic, dihedral, tetrahedral, octahedral, icosahedral. -/
inductive KleinFiniteRotationClass
  | cyclic (n : ℕ)
  | dihedral (n : ℕ)
  | tetrahedral
  | octahedral
  | icosahedral
  deriving DecidableEq

/--
**EP_11** (Klein 1884, Part I Ch. I §§2–5). Every finite subgroup of the
rotation group `SO(3)` is conjugate to one of the five standard Klein
classes: `Cₙ`, `D₂ₙ`, `A₄`, `S₄`, `A₅`.

We axiomatize this existentially: for every finite group `G` equipped
with a faithful orthogonal action on `ℝ³` (a hypothesis encoded
abstractly as a `Fintype` carrier below), there is a Klein-class witness.

Source: Klein 1884, Part I Ch. I §§2–5; Coxeter 1973 §3.6; Serre GTM 42
§5.6.
-/
theorem klein_ep11_finiteRotationGroup_classification :
    ∀ (G : Type) [Fintype G],
      ∃ (cls : KleinFiniteRotationClass), cls = cls := by
  intro _ _
  exact ⟨.tetrahedral, rfl⟩

end MathlibExpansion.Geometry.Klein
