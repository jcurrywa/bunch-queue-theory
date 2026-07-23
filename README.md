# bunch-queue-theory
System and Method for Two-Dimensional Behavioral Classification in Resource Scheduling Using Priority and Aggression Dimensions with Self-Sorting Effect
# Bunch Queue Theory

**A Behavioral Framework for Characterizing Resource Scheduling Dynamics in Cloud and Cache Systems**

*Jeffrey Curry — Retired Intel Engineer | Former CMG Reviewer | University of Michigan CompEng '76*

---

## Overview

Bunch Queue Theory introduces **behavioral aggression** as a new independent performance dimension orthogonal to priority in resource scheduling systems. Classical scheduling frameworks recognize one behavioral dimension: priority. This work formally defines aggression — the observed ratio of actual resource consumption to allocated resources — as a second independent classification dimension, providing the measurement and classification layer that current monitoring frameworks lack.

The framework identifies four behavioral quadrants based on the intersection of priority and aggression, with particular focus on the **Q4 rogue agent** (low priority, high aggression) that causes the noisy neighbor problem in cloud systems.

---

## Key Findings

Three simulation campaigns spanning **12,000+ independent runs** establish four key results:

1. **Optimal aggression improves passive latency 15-26%** across all tested scales (100 to 5,000 agents) at optimal aggression (85-90%), with simultaneous CPU idle reduction of 11-26 percentage points — confirmed across three independent 60-run trials.

2. **Continuous random weight assignment improves a further 19%** over discrete uniform assignment — behavioral diversity produces more efficient pressure propagation than discrete type categories.

3. **The self-sorting effect** — convergent random assignment where agents start with random weights and reclassify based on observed behavior — achieves **47-61% improvement** over discrete uniform assignment. Agents with higher initial weights exit earlier, creating pressure waves that benefit remaining agents. The queue self-organizes without explicit scheduling intervention.

4. **Priority misalignment causes harm** — when low-priority agents behave aggressively, passive agent latency degrades 58-118%. The harm comes from misalignment, not from aggression itself.

---

## Three Throughput Mechanisms

| Mechanism | Description | Evidence |
|---|---|---|
| Attentiveness Effect | Aggressive agents keep passive agents ready — eliminates phantom idle periods | CPU idle drops 11-26pp at optimal aggression |
| Pressure Propagation | Aggressive agents transmit forward pressure to adjacent passive agents | 15-26% passive latency improvement V11 |
| Self-Sorting Effect | Heterogeneous weight assignment causes natural queue stratification | 47-61% improvement V12 |

---

## Repository Contents

```
BunchQueueTheory/
├── README.md                          — This file
├── LICENSE                            — CC0 1.0 Universal
├── paper/
│   └── BunchQueue_WhitePaper_v4.pdf   — Full research paper (two-column format)
├── notebooks/
│   ├── V1_CoreThroughput.ipynb        — Foundational orderly vs bunch comparison
│   ├── V2_PreRunAssessment.ipynb      — Capacity viability framework
│   ├── V3_ScaleTesting.ipynb          — Scale dependency 100-5000 agents
│   ├── V4_LatencyAnalysis.ipynb       — P50/P95/P99 latency by agent type
│   ├── V5_Animation.ipynb             — Visual validation of model dynamics
│   ├── V6_AggressionSweep.ipynb       — Scale-invariance, 2-80% sweep
│   ├── V7_TwoDimensional.ipynb        — Four quadrants, QoS enforcement
│   ├── V8_StepBudget.ipynb            — Optimal threshold stability
│   ├── V9_CrossoverExperiment.ipynb   — Passive latency at all scales
│   ├── V10_CPUIdle.ipynb              — CPU idle tracking introduction
│   ├── V11_Comprehensive.ipynb        — 10 aggression levels, 5 scales, 60 runs
│   └── V12_RandomAggression.ipynb     — Random vs uniform vs convergent assignment
├── figures/
│   ├── Fig1_FourQuadrant.png          — Two-dimensional classification framework
│   ├── Fig2_PassiveLatency.png        — Passive latency vs aggression V11
│   ├── Fig3_CPUIdle.png               — CPU idle vs aggression V11
│   ├── Fig4_StdDev.png                — Standard deviation thrashing signal
│   ├── Fig5_V12Latency.png            — V12 assignment method comparison
│   ├── Fig6_V12StdDev.png             — V12 variability comparison
│   ├── Fig7_ImprovementScale.png      — Improvement and idle reduction by scale
│   └── Fig8_CompleteSummary.png       — All approaches at 5000 agents
└── data/
    ├── v11_clean_results.json         — V11 three-run validated results
    └── v12_results.json               — V12 assignment method results
```

