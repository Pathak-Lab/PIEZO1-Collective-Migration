"""
Fig S14-S17 Cumming plots

Author: Jinghao Chen
Email: jinghc2@uci.edu

"""
import pandas as pd
import dabest
from matplotlib import pyplot as plt

print("We're using DABEST v{}".format(dabest.__version__))


#%% load the data
file_loc = 'C:/Users/user/Desktop/.../231212_new_supp_source_data'

fig_num = 16

piezo1_cs = pd.read_excel(file_loc + '/231212_Fig_S' + str(fig_num) + '_wound_closure.xlsx') # replace ... by the data location
piezo1_el = pd.read_excel(file_loc + '/231212_Fig_S' + str(fig_num) + '_edge_length.xlsx') # replace ... by the data location

#%% load the data
if fig_num == 14:
    cs_gof = dabest.load(piezo1_cs,idx=("ControlGoF(PCM)", "GoF(PCM)","GoF(PCM)+↓Cor.Dir."))
    el_gof = dabest.load(piezo1_el,idx=("ControlGoF(PCM)", "GoF(PCM)","GoF(PCM)+↓Cor.Dir."))
    cs_yoda1 = dabest.load(piezo1_cs,idx=("DMSO(PCM)", "Yoda1(PCM)","Yoda1(PCM)+↓Cor.Dir."))
    el_yoda1 = dabest.load(piezo1_el,idx=("DMSO(PCM)", "Yoda1(PCM)","Yoda1(PCM)+↓Cor.Dir."))
    cs_cko = dabest.load(piezo1_cs,idx=("ControlcKO(PCM)", "cKO(PCM)","cKO(PCM)+↑Cor.Dir."))
    el_cko = dabest.load(piezo1_el,idx=("ControlcKO(PCM)", "cKO(PCM)","cKO(PCM)+↑Cor.Dir."))
elif fig_num == 15:
    cs_gof = dabest.load(piezo1_cs,idx=("ControlGoF(PCM)", "GoF(PCM)","GoF(PCM)+↑D.","GoF(PCM)+↓D."))
    el_gof = dabest.load(piezo1_el,idx=("ControlGoF(PCM)", "GoF(PCM)","GoF(PCM)+↑D.","GoF(PCM)+↓D."))
    cs_yoda1 = dabest.load(piezo1_cs,idx=("DMSO(PCM)", "Yoda1(PCM)","Yoda1(PCM)+↑D.","Yoda1(PCM)+↓D."))
    el_yoda1 = dabest.load(piezo1_el,idx=("DMSO(PCM)", "Yoda1(PCM)","Yoda1(PCM)+↑D.","Yoda1(PCM)+↓D."))
    cs_cko = dabest.load(piezo1_cs,idx=("ControlcKO(PCM)", "cKO(PCM)","cKO(PCM)+↑D.","cKO(PCM)+↓D."))
    el_cko = dabest.load(piezo1_el,idx=("ControlcKO(PCM)", "cKO(PCM)","cKO(PCM)+↑D.","cKO(PCM)+↓D."))
elif fig_num == 16:
    cs_gof = dabest.load(piezo1_cs,idx=("ControlGoF(CM)", "GoF(CM)","GoF(CM)+↓Cor.Dir."))
    el_gof = dabest.load(piezo1_el,idx=("ControlGoF(CM)", "GoF(CM)","GoF(CM)+↓Cor.Dir."))
    cs_yoda1 = dabest.load(piezo1_cs,idx=("DMSO(CM)", "Yoda1(CM)","Yoda1(CM)+↓Cor.Dir."))
    el_yoda1 = dabest.load(piezo1_el,idx=("DMSO(CM)", "Yoda1(CM)","Yoda1(CM)+↓Cor.Dir."))
    cs_cko = dabest.load(piezo1_cs,idx=("ControlcKO(CM)", "cKO(CM)","cKO(CM)+↑Cor.Dir."))
    el_cko = dabest.load(piezo1_el,idx=("ControlcKO(CM)", "cKO(CM)","cKO(CM)+↑Cor.Dir."))
