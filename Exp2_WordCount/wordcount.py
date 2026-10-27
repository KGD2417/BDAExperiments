from itertools import groupby

def map_phase(lines):
    pairs = []
    for line in lines:
        for word in line.strip().lower().split():
            word = "".join(ch for ch in word if ch.isalnum())
            if word:
                pairs.append((word, 1))
    return pairs

def shuffle_sort(pairs):
    return sorted(pairs, key=lambda p: p[0])

def reduce_phase(sorted_pairs):
    return {word: sum(c for _, c in group) for word, group in groupby(sorted_pairs, key=lambda p: p[0])}

with open("input.txt") as f:
    lines = f.readlines()

mapped = map_phase(lines)
print("Map output:", mapped[:10], "...")
shuffled = shuffle_sort(mapped)
print("After shuffle & sort:", shuffled[:10], "...")
result = reduce_phase(shuffled)
print("\nFinal word count:")
for word, count in result.items():
    print(f"{word}\t{count}")
