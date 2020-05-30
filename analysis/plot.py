#!/usr/bin/env python3
import matplotlib.pyplot as plt
import numpy as np
import sys


BLUE = [[0, 1, 1], [0, 0.4, 0.4], [0, 0, 0.8], [0.6, 0.2, 1]]
GREEN = [[0.7, 1, 0.4], [0.3, 0.6, 0], [0.6, 0.6, 0], [0, 0.4, 0]]
RED = [[1, 0.4, 0.7], [1, 0, 0], [1, 0.5, 0], [1, 1, 0]]

if __name__ == '__main__':
  pos = np.load('pos.npy', allow_pickle = True)
  dep = np.load('dep.npy', allow_pickle = True)
  srl = np.load('srl.npy', allow_pickle = True)

  ## POS
  fig = plt.figure(figsize=(8, 6))
  ax = fig.add_subplot(1, 1, 1)
  for i in range(4): # 8, 9, 10, 11, 8 代表第 8 層的 input，也就是第 7 層的 output
    ax.plot(pos[i].T[0], pos[i].T[1], color = BLUE[i], linestyle='dashed') 
  ## Dependency tree
  for i in range(7, 11): # 7 是第 7 層的 output
    ax.plot(dep[i][:35].T[0], dep[i][:35].T[-4], color = GREEN[i - 7], linestyle='dotted')  
  for i in range(4):
    ax.plot(srl[i].T[0], srl[i].T[1], color = RED[i], linestyle='solid')
  legend = ['POS-L ' + str(i) for i in range(7, 11)] +\
           ['Dep-L ' + str(i) for i in range(7, 11)] +\
           ['SRL-L ' + str(i) for i in range(7, 11)]
  ax.legend(legend, loc='lower right', ncol = 3) 
  ax.set_title("Compare POS, dependency parsing, and SRL")
  plt.savefig('result.pdf')
  plt.clf()
  plt.close()
  

       
