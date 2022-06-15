import numpy as np
from custom import *
import matplotlib.pyplot as plt
from itertools import chain

def signal(frequency, phase = 0):
    return np.sin(2 * np.pi * frequency * time + phase)

#number of data points is duration/sr
#frequency denotes number of cicles per second, and second is 1/sr.
duration = 1
sr = 100 #per second
time = np.arange(0, duration, 1/sr)

def DFT(x):
    N = len(x)
    n = np.arange(N)
    k = n.reshape((N, 1))
    e = np.exp(-2j * np.pi * k * n / N)
    X = np.dot(e, x)
    return X

def noise(m, sd, l):
    return np.random.normal(m, sd, l)

windows = 5
metric1 = list(chain.from_iterable([signal(2+i, j)+k for i, j, k in zip(noise(0, 0.1, windows), noise(0, 0.2, windows) , noise(0, 0.5, windows) ) ]))
metric2 = list(chain.from_iterable([signal(3+i, j)+k for i, j, k in zip(noise(0, 0.1, windows), noise(0, 0.2, windows) , noise(0, 0.5, windows) ) ]))
signal = [x+y for x, y in zip(metric1, metric2)]

X = DFT(signal)

# calculate the frequency
N = len(X)
n = np.arange(N)
T = N/sr
freq = n/T 

plt.figure()
plt.stem(freq, abs(X), 'b', \
         markerfmt=" ", basefmt="-b")
plt.xlabel('Freq (Hz)')
plt.ylabel('DFT Amplitude |X(freq)|')
plt.show()






windows = 5
metric1 = list(chain.from_iterable([signal(2+i, j)+k for i, j, k in zip(noise(0, 0.1, windows), noise(0, 0.2, windows) , noise(0, 0.5, windows) ) ]))
metric2 = list(chain.from_iterable([signal(3+i, j)+k for i, j, k in zip(noise(0, 0.1, windows), noise(0, 0.2, windows) , noise(0, 0.5, windows) ) ]))

#plt.plot(metric1)
#plt.plot(metric2)

plt.plot([x+y for x, y in zip(metric1, metric2)])
plt.xticks([i/sr for i in range(duration+1)], [i for i in range(duration+1)])
plt.show()


