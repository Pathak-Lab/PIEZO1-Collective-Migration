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

file_loc = '/Volumes/Expansion/Data/collective motility'

temp_loc = input('Current file location: \n'+file_loc+'\n Is that correct? (yes/no): ')

if temp_loc == 'no':
    file_loc = input('Please input the complete file location: ')

piezo1_cs = pd.read_excel(file_loc + '/supp_piezo1_cs.xlsx') # replace ... by the data location
piezo1_el = pd.read_excel(file_loc + '/supp_piezo1_el.xlsx') # replace ... by the data location

plot_opt = input('Please indicate the plotting cases (cko/yoda1/gof/all): ')

save_opt = input('Please indicate the format of the saved figures (svg/png): ')



if plot_opt == 'gof' or plot_opt == 'all' or plot_opt == '':
    #%% Option 1: GoF

    cs = dabest.load(piezo1_cs,idx=("ControlGoF(CM)", "GoF(CM)","GoF(CM)+Alp","GoF(CM)-Alp"))
    el = dabest.load(piezo1_el,idx=("ControlGoF(CM)", "GoF(CM)","GoF(CM)+Alp","GoF(CM)-Alp"))

    #%% Plot the data

    f, axx = plt.subplots(nrows=1, ncols=2,
                            figsize=(14, 7),
                            gridspec_kw={'wspace': 0.25} # ensure proper width-wise spacing.
                           )

    cs.cohens_d.plot(ax=axx.flat[0],swarm_label="Norm. Closing Speed");
    el.cohens_d.plot(ax=axx.flat[1],swarm_label="Norm. Edge Length");

    #%% Save the plots

    if save_opt == 'png':
        f.savefig(file_loc + '/figS7_GoF.png', format='png')
    else:
        f.savefig(file_loc + '/figS7_GoF.svg', format='svg')



if plot_opt == 'yoda1' or plot_opt == 'all' or plot_opt == '':
    #%% Option 2: Yoda1

    cs = dabest.load(piezo1_cs,idx=("DMSO(CM)", "Yoda1(CM)","Yoda1(CM)+Alp","Yoda1(CM)-Alp"))
    el = dabest.load(piezo1_el,idx=("DMSO(CM)", "Yoda1(CM)","Yoda1(CM)+Alp","Yoda1(CM)-Alp"))

    #%% Plot the data

    f, axx = plt.subplots(nrows=1, ncols=2,
                            figsize=(14, 7),
                            gridspec_kw={'wspace': 0.25} # ensure proper width-wise spacing.
                           )

    cs.cohens_d.plot(ax=axx.flat[0],swarm_label="Norm. Closing Speed");
    el.cohens_d.plot(ax=axx.flat[1],swarm_label="Norm. Edge Length");

    #%% Save the plots

    if save_opt == 'png':
        f.savefig(file_loc + '/figS7_Yoda1.png', format='png')
    else:
        f.savefig(file_loc + '/figS7_Yoda1.svg', format='svg')


if plot_opt == 'cko' or plot_opt == 'all' or plot_opt == '':
    #%% Option 3: cKo

    cs = dabest.load(piezo1_cs,idx=("ControlcKO(CM)", "cKO(CM)","cKO(CM)+Alp","cKO(CM)-Alp"))
    el = dabest.load(piezo1_el,idx=("ControlcKO(CM)", "cKO(CM)","cKO(CM)+Alp","cKO(CM)-Alp"))

    #%% Plot the data

    f, axx = plt.subplots(nrows=1, ncols=2,
                            figsize=(14, 7),
                            gridspec_kw={'wspace': 0.25} # ensure proper width-wise spacing.
                           )

    cs.cohens_d.plot(ax=axx.flat[0],swarm_label="Norm. Closing Speed");
    el.cohens_d.plot(ax=axx.flat[1],swarm_label="Norm. Edge Length");

    #%% Save the plots

    if save_opt == 'png':
        f.savefig(file_loc + '/figS7_cKO.png', format='png')
    else:
        f.savefig(file_loc + '/figS7_cKO.svg', format='svg')
