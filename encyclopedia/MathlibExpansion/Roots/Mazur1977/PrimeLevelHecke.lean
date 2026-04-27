import Mathlib

/-!
# Prime-level Hecke carrier (Mazur 1977, §6 — Ribet-consumed fragment)

Defines the carrier shape `PrimeLevelHeckeCarrier R M p` for the Ribet-
consumed fragment of Mazur's Eisenstein-ideal work at prime level
`Γ₀(p)`. The carrier is a commutative `R`-algebra `T` acting on an
`R`-module `M` via an algebra homomorphism `toEnd : T →ₐ[R] Module.End R M`,
together with named `Hecke` generators `T_q` indexed by primes `q ≠ p`.

**Scope contract (CONSENSUS-bounded).** This carrier is intentionally
restricted to the slice consumed by Ribet 1990: weight 2, prime level
`Γ₀(p)`. It is NOT the full Eisenstein Ideal paper. It is NOT the Mazur
torsion theorem. It does NOT carry `J₀(p)` / Néron / component-group
geometry. Squarefree level and Tilouine 1995 are explicit follow-on
breaches.

**Doctrine v2 (poison-class dodges).**
- Every struct field is typed data or a typed equation. No `Prop := True`
  laundering (T0). No `(statement : Prop, proof : statement)` witness
  pairs (T1). No `IsFoo_requires_Bar : Prop` projection stubs.
- `toEnd` is an `AlgHom`, not a bare `RingHom`; it transports the `R`-module
  structure on `M` through the algebra.
- `generator` is indexed by the dependent subtype `{q : ℕ // q.Prime ∧ q ≠ p}`,
  not by a free-choice function.
- Pairwise commutativity of the `T_q` is derived from `CommRing T`, and
  commutativity of their images in `Module.End R M` is exposed as a theorem.
  This is the shape the Ribet consumer (and the optional `ofAdjoin` builder)
  needs.

The optional builder `ofAdjoin` is deferred to a second pass — the Mathlib
availability of `CommRing (Algebra.adjoin R (Set.range f))` from pairwise
`Commute` on `Range f` is OPEN per r3 CONSENSUS and is tracked as a
contingent theorem gap. Downstream construction of the carrier from modular-
symbol cohomology proceeds via a direct `Algebra.adjoin` once that lemma
lands upstream, or via a wrapper package in a dedicated follow-on.
-/

namespace MathlibExpansion.Roots.Mazur1977

universe u v w

/-- **Prime-level Hecke carrier.**

The Ribet-consumed shape of the weight-2 Hecke algebra at prime level
`Γ₀(p)`, acting on an abstract carrier module `M` over a base ring `R`.

`T` is the carrier type of the Hecke algebra and is itself a commutative
`R`-algebra. `toEnd` transports `T` into `Module.End R M` as an
`R`-algebra homomorphism. `generator q` picks out the Hecke operator
`T_q` for primes `q ≠ p`, and `generator_commute` records pairwise
commutativity in the ambient endomorphism algebra — which is automatic
from `CommRing T` but is exposed here as a named field so downstream
consumers (e.g. Ribet 1990) can invoke it without re-deriving it. -/
structure PrimeLevelHeckeCarrier
    (R : Type u) (M : Type v) [CommRing R] [AddCommGroup M] [Module R M]
    (p : ℕ) where
  /-- The carrier type of the prime-level Hecke algebra `T`. -/
  T : Type w
  /-- `T` is a commutative ring. -/
  instCommRing : CommRing T
  /-- `T` is an `R`-algebra. -/
  instAlgebra : Algebra R T
  /-- Algebra homomorphism `T →ₐ[R] Module.End R M` realizing the action. -/
  toEnd : T →ₐ[R] Module.End R M
  /-- Hecke generator `T_q` for each prime `q ≠ p`. -/
  generator : {q : ℕ // q.Prime ∧ q ≠ p} → T

attribute [instance] PrimeLevelHeckeCarrier.instCommRing
attribute [instance] PrimeLevelHeckeCarrier.instAlgebra

namespace PrimeLevelHeckeCarrier

variable {R : Type u} {M : Type v} [CommRing R] [AddCommGroup M] [Module R M]
variable {p : ℕ}

/-- The `T_q` generators commute pairwise in `T`. This follows immediately
from `CommRing T` and is exposed as a named lemma because Ribet-facing
consumers phrase commutativity on the named generators rather than on
arbitrary elements. -/
theorem generator_commute (C : PrimeLevelHeckeCarrier.{u,v,w} R M p)
    (i j : {q : ℕ // q.Prime ∧ q ≠ p}) :
    Commute (C.generator i) (C.generator j) :=
  (mul_comm (C.generator i) (C.generator j))

/-- The `T_q` endomorphisms (image under `toEnd`) commute pairwise. -/
theorem generator_toEnd_commute (C : PrimeLevelHeckeCarrier.{u,v,w} R M p)
    (i j : {q : ℕ // q.Prime ∧ q ≠ p}) :
    Commute (C.toEnd (C.generator i)) (C.toEnd (C.generator j)) := by
  have h := C.generator_commute i j
  have : C.toEnd (C.generator i * C.generator j)
          = C.toEnd (C.generator j * C.generator i) := by
    rw [h.eq]
  simpa [Commute, SemiconjBy, map_mul] using this

end PrimeLevelHeckeCarrier

end MathlibExpansion.Roots.Mazur1977
