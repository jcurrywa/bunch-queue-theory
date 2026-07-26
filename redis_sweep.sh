#!/bin/bash
# BPQT Redis Comprehensive Sweep
# Two experiments:
# 1 — Concurrency sweep (maps to aggression level)
# 2 — Pipeline depth sweep (maps to type coefficient)

echo "BPQT REDIS COMPREHENSIVE SWEEP"
echo "================================="
echo ""

# ── Experiment 1 — Concurrency Sweep ─────────
# Maps to aggression level in simulation
# Low c = passive agents
# High c = aggressive agents
# Looking for peak throughput and thrashing onset

echo "Experiment 1 — Concurrency Sweep"
echo "---------------------------------"

for c in 1 5 10 20 30 50 75 100 150 200 300 500 750 1000
do
    echo "  Running c=$c..."
    redis-benchmark -q -n 50000 -c $c \
        -t set,get \
        --csv > /home/jc/redis_sweep_c${c}.txt
    echo "  Done c=$c"
done

echo ""
echo "Experiment 1 complete"
echo ""

# ── Experiment 2 — Pipeline Depth Sweep ──────
# Maps to aggression coefficient in simulation
# P=1  = passive (type_coeff 0.3)
# P=16 = aggressive (type_coeff 1.0)
# Fixed c=50 — isolates pipeline effect

echo "Experiment 2 — Pipeline Depth Sweep"
echo "------------------------------------"

for p in 1 2 4 8 16 32 64 128 256
do
    echo "  Running P=$p..."
    redis-benchmark -q -n 50000 -c 50 \
        -P $p \
        -t set,get \
        --csv > /home/jc/redis_sweep_p${p}.txt
    echo "  Done P=$p"
done

echo ""
echo "Experiment 2 complete"
echo ""

# ── Experiment 3 — Mixed Priority Sweep ──────
# Simulates Q1+Q3 mix at different ratios
# Maps to % aggressive agents in simulation
# Total clients always 100
# Varying ratio of pipeline (Q1) vs no-pipeline (Q3)

echo "Experiment 3 — Mixed Priority Ratio Sweep"
echo "------------------------------------------"

for q1 in 5 10 15 20 25 30 40 50
do
    q3=$((100-q1))
    echo "  Running Q1=$q1 Q3=$q3..."

    # Q3 passive clients in background
    redis-benchmark -q -n 50000 -c $q3 \
        -t set,get \
        --csv > /home/jc/redis_mixed_q3_${q1}.txt &
    Q3_PID=$!

    # Q1 aggressive clients with pipeline
    redis-benchmark -q -n 50000 -c $q1 \
        -P 8 \
        -t set,get \
        --csv > /home/jc/redis_mixed_q1_${q1}.txt

    wait $Q3_PID
    echo "  Done Q1=$q1% Q3=$q3%"
done

echo ""
echo "Experiment 3 complete"
echo ""

# ── Collect all results ───────────────────────
echo "================================="
echo "ALL EXPERIMENTS COMPLETE"
echo ""
echo "Files saved to /home/jc/:"
ls /home/jc/redis_sweep_*.txt | wc -l
echo "concurrency sweep files"
ls /home/jc/redis_sweep_p*.txt | wc -l
echo "pipeline sweep files"
ls /home/jc/redis_mixed_*.txt | wc -l
echo "mixed priority files"
echo ""
echo "SCP all files:"
echo "scp -P 2222 jc@127.0.0.1:/home/jc/redis_sweep_*.txt C:\Users\jcurr\Desktop\redis\"
echo "scp -P 2222 jc@127.0.0.1:/home/jc/redis_mixed_*.txt C:\Users\jcurr\Desktop\redis\"
