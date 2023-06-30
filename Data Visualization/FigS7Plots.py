# -*- coding: utf-8 -*-
"""
Created on Fri Nov  4 15:12:35 2022

@author: cjh_m
"""

"""
Fig S7 Cumming plots

Author: Jinghao Chen
Email: jinghc2@uci.edu

"""
import pandas as pd
import dabest
from matplotlib import pyplot as plt

print("We're using DABEST v{}".format(dabest.__version__))


#%% load the data

piezo1_cs = pd.read_excel('.../supp_piezo1_cs.xlsx') # replace ... by the data location
piezo1_el = pd.read_excel('.../supp_piezo1_el.xlsx') # replace ... by the data location

#%% Option 1: GoF

cs = dabest.load(piezo1_cs,idx=("ControlGoF(SC)", "GoF(SC)","GoF(SC)+Alp","GoF(SC)-Alp"))
el = dabest.load(piezo1_el,idx=("ControlGoF(SC)", "GoF(SC)","GoF(SC)+Alp","GoF(SC)-Alp"))

#%% Option 2: Yoda1

cs = dabest.load(piezo1_cs,idx=("DMSO(SC)", "Yoda1(SC)","Yoda1(SC)+Alp","Yoda1(SC)-Alp"))
el = dabest.load(piezo1_el,idx=("DMSO(SC)", "Yoda1(SC)","Yoda1(SC)+Alp","Yoda1(SC)-Alp"))

#%% Option 3: cKo

cs = dabest.load(piezo1_cs,idx=("ControlcKO(SC)", "cKO(SC)","cKO(SC)+Alp","cKO(SC)-Alp"))
el = dabest.load(piezo1_el,idx=("ControlcKO(SC)", "cKO(SC)","cKO(SC)+Alp","cKO(SC)-Alp"))

#%% Plot the data

f, axx = plt.subplots(nrows=1, ncols=2,
                        figsize=(14, 7),
                        gridspec_kw={'wspace': 0.25} # ensure proper width-wise spacing.
                       )

cs.cohens_d.plot(ax=axx.flat[0],swarm_label="Norm. Closing Speed");
el.cohens_d.plot(ax=axx.flat[1],swarm_label="Norm. Edge Length");

#%% Save the plots

f.savefig(".../fig3_cKO.svg", format='svg') # replace ... by the saving location
