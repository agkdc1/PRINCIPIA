import MathlibExpansion.Padics.Cp.Basic
import Mathlib.FieldTheory.AbsoluteGaloisGroup

/-!
# The absolute Galois action on `C_p`

This file packages the natural action of `G_{ℚ_p}` on the completion of the
valued algebraic closure of `ℚ_[p]`.

## Design

The action on the completion is defined concretely:

- each `g : Gal(\overline{ℚ_[p]} / ℚ_[p])` acts on
  `AlgebraicClosure ℚ_[p]` by an algebra automorphism;
- assuming the extended `p`-adic valuation is invariant under this action, each
  automorphism is uniformly continuous;
- the completion functor then produces a ring automorphism of `Cp p`.

Two upstream-narrow boundaries remain in this pinned Mathlib `v4.17.0`
snapshot:

- invariance of the chosen extended `p`-adic valuation under
  `G_{ℚ_p}`;
- joint continuity of the induced action `G_{ℚ_p} × Cp p → Cp p`.

The valuation-invariance input is the standard consequence of uniqueness of
the extension of a complete nonarchimedean absolute value to finite algebraic
extensions (Serre, *Local Fields*, Ch. II §2, Proposition 3; also cited as
Neukirch, *Algebraic Number Theory*, Ch. II, Theorem 4.8). The continuity input
is the `C`-action setup used in Tate, "p-Divisible Groups" (1967), §3.3,
immediately before Theorem 1, where continuous cochains for the absolute Galois
action on the completed algebraic closure are introduced.
-/

noncomputable section

open UniformSpace

namespace MathlibExpansion.Padics

open MathlibExpansion.FieldTheory.AlgebraicClosure

/-- The absolute Galois group of `ℚ_[p]`. -/
abbrev PadicGaloisGroup (p : ℕ) [Fact p.Prime] :=
  AlgebraicClosure ℚ_[p] ≃ₐ[ℚ_[p]] AlgebraicClosure ℚ_[p]

/-- Upstream-narrow boundary (Serre, *Local Fields*, Ch. II §2,
Proposition 3; Neukirch, *Algebraic Number Theory*, Ch. II, Theorem 4.8):
the canonical extended `p`-adic valuation on `AlgebraicClosure ℚ_[p]` is
invariant under the absolute Galois group action.

Mathematically this follows from uniqueness of the extension of the complete
`p`-adic absolute value to every finite algebraic subextension. The local
`PadicValuedAlgebraicClosure` substrate currently records existence of an
extension, but not this uniqueness theorem, so the invariant equality remains
as the exact upstream boundary needed by `galoisUniformContinuous`. -/
axiom algebraicClosurePadicValuation_galoisInvariant
    (p : ℕ) [Fact p.Prime]
    (g : PadicGaloisGroup p) (x : AlgebraicClosure ℚ_[p]) :
    algebraicClosurePadicValuation p (g.toFun x) = algebraicClosurePadicValuation p x

/-- Every element of the absolute Galois group acts uniformly continuously on
the valued algebraic closure. -/
theorem galoisUniformContinuous (p : ℕ) [Fact p.Prime]
    (g : PadicGaloisGroup p) :
    UniformContinuous (fun x : AlgebraicClosure ℚ_[p] => g x) := by
  let hBasis :=
    Valued.hasBasis_uniformity (AlgebraicClosure ℚ_[p]) NNReal
  rw [hBasis.uniformContinuous_iff hBasis]
  intro γ _
  refine ⟨γ, trivial, ?_⟩
  intro x y hxy
  have hg :
      algebraicClosurePadicValuation p (g (y - x)) =
        algebraicClosurePadicValuation p (y - x) := by
    simpa using
      (algebraicClosurePadicValuation_galoisInvariant (p := p) (g := g) (x := y - x))
  simpa only [Set.mem_setOf_eq] using
    (show algebraicClosurePadicValuation p (g y - g x) < γ from by
      rw [show g y - g x = g (y - x) by simp]
      rw [hg]
      simpa only [Set.mem_setOf_eq] using hxy)

/-- The ring homomorphism on `Cp p` induced by an absolute Galois automorphism. -/
noncomputable def galoisCompletionRingHom (p : ℕ) [Fact p.Prime]
    (g : PadicGaloisGroup p) :
    Cp p →+* Cp p :=
  UniformSpace.Completion.mapRingHom
    (f := g.toRingHom)
    (galoisUniformContinuous p g).continuous

@[simp]
theorem galoisCompletionRingHom_coe (p : ℕ) [Fact p.Prime]
    (g : PadicGaloisGroup p) (x : AlgebraicClosure ℚ_[p]) :
    galoisCompletionRingHom p g x = (g x : AlgebraicClosure ℚ_[p]) := by
  simpa [galoisCompletionRingHom] using
    (UniformSpace.Completion.map_coe
      (f := fun y : AlgebraicClosure ℚ_[p] => g y)
      (galoisUniformContinuous p g) x)

