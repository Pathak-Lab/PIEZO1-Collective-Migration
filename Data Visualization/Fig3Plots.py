"""
Fig 3 Cumming plots

Author: Jinghao Chen
Email: jinghc2@uci.edu

"""
import pandas as pd
import dabest
from matplotlib import pyplot as plt

print("We're using DABEST v{}".format(dabest.__version__))


#%% load the data

piezo1_cs = pd.read_excel('.../piezo1_cs.xlsx') # replace ... by the data location
piezo1_el = pd.read_excel('.../piezo1_el.xlsx') # replace ... by the data location

#%% Option 1: GoF

cs = dabest.load(piezo1_cs,idx=("ControlGoF(SC)", "GoF(SC)","GoF(SC)-Dir"))
el = dabest.load(piezo1_el,idx=("ControlGoF(SC)", "GoF(SC)","GoF(SC)-Dir"))

#%% Option 2: Yoda1

cs = dabest.load(piezo1_cs,idx=("DMSO(SC)", "Yoda1(SC)","Yoda1(SC)-Dir"))
el = dabest.load(piezo1_el,idx=("DMSO(SC)", "Yoda1(SC)","Yoda1(SC)-Dir"))

#%% Option 3: cKo

cs = dabest.load(piezo1_cs,idx=("ControlcKO(SC)", "cKO(SC)","cKO(SC)+Dir"))
el = dabest.load(piezo1_el,idx=("ControlcKO(SC)", "cKO(SC)","cKO(SC)+Dir"))

#%% Plot the data

f, axx = plt.subplots(nrows=1, ncols=2,
                        figsize=(14, 7),
                        gridspec_kw={'wspace': 0.25} # ensure proper width-wise spacing.
                       )

cs.cohens_d.plot(ax=axx.flat[0],swarm_label="Norm. Wound Closure");
el.cohens_d.plot(ax=axx.flat[1],swarm_label="Norm. Edge Length");

#%% Save the plots

f.savefig(".../fig3_cKO.svg", format='svg') # replace ... by the saving location
