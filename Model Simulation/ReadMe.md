# Simulation Codes

## Collective Cell Migration Model - Homogeneous Cell Type
### Scripts
* Main.m: model tuning, testing, visualization
* caseStudy.m: user interface to study PIEZO1 effects by repeated simulations
### Basic Functions
* DIM.m: initializing the environment
* DCM.m: performing repeated simulations, generating and collecting data
* DPM.m: processing simulation data
### Numerical PDE Solvers
* iter.m: numerical scheme, one step iteration
* dif.m: numerical scheme, diffusion
* adv.m: numerical scheme, advection
* inicond.m: initial condition
* iniud.mat: pre-saved initial values
* iter0.m: generating initial values
* bdcond.m: boundary condition
* bdgenerator.m: boundary condition - generating randomness in space
* bdmidgenerator.m: boundary condition - smoothing in time
### Tools and Measurements
* fbell.m: bell shape function
* rectifier.m: adjusting outlier datapoints
* plotfunc.m: used in Main.m for visualization
* plotpending.jpg: image to show if not plot immediately
* velocityField.m: preparing for visualizing velocity fields
* touch.m: detecting if wound closed
* edge_detection.m: detecting wound edges
* edge_distance.m: measuring the minimal distance between wound interfaces
* edge_length.m: measuring wound edge length
* cellmass.m: measuring cell mass within a specified region
* wscale.m: measuring wound scale

## Collective Cell Migration Model - Heterogeneous Cell Type
### Scripts
* MainHg.m: model tuning, testing, visualization
### Numerical PDE Solvers
* iterHg.m: numerical scheme, one step iteration
* difHg.m: numerical scheme, diffusion
* advHg.m: numerical scheme, advection