/-- The absolute Galois action on `Cp p`, obtained by extending the action on
`AlgebraicClosure ℚ_[p]` to the completion. -/
noncomputable def galoisCompletionEquiv (p : ℕ) [Fact p.Prime]
    (g : PadicGaloisGroup p) :
    Cp p ≃+* Cp p :=
  RingEquiv.ofHomInv
    (galoisCompletionRingHom p g)
    (galoisCompletionRingHom p g.symm)
    (by
      ext x
      let lhs : Cp p → Cp p :=
        fun z => galoisCompletionRingHom p g.symm (galoisCompletionRingHom p g z)
      have hEq : lhs = id := by
        apply UniformSpace.Completion.ext
        · simpa [lhs, galoisCompletionRingHom] using
            ((UniformSpace.Completion.continuous_map
                (f := fun y : AlgebraicClosure ℚ_[p] => g.symm y)).comp
              (UniformSpace.Completion.continuous_map
                (f := fun y : AlgebraicClosure ℚ_[p] => g y)))
        · exact continuous_id
        · intro a
          simp [lhs, galoisCompletionRingHom_coe]
      simpa [lhs] using congrArg (fun f : Cp p → Cp p => f x) hEq)
    (by
      ext x
      let lhs : Cp p → Cp p :=
        fun z => galoisCompletionRingHom p g (galoisCompletionRingHom p g.symm z)
      have hEq : lhs = id := by
        apply UniformSpace.Completion.ext
        · simpa [lhs, galoisCompletionRingHom] using
            ((UniformSpace.Completion.continuous_map
                (f := fun y : AlgebraicClosure ℚ_[p] => g y)).comp
              (UniformSpace.Completion.continuous_map
                (f := fun y : AlgebraicClosure ℚ_[p] => g.symm y)))
        · exact continuous_id
        · intro a
          simp [lhs, galoisCompletionRingHom_coe]
      simpa [lhs] using congrArg (fun f : Cp p → Cp p => f x) hEq)

@[simp]
theorem galoisCompletionEquiv_coe (p : ℕ) [Fact p.Prime]
    (g : PadicGaloisGroup p) (x : AlgebraicClosure ℚ_[p]) :
    galoisCompletionEquiv p g (x : Cp p) = (g x : AlgebraicClosure ℚ_[p]) := by
  simp [galoisCompletionEquiv, galoisCompletionRingHom_coe]

/-- The absolute Galois action on `Cp p` as a multiplicative action into ring
automorphisms. -/
noncomputable def galoisAction (p : ℕ) [Fact p.Prime] :
    PadicGaloisGroup p →* (Cp p ≃+* Cp p) where
  toFun := galoisCompletionEquiv p
  map_one' := by
    ext x
    let lhs : Cp p → Cp p := galoisCompletionEquiv p 1
    have hEq : lhs = id := by
      apply UniformSpace.Completion.ext
      · simpa [lhs, galoisCompletionEquiv, galoisCompletionRingHom] using
          (UniformSpace.Completion.continuous_map
            (f := fun y : AlgebraicClosure ℚ_[p] => (1 : PadicGaloisGroup p) y))
      · exact continuous_id
      · intro a
        simp [lhs, galoisCompletionEquiv, galoisCompletionRingHom_coe]
    simpa [lhs] using congrArg (fun f : Cp p → Cp p => f x) hEq
  map_mul' g h := by
    ext x
    let lhs : Cp p → Cp p := galoisCompletionEquiv p (g * h)
    let rhs : Cp p → Cp p := fun z => galoisCompletionEquiv p g (galoisCompletionEquiv p h z)
    have hEq : lhs = rhs := by
      apply UniformSpace.Completion.ext
      · simpa [lhs, galoisCompletionEquiv, galoisCompletionRingHom] using
          (UniformSpace.Completion.continuous_map
            (f := fun y : AlgebraicClosure ℚ_[p] => (g * h) y))
      · simpa [rhs, galoisCompletionEquiv, galoisCompletionRingHom] using
          ((UniformSpace.Completion.continuous_map
              (f := fun y : AlgebraicClosure ℚ_[p] => g y)).comp
            (UniformSpace.Completion.continuous_map
              (f := fun y : AlgebraicClosure ℚ_[p] => h y)))
      · intro a
        simp [lhs, rhs, galoisCompletionEquiv, galoisCompletionRingHom_coe]
    simpa [lhs, rhs] using congrArg (fun f : Cp p → Cp p => f x) hEq

@[simp]
theorem galoisAction_coe_apply (p : ℕ) [Fact p.Prime]
    (g : PadicGaloisGroup p) (x : AlgebraicClosure ℚ_[p]) :
    galoisAction p g (x : Cp p) = (g x : AlgebraicClosure ℚ_[p]) := by
  simp [galoisAction, galoisCompletionEquiv_coe]

@[simp]
theorem galoisAction_padicRat_apply (p : ℕ) [Fact p.Prime]
    (g : PadicGaloisGroup p) (x : ℚ_[p]) :
    galoisAction p g (algebraMap ℚ_[p] (Cp p) x) = algebraMap ℚ_[p] (Cp p) x := by
  rw [algebraMap_padicRatToCp]
  rw [galoisAction_coe_apply]
  exact congrArg (fun z : AlgebraicClosure ℚ_[p] => (z : Cp p)) (g.commutes x)

/-- Upstream-narrow boundary (Tate, "p-Divisible Groups" (1967), §3.3,
Theorem 1 setup): the absolute Galois action on `Cp p` is jointly continuous.

Tate's §3.3 introduces the absolute Galois action on the completion `C` of the
algebraic closure by continuity before forming the continuous cohomology groups
in Theorem 1. The pinned Mathlib snapshot has the Krull topology and completion
functor APIs used in the construction above, but it has no theorem packaging
this completed action as a jointly continuous action. -/
axiom galoisAction_continuous (p : ℕ) [Fact p.Prime] :
    Continuous (fun gx : PadicGaloisGroup p × Cp p => galoisAction p gx.1 gx.2)

end MathlibExpansion.Padics
