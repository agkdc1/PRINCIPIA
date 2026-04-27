import Mathlib

/-!
# Complex period lattices

The analytic Weierstrass elliptic-function lane needs a bundled rank-`2`
period lattice in `ℂ`.  Following the Step 5 verdict, the carrier is a
`Submodule ℤ ℂ`, not a bare additive subgroup.
-/

noncomputable section

namespace MathlibExpansion
namespace Complex
namespace Elliptic

/-- A complex period lattice, bundled by two real-linearly independent periods
and carried by the `ℤ`-submodule they generate. -/
structure ComplexPeriodLattice where
  basisVec : Fin 2 → ℂ
  linIndep : LinearIndependent ℝ basisVec

namespace ComplexPeriodLattice

/-- The underlying lattice, viewed as a `ℤ`-submodule of `ℂ`. -/
def carrier (Λ : ComplexPeriodLattice) : Submodule ℤ ℂ :=
  Submodule.span ℤ (Set.range Λ.basisVec)

/-- The first chosen period. -/
abbrev ω₁ (Λ : ComplexPeriodLattice) : ℂ :=
  Λ.basisVec 0

/-- The second chosen period. -/
abbrev ω₂ (Λ : ComplexPeriodLattice) : ℂ :=
  Λ.basisVec 1

@[simp] theorem basisVec_mem_carrier (Λ : ComplexPeriodLattice) (i : Fin 2) :
    Λ.basisVec i ∈ Λ.carrier :=
  Submodule.subset_span ⟨i, rfl⟩

@[simp] theorem omega1_mem_carrier (Λ : ComplexPeriodLattice) :
    Λ.ω₁ ∈ Λ.carrier :=
  Λ.basisVec_mem_carrier 0

@[simp] theorem omega2_mem_carrier (Λ : ComplexPeriodLattice) :
    Λ.ω₂ ∈ Λ.carrier :=
  Λ.basisVec_mem_carrier 1

@[simp] theorem zero_mem_carrier (Λ : ComplexPeriodLattice) :
    (0 : ℂ) ∈ Λ.carrier :=
  Λ.carrier.zero_mem

theorem add_mem_carrier {Λ : ComplexPeriodLattice} {z w : ℂ}
    (hz : z ∈ Λ.carrier) (hw : w ∈ Λ.carrier) :
    z + w ∈ Λ.carrier :=
  Λ.carrier.add_mem hz hw

theorem neg_mem_carrier {Λ : ComplexPeriodLattice} {z : ℂ} (hz : z ∈ Λ.carrier) :
    -z ∈ Λ.carrier :=
  Λ.carrier.neg_mem hz

theorem intCast_smul_mem_carrier {Λ : ComplexPeriodLattice} (n : ℤ) {z : ℂ}
    (hz : z ∈ Λ.carrier) : n • z ∈ Λ.carrier := by
  simpa using Λ.carrier.smul_mem n hz

end ComplexPeriodLattice

end Elliptic
end Complex
end MathlibExpansion
