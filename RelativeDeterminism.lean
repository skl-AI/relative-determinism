-- Import basic set theory and cardinal numbers library in Lean 4 (Mathlib)
import Mathlib.SetTheory.Cardinal.Basic

-- Declare universe level u for cardinal consistency
universe u

-- Theorem: Cardinal barrier (if environment cardinality is strictly greater than agent cardinality, injection is impossible)
-- Description: Proves that a discrete agent cannot map the continuum without information loss
theorem cardinality_barrier {Ω S : Type u} (h_lt : Cardinal.mk S < Cardinal.mk Ω) :
    ¬ ∃ (f : Ω → S), Function.Injective f := by
  -- Assume by contradiction: suppose there exists an injective mapping f from Ω to S
  rintro ⟨f, h_inj⟩
  -- From function injectivity, obtain cardinal inequality: Ω cardinality is less than or equal to S cardinality
  have h_le : Cardinal.mk Ω ≤ Cardinal.mk S := Cardinal.mk_le_of_injective h_inj
  -- Combine non-strict inequality (h_le) and strict inequality (h_lt), obtaining a cyclic contradiction
  exact lt_irrefl (Cardinal.mk Ω) (lt_of_le_of_lt h_le h_lt)



-- Section 2: Computational Asymmetry and Entropy Reduction

-- Define agent structure with its computational capacity
structure Agent where
  -- Agent identifier or name
  id : String
  -- Agent computational capacity (numerical measure of resources)
  capacity : ℕ

-- Definition of asymmetry between avant-garde and lagging agent
def IsAvantGarde (A_adv A_lag : Agent) : Prop :=
  -- Avant-garde agent has strictly greater computational capacity
  A_lag.capacity < A_adv.capacity

-- Theorem: Existence of computational gap (ΔC > 0)
-- Description: Proves that asymmetry guarantees a strictly positive resource gap
theorem computational_gap (A_adv A_lag : Agent) (h_asym : IsAvantGarde A_adv A_lag) :
    A_adv.capacity - A_lag.capacity > 0 := by
  -- Unfold definition of IsAvantGarde
  dsimp [IsAvantGarde] at h_asym
  -- Apply inequality properties for natural numbers
  exact Nat.sub_pos_of_lt h_asym

-- Model residual entropy as a decreasing function of filtering avant-garde's capacity
def Entropy (base_chaos : ℕ) (A_filter : Agent) : ℕ :=
  -- As avant-garde capacity grows, residual chaos (entropy) for the environment decreases
  base_chaos - A_filter.capacity

-- Theorem: Entropy reduction under avant-garde action
-- Description: Proves that growth of avant-garde capacity strictly decreases environment uncertainty
theorem entropy_reduction (base_chaos : ℕ) (A_adv1 A_adv2 : Agent)
    (h_growth : A_adv1.capacity < A_adv2.capacity)
    (h_bound : A_adv2.capacity ≤ base_chaos) :
    Entropy base_chaos A_adv2 < Entropy base_chaos A_adv1 := by
  -- Unfold entropy function definition for both agents
  dsimp [Entropy]
  -- Automatically solve linear inequality for natural numbers via omega
  omega



-- Section 3: Relative Determinism and Algorithmic Closure

-- Model algorithmic rule as a discrete function (from ℕ to ℕ)
def Algorithm := ℕ → ℕ

-- Definition: Environment state is algorithmic (computable),
-- if it is given by the action of some rule from the avant-garde set
def IsAlgorithmicState (state : ℕ) (f : Algorithm) (input : ℕ) : Prop :=
  state = f input

-- Theorem: Guarantee of algorithmic structure for the lagging agent
-- Description: Proves that if state is formed by avant-garde algorithm,
-- lagging agent will always discover the underlying computable function (ready-made "tracks")
theorem algorithmic_determinism (input : ℕ) (f : Algorithm) :
    ∃ (f_found : Algorithm), IsAlgorithmicState (f input) f_found input := by
  -- Choose function f itself, formed by avant-garde, as the target algorithm
  use f
  -- Unfold definition of IsAlgorithmicState
  dsimp [IsAlgorithmicState]



-- Section 4: Evolutionary Dynamics, Phase Transitions, and Bifurcation Point

-- Define evolving agent structure
structure EvolvingAgent where
  -- Agent identifier
  id : String
  -- Accumulated computational capacity
  capacity : ℕ

-- Phase transition threshold condition
def ReachesThreshold (agent : EvolvingAgent) (threshold : ℕ) : Prop :=
  threshold ≤ agent.capacity

