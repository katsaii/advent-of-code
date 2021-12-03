FileIO file;
file.open("in/day_01.txt", FileIO.READ);
int samples[0];
while (file => int sample) {
    samples << sample;
}
file.close();
0 => int increaseCount;
for (1 => int i; i < samples.size(); 1 +=> i) {
    samples[i - 1] => int prev;
    samples[i] => int curr;
    if (curr > prev) {
        1 +=> increaseCount;
    }
}
0 => int windowIncreaseCount;
for (1 => int i; i + 3 <= samples.size(); 1 +=> i) {
    samples[i - 1] => int prev;
    samples[i + 2] => int curr;
    if (curr > prev) {
        1 +=> windowIncreaseCount;
    }
}
IO.newline() => string nl;
chout <= "depth increase count" <= nl
      <= increaseCount <= nl <= nl
      <= "depth increase count for window of size 3" <= nl
      <= windowIncreaseCount <= nl;
