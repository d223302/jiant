#!/usr/bin/env python3
import matplotlib.pyplot as plt
import numpy as np
import sys


if __name__ == '__main__':
  result_file = sys.argv[1]
  pretrain_data = [[] for _ in range(12)]
  seen = []
  with open(result_file, 'r') as f:
    while True:
      line = f.readline()
      if line == "":
        break
      field = line.rstrip().split(',')
      step, layer, f1 = int(field[0]), int(field[1]), float(field[-1])
      if [step, layer] in seen:
        continue
      else:
        seen.append([step, layer]) 
      if layer in [8, 9, 10, 11]:  
        pretrain_data[layer].append(np.asarray([step, f1]))


  processed_data = []    
  for layer in range(8, 12):
    temp = np.asarray(pretrain_data[layer])
    temp = temp[temp[:, 0].argsort()]
    processed_data.append(temp)
    
  processed_data = np.asarray(processed_data)
  print(processed_data)
  save_name = result_file.split('.')[0] + '.npy'
  np.save(save_name, processed_data)