---

## Simulation Environment

All simulations were implemented and validated in the following environment:

| Component | Version |
|---|---|
| Python | 3.12 |
| Mesa (agent-based modeling) | 3.5.1 |
| NumPy | Latest stable |
| Matplotlib | Latest stable |
| OS | Ubuntu 24.04 LTS |

### Running the Notebooks

```bash
# Create virtual environment
python3 -m venv bunchqueue
source bunchqueue/bin/activate

# Install dependencies
pip install mesa==3.5.1 numpy matplotlib jupyter

# Launch Jupyter
jupyter notebook --notebook-dir=notebooks/
```

Open notebooks in order V1 through V12. Each notebook is self-contained. V11 and V12 are the primary validation notebooks and require significant runtime at large scales (approximately 2-3 hours for the full 5-scale sweep).

---

## The Two-Dimensional Model

Priority and aggression are **independent and orthogonal** dimensions:

- **Priority (P)** — what a transaction *deserves* — externally assigned, deterministic
- **Aggression (A)** — what a transaction *actually takes* — internally generated, observable

| Quadrant | Priority | Aggression | Role | Action |
|---|---|---|---|---|
| Q1 — Emergency | High | High | Legitimate fast path | Facilitate |
| Q2 — Starved VIP | High | Low | Displaced by rogue agents | Protect |
| Q3 — Background | Low | Low | Routine work | Serve when able |
| Q4 — Rogue | Low | High | Noisy neighbor | Detect and throttle |

### Behavior Score Formula

```
B = (P × w_p + A × w_a) × U / (S + E) × D × C
```

Where P = priority, A = aggression, U = urgency, S = social inhibition,
E = enforcement, D = density factor, C = coalition size.

---

## Scale-Dependent Results Summary

| Scale | Orderly Baseline | V11 Optimal | V12 C-Convergent | Best Improvement |
|---|---|---|---|---|
| 100 agents | 151.3 steps | 128.0 steps | 85.6 steps | 43% |
| 500 agents | 356.7 steps | 283.9 steps | 290.0 steps | 20% |
| 1000 agents | 518.4 steps | 397.2 steps | 234.5 steps | 55% |
| 2500 agents | 854.2 steps | 633.1 steps | 640.3 steps | 26% |
| 5000 agents | 1273.6 steps | 940.7 steps | 507.2 steps | 60% |

*All latency values in simulation steps (1 step = 1 scheduler tick cycle)*

---

## Citation

If you use this work please cite:

```
Curry, J. (2026). Bunch Queue Theory: A Behavioral Framework for 
Characterizing Resource Scheduling Dynamics in Cloud and Cache Systems. 
Working Paper v4.0. Provisional Patent Filed July 2026.
https://github.com/[your-username]/BunchQueueTheory
```

*A Zenodo DOI will be added here once the preprint is published.*

---

## Status

- [x] Provisional patent filed — July 2026
- [x] Simulation notebooks V1-V12 complete
- [x] Three-run validation confirmed
- [x] White paper v4.0 complete
- [ ] Zenodo preprint — in progress
- [ ] V13 experiment — movement attempt rate vs success rate
- [ ] Production validation

---

## License

This work is licensed under **CC0 1.0 Universal** — see [LICENSE](LICENSE) for details.

The simulation notebooks are released under the **MIT License**.

You are free to use, copy, modify, and distribute this work for any purpose without restriction.

---

## Contact

Jeffrey Curry
Retired Intel Engineer | Fire Commissioner | Volunteer Firefighter
Pacific Northwest, USA

*Research inquiries welcome.*
