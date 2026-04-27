import Lake
open Lake DSL

package MathlibOverlay where
  leanLibDir := "../../../.lake/packages/mathlib/.lake/build/lib"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.17.0"

lean_lib MathlibOverlay where
  srcDir := ".."
  roots := #[]
  globs := #[
    `Mathlib.NumberTheory.Cyclotomic.CyclotomicCharacterContinuous,
    `Mathlib.NumberTheory.ModularForms.CuspOrder,
    `Mathlib.RingTheory.Polynomial.Eisenstein.Distinguished,
    `Mathlib.RingTheory.PowerSeries.CoeffMulMem,
    `Mathlib.RingTheory.PowerSeries.Trunc
  ]
