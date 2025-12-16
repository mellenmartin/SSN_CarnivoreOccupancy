# SSN_CarnivoreOccupancy

Code, initial values, and formatted/extracted data to replicate dynamic occupancy analyses evaluating the effects of climate conditions and future climate projections on the occupancy of fishers, martens, grey foxes, and ringtails. JAGS model output was too large to upload in command line chains or RDS format...

<h3>JAGSmodel</h3>

There are 5 files in this folder:

**./JAGSmodel/SSN_DynOccProjectionModel.R:** The Bayesian dynamic occupancy model to estimate initial occupancy, persistence, and colonization of fishers, gray foxes, martens, and ringtails during observed years, predict occupancy under five climate model scenarios in two time periods, and summarize parameters of interest (e.g., prop occupied, turnover)  

**./JAGSmodel/SN_data.txt:**  data formatted for JAGS model via "dump.format" function. Given sensitive status of marten and fisher, raw data cannot be shared, but JAGS data input includes:
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
