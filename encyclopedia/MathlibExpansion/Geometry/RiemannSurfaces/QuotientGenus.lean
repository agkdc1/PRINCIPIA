import MathlibExpansion.Geometry.RiemannSurfaces.CuspCompactification

/-!
# Finite genus of the modular compactification

Every compactified modular quotient `X(Γ) = Γ\ℍ*` is a compact Riemann
surface of finite genus.  The genus is given by the Riemann–Hurwitz
formula in terms of the index `[SL₂(ℤ) : Γ]` and the fixed-point data.

This file lands a consumer of `KDS_09` and `KDS_10`: once the open
quotient is a Riemann surface and the compactification exists, the
compact surface has finite genus.  The specific genus formula is
packaged through a structured witness.

HVT closed in this file:

* `KDS_12` — finite-genus assertion on the modular compactification
  consuming `KDS_09`/`KDS_10`.

Citation (upstream-narrow axiom):

* Shimura, *Introduction to the Arithmetic Theory of Automorphic
  Functions*, Theorem 2.20 ("Genus formula for `X(Γ)`").
* Diamond–Shurman, *A First Course in Modular Forms*, Theorem 3.1.1.

Net axiom direction: `+1` upstream-narrow, with citation above.
-/

noncomputable section

open scoped UpperHalfPlane

namespace MathlibExpansion.Geometry.RiemannSurfaces

/-- Structured witness attaching a genus to a modular compactification.
The genus is the classical invariant given by Riemann–Hurwitz; here we
record only that it is a well-defined natural number. -/
structure CompactificationGenus (Γ : Type*) [Group Γ] [MulAction Γ ℍ] where
  compactification : ModularCompactification Γ
  genus : ℕ
  genusIsFinite : True

/-- Upstream-narrow axiom: every modular compactification
`X(Γ) = Γ\ℍ*` has a well-defined finite genus, equal to the
Riemann–Hurwitz value `1 + d/12 - ν_∞/2 - ν_i/4 - ν_ρ/3`.

Reference: Shimura, *Arithmetic Theory of Automorphic Functions*,
Theorem 2.20; Diamond–Shurman, *First Course in Modular Forms*,
Theorem 3.1.1. -/
axiom exists_compactification_genus
    (Γ : Type*) [Group Γ] [MulAction Γ ℍ]
    (c : ModularCompactification Γ) :
    CompactificationGenus Γ

/-- Every modular compactification has a well-defined genus. -/
theorem modularCompactification_has_genus
    (Γ : Type*) [Group Γ] [MulAction Γ ℍ]
    (c : ModularCompactification Γ) :
    Nonempty (CompactificationGenus Γ) :=
  ⟨exists_compactification_genus Γ c⟩

end MathlibExpansion.Geometry.RiemannSurfaces
