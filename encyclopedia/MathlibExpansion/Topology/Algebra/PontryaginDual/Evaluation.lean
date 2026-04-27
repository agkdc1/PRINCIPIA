import Mathlib.Topology.Algebra.PontryaginDual

/-!
# Evaluation into the double Pontryagin dual

This file packages the canonical evaluation pairing
`G × PontryaginDual G → Circle` as a point of the double dual and as a
continuous homomorphism `G → PontryaginDual (PontryaginDual G)`.
-/

namespace PontryaginDual

universe u v

variable {G : Type u} {H : Type v}
variable [CommGroup G] [CommGroup H]
variable [TopologicalSpace G] [TopologicalSpace H]
variable [IsTopologicalGroup G] [IsTopologicalGroup H]

/-- Evaluation at `g : G` defines a character on `PontryaginDual G`. -/
noncomputable def doubleDualEval (g : G) : PontryaginDual (PontryaginDual G) where
  toFun χ := χ g
  map_one' := by
    rfl
  map_mul' χ ψ := by
    rfl
  continuous_toFun := by
    change Continuous fun χ : ContinuousMonoidHom G Circle => χ g
    exact continuous_eval_const g

@[simp]
theorem doubleDualEval_apply (g : G) (χ : PontryaginDual G) :
    doubleDualEval g χ = χ g := rfl

/-- The canonical evaluation homomorphism into the double dual. -/
noncomputable def evalHom [LocallyCompactSpace G] :
    ContinuousMonoidHom G (PontryaginDual (PontryaginDual G)) where
  toFun := doubleDualEval
  map_one' := by
    apply ContinuousMonoidHom.ext
    intro χ
    change χ 1 = 1
    simpa using χ.map_one
  map_mul' g h := by
    apply ContinuousMonoidHom.ext
    intro χ
    change χ (g * h) = χ g * χ h
    simpa using χ.map_mul g h
  continuous_toFun := by
    refine ContinuousMonoidHom.continuous_of_continuous_uncurry doubleDualEval ?_
    simpa [Function.uncurry, doubleDualEval] using
      (show Continuous fun p : ContinuousMonoidHom G Circle × G => p.1 p.2 from continuous_eval).comp
        (continuous_snd.prod_mk continuous_fst)

@[simp]
theorem evalHom_apply [LocallyCompactSpace G] (g : G) :
    evalHom (G := G) g = doubleDualEval g := rfl

@[simp]
theorem evalHom_apply_apply [LocallyCompactSpace G] (g : G) (χ : PontryaginDual G) :
    evalHom (G := G) g χ = χ g := rfl

@[simp]
theorem map_doubleDualEval (f : ContinuousMonoidHom G H) (g : G) :
    PontryaginDual.map (PontryaginDual.map f) (doubleDualEval g) =
      doubleDualEval (f g) := by
  apply ContinuousMonoidHom.ext
  intro χ
  rfl

end PontryaginDual