else:
    cs_gof = dabest.load(piezo1_cs,idx=("ControlGoF(CM)", "GoF(CM)","GoF(CM)+↑Adh.","GoF(CM)+↓Adh."))
    el_gof = dabest.load(piezo1_el,idx=("ControlGoF(CM)", "GoF(CM)","GoF(CM)+↑Adh.","GoF(CM)+↓Adh."))
    cs_yoda1 = dabest.load(piezo1_cs,idx=("DMSO(CM)", "Yoda1(CM)","Yoda1(CM)+↑Adh.","Yoda1(CM)+↓Adh."))
    el_yoda1 = dabest.load(piezo1_el,idx=("DMSO(CM)", "Yoda1(CM)","Yoda1(CM)+↑Adh.","Yoda1(CM)+↓Adh."))
    cs_cko = dabest.load(piezo1_cs,idx=("ControlcKO(CM)", "cKO(CM)","cKO(CM)+↑Adh.","cKO(CM)+↓Adh."))
    el_cko = dabest.load(piezo1_el,idx=("ControlcKO(CM)", "cKO(CM)","cKO(CM)+↑Adh.","cKO(CM)+↓Adh."))
    
#%% Plot the data



if fig_num == 14:
    f, axx = plt.subplots(nrows=3, ncols=2,
                        figsize=(12, 18),
                        gridspec_kw={'wspace': .25,'hspace': .4} # ensure proper width-wise spacing.
                       )
elif fig_num == 15:
    f, axx = plt.subplots(nrows=3, ncols=2,
                        figsize=(14, 20),
                        gridspec_kw={'wspace': .25,'hspace': .4} # ensure proper width-wise spacing.
                       ) 
elif fig_num == 16:
    f, axx = plt.subplots(nrows=3, ncols=2,
                        figsize=(12, 18),
                        gridspec_kw={'wspace': .25,'hspace': .4} # ensure proper width-wise spacing.
                       )
else:
    f, axx = plt.subplots(nrows=3, ncols=2,
                        figsize=(15, 20),
                        gridspec_kw={'wspace': .25,'hspace': .4} # ensure proper width-wise spacing.
                       ) 

cs_gof.cohens_d.plot(ax=axx.flat[0],swarm_label="Norm. Wound Closure");
el_gof.cohens_d.plot(ax=axx.flat[1],swarm_label="Norm. Edge Length");
cs_yoda1.cohens_d.plot(ax=axx.flat[2],swarm_label="Norm. Wound Closure");
el_yoda1.cohens_d.plot(ax=axx.flat[3],swarm_label="Norm. Edge Length");
cs_cko.cohens_d.plot(ax=axx.flat[4],swarm_label="Norm. Wound Closure");
el_cko.cohens_d.plot(ax=axx.flat[5],swarm_label="Norm. Edge Length");


if fig_num == 14:
    plt.text(-5,5.3,'(A)', fontsize = 22) 
    plt.text(-5,3.43,'(B)', fontsize = 22) 
    plt.text(-5,1.55,'(C)', fontsize = 22) 
    plt.text(-2.9,5.3,'√', fontsize = 40, fontweight='bold') 
    plt.text(-1.9,5.3,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,5.3,'×', fontsize = 40,color="red", fontweight='bold') 
    plt.text(1.8,5.3,'√', fontsize = 40, fontweight='bold') 
    plt.text(-2.9,3.35,'√', fontsize = 40, fontweight='bold') 
    plt.text(-1.9,3.35,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,3.35,'×', fontsize = 40,color="red", fontweight='bold') 
    plt.text(1.8,3.35,'√', fontsize = 40, fontweight='bold') 
    plt.text(-2.9,1.5,'√', fontsize = 40, fontweight='bold') 
    plt.text(-1.9,1.5,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,1.5,'√', fontsize = 40, fontweight='bold') 
    plt.text(1.8,1.5,'√', fontsize = 40, fontweight='bold') 
