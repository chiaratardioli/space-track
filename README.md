# Satellite catalog instructions

This folder contains:

- 2 bash scripts to download the TLE catalog (option 1) using API and the satcat provided by NORAD:
    - download_cat_MAC.sh
    - download_cat_LINUX.sh
    
- 2 document files:
    - docs/satcat_format.txt
    - docs/tle_format.txt
    
    that explain the catalog format (downloaded from the websites).

- 2 fortran programs to convert the format and make readable the catalog by R:
    - TLE2KEP.f90
    - SAT2TABLE.f90
    
- 1 R markdown file 
    - SatAnalysis.Rmd 
    
    that run the analysis using R (it is assumed that the catalog have been downloaded).
    To compile this file, type `make html` in the terminal or use `Rstudio`. 
    To download and install R look [here](http://www.r-project.org). And example of the output is 
    contained in 'SatAnalysis.md'.
    
- 1 makefile
    - makefile: make clean

## Download the satellite catalogues

1.  To download the TLE catalog from space-track.org:
```
./download_cat_MAC.sh 1      # for MAC users
./download_cat_LINUX.sh 1    # for LINUX users
```
and follow intructions. You need an account on [space-track.org](https://www.space-track.org).


2. To download the satellite catalog (containing the physical parameters) from celestrak.com:
```
./download_cat_MAC.sh 2      # for MAC users
./download_cat_LINUX.sh 2    # for LINUX users
```
