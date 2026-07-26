#!/bin/bash
# BQT Priority-Differentiated Redis Test
# Q1 clients: high priority, aggressive
# Q3 clients: low priority, passive

echo "BQT REDIS TEST — Priority Differentiated"
echo "========================================="
echo ""

# Baseline — passive only (all Q3)
echo "Test 1: Passive only — 10 Q3 clients"
redis-benchmark -q -n 50000 -c 10 \
    --csv -t set,get > /home/jc/redis_q3_only.txt
echo "Done — Q3 only baseline"
echo ""

# Aggressive only — all Q1 same priority
echo "Test 2: Aggressive only — 50 Q1 clients"
redis-benchmark -q -n 50000 -c 50 \
    --csv -t set,get > /home/jc/redis_q1_only.txt
echo "Done — Q1 only"
echo ""

# Mixed — Q1 and Q3 together (BQT scenario)
echo "Test 3: Mixed — 10 Q1 + 40 Q3 clients"
echo "  Starting Q3 passive clients in background..."
redis-benchmark -q -n 50000 -c 40 \
    --csv -t set,get > /home/jc/redis_q3_mixed.txt &
Q3_PID=$!

echo "  Starting Q1 aggressive clients..."
redis-benchmark -q -n 50000 -c 10 \
    --csv -t set,get \
    -P 8 > /home/jc/redis_q1_mixed.txt
Q1_EXIT=$?

wait $Q3_PID
echo "Done — Mixed Q1+Q3"
echo ""

# Pipeline aggressive — Q1 with pipelining
echo "Test 4: Q1 with pipeline depth 16"
redis-benchmark -q -n 50000 -c 10 \
    -P 16 --csv -t set,get \
    > /home/jc/redis_q1_pipeline.txt
echo "Done — Q1 pipeline"
echo ""

echo "All tests complete"
echo "Files saved to /home/jc/"
