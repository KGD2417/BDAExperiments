import random
import statistics

def trailing_zeros(n):
    if n == 0:
        return 0
    count = 0
    while n % 2 == 0:
        n //= 2
        count += 1
    return count

def fm_single(stream, a, b, m):
    max_r = 0
    for x in stream:
        h = (a * x + b) % m
        max_r = max(max_r, trailing_zeros(h))
    return 2 ** max_r

def flajolet_martin(stream, num_hashes=30, group_size=5):
    m = 2 ** 31 - 1
    estimates = [fm_single(stream, random.randint(1, m - 1), random.randint(0, m - 1), m) for _ in range(num_hashes)]
    groups = [estimates[i:i + group_size] for i in range(0, num_hashes, group_size)]
    averages = [sum(g) / len(g) for g in groups]
    return estimates, statistics.median(averages)

print("Small example with h(x) = (3x + 1) mod 5")
small_stream = [1, 3, 2, 1, 2, 3, 4, 3, 1, 2, 3, 1]
max_r = 0
for x in small_stream:
    h = (3 * x + 1) % 5
    r = trailing_zeros(h)
    max_r = max(max_r, r)
    print(f"x={x}  h(x)={h}  binary={h:03b}  trailing zeros={r}")
print(f"R = {max_r}, estimated distinct = 2^R = {2 ** max_r}, actual = {len(set(small_stream))}\n")

random.seed(42)
stream = [random.randint(1, 1000) for _ in range(5000)]
estimates, final = flajolet_martin(stream)
print("Large stream of", len(stream), "elements")
print("Individual hash estimates:", estimates)
print("Actual distinct elements:", len(set(stream)))
print("FM estimate (median of averages):", final)
