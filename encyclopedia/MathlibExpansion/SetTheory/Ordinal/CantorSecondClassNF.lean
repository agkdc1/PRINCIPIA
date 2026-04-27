import Mathlib.SetTheory.Ordinal.CantorNormalForm
import MathlibExpansion.SetTheory.Ordinal.SecondNumberClass

/-!
# Cantor normal form in the second number-class

This file packages the existing Mathlib CNF construction under the historical
second-number-class interface used by Cantor's text.
-/

namespace MathlibExpansion.SetTheory.Ordinal

universe u

noncomputable def cantorSecondClassNF (o : _root_.Ordinal.{u}) :
    List (_root_.Ordinal × _root_.Ordinal) :=
  _root_.Ordinal.CNF _root_.Ordinal.omega0 o

theorem cantorSecondClassNF_foldr (o : _root_.Ordinal.{u}) :
    (cantorSecondClassNF o).foldr
        (fun p r => _root_.Ordinal.omega0 ^ p.1 * p.2 + r) 0 = o := by
  simpa [cantorSecondClassNF] using (_root_.Ordinal.CNF_foldr _root_.Ordinal.omega0 o)

theorem cantorSecondClassNF_sorted (o : _root_.Ordinal.{u}) :
    ((cantorSecondClassNF o).map Prod.fst).Sorted (· > ·) := by
  simpa [cantorSecondClassNF] using (_root_.Ordinal.CNF_sorted _root_.Ordinal.omega0 o)

theorem exponent_card_le_aleph0_of_mem_cantorSecondClassNF
    {o : _root_.Ordinal.{u}} (ho : o ∈ secondNumberClass)
    {x : _root_.Ordinal × _root_.Ordinal} (hx : x ∈ cantorSecondClassNF o) :
    x.1.card ≤ _root_.Cardinal.aleph0 := by
  have hxle : x.1 ≤ o :=
    (_root_.Ordinal.CNF_fst_le_log hx).trans (_root_.Ordinal.log_le_self _ _)
  exact (_root_.Ordinal.card_le_card hxle).trans ho.2

end MathlibExpansion.SetTheory.Ordinal
