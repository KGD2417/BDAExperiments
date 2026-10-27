import sys

for line in sys.stdin:
    for word in line.strip().lower().split():
        word = "".join(ch for ch in word if ch.isalnum())
        if word:
            print(f"{word}\t1")
