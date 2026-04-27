import MathlibExpansion.Roots.Valence.PiecewiseContourIndent

/-!
# Axiom accounting for the staged piecewise contour PR draft

This file records `#print axioms` for the main exported lemmas in the staged
`Mathlib.Analysis.Complex.PiecewiseContour` namespace.  The goal is to certify
that the contour core and indent package stay theorem-land only.
-/

namespace MathlibExpansion.Roots.Valence.PiecewiseContourAxiomsCheck

#print axioms Mathlib.Analysis.Complex.PiecewiseContour.C1Path.integral_symm
#print axioms Mathlib.Analysis.Complex.PiecewiseContour.PiecewiseC1.integral_trans
#print axioms Mathlib.Analysis.Complex.PiecewiseContour.PiecewiseC1.integral_symm
#print axioms Mathlib.Analysis.Complex.PiecewiseContour.C1Path.integral_sub_center_inv_const_arc
#print axioms Mathlib.Analysis.Complex.PiecewiseContour.C1Path.small_circle_estimate
#print axioms Mathlib.Analysis.Complex.PiecewiseContour.C1Path.tendsto_integral_indent_arc

end MathlibExpansion.Roots.Valence.PiecewiseContourAxiomsCheck
