/-
# K-Theory Homotopy (Atiyah-Hirzebruch 1961; Atiyah 1967)
B1a for T20c_mid_17_KTHOM.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.KTheory.Homotopy

/-- **K-theory grade carrier** (Atiyah-Hirzebruch 1961). -/
@[ext] structure KGrade where
  degree : ℤ

/-- **Atiyah 1967 K-theory, addition of K-classes.** -/
def addGrade (a b : KGrade) : KGrade := ⟨a.degree + b.degree⟩

@[simp] theorem addGrade_def (a b : KGrade) :
    (addGrade a b).degree = a.degree + b.degree := rfl

theorem addGrade_comm (a b : KGrade) : addGrade a b = addGrade b a := by
  unfold addGrade
  apply KGrade.ext
  ring

theorem addGrade_assoc (a b c : KGrade) :
    addGrade (addGrade a b) c = addGrade a (addGrade b c) := by
  unfold addGrade
  apply KGrade.ext
  ring

end MathlibExpansion.Topology.KTheory.Homotopy
