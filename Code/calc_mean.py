#! /usr/local/python2.7
"""
mean_size.py
Created by Tim Stuart
"""

import sys
import numpy as np

lengths = []
for line in sys.stdin:
    if line.startswith('@'):
        pass
    else:
        line = line.rsplit()
        length = int(line[8])
        if length > 0:
            lengths.append(length)
        else:
            pass


def reject_outliers(data, m=2.):
    """
    rejects outliers more than 2
    standard deviations from the median
    """
    median = np.median(data)
    std = np.std(data)
    filtered = []
    for item in data:
        if abs(item - median) < m * std:
            filtered.append(item)
        else:
            pass
    return filtered


def calc_size(data):
    mn = int(np.mean(data))
    std = int(np.std(data))
    return mn, std


data = reject_outliers(lengths)
mn, std = calc_size(data)
print mn, std
