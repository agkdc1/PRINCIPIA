import Mathlib.NumberTheory.DirichletCharacter.Basic
import MathlibExpansion.Roots.Iwasawa.Basic
import MathlibExpansion.Roots.Iwasawa.StructureTheorem

/-!
# MazurWiles1984.Boundary

Opaque interface for the Mazur–Wiles 1984 main conjecture.

## Scope

Classical Mazur–Wiles statement only. Base ring fixed to `ℤ_[p]`, character
valued in `ℤ_[p]`, even parity required.

## Opaque strategy

`xinfDatum` is the single `opaque` declaration. Its return type `LambdaModuleDatum p`
is a structure that bundles the carrier type with all required typeclass instances.
The structure is inhabited by the trivial (PUnit) module, so the `opaque` is valid
without introducing any `axiom`.

`XInf` is then defined as the carrier of `xinfDatum`, and the typeclass instances
(`AddCommGroup`, `Module`, `Module.Finite`) are derived from the bundle fields.

`MainConjecture.lean` now splits the main-conjecture equality into two narrow
inclusion-direction axioms. `#print axioms` on any declaration in this file
shows no Lean `axiom`.

## Doctrine-v2 safety

No `sorry`, no `axiom` in this file.
-/

open scoped Padic

namespace MazurWiles1984

variable (p : ℕ) [Fact p.Prime]

/-- Input datum for the Mazur–Wiles main conjecture.

`n` is the tame conductor (coprime to `p`); the `p`-part comes from the
cyclotomic tower. `χ` is a Dirichlet character valued in `ℤ_[p]`, required
to be even so that the corresponding Selmer group is nontrivial. -/
structure CharacterInput where
  n       : ℕ
  coprime : Nat.Coprime p n
  χ       : DirichletCharacter ℤ_[p] n
  isEven  : χ.Even

/-! ## Bundled module datum -/

/-- Bundle holding a carrier type together with all the Λ-module structure
needed for the Mazur–Wiles construction.

The bundle lives in `Type 1` and is inhabited by the trivial PUnit module,
so `opaque xinfDatum : LambdaModuleDatum p d` does not require an `axiom`. -/
structure LambdaModuleDatum (d : CharacterInput p) : Type 1 where
  carrier  : Type
  instACG  : AddCommGroup carrier
  instMod  : Module (PowerSeries ℤ_[p]) carrier
  instFin  : Module.Finite (PowerSeries ℤ_[p]) carrier

/-- `LambdaModuleDatum p d` is inhabited by the zero/trivial module `PUnit`. -/
private def trivialLambdaModuleDatum (d : CharacterInput p) : LambdaModuleDatum p d where
  carrier := PUnit
  instACG := (inferInstance : AddCommGroup PUnit)
  instMod := (inferInstance : Module (PowerSeries ℤ_[p]) PUnit)
  instFin := by
    refine Module.Finite.mk ?_
    have htop : (⊤ : Submodule (PowerSeries ℤ_[p]) PUnit) = ⊥ := by
      ext x
      simp
    rw [htop]
    exact Submodule.fg_bot

/-- `LambdaModuleDatum p d` is inhabited by the zero/trivial module `PUnit`. -/
instance (d : CharacterInput p) : Inhabited (LambdaModuleDatum p d) :=
  ⟨trivialLambdaModuleDatum (p := p) d⟩

/-! ## Opaque X_∞ bundle -/

/-- The opaque X_∞ datum: the Pontryagin dual of the `p`-power Selmer group over
the cyclotomic tower `ℚ(ζ_{p^∞})`, together with its Λ-module structure.

This is the single `opaque` in the file. `LambdaModuleDatum p d` is inhabited
(trivially, via PUnit), so no `axiom` is needed. -/
opaque xinfDatum (d : CharacterInput p) : LambdaModuleDatum p d

/-- The underlying type of X_∞. -/
abbrev XInf (d : CharacterInput p) : Type := (xinfDatum p d).carrier

instance (d : CharacterInput p) : AddCommGroup (XInf p d) := (xinfDatum p d).instACG
instance (d : CharacterInput p) : Module (PowerSeries ℤ_[p]) (XInf p d) := (xinfDatum p d).instMod
instance (d : CharacterInput p) : Module.Finite (PowerSeries ℤ_[p]) (XInf p d) :=
  (xinfDatum p d).instFin

/-- Package `XInf p d` as a `FinitelyGeneratedLambdaModule.{0,0}` so that
`MathlibExpansion.Roots.Iwasawa.characteristicIdeal` can be applied to it.

The carrier `XInf p d = (xinfDatum p d).carrier : Type` is in universe 0,
matching the `.{0,0}` restriction of `characteristicIdeal`. -/
noncomputable def XInfAsModule (d : CharacterInput p) :
    MathlibExpansion.Roots.Iwasawa.FinitelyGeneratedLambdaModule.{0, 0} ℤ_[p] where
  carrier := XInf p d
  finite   := inferInstance

/-! ## Opaque p-adic L-function -/

/-- The Kubota–Leopoldt `p`-adic L-function attached to `χ`, viewed as an
element of the Iwasawa algebra `Λ = ℤ_[p][[T]]`. Opaque: its construction
via Stickelberger elements or measures is not formalized here. -/
opaque Lp (d : CharacterInput p) : PowerSeries ℤ_[p]

end MazurWiles1984
