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
    To download and install R look [here](http://www.r-project.org). See below.
    
- 1 makefile
    - makefile: make clean

## Download the satellite catalogues

1.  To download the TLE catalog from space-track.org:
```
./download_cat_MAC.sh 1      # for MAC users
./download_cat_LINUX.sh 1    # for LINUX users
```
and follow intructions. You need an account on [space-track.org](https://www.space-track.org). 
If it is not working, try deleting the file `cookies.txt`.


2. To download the satellite catalog (containing the physical parameters) from celestrak.com:
```
./download_cat_MAC.sh 2      # for MAC users
./download_cat_LINUX.sh 2    # for LINUX users
```

## Satellite Analysis outputs

The `SatAnalysis.Rmd` processes the orbits for the two calatogues previously downloaded.
It runs on R (knitr) and produces three output files:

 - `SatAnalysis.md`: the output of R, visualize the catalogues and contains some plots.
    An example of it is contained in this repository.

 - `orbitsat.txt`: merge the two catalogues and contains the following fields:
    - NORAD_ID
    - semimajor axis [km]
    - eccentricity
    - inclination [deg]
    - right ascension of the ascending node [deg]
    - argument of pericenter [deg]
    - mean anomaly [deg]
    - launch date [YY-MM-DD]
    - decay date [YY-MM-DD]
    - ratio-cross-section (RCS)

 - `heo_sat.txt`: a list of orbits that satisfy the following conditions:
    - eccentrycity > 0.3
    - perigee < 6600 km
    - ratio-cross-section > 1.0