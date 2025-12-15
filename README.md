# SSN_CarnivoreOccupancy

Code, JAGS model output, and formatted/extracted data to replicate dynamic occupancy analyses evaluating the effects of climate conditions and future climate projections on the occupancy of fishers, martens, grey foxes, and ringtails.

<h3>JAGSmodel</h3>

There are 2 files in this folder, each with code to pass to JAGS to run the models. 

**./JAGSmodel/SSN_DynOccProjectionModel.R:** The Bayesian dynamic occupancy model to estimate initial occupancy, persistence, and colonization of fishers, gray foxes, martens, and ringtails during observed years, predict occupancy under five climate model scenarios in two time periods, and summarize parameters of interest (e.g., prop occupied, turnover)  

**./JAGSmodel/SN_data.txt:**  data formatted for JAGS model via "dump.format" function. Given sensitive status of marten and fisher, raw data cannot be shared, but JAGS data input includes:
| List item     | Type       | Description                                                                                                                             |
| ------------- | ---------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| ytracks       | obs matrix | whether trackplate detected species <i>s</i> -- can be 0 [no], 1 [yes], NA [not deployed]                                               |
| ycams         | obs matrix | whether camera detected species <i>s</i> -- can be 0 [no], 1 [yes], NA [not deployed]                                                   |
| trackdeployed | cov matrix | whether trackplate was deployed -- can be 0 [no], 1 [yes], NA [not deployed]; note, essentially nuisance parameter given NAs in ytracks |
| camdeployed   | cov matrix | whether camera was deployed -- can be 0 [no], 1 [yes], NA [not deployed]; note, essentially nuisance parameter given NAs in ycams       |
| U             | vector     | sampling unit IDs [1:202]                                                                                                               |
| R             | vector     | station IDs in sampling unit <i>u</i>                                                                                                   |
| W             | vector     | sampling occasion <i>w</i> at station <i>r</i> in sampling unit <i>u</i>                                                                |
| T             | vector     | number of sampling years [1:14]  2002 - 2015                                                                                            |
| S             | vector     | number of species [1:4] 1 = fisher, 2 = fox, 3 = marten, 4 = ringtail                                                                   |
| G             | vector     | occupancy grid cell IDs [1:1255]                                                                                                        |
| NK            | vector     | occupancy grid cell IDs that do not intersect the Kern Plateau [1:1042]\ used to index occupancy to prevent estimating marten & ringtail occupancy in Kern (they don't occur there)                                                                                                       |
| Kern          | vector     | occupancy grid cell IDs that intersect the Kern Plateau [1:217] used to summarize occupancy & other parameters in Kern                  |
| SQFW          | vector     | occupancy grid cell IDs that intersect the Sequoia NF [1:425] used to summarize occupancy & other parameters in Sequoia NF              |
| Sierra        | vector     | occupancy grid cell IDs that intersect the Sierra NF [1:613] used to summarize occupancy & other parameters in Sierra NF                |
| LowElevNK     | vector     | occupancy grid cell IDs at low elev that do not intersect the Kern Plateau [1:273]                                                      |
| MidElevNK     | vector     | occupancy grid cell IDs at mid elev that do not intersect the Kern Plateau [1:463]                                                      |
| HigElevNK     | vector     | occupancy grid cell IDs at high elev that do not intersect the Kern Plateau [1:302]                                                     |

