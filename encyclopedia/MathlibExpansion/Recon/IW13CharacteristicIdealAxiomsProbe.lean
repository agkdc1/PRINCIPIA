import MathlibExpansion.Roots.Iwasawa.StructureTheorem

/-!
# `#print axioms` probe for the Iwasawa invariants upgrade

Emits `info` messages showing which axioms each declaration transitively
depends on.  Captured in the Pub/Sub build log for the
`IWASAWA_NO7_INVARIANTS_UPGRADE_REPORT`.
-/

open MathlibExpansion.Roots.Iwasawa

#print axioms characteristicIdeal
#print axioms iwasawa_mu
#print axioms iwasawa_lambda
#print axioms characteristicIdeal_eq_of_decomposition
#print axioms iwasawa_mu_eq_of_decomposition
#print axioms iwasawa_lambda_eq_of_decomposition
#print axioms characteristicIdeal_eq_top_of_freeEquiv
#print axioms iwasawa_mu_eq_zero_of_freeEquiv
#print axioms iwasawa_lambda_eq_zero_of_freeEquiv
#print axioms freeProfileDecomposition
