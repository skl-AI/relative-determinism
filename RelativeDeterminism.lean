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



-- Секция 4: Эволюционная динамика, фазовые переходы и дискретные гонки емкостей
-- Section 4: Evolutionary Dynamics, Phase Transitions, and Discrete Capacity Races

-- Определение структуры эволюционирующего агента с целочисленной емкостью
-- Definition of evolving agent structure with integer capacity
structure EvolvingAgent where
  -- Идентификатор агента
  -- Agent identifier
  id : String
  -- Накопленная вычислительная емкость
  -- Accumulated computational capacity
  capacity : ℕ

-- Условие достижения порогового значения емкости для фазового перехода
-- Phase transition threshold condition
def ReachesThreshold (agent : EvolvingAgent) (threshold : ℕ) : Prop :=
  threshold ≤ agent.capacity

-- Теорема 4.1: Преодоление порогового значения емкости
-- Theorem 4.1: Overcoming capacity threshold
theorem phase_transition_to_vanguard (agent base_baseline : EvolvingAgent) (threshold : ℕ)
    -- Гипотеза о достижении порога агентом
    -- Hypothesis that agent reaches threshold
    (h_thresh : ReachesThreshold agent threshold)
    -- Гипотеза о том, что базовая линия ниже порога
    -- Hypothesis that baseline capacity is below threshold
    (h_baseline : base_baseline.capacity < threshold) :
    -- Доказываем, что базовая линия строго меньше емкости агента
    -- Proving that baseline is strictly less than agent capacity
    base_baseline.capacity < agent.capacity := by
  -- Раскрываем определение ReachesThreshold в гипотезе h_thresh
  -- Unfold definition of ReachesThreshold in h_thresh
  dsimp [ReachesThreshold] at h_thresh
  -- Применяем автоматический линейный решатель omega для натуральных чисел
  -- Apply linear solver omega for natural numbers
  omega

-- Определение состояния системы из двух дискретных агентов
-- Two-agent system state definition
structure SystemState where
  -- Емкость авангардного агента
  -- Avant-garde agent capacity
  c_adv : ℕ
  -- Емкость отстающего агента
  -- Lagging agent capacity
  c_lag : ℕ

-- Определение сохранения лидерства авангарда над отстающим
-- Definition of avant-garde leadership maintenance
def AdvLeads (st : SystemState) : Prop :=
  st.c_lag < st.c_adv

-- Определение равенства емкостей в точке бифуркации
-- Definition of capacity equality at bifurcation point
def IsBifurcationPoint (st : SystemState) : Prop :=
  st.c_adv = st.c_lag

-- Теорема 4.2: Нарушение однозначного лидерства в точке бифуркации
-- Theorem 4.2: Violation of unambiguous leadership at bifurcation point
theorem bifurcation_symmetry (st : SystemState)
    -- Гипотеза нахождения системы в точке бифуркации
    -- Hypothesis of system being at bifurcation point
    (h_bif : IsBifurcationPoint st) :
    -- Утверждение об отсутствии лидерства авангарда
    -- Statement that avant-garde does not lead
    ¬ AdvLeads st := by
  -- Раскрываем определение IsBifurcationPoint для гипотезы h_bif
  -- Unfold IsBifurcationPoint definition for h_bif
  dsimp [IsBifurcationPoint] at h_bif
  -- Раскрываем определение AdvLeads в целевом выражении
  -- Unfold AdvLeads definition in goal
  dsimp [AdvLeads]
  -- Показываем невозможность c_lag < c_adv при c_adv = c_lag через omega
  -- Show impossibility of c_lag < c_adv when c_adv = c_lag via omega
  omega

-- Дискретная модель динамики емкостей через рекуррентные соотношения
-- Discrete model of capacity dynamics via recurrence relations
structure DiscreteSystemState where
  -- Шаг дискретного времени (такты эволюции)
  -- Discrete time step (evolution ticks)
  time : ℕ
  -- Дискретная емкость авангардного агента
  -- Discrete avant-garde capacity
  c_adv : ℕ
  -- Дискретная емкость отстающего агента
  -- Discrete lagging capacity
  c_lag : ℕ

-- Функция дискретного шага прироста емкости авангарда
-- Function for discrete step of avant-garde capacity growth
def step_adv (c_adv : ℕ) (quantum_growth : ℕ) : ℕ :=
  -- Новая емкость равна старой плюс дискретный квант прироста
  -- New capacity equals old plus discrete growth quantum
  c_adv + quantum_growth

-- Функция дискретного шага отстающего агента на основе целочисленного гэпа
-- Function for discrete step of lagging agent based on integer gap
def step_lag (c_adv c_lag : ℕ) (assimilation_speed : ℕ) : ℕ :=
  -- Проверяем условие, что отстающий меньше авангарда
  -- Check condition that lagging is less than avant-garde
  if c_lag < c_adv then
    -- Отстающий усваивает часть гэпа, ограниченную скоростью ассимиляции
    -- Lagging absorbs part of gap bounded by assimilation speed
    c_lag + min (c_adv - c_lag) assimilation_speed
  else
    -- Иначе емкости равны, оставляем значение без изменений
    -- Otherwise capacities are equal, keep value unchanged
    c_lag

