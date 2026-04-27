import Mathlib.SetTheory.Ordinal.CantorNormalForm
import MathlibExpansion.SetTheory.Ordinal.CantorSecondClassNF
import MathlibExpansion.SetTheory.Ordinal.SecondNumberClass

/-!
# Hausdorff normal-form wrappers

This module exposes the existing ordinal Cantor-normal-form machinery under the
Hausdorff-facing names used by the encyclopedia lane.
-/

namespace MathlibExpansion
namespace SetTheory
namespace Ordinal

universe u

/-- Hausdorff's normal-form list for base `b`. -/
noncomputable def hausdorffNF (b o : _root_.Ordinal.{u}) :
    List (_root_.Ordinal × _root_.Ordinal) :=
  _root_.Ordinal.CNF b o

/-- The Hausdorff normal form folds back to the original ordinal. -/
theorem hausdorffNF_foldr (b o : _root_.Ordinal.{u}) :
    (hausdorffNF b o).foldr (fun p r => b ^ p.1 * p.2 + r) 0 = o := by
  simpa [hausdorffNF] using (_root_.Ordinal.CNF_foldr b o)

/-- Base `ω` recovers the local second-number-class wrapper already in the tree. -/
theorem hausdorffNF_omega_eq_cantorSecondClassNF (o : _root_.Ordinal.{u}) :
    hausdorffNF _root_.Ordinal.omega0 o = cantorSecondClassNF o :=
  rfl

/-- The base-`ω` Hausdorff normal form reconstructs the ordinal. -/
theorem hausdorffNF_omega_foldr (o : _root_.Ordinal.{u}) :
    (hausdorffNF _root_.Ordinal.omega0 o).foldr
        (fun p r => _root_.Ordinal.omega0 ^ p.1 * p.2 + r) 0 = o := by
  simpa [hausdorffNF] using (_root_.Ordinal.CNF_foldr _root_.Ordinal.omega0 o)

end Ordinal
end SetTheory
end MathlibExpansion
