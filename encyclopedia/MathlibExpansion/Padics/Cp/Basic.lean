import MathlibExpansion.FieldTheory.AlgebraicClosure.Valued

/-!
# The basic `C_p` object

This file introduces the local `C_p` carrier used by the Hodge-Tate side of the
`mathlib-expansion` namespace in the pinned Mathlib `v4.17.0` snapshot.

The object is the completion of the valued algebraic closure of `ℚ_[p]` supplied
by `MathlibExpansion.FieldTheory.AlgebraicClosure.Valued`.

## What is provided

- `MathlibExpansion.Padics.Cp p` as
  `UniformSpace.Completion (AlgebraicClosure ℚ_[p])`;
- the canonical ring embedding
  `AlgebraicClosure ℚ_[p] →+* Cp p`;
- the induced `ℚ_[p]`-algebra structure on `Cp p`.

The `Field`, `TopologicalDivisionRing`, `CompleteSpace`, and
`Algebra (AlgebraicClosure ℚ_[p]) (Cp p)` instances are inherited directly from
the completion machinery; the only instance added here is the explicit
`Algebra ℚ_[p] (Cp p)` instance.
-/

noncomputable section

open UniformSpace

namespace MathlibExpansion.Padics

open MathlibExpansion.FieldTheory.AlgebraicClosure

/-- The p-adic completion of the algebraic closure of `ℚ_[p]`. -/
abbrev Cp (p : ℕ) [Fact p.Prime] :=
  PadicAlgClosureCompletion p

/-- The canonical ring embedding of `AlgebraicClosure ℚ_[p]` into `Cp p`. -/
abbrev algebraicClosureToCp (p : ℕ) [Fact p.Prime] :
    AlgebraicClosure ℚ_[p] →+* Cp p :=
  UniformSpace.Completion.coeRingHom

/-- The canonical ring embedding of `ℚ_[p]` into `Cp p`. -/
noncomputable def padicRatToCp (p : ℕ) [Fact p.Prime] :
    ℚ_[p] →+* Cp p :=
  (algebraicClosureToCp p).comp (algebraMap ℚ_[p] (AlgebraicClosure ℚ_[p]))

@[simp]
theorem padicRatToCp_apply (p : ℕ) [Fact p.Prime] (x : ℚ_[p]) :
    padicRatToCp p x =
      ((algebraMap ℚ_[p] (AlgebraicClosure ℚ_[p]) x : AlgebraicClosure ℚ_[p]) : Cp p) :=
  rfl

/-- The completion `Cp p` is canonically a `ℚ_[p]`-algebra via the composite
`ℚ_[p] → AlgebraicClosure ℚ_[p] → Cp p`. -/
noncomputable instance instAlgebraPadicRatCp (p : ℕ) [Fact p.Prime] :
    Algebra ℚ_[p] (Cp p) :=
  (padicRatToCp p).toAlgebra

@[simp]
theorem algebraMap_padicRatToCp (p : ℕ) [Fact p.Prime] (x : ℚ_[p]) :
    algebraMap ℚ_[p] (Cp p) x =
      ((algebraMap ℚ_[p] (AlgebraicClosure ℚ_[p]) x : AlgebraicClosure ℚ_[p]) : Cp p) := by
  simpa [padicRatToCp_apply] using
    congrArg (fun f : ℚ_[p] →+* Cp p => f x)
      (RingHom.algebraMap_toAlgebra (padicRatToCp p))

@[simp]
theorem algebraicClosureToCp_apply (p : ℕ) [Fact p.Prime]
    (x : AlgebraicClosure ℚ_[p]) :
    algebraicClosureToCp p x = (x : Cp p) :=
  rfl

end MathlibExpansion.Padics
