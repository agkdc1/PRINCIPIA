import Mathlib

/-!
# Maurer-Cartan form

This file packages the left-translation trivialization of the tangent space on
the unit group of an algebra, i.e. the Banach-algebra model of the Maurer-Cartan
form.
-/

noncomputable section

namespace MathlibExpansion.LieGroups.Chevalley

section

variable {𝕜 : Type*} [RCLike 𝕜]
variable {A : Type*} [NormedRing A] [NormedAlgebra 𝕜 A]

/-- The Maurer-Cartan form at `g`, written in ambient algebra coordinates. -/
def maurerCartanAt (g : Aˣ) : A →ₗ[𝕜] A :=
  LinearMap.mulLeft 𝕜 (↑g⁻¹ : A)

/-- The inverse linear trivialization corresponding to left translation by `g`. -/
def maurerCartanAtInv (g : Aˣ) : A →ₗ[𝕜] A :=
  LinearMap.mulLeft 𝕜 (↑g : A)

@[simp] theorem maurerCartanAt_apply (g : Aˣ) (v : A) :
    maurerCartanAt (𝕜 := 𝕜) g v = ↑g⁻¹ * v :=
  LinearMap.mulLeft_apply 𝕜 (↑g⁻¹ : A) v

@[simp] theorem maurerCartanAtInv_apply (g : Aˣ) (v : A) :
    maurerCartanAtInv (𝕜 := 𝕜) g v = ↑g * v :=
  LinearMap.mulLeft_apply 𝕜 (↑g : A) v

@[simp] theorem maurerCartanAt_one :
    maurerCartanAt (𝕜 := 𝕜) (1 : Aˣ) = LinearMap.id := by
  ext v
  simp [maurerCartanAt]

@[simp] theorem maurerCartanAtInv_one :
    maurerCartanAtInv (𝕜 := 𝕜) (1 : Aˣ) = LinearMap.id := by
  ext v
  simp [maurerCartanAtInv]

theorem maurerCartanAt_mul (g h : Aˣ) :
    maurerCartanAt (𝕜 := 𝕜) (g * h) =
      (maurerCartanAt (𝕜 := 𝕜) h).comp (maurerCartanAt (𝕜 := 𝕜) g) := by
  ext v
  simp [maurerCartanAt, mul_assoc]

theorem maurerCartanAt_left_translate (g h : Aˣ) (v : A) :
    maurerCartanAt (𝕜 := 𝕜) (g * h) ((g : A) * v) =
      maurerCartanAt (𝕜 := 𝕜) h v := by
  simp [maurerCartanAt, mul_assoc]

@[simp] theorem maurerCartanAt_leftInverse (g : Aˣ) :
    (maurerCartanAt (𝕜 := 𝕜) g).comp (maurerCartanAtInv (𝕜 := 𝕜) g) = LinearMap.id := by
  ext v
  simp [maurerCartanAt, maurerCartanAtInv, mul_assoc]

@[simp] theorem maurerCartanAt_rightInverse (g : Aˣ) :
    (maurerCartanAtInv (𝕜 := 𝕜) g).comp (maurerCartanAt (𝕜 := 𝕜) g) = LinearMap.id := by
  ext v
  simp [maurerCartanAt, maurerCartanAtInv, mul_assoc]

end

end MathlibExpansion.LieGroups.Chevalley
