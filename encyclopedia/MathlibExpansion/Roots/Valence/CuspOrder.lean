import MathlibExpansion.NumberTheory.ModularForms.CuspOrder

/-!
# Compatibility wrapper for staged CuspOrder

This namespace preserves the original staging module path while delegating all
declarations to the namespace-local staging chapter at
`MathlibExpansion.NumberTheory.ModularForms.CuspOrder`.
-/

namespace MathlibExpansion
namespace Roots
namespace Valence
namespace CuspOrder

export _root_.CuspOrder
  (ordAtInfinity
   qExpansion_order_eq_ordAtInfinity
   LocalCuspOrder
   cuspFunctionAtCusp
   eq_cuspFunctionAtCusp
   differentiableAt_cuspFunctionAtCusp
   analyticAt_cuspFunctionAtCusp
   qExpansionAtCusp
   ordAtCusp
   ordAtCusp_width
   slashModularForm
   slashModularForm_coe
   cuspFunctionAtCusp_mul_left
   qExpansionAtCusp_mul_left
   ordAtCusp_mul_left
   ordAtCuspInftyGammaTwo
   ordAtCuspZeroGammaTwo
   ordAtCuspInftyGamma0Two
   ordAtCuspZeroGamma0Two
   ordAtCuspInftyGammaTwo_width
   ordAtCuspZeroGammaTwo_width
   ordAtCuspInftyGamma0Two_width
   ordAtCuspZeroGamma0Two_width
   ordAtCuspInftyGammaTwo_order)

end CuspOrder
end Valence
end Roots
end MathlibExpansion
