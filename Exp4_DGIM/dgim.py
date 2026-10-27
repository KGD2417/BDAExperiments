class DGIM:
    def __init__(self, window_size):
        self.N = window_size
        self.time = 0
        self.buckets = []

    def add(self, bit):
        self.time += 1
        if self.buckets and self.buckets[-1][0] <= self.time - self.N:
            self.buckets.pop()
        if bit == 1:
            self.buckets.insert(0, (self.time, 1))
            self.merge()

    def merge(self):
        i = 0
        while i + 2 < len(self.buckets):
            if self.buckets[i][1] == self.buckets[i + 1][1] == self.buckets[i + 2][1]:
                size = self.buckets[i + 1][1] * 2
                self.buckets[i + 1] = (self.buckets[i + 1][0], size)
                del self.buckets[i + 2]
            else:
                i += 1

    def count(self, k=None):
        k = k or self.N
        total, last = 0, 0
        for ts, size in self.buckets:
            if ts > self.time - k:
                total += size
                last = size
            else:
                break
        return total - last // 2

stream = "1011011000101110110010110101110100101011"
N = 20
dgim = DGIM(N)
for b in stream:
    dgim.add(int(b))

print("Stream:", stream)
print("Window size N =", N)
print("Buckets (timestamp, size):", dgim.buckets)
for k in (N, 10, 5):
    actual = stream[-k:].count("1")
    print(f"Last {k} bits -> actual 1s = {actual}, DGIM estimate = {dgim.count(k)}")
