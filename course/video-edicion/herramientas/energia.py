"""Imprime RMS (dBFS) en ventanas de 20 ms de un tramo: energia.py <wav> <t0> <t1>"""
import sys, wave, struct, math
f = wave.open(sys.argv[1]); sr = f.getframerate(); ch = f.getnchannels(); sw = f.getsampwidth()
t0, t1 = float(sys.argv[2]), float(sys.argv[3])
f.setpos(int(t0*sr)); n = int((t1-t0)*sr); raw = f.readframes(n)
fmt = {2:'h',4:'i'}[sw]; data = struct.unpack('<%d%s' % (len(raw)//sw, fmt), raw)
full = float(2**(8*sw-1)); win = int(0.02*sr)*ch
out=[]
for i in range(0, len(data)-win, win):
    s = data[i:i+win]; r = math.sqrt(sum(x*x for x in s)/len(s))/full
    out.append(f"{t0+i/ch/sr:.2f}:{20*math.log10(r+1e-9):.0f}")
print(' '.join(out))
