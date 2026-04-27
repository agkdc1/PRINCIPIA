import Mathlib.Data.Fin.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Logic.Function.Iterate
import Mathlib.Tactic
import MathlibExpansion.Foundations.Dedekind.SimplyInfinite

/-!
# Dedekind recursion by iteration

This file exposes Dedekind's "definition by induction" theorem in the explicit
`∃!` form used by the textbook.
-/

namespace MathlibExpansion
namespace Foundations
namespace Dedekind

theorem existsUnique_iterateMap {Ω : Type*} (θ : Ω → Ω) (ω : Ω) :
    ∃! ψ : ℕ → Ω, ψ 0 = ω ∧ ∀ n, ψ (n + 1) = θ (ψ n) := by
  refine ⟨fun n => θ^[n] ω, ?_, ?_⟩
  · constructor
    · simp
    · intro n
      simpa using Function.iterate_succ_apply' θ n ω
  · intro ψ hψ
    funext n
    induction n with
    | zero =>
        exact hψ.1
    | succ n ih =>
        rw [hψ.2 n, Function.iterate_succ_apply', ih]

theorem existsUnique_iterate_map {Ω : Type*} (θ : Ω → Ω) (ω : Ω) :
    ∃! ψ : ℕ → Ω, ψ 0 = ω ∧ ∀ n, ψ (n + 1) = θ (ψ n) :=
  existsUnique_iterateMap θ ω

theorem existsUnique_recursion_on_prefix {Ω : Type*} (θ : Ω → Ω) (ω : Ω) (n : ℕ) :
    ∃! ψ : Fin (n + 1) → Ω,
      ψ 0 = ω ∧ ∀ k : Fin n, ψ k.succ = θ (ψ k.castSucc) := by
  refine ⟨fun i => θ^[i.1] ω, ?_, ?_⟩
  · constructor
    · simp
    · intro k
      simpa using Function.iterate_succ_apply' θ k.1 ω
  · intro ψ hψ
    ext i
    induction' i using Fin.induction with i ih
    · exact hψ.1
    · rw [hψ.2 i, ih]
      simpa using (Function.iterate_succ_apply' θ i.1 ω).symm

theorem existsUnique_recursionOnPrefix {Ω : Type*} (θ : Ω → Ω) (ω : Ω) (n : ℕ) :
    ∃! ψ : Fin (n + 1) → Ω,
      ψ 0 = ω ∧ ∀ k : Fin n, ψ k.succ = θ (ψ k.castSucc) :=
  existsUnique_recursion_on_prefix θ ω n

theorem map_succClosure_eq_image {Ω : Type*} {θ : Ω → Ω} {ω : Ω} {ψ : ℕ → Ω}
    (_hψ0 : ψ 0 = ω) (hψs : ∀ n, ψ (n + 1) = θ (ψ n)) (T : Set ℕ) :
    ψ '' (Nat.succ '' T) = θ '' (ψ '' T) := by
  ext y
  constructor
  · rintro ⟨x, ⟨n, hn, rfl⟩, rfl⟩
    exact ⟨ψ n, ⟨n, hn, rfl⟩, by simpa using (hψs n).symm⟩
  · rintro ⟨z, ⟨n, hn, rfl⟩, rfl⟩
    refine ⟨n + 1, ⟨n, hn, rfl⟩, by simpa using hψs n⟩

theorem range_rec_eq_iterate_orbit {Ω : Type*} (θ : Ω → Ω) (ω : Ω) :
    Set.range (fun n : ℕ => θ^[n] ω) = {x | ∃ n, θ^[n] ω = x} := by
  ext x
  constructor
  · rintro ⟨n, rfl⟩
    exact ⟨n, rfl⟩
  · rintro ⟨n, hn⟩
    exact ⟨n, hn⟩

theorem range_from_n_eq_iterate_orbit_of_value {Ω : Type*} (θ : Ω → Ω) (ω : Ω) (n : ℕ) :
    Set.range (fun k : ℕ => θ^[k] ((θ^[n]) ω)) =
      {x | ∃ k, θ^[k] ((θ^[n]) ω) = x} := by
  ext x
  constructor
  · rintro ⟨k, rfl⟩
    exact ⟨k, rfl⟩
  · rintro ⟨k, hk⟩
    exact ⟨k, hk⟩

theorem map_succImage_eq_image {Ω : Type*} {θ : Ω → Ω} {ω : Ω} {ψ : ℕ → Ω}
    (hψ0 : ψ 0 = ω) (hψs : ∀ n, ψ (n + 1) = θ (ψ n)) (T : Set ℕ) :
    ψ '' (Nat.succ '' T) = θ '' (ψ '' T) :=
  map_succClosure_eq_image hψ0 hψs T

theorem range_iterate_eq_orbit {Ω : Type*} (θ : Ω → Ω) (ω : Ω) :
    Set.range (fun n : ℕ => θ^[n] ω) = {x | ∃ n : ℕ, θ^[n] ω = x} :=
  range_rec_eq_iterate_orbit θ ω

theorem range_from_eq_orbit {Ω : Type*} (θ : Ω → Ω) (ω : Ω) (n : ℕ) :
    Set.range (fun k : ℕ => θ^[k] (θ^[n] ω)) = {x | ∃ k : ℕ, θ^[k] (θ^[n] ω) = x} :=
  range_from_n_eq_iterate_orbit_of_value θ ω n

namespace SimplyInfiniteSystem

theorem existsUnique_recursor {α Ω : Type*} (S : SimplyInfiniteSystem α) (θ : Ω → Ω) (ω : Ω) :
    ∃! ψ : α → Ω, ψ S.zero = ω ∧ ∀ a : α, ψ (S.succ a) = θ (ψ a) := by
  let ψ : α → Ω := fun a => θ^[S.equivNat a] ω
  refine ⟨ψ, ?_, ?_⟩
  · constructor
    · simp [ψ]
    · intro a
      change θ^[S.equivNat (S.succ a)] ω = θ (θ^[S.equivNat a] ω)
      rw [S.equivNat_succ]
      exact Function.iterate_succ_apply' θ (S.equivNat a) ω
  · intro φ hφ
    funext a
    have hzero : φ S.zero = ω := hφ.1
    have hsucc : ∀ a : α, φ (S.succ a) = θ (φ a) := hφ.2
    have hnat : ∀ n : ℕ, φ (S.equivNat.symm n) = θ^[n] ω := by
      intro n
      induction n with
      | zero =>
          simpa using hzero
      | succ n ihn =>
          calc
            φ (S.equivNat.symm (n + 1))
                = φ (S.succ (S.equivNat.symm n)) := by simp
            _ = θ (φ (S.equivNat.symm n)) := hsucc _
            _ = θ (θ^[n] ω) := by rw [ihn]
            _ = θ^[n + 1] ω := by simp [Function.iterate_succ_apply']
    simpa [ψ] using hnat (S.equivNat a)

end SimplyInfiniteSystem

end Dedekind
end Foundations
end MathlibExpansion
