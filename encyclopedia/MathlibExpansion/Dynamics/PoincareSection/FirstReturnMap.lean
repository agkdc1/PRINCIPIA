import Mathlib.Dynamics.PeriodicPts.Defs
import MathlibExpansion.Dynamics.PeriodicOrbit.Defs

/-!
# First-return maps on explicit sections

This is the executable coordinate-level Poincare-section shell: a chosen
section, a return time, and the induced self-map on the section. The hard
analytic existence theory is intentionally left out; the file packages the
return-map interface that downstream periodic-point arguments consume.
-/

namespace MathlibExpansion
namespace Dynamics
namespace PoincareSection

structure FirstReturnData (τ : Type*) (α : Type*) where
  flow : τ -> α -> α
  sectionSet : Set α
  returnTime : α -> τ
  next : α -> α
  memSection : forall {x}, x ∈ sectionSet -> next x ∈ sectionSet
  nextEqFlow : forall {x}, x ∈ sectionSet -> next x = flow (returnTime x) x

def firstReturnMap {τ α : Type*} (data : FirstReturnData τ α) : data.sectionSet -> data.sectionSet :=
  fun x => ⟨data.next x, data.memSection x.property⟩

@[simp] theorem firstReturnMap_coe {τ α : Type*} (data : FirstReturnData τ α)
    (x : data.sectionSet) :
    (firstReturnMap data x : α) = data.next x := rfl

theorem fixedPoint_imp_closed_return {τ α : Type*} (data : FirstReturnData τ α)
    {x : α} (hx : x ∈ data.sectionSet) (hfix : data.next x = x) :
    data.flow (data.returnTime x) x = x := by
  simpa [data.nextEqFlow hx] using hfix

theorem fixedPoint_is_periodicPt {τ α : Type*} (data : FirstReturnData τ α)
    {x : α} (hx : x ∈ data.sectionSet) (hfix : data.next x = x) :
    Function.IsPeriodicPt data.next 1 x := by
  change data.next^[1] x = x
  simpa using hfix

theorem fixedPoint_on_section_is_periodicPt {τ α : Type*} (data : FirstReturnData τ α)
    (x : data.sectionSet) (hfix : firstReturnMap data x = x) :
    Function.IsPeriodicPt data.next 1 (x : α) := by
  have hfix' : data.next (x : α) = (x : α) := congrArg Subtype.val hfix
  exact fixedPoint_is_periodicPt data x.property hfix'

end PoincareSection
end Dynamics
end MathlibExpansion