elif fig_num == 15:
    plt.text(-6.25,2.68,'(A)', fontsize = 22) 
    plt.text(-6.25,1.95,'(B)', fontsize = 22) 
    plt.text(-6.25,1.2,'(C)', fontsize = 22) 
    plt.text(-4.15,2.66,'√', fontsize = 40, fontweight='bold') 
    plt.text(-3.15,2.66,'×', fontsize = 40,color="red", fontweight='bold') 
    plt.text(-2.15,2.66,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,2.66,'×', fontsize = 40,color="red",fontweight='bold') 
    plt.text(1.8,2.66,'×', fontsize = 40,color="red",fontweight='bold')
    plt.text(2.8,2.66,'×', fontsize = 40,color="red",fontweight='bold')
    plt.text(-4.15,1.9,'√', fontsize = 40, fontweight='bold') 
    plt.text(-3.15,1.9,'√', fontsize = 40, fontweight='bold') 
    plt.text(-2.15,1.9,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,1.9,'×', fontsize = 40,color="red",fontweight='bold') 
    plt.text(1.8,1.9,'√', fontsize = 40,fontweight='bold')
    plt.text(2.8,1.9,'√', fontsize = 40,fontweight='bold')
    plt.text(-4.15,1.18,'√', fontsize = 40, fontweight='bold') 
    plt.text(-3.15,1.18,'√', fontsize = 40, fontweight='bold') 
    plt.text(-2.15,1.18,'×', fontsize = 40,color="red", fontweight='bold') 
    plt.text(0.8,1.18,'√', fontsize = 40,fontweight='bold') 
    plt.text(1.8,1.18,'×', fontsize = 40,color="red",fontweight='bold')
    plt.text(2.8,1.18,'√', fontsize = 40,fontweight='bold')
elif fig_num == 16:
    plt.text(-5,5.48,'(A)', fontsize = 22) 
    plt.text(-5,3.52,'(B)', fontsize = 22) 
    plt.text(-5,1.6,'(C)', fontsize = 22)
    plt.text(-2.9,5.38,'√', fontsize = 40, fontweight='bold') 
    plt.text(-1.9,5.38,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,5.38,'×', fontsize = 40,color="red", fontweight='bold') 
    plt.text(1.8,5.38,'√', fontsize = 40, fontweight='bold') 
    plt.text(-2.9,3.35,'√', fontsize = 40, fontweight='bold') 
    plt.text(-1.9,3.35,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,3.35,'√', fontsize = 40, fontweight='bold') 
    plt.text(1.8,3.35,'√', fontsize = 40, fontweight='bold') 
    plt.text(-2.9,1.55,'√', fontsize = 40, fontweight='bold') 
    plt.text(-1.9,1.55,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,1.55,'√', fontsize = 40, fontweight='bold') 
    plt.text(1.8,1.55,'√', fontsize = 40, fontweight='bold')
else:
    plt.text(-6.25,2.25,'(A)', fontsize = 22) 
    plt.text(-6.25,1.7,'(B)', fontsize = 22) 
    plt.text(-6.25,1.15,'(C)', fontsize = 22) 
    plt.text(-4.15,2.23,'√', fontsize = 40, fontweight='bold') 
    plt.text(-3.15,2.23,'√', fontsize = 40, fontweight='bold') 
    plt.text(-2.15,2.23,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,2.23,'×', fontsize = 40,color="red",fontweight='bold') 
    plt.text(1.8,2.23,'×', fontsize = 40,color="red",fontweight='bold')
    plt.text(2.8,2.23,'×', fontsize = 40,color="red",fontweight='bold')
    plt.text(-4.15,1.63,'√', fontsize = 40, fontweight='bold') 
    plt.text(-3.15,1.63,'√', fontsize = 40, fontweight='bold') 
    plt.text(-2.15,1.63,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,1.63,'√', fontsize = 40,fontweight='bold') 
    plt.text(1.8,1.63,'√', fontsize = 40,fontweight='bold')
    plt.text(2.8,1.63,'√', fontsize = 40,fontweight='bold')
    plt.text(-4.15,1.12,'√', fontsize = 40, fontweight='bold') 
    plt.text(-3.15,1.12,'×', fontsize = 40,color="red", fontweight='bold') 
    plt.text(-2.15,1.12,'√', fontsize = 40, fontweight='bold') 
    plt.text(0.8,1.12,'√', fontsize = 40,fontweight='bold') 
    plt.text(1.8,1.12,'√', fontsize = 40,fontweight='bold')
    plt.text(2.8,1.12,'√', fontsize = 40,fontweight='bold')

#%% Save the plots

f.savefig(file_loc + '/S' + str(fig_num) + '_Fig.tiff', format='tiff', dpi=300)
f.savefig(file_loc + '/S' + str(fig_num) + '_Fig.svg', format='svg', dpi=300)
f.savefig(file_loc + '/S' + str(fig_num) + '_Fig.png', format='png', dpi=300)




