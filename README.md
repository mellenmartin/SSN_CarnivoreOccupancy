# Effects of climate conditions on current and future occurrence of mesocarnivores in the southern Sierra Nevada

Code, initial values, and formatted/extracted data to replicate dynamic occupancy analyses evaluating the effects of climate conditions and future climate projections on the occupancy of fishers, martens, grey foxes, and ringtails. JAGS model output was too large to upload in command line chains or RDS format...

<h3>JAGSmodel</h3>

There are 6 files in this folder:

**./JAGSmodel/SSN_DynOccProjectionModel.R:** The Bayesian dynamic occupancy model to estimate initial occupancy, persistence, and colonization of fishers, gray foxes, martens, and ringtails during observed years, predict occupancy under five climate model scenarios in two time periods, and summarize parameters of interest (e.g., prop occupied, turnover)  

**./JAGSmodel/SN_data.txt:**  data formatted for JAGS model via "dump.format" function. Given sensitive status of marten and fisher, raw detections (including coordinates) cannot be shared, but JAGS data can be used to replicate analysis. Data file includes:
| List item     | Type           | Description                                                                                                                             |
| ------------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| ytracks       | obs matrix     | whether trackplate detected species <i>s</i> -- can be 0 [no], 1 [yes], NA [not deployed]    [1:202; 1:14; 1:9; 1:5; 1:4]               |
| ycams         | obs matrix     | whether camera detected species <i>s</i> -- can be 0 [no], 1 [yes], NA [not deployed]     [1:202; 1:14; 1:9; 1:5; 1:4]                  |
| U             | vector         | sampling unit IDs [1:202]                                                                                                               |
| R             | vector         | station IDs in sampling unit <i>u</i> [1:9]                                                                                             |
| W             | vector         | sampling occasion <i>w</i> at station <i>r</i> in sampling unit <i>u</i>  [1:5]                                                         |
| T             | vector         | number of sampling years [1:14]  2002 - 2015                                                                                            |
| S             | vector         | number of species [1:4] 1 = fisher, 2 = fox, 3 = marten, 4 = ringtail                                                                   |
| G             | vector         | occupancy grid cell IDs [1:1255]                                                                                                        |
| trackdeployed | det cov matrix | whether trackplate was deployed -- can be 0 [no], 1 [yes], NA [not deployed]; note, essentially nuisance parameter given NAs in ytracks |
| camdeployed   | det cov matrix | whether camera was deployed -- can be 0 [no], 1 [yes], NA [not deployed]; note, essentially nuisance parameter given NAs in ycams       |
| scancov       | det cov matrix | scaled canopy cover covariate at each station in each unit in each year [1:202; 1:9; 1:14]                                              |
| ssdcancov     | det cov matrix | scaled standard deviation of canopy cover covariate at each station in each unit in each year [1:202; 1:9; 1:14]                        |
| prevtrackdet  | det cov matrix | whether trackplate detected species <i>s</i> in the previous check -- can be 0 [no], 1 [yes] [1:202; 1:14; 1:9; 1:5; 1:4]               |
| prevcamdet    | det cov matrix | whether camera detected species <i>s</i> in the previous check -- can be 0 [no], 1 [yes] [1:202; 1:14; 1:9; 1:5; 1:4]                   |
| gcancov       | occ cov matrix | scaled canopy cover covariate in each grid cell in each year, including two prediction timepoints [1:1255; 1:16]                        |
| gsdcancov     | occ cov matrix | scaled standard deviation of canopy cover covariate in each grid cell in each year, including two prediction timepoints [1:1255; 1:16]  |
| gsnow         | occ cov matrix | scaled snowpack covariate in each grid cell in each year, including two prediction timepoints and five climate scenarios [1:1255; 1:16; 1:5] |
| gtmin         | occ cov matrix | scaled min temp covariate in each grid cell in each year, including two prediction timepoints and five climate scenarios [1:1255; 1:16; 1:5] |
| gppt          | occ cov matrix | scaled precipitation covariate in each grid cell in each year, including two prediction timepoints and five climate scenarios [1:1255; 1:16; 1:5] |
| NK            | vector         | occupancy grid cell IDs that do not intersect the Kern Plateau [1:1042] used to index occupancy to prevent estimating marten & ringtail occupancy in Kern (they don't occur there)                                                                                                       |
| Kern          | vector     | occupancy grid cell IDs that intersect the Kern Plateau [1:217] used to summarize occupancy & other parameters in Kern                      |
| SQFW          | vector     | occupancy grid cell IDs that intersect the Sequoia NF [1:425] used to summarize occupancy & other parameters in Sequoia NF                  |
| Sierra        | vector     | occupancy grid cell IDs that intersect the Sierra NF [1:613] used to summarize occupancy & other parameters in Sierra NF                    |
| LowElevNK     | vector     | occupancy grid cell IDs at low elev that do not intersect the Kern Plateau [1:273]                                                          |
| MidElevNK     | vector     | occupancy grid cell IDs at mid elev that do not intersect the Kern Plateau [1:463]                                                          |
| HigElevNK     | vector     | occupancy grid cell IDs at high elev that do not intersect the Kern Plateau [1:302]                                                         |


**./JAGSmodel/SN_inits1.txt, SN_inits2.txt, SN_inits3.txt:** initial values for JAGS model


**./JAGSmodel/SSNOccupancy_ParamSummary.csv:** parameter summaries for monitored parameters of interest discussed in manuscript:
| Parameter     | Type           | Description                                                                                                                             |
| ------------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| b0tracks      | det intercept  | trackplate observation process intercept, allowed to vary by year and species    [1:14; 1:4]                                            |
| b1            | det slope      | effect of canopy cover (scancov) within 100 m of trackplate station on species-specific detection probability    [1:4]                  |
| b2            | det slope      | effect of standard deviation of canopy cover (ssdcancov) within 100 m of trackplate station on species-specific detection probability    [1:4]|
| b3            | det slope      | effect of whether species <i>s</i> was previously detected at trackplate station on species-specific detection probability    [1:4]     |
| c0cams        | det intercept  | camera observation process intercept, allowed to vary by year and species    [1:14; 1:4]                                                |
| c1            | det slope      | effect of canopy cover (scancov) within 100 m of trackplate station on species-specific detection probability    [1:4]                  |
| c2            | det slope      | effect of standard deviation of canopy cover (ssdcancov) within 100 m of trackplate station on species-specific detection probability    [1:4] |
| c3            | det slope      | effect of whether species <i>s</i> was previously detected at trackplate station on species-specific detection probability    [1:4]     |
| c4            | det slope      | effect of camera model 1 (1/0) on species-specific detection probability    [1:4]                                                       |
| c5            | det slope      | whether camera was deployed -- can be 0 [no], 1 [yes], NA [not deployed]; note, essentially nuisance parameter given NAs in ycams       |
| d0            | occ intercept  | initial occupancy intercept in year 1, allowed to vary by species [1:4]                                                                 |
| d1            | occ slope      | effect of canopy cover (gcancov) within grid cell <i>g</i> on species-specific occupancy in year 1    [1:4]                             |
| d2            | occ slope      | effect of standard deviation canopy cover (gsdcancov) within grid cell <i>g</i> on species-specific occupancy in year 1    [1:4]        |
| d3            | occ slope      | effect of snowpack (gsnow) within grid cell <i>g</i> on species-specific occupancy in year 1    [1:4]                                   |
| d4            | occ slope      | effect of precipitation (gppt) within grid cell <i>g</i> on species-specific occupancy in year 1    [1:4]                               |
| d5            | occ slope      | effect of minimum temperature (gtmin) within grid cell <i>g</i> on species-specific occupancy in year 1    [1:4]                        |
| gamma.0       | gam intercept  | species-specific colonization intercept     [1:4]                                                                                       |
| gam1          | gam slope      | effect of canopy cover (gcancov) within grid cell <i>g</i> on species-specific colonization probability    [1:4]                        |       
| gam2          | gam slope      | effect of standard deviation of canopy cover (gsdcancov) within grid cell <i>g</i> on species-specific colonization probability    [1:4]|                     
| gam3          | gam slope      | effect of snowpack (gsnow) within grid cell <i>g</i> on species-specific colonization probability    [1:4]                              |   
| gam5          | gam slope      | effect of precipitation (gppt) within grid cell <i>g</i> on species-specific colonization probability    [1:4]                          |   
| gam6          | gam slope      | effect of minimum temperature (gtmin) within grid cell <i>g</i> on species-specific colonization probability    [1:4]                   |   
| phi.0         | phi intercept  | species-specific persistence intercept     [1:4]                                                                                        |
| phi1          | gam slope      | effect of canopy cover (gcancov) within grid cell <i>g</i> on species-specific persistence probability    [1:4]                         |       
| phi2          | gam slope      | effect of standard deviation of canopy cover (gsdcancov) within grid cell <i>g</i> on species-specific persistence probability    [1:4] |                     
| phi3          | gam slope      | effect of snowpack (gsnow) within grid cell <i>g</i> on species-specific persistence probability    [1:4]                               |   
| phi5          | gam slope      | effect of precipitation (gppt) within grid cell <i>g</i> on species-specific persistence probability    [1:4]                           |   
| phi6          | gam slope      | effect of minimum temperature (gtmin) within grid cell <i>g</i> on species-specific persistence probability    [1:4]                    | 
| det.tra.v     | det probability| year and species-specific estimates of weekly detection probability at trackplates   [1:14; 1:4]                                        |   
| det.tra.t     | det probability| year and species-specific estimates of annual detection probabiltiy at trackplates   [1:14; 1:4]                                        | 
| det.cam.v     | det probability| year and species-specific estimates of weekly detection probabiltiy at cameras       [1:14; 1:4]                                        |   
| det.cam.t     | det probability| year and species-specific estimates of annual detection probabiltiy at trackplates   [1:14; 1:4]                                        |
| p.occ         | occupancy      | year and species-specific estimates of annual occupancy across the study landscape   [1:14; 1:4]                                        |   
| p.occp        | occupancy projections | predictions of species-specific occupancy across the study landscape in two future time periods and under five climate scenarios   [1:2; 1:4; 1:5] | 

