import MathlibExpansion.Roots.Valence.CompositeContour

/-!
# Axiom accounting for `CompositeContour`

Chapter A is intended to be theorem-land only.  This file records `#print axioms`
for the main exported lemmas so the build log can certify that no new axioms were
introduced.
-/

namespace MathlibExpansion.Roots.Valence.AxiomsCheck

#print axioms MathlibExpansion.Roots.Valence.CompositeContour.C1Path.integral_symm
#print axioms MathlibExpansion.Roots.Valence.CompositeContour.PiecewiseC1.integral_trans
#print axioms MathlibExpansion.Roots.Valence.CompositeContour.PiecewiseC1.integral_symm
#print axioms MathlibExpansion.Roots.Valence.CompositeContour.C1Path.integral_sub_center_inv_const_arc
#print axioms MathlibExpansion.Roots.Valence.CompositeContour.C1Path.small_circle_estimate
#print axioms MathlibExpansion.Roots.Valence.CompositeContour.C1Path.tendsto_integral_indent_arc

end MathlibExpansion.Roots.Valence.AxiomsCheck
