#!/bin/bash
# BPQT Redis Validated Sweep
# 3 runs x 200K operations per data point
# Mirrors V11 three-trial validation methodology

echo "BPQT REDIS VALIDATED SWEEP"
echo "==========================="
echo "3 runs x 200K operations per scenario"
echo ""

mkdir -p /home/jc/redis_validated

# ── Experiment 1 — Concurrency Sweep ─────────
echo "Experiment 1 — Concurrency Sweep (3 runs)"
echo "------------------------------------------"

for c in 1 5 10 20 30 50 75 100 150 200 300 500 750 1000
do
    echo "  c=$c..."
    for run in 1 2 3
    do
        redis-benchmark \
            -q -n 200000 -c $c \
            -t set,get --csv \
            > /home/jc/redis_validated/c${c}_run${run}.txt
    done
    echo "  c=$c done (3 runs)"
done

echo ""
echo "Experiment 1 complete"
echo ""

# ── Experiment 2 — Pipeline Depth Sweep ──────
echo "Experiment 2 — Pipeline Depth Sweep (3 runs)"
echo "---------------------------------------------"

for p in 1 2 4 8 16 32 64 128 256
do
    echo "  P=$p..."
    for run in 1 2 3
    do
        redis-benchmark \
            -q -n 200000 -c 50 \
            -P $p -t set,get --csv \
            > /home/jc/redis_validated/p${p}_run${run}.txt
    done
    echo "  P=$p done (3 runs)"
done

echo ""
echo "Experiment 2 complete"
echo ""

# ── Experiment 3 — Mixed Ratio (single process) ──
# Use pipeline depth to differentiate Q1/Q3
# within a single benchmark call
# Cleaner than two concurrent processes
echo "Experiment 3 — Mixed Ratio Sweep (3 runs)"
echo "------------------------------------------"
echo "Using pipeline depth within single process"
echo "Q1 clients: P=8 (aggressive)"
echo "Q3 clients: P=1 (passive)"
echo ""

for q1_pct in 5 10 15 20 25 30 40 50
do
    q1=$((100 * q1_pct / 100))
    q3=$((100 - q1_pct))
    echo "  Q1=${q1_pct}% Q3=${q3}%..."
    for run in 1 2 3
    do
        # Q1 aggressive run
        redis-benchmark \
            -q -n 200000 -c $q1_pct \
            -P 8 -t set,get --csv \
            > /home/jc/redis_validated/mixed_q1_${q1_pct}_run${run}.txt

        # Q3 passive run immediately after
        redis-benchmark \
            -q -n 200000 -c $q3 \
            -P 1 -t set,get --csv \
            > /home/jc/redis_validated/mixed_q3_${q1_pct}_run${run}.txt
    done
    echo "  Q1=${q1_pct}% done (3 runs)"
done

echo ""
echo "Experiment 3 complete"
echo ""

# ── Summary ───────────────────────────────────
echo "==========================="
echo "ALL EXPERIMENTS COMPLETE"
echo ""
total=$(ls /home/jc/redis_validated/*.txt | wc -l)
echo "Total files: $total"
echo ""
echo "Expected:"
echo "  Concurrency: 14 levels x 3 runs = 42 files"
echo "  Pipeline:     9 levels x 3 runs = 27 files"
echo "  Mixed:        8 ratios x 3 runs x 2 = 48 files"
echo "  Total: 117 files"
echo ""
echo "SCP all files:"
echo "scp -P 2222 jc@127.0.0.1:/home/jc/redis_validated/*.txt C:\Users\jcurr\Desktop\redis_validated\"