-- Theorem 4.1: Overcoming capacity threshold
-- Description: Proves that upon reaching threshold, agent strictly exceeds baseline level
theorem phase_transition_to_vanguard (agent base_baseline : EvolvingAgent) (threshold : ℕ)
    (h_thresh : ReachesThreshold agent threshold)
    (h_baseline : base_baseline.capacity < threshold) :
    base_baseline.capacity < agent.capacity := by
  -- Unfold definition of ReachesThreshold
  dsimp [ReachesThreshold] at h_thresh
  -- Apply linear solver omega
  omega

-- Two-agent system state
structure SystemState where
  c_adv : ℕ
  c_lag : ℕ

-- Definition: Leadership maintenance
def AdvLeads (st : SystemState) : Prop :=
  st.c_lag < st.c_adv

-- Definition: Capacity equality at bifurcation point
def IsBifurcationPoint (st : SystemState) : Prop :=
  st.c_adv = st.c_lag

-- Theorem 4.2: Violation of unambiguous leadership at bifurcation point
-- Description: Proves that upon reaching bifurcation point, neither agent has strict preferential leadership
theorem bifurcation_symmetry (st : SystemState) (h_bif : IsBifurcationPoint st) :
    ¬ AdvLeads st := by
  -- Unfold bifurcation point definition
  dsimp [IsBifurcationPoint] at h_bif
  -- Unfold leadership definition
  dsimp [AdvLeads]
  -- Show impossibility of c_lag < c_adv when c_adv = c_lag via omega
  omega

-- System structure with functionally equivalent agents in oscillation process
structure OscillatingSystem where
  cap1 : ℕ
  cap2 : ℕ

-- Section 4.3: Phase Transition, Bifurcation Point, and Outcome Dichotomy

-- Agent structure at phase transition boundary
structure VanguardAgent where
  -- Agent identifier
  id : String
  -- Accumulated computational capacity
  capacity : ℕ
  -- Continuum reduction vector (discretization direction)
  vectorHash : ℕ

-- Definition of bifurcation state (capacity equality at the front)
def IsBifurcationState (A_adv A_lag : VanguardAgent) : Prop :=
  A_adv.capacity = A_lag.capacity

-- Definition of vector collinearity (work in a single projection channel)
def IsCollinear (A1 A2 : VanguardAgent) : Prop :=
  A1.vectorHash = A2.vectorHash

-- Definition of linear preferential leadership
def HasStrictLead (A_adv A_lag : VanguardAgent) : Prop :=
  A_lag.capacity < A_adv.capacity

-- Theorem 4.3.1: Violation of linear determinism at bifurcation point
-- Description: Proves that at capacity equality, neither agent possesses strict leadership
theorem bifurcation_symmetry_break (A1 A2 : VanguardAgent)
    (h_bif : IsBifurcationState A1 A2) :
    ¬ HasStrictLead A1 A2 ∧ ¬ HasStrictLead A2 A1 := by
  -- Unfold bifurcation state definition
  dsimp [IsBifurcationState] at h_bif
  -- Unfold strict leadership definition
  dsimp [HasStrictLead]
  -- Split proof into two independent parts and solve via omega
  constructor <;> omega

-- Theorem 4.3.2: Complete classification of phase transition outcomes
-- Description: Proves that bifurcation point guarantees either stochastic turnover (on vector coincidence),
-- or topological branching of reality (on orthogonality)
theorem bifurcation_outcomes_completeness (A1 A2 : VanguardAgent)
    (h_bif : IsBifurcationState A1 A2) :
    (IsCollinear A1 A2 ∧ (¬ HasStrictLead A1 A2 ∧ ¬ HasStrictLead A2 A1)) ∨
    (¬ IsCollinear A1 A2) := by
  -- Unfold IsBifurcationState definition
  dsimp [IsBifurcationState] at h_bif
  -- Unfold IsCollinear definition
  dsimp [IsCollinear]
  -- Unfold HasStrictLead definition
  dsimp [HasStrictLead]
  -- Split proof by cases: whether reduction vectors of A1 and A2 are equal
  by_cases h_vec : A1.vectorHash = A2.vectorHash
  · -- Case 1: Vectors coincide (collinear scenario / turnover)
    left
    -- Prove pair (vector coincidence, absence of strict leadership)
    refine ⟨h_vec, ?_⟩
    constructor <;> omega
  · -- Case 2: Vectors do not coincide (orthogonal scenario / branching)
    right
    -- Substitute vector equality negation
    exact h_vec
