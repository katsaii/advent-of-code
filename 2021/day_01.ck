FileIO file;
file.open("in/day_01.txt", FileIO.READ);
int samples[0];
while (file => int sample) {
    samples << sample;
}
file.close();
SinOsc snd => dac;
0 => int increaseCount;
for (1 => int i; i < samples.size(); 1 +=> i) {
    samples[i - 1] => int prev;
    samples[i    ] => int curr;
    if (curr > prev) {
        1 +=> increaseCount;
        snd.freq(220 + curr / 10);
        1::ms => now;
    }
}
0 => int windowIncreaseCount;
3 => int windowSize;
for (1 => int i; i + windowSize <= samples.size(); 1 +=> i) {
    0 => int prev;
    0 => int curr;
    for (0 => int j; j < windowSize; 1 +=> j) {
        samples[i - 1 + j] +=> prev;
        samples[i     + j] +=> curr;
    }
    if (curr > prev) {
        1 +=> windowIncreaseCount;
        snd.freq(880 - curr / windowSize / 10);
        1::ms => now;
    }
}
IO.newline() => string nl;
chout <= "depth increase count" <= nl
      <= increaseCount <= nl <= nl
      <= "depth increase count for window of size " <= windowSize <= nl
      <= windowIncreaseCount <= nl;