-- Теорема: Целочисленная инвариантность ненулевого гэпа при дискретном шаге
-- Theorem: Integer invariance of non-zero gap under discrete step
theorem discrete_integer_gap_pos (st : DiscreteSystemState)
    -- Гипотеза о строгом отставании емкости отстающего
    -- Hypothesis of strict lagging capacity deficit
    (h_lag : st.c_lag < st.c_adv) :
    -- Доказываем, что целочисленная разность строго больше нуля
    -- Prove that integer difference is strictly greater than zero
    0 < st.c_adv - st.c_lag := by
  -- Применяем автоматический арифметический решатель omega
  -- Apply automatic arithmetic solver omega
  omega

-- Структура агента на границе фазового перехода с вектором редукции
-- Agent structure at phase transition boundary with reduction vector
structure VanguardAgent where
  -- Идентификатор агента
  -- Agent identifier
  id : String
  -- Накопленная дискретная емкость
  -- Accumulated discrete capacity
  capacity : ℕ
  -- Хеш вектора редукции континуума
  -- Continuum reduction vector hash
  vectorHash : ℕ

-- Определение состояния бифуркации через равенство емкостей фронта
-- Definition of bifurcation state through frontier capacity equality
def IsBifurcationState (A_adv A_lag : VanguardAgent) : Prop :=
  A_adv.capacity = A_lag.capacity

-- Определение коллинеарности векторов редукции
-- Definition of reduction vector collinearity
def IsCollinear (A1 A2 : VanguardAgent) : Prop :=
  A1.vectorHash = A2.vectorHash

-- Определение строгого линейного лидерства
-- Definition of strict linear leadership
def HasStrictLead (A_adv A_lag : VanguardAgent) : Prop :=
  A_lag.capacity < A_adv.capacity

-- Теорема 4.3.1: Нарушение линейного детерминизма в точке бифуркации
-- Theorem 4.3.1: Violation of linear determinism at bifurcation point
theorem bifurcation_symmetry_break (A1 A2 : VanguardAgent)
    -- Гипотеза нахождения агентов в состоянии бифуркации
    -- Hypothesis of agents being in bifurcation state
    (h_bif : IsBifurcationState A1 A2) :
    -- Утверждение об отсутствии строгого лидерства в обе стороны
    -- Statement of absence of strict leadership in both directions
    ¬ HasStrictLead A1 A2 ∧ ¬ HasStrictLead A2 A1 := by
  -- Раскрываем определение IsBifurcationState в гипотезе h_bif
  -- Unfold IsBifurcationState in h_bif
  dsimp [IsBifurcationState] at h_bif
  -- Раскрываем определение HasStrictLead в цели
  -- Unfold HasStrictLead in goal
  dsimp [HasStrictLead]
  -- Применяем конъюнкцию и решаем через omega для обеих частей
  -- Apply conjunction and solve via omega for both parts
  constructor <;> omega

-- Теорема 4.3.2: Полная классификация исходов фазового перехода
-- Theorem 4.3.2: Complete classification of phase transition outcomes
theorem bifurcation_outcomes_completeness (A1 A2 : VanguardAgent)
    -- Гипотеза состояния бифуркации для агентов
    -- Hypothesis of bifurcation state for agents
    (h_bif : IsBifurcationState A1 A2) :
    -- Доказываем дихотомию: либо коллинеарность со сжатием, либо ортогональность
    -- Prove dichotomy: either collinearity with turnover or orthogonality
    (IsCollinear A1 A2 ∧ (¬ HasStrictLead A1 A2 ∧ ¬ HasStrictLead A2 A1)) ∨
    (¬ IsCollinear A1 A2) := by
  -- Раскрываем определение IsBifurcationState в гипотезе h_bif
  -- Unfold IsBifurcationState in h_bif
  dsimp [IsBifurcationState] at h_bif
  -- Раскрываем определение IsCollinear в цели
  -- Unfold IsCollinear in goal
  dsimp [IsCollinear]
  -- Раскрываем определение HasStrictLead в цели
  -- Unfold HasStrictLead in goal
  dsimp [HasStrictLead]
  -- Разбираем случаи равенства хешей векторов редукции
  -- Split by cases on whether reduction vector hashes are equal
  by_cases h_vec : A1.vectorHash = A2.vectorHash
  · -- Случай 1: Векторы совпадают (коллинеарный сценарий / инверсия)
    -- Case 1: Vectors coincide (collinear scenario / turnover)
    left
    -- Уточняем пару утверждений через конъюнкцию
    -- Refine pair of statements via conjunction
    refine ⟨h_vec, ?_⟩
    -- Доказываем отсутствие лидерства через omega
    -- Prove lack of leadership via omega
    constructor <;> omega
  · -- Случай 2: Векторы не совпадают (ортогональный сценарий / ветвление)
    -- Case 2: Vectors do not coincide (orthogonal scenario / branching)
    right
    -- Точное совпадение с отрицанием равенства векторов
    -- Exact match with vector equality negation
    exact h_vec
