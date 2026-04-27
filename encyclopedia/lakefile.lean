import Lake
open Lake DSL

package MathlibExpansion where
  -- add package configuration options here

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.17.0"

@[default_target]
lean_lib MathlibExpansion where
