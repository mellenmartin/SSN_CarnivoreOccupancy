model {
  
  ### Determine derived values ###
  
  # Predicted probability of detection at track plates and cameras as a funciton of cc
  for(x in 1:100){
    for(s in 1:S){
      logit(canopy.fx.track[x,s]) <- mean(b0tracks[not10,s]) + b1[s]*((x-cc.mean)/cc.sd)
      logit(canopy.fx.camera[x,s]) <- mean(c0cams[10:TT1,s]) + c1[s]*((x-cc.mean)/cc.sd)
    }
  }
  
  # Lambda (change over time) throughout the entire state-space
  for(s in 1:S){
    for(t in 2:TT1){
      lambda[t,s] <- sum(z[,t,s])/sum(z[,t-1,s])
    }
    for(p in 1:5){
      lambdap[1,s,p] <- sum(zp[,1,s,p])/sum(z[,TT1,s])
      lambdap[2,s,p] <- sum(zp[,2,s,p])/sum(zp[,1,s,p])
    } #p
  } #s
  
  # Proportion of each forest that is occupied each year
  for(s in 1:S){
    for(t in 1:TT1){
      pforest[t,s,1] <- (sum(z[SQFW,t,s]))/length(SQFW)
      pforest[t,s,2] <- (sum(z[Kern,t,s]))/length(Kern)
      pforest[t,s,3] <- (sum(z[Sierra,t,s]))/length(Sierra)
    }
    for(t in 1:2){
      for(p in 1:5){
        pforestp[t,s,1,p] <- (sum(zp[SQFW,t,s,p]))/length(SQFW)
        pforestp[t,s,2,p] <- (sum(zp[Kern,t,s,p]))/length(Kern)
        pforestp[t,s,3,p] <- (sum(zp[Sierra,t,s,p]))/length(Sierra)
      }
    }
  }
  
  # Differences between 2011-2015 from 2010 by elevational band and with projections; excluding kern plateau
  for(s in 1:S){      # For each species
    for(t in 10:TT1){   # For each year after 2010 
      pchange[t,s,1] <- (sum(z[LowElevNK,t,s])/length(LowElevNK))-(sum(z[LowElevNK,9,s])/length(LowElevNK))
      pchange[t,s,2] <- (sum(z[MidElevNK,t,s])/length(MidElevNK))-(sum(z[MidElevNK,9,s])/length(MidElevNK))
      pchange[t,s,3] <- (sum(z[HigElevNK,t,s])/length(HigElevNK))-(sum(z[HigElevNK,9,s])/length(HigElevNK))
    } #t
    for(t in 1:2){
      for(p in 1:5){
        pchangep[t,s,1,p] <- (sum(zp[LowElevNK,t,s,p])/length(LowElevNK))-(sum(z[LowElevNK,9,s])/length(LowElevNK))
        pchangep[t,s,2,p] <- (sum(zp[MidElevNK,t,s,p])/length(MidElevNK))-(sum(z[MidElevNK,9,s])/length(MidElevNK))
        pchangep[t,s,3,p] <- (sum(zp[HigElevNK,t,s,p])/length(HigElevNK))-(sum(z[HigElevNK,9,s])/length(HigElevNK))
      } #p
    } #t
  } #s
  
  # Derived parameters of detection
  for (s in 1:S){                     # For each species
    for (t in 10:TT1){                  # For each year [5 years with cameras (2010-)]; start in 2011 (year 10)
      det.cam.v[t,s] <- mean(pcam[,t,,,s])
      det.cam.t[t,s] <- 1-((1-det.cam.v[t,s])^W)
    } #t
    for (t in not10){
      det.tra.v[t,s] <- mean(ptrack[,t,,,s])
      det.tra.t[t,s] <- 1-((1-det.tra.v[t,s])^W)
    } #t
  } #s
  
  
  # PROJECTIONS
  # Derived parameters: Sample and population occupancy, growth rate and turnover
  for (t in 1:2){
    for (s in 1:2){
      for (p in 1:5){
        p.occp[t,s,p] <- n.occp[t,s,p]/G        # proportion of occupied sites each year in non-kern
        n.occp[t,s,p] <- sum(zp[1:G,t,s,p])    # number of occupied sites non-kern each year
      } #s
    } #t
  } #p
  
  # Derived parameters: Sample and population occupancy, growth rate and turnover
  for (t in 1:2){
    for (s in 3:4){
      for (p in 1:5){
        p.occp[t,s,p] <- n.occNKp[t,s,p]/NK       # proportion of occupied sites each year in non-kern
        n.occNKp[t,s,p] <- sum(zp[1:NK,t,s,p])    # number of occupied sites non-kern each year
      } #s
    } #t
  } #p
  
  # Derived parameters: Sample and population occupancy, growth rate and turnover
  for (t in 1:TT1){
    for (s in 1:2){
      p.occ[t,s] <- n.occ[t,s]/G        # proportion of occupied sites each year in non-kern
      n.occ[t,s] <- sum(z[1:G,t,s])    # number of occupied sites non-kern each year
    } #s
  } #t
  
  # Derived parameters: Sample and population occupancy, growth rate and turnover
  for (t in 1:TT1){
    for (s in 3:4){
      p.occ[t,s] <- n.occNK[t,s]/NK       # proportion of occupied sites each year in non-kern
      n.occNK[t,s] <- sum(z[1:NK,t,s])    # number of occupied sites non-kern each year
    } #s
  } #t
  
  
  ### Observation model for camera detections ####
  for (u in 1:U){                     # For each unit
    for (r in 1:6){                     # For each station (only 6 cameras)
      for (t in 10:TT1){                  # For each year [5 years with cameras (2010-)]; start in 2011 (year 10)
        for (w in 1:W){                     # For each week/check
          for (s in 1:S){                     # For each species
            ycams[u,t,r,w,s] ~ dbern(muc[u,t,r,w,s])   # presence/absence each year on cam
            muc[u,t,r,w,s] <- z[stgrid[u,t,r],t,s]*pcam[u,t,r,w,s]  # true occupancy in the grid cell where camera was placed * probability of detection
            logit(pcam[u,t,r,w,s]) <- c0cams[t,s] + c1[s]*scancov[u,r,t] + c2[s]*ssdcancov[u,r,t] + c3[s]*camtype1[u,t-9,r]
            + c4[s]*camtype2[u,t-9,r] + c5[s]*prevcamdet[u,t,r,w,s]
          } #s
        } #w
      } #t
    } #r
  } #u
  
  # Observation model for track plates
  for (u in 1:U){                   # For each unit
    for (r in 1:R){                   # For each station
      for (w in 1:W){                   # For each week/check
        for (s in 1:S){                   # For each species
          for (t in not10){                 # For each year [second half of study]
            ytracks[u,t,r,w,s] ~ dbern(mut[u,t,r,w,s]) # presence/absence each year
            mut[u,t,r,w,s] <- z[stgrid[u,t,r],t,s]*ptrack[u,t,r,w,s] # true occupancy * probability of detection
            logit(ptrack[u,t,r,w,s]) <- b0tracks[t,s] + b1[s]*scancov[u,r,t] + b2[s]*ssdcancov[u,r,t] + b3[s]*prevtrackdet[u,t,r,w,s]
          } #t
        } #s
      } #w
    } #r
  } #u
  
  # PROJECTIONS Occupancy latent process for everywhere else
  for (g in 1:NK){
    for (s in 1:S){  
      for (p in 1:5){
        zp[g,1,s,p] ~ dbern(muZ_2[g,1,s,p])
        zp[g,2,s,p] ~ dbern(muZ_2[g,2,s,p])
        muZ_2[g,1,s,p] <- (z[g,TT1,s]*phi_2[g,1,s,p]) + ((1-z[g,TT1,s])*gamma_2[g,1,s,p])
        muZ_2[g,2,s,p] <- (zp[g,1,s,p]*phi_2[g,2,s,p]) + ((1-zp[g,1,s,p])*gamma_2[g,2,s,p])
        logit(phi_2[g,1,s,p]) <- phi.0[s] + phi1[s]*gcancov[g,15] + phi2[s]*gsdcancov[g,15] + phi3[s]*gsnow[g,15,p] + phi5[s]*gppt[g,15,p] + phi6[s]*gtmin[g,15,p] 
        logit(gamma_2[g,1,s,p]) <- gamma.0[s] + gam1[s]*gcancov[g,15] + gam2[s]*gsdcancov[g,15] + gam3[s]*gsnow[g,15,p] + gam5[s]*gppt[g,15,p] + gam6[s]*gtmin[g,15,p]
        logit(phi_2[g,2,s,p]) <- phi.0[s] + phi1[s]*gcancov[g,15+1] + phi2[s]*gsdcancov[g,15+1] + phi3[s]*gsnow[g,15+1,p] + phi5[s]*gppt[g,15+1,p] + phi6[s]*gtmin[g,15+1,p] 
        logit(gamma_2[g,2,s,p]) <- gamma.0[s] + gam1[s]*gcancov[g,15+1] + gam2[s]*gsdcancov[g,15+1] + gam3[s]*gsnow[g,15+1,p] + gam5[s]*gppt[g,15+1,p] + gam6[s]*gtmin[g,15+1,p]
      } #s
    } #g
  } #p
  
  # Occupancy latent process for not-kern
  for (g in 1:NK){
    for (s in 1:S){
      for (t in 2:TT1){
        z[g,t,s] ~ dbern(muZ[g,t,s])
        muZ[g,t,s] <- (z[g,t-1,s]*phi[g,t,s]) + ((1-z[g,t-1,s])*gamma[g,t,s])
        logit(phi[g,t,s]) <- phi.0[s] + phi1[s]*gcancov[g,t] + phi2[s]*gsdcancov[g,t] + phi3[s]*gsnow[g,t,1] + phi5[s]*gppt[g,t,1] + phi6[s]*gtmin[g,t,1] 
        logit(gamma[g,t,s]) <- gamma.0[s] + gam1[s]*gcancov[g,t] + gam2[s]*gsdcancov[g,t] + gam3[s]*gsnow[g,t,1] + gam5[s]*gppt[g,t,1] + gam6[s]*gtmin[g,t,1]
      } #t
    } #s
  } #g
  
  # PROJECTIONS Occupancy latent process for kern plateau
  for (g in (NK+1):G){
    for (s in 1:2){  
      for (p in 1:5){
        zp[g,1,s,p] ~ dbern(muZ_2[g,1,s,p])
        zp[g,2,s,p] ~ dbern(muZ_2[g,2,s,p])
        muZ_2[g,1,s,p] <- (z[g,TT1,s]*phi_2[g,1,s,p]) + ((1-z[g,TT1,s])*gamma_2[g,1,s,p])
        muZ_2[g,2,s,p] <- (zp[g,1,s,p]*phi_2[g,2,s,p]) + ((1-zp[g,1,s,p])*gamma_2[g,2,s,p])
        logit(phi_2[g,1,s,p]) <- phi.0[s] + phi1[s]*gcancov[g,15] + phi2[s]*gsdcancov[g,15] + phi3[s]*gsnow[g,15,p] + phi5[s]*gppt[g,15,p] + phi6[s]*gtmin[g,15,p] 
        logit(gamma_2[g,1,s,p]) <- gamma.0[s] + gam1[s]*gcancov[g,15] + gam2[s]*gsdcancov[g,15] + gam3[s]*gsnow[g,15,p] + gam5[s]*gppt[g,15,p] + gam6[s]*gtmin[g,15,p]
        logit(phi_2[g,2,s,p]) <- phi.0[s] + phi1[s]*gcancov[g,15+1] + phi2[s]*gsdcancov[g,15+1] + phi3[s]*gsnow[g,15+1,p] + phi5[s]*gppt[g,15+1,p] + phi6[s]*gtmin[g,15+1,p] 
        logit(gamma_2[g,2,s,p]) <- gamma.0[s] + gam1[s]*gcancov[g,15+1] + gam2[s]*gsdcancov[g,15+1] + gam3[s]*gsnow[g,15+1,p] + gam5[s]*gppt[g,15+1,p] + gam6[s]*gtmin[g,15+1,p]
      } #s
    } #g
  } #p
  
  # Occupancy latent process for kern plateau
  for (g in (NK+1):G){
    for (s in 1:2){      # Don't model marten on Kern
      for (t in 2:TT1){
        z[g,t,s] ~ dbern(muZ[g,t,s])
        muZ[g,t,s] <- (z[g,t-1,s]*phi[g,t,s]) + ((1-z[g,t-1,s])*gamma[g,t,s])
        logit(phi[g,t,s]) <- phi.0[s] + phi1[s]*gcancov[g,t] + phi2[s]*gsdcancov[g,t] + phi3[s]*gsnow[g,t,1] + phi5[s]*gppt[g,t,1] + phi6[s]*gtmin[g,t,1]
        logit(gamma[g,t,s]) <- gamma.0[s] + gam1[s]*gcancov[g,t] + gam2[s]*gsdcancov[g,t] + gam3[s]*gsnow[g,t,1] + gam5[s]*gppt[g,t,1] + gam6[s]*gtmin[g,t,1]
      } #t
    } #s
  } #g
  
  # Projections on the kern for ringtail and marten
  for(g in (NK+1):G){
    for(t in 1:2){
      for(p in 1:5){
        for(s in 3:4){
          zp[g,t,s,p] <- 0
        } #s
      } #t
    } #g
  } #p
  
  for(g in (NK+1):G){
    for(t in 1:TT1){
      for(s in 3:4){
        z[g,t,s] <- 0
      } #s
    } #t
  } #g
  
  # Ecological submodel for starting occupancy (without projections)
  for (s in 1:S){
    for (g in 1:NK){
      z[g,1,s] ~ dbern(psi1[g,s]) # Occupancy in the first year is bernoulli distributed (0/1)
      logit(psi1[g,s]) <- d0[s] + d1[s]*gcancov[g,1] + d2[s]*gsdcancov[g,1] + d3[s]*gsnow[g,1,1] + d4[s]*gppt[g,1,1] + d5[s]*gtmin[g,1,1]
    } #g
  } #s
  for(s in 1:2){     # Don't model marten or ringtail on kern
    for (g in (NK+1):G){
      z[g,1,s] ~ dbern(psi1[g,s]) # Occupancy in the first year is bernoulli distributed (0/1)
      logit(psi1[g,s]) <- d0[s] + d1[s]*gcancov[g,1] + d2[s]*gsdcancov[g,1] + d3[s]*gsnow[g,1,1] + d4[s]*gppt[g,1,1] + d5[s]*gtmin[g,1,1]
    } #g
  } #s
  
  #### Specify priors ####
  for(s in 1:S){
    for(t in 10:TT1){ # 5 years of camera data
    c0cams[t,s] ~ dnorm(c0.mu[s], c0.tau[s])T(-10,10)
    } #t
    for(t in not10){ # Preparing intercept as a random effect
    b0tracks[t,s] ~ dnorm(b0.mu[s], b0.tau[s])T(-10,10)
    } #t
    # for(k in 1:2){
    phi1[s] ~ dnorm(0, 0.01)T(-10,10)
    phi2[s] ~ dnorm(0, 0.01)T(-10,10)
    phi3[s] ~ dnorm(0, 0.01)T(-10,10)
    #phi4[s] ~ dnorm(0, 0.01)T(-10,10)
    phi5[s] ~ dnorm(0, 0.01)T(-10,10)
    phi6[s] ~ dnorm(0, 0.01)T(-10,10)
    gam1[s] ~ dnorm(0, 0.01)T(-10,10)
    gam2[s] ~ dnorm(0, 0.01)T(-10,10)
    gam3[s] ~ dnorm(0, 0.01)T(-10,10)
    #gam4[s] ~ dnorm(0, 0.01)T(-10,10)
    gam5[s] ~ dnorm(0, 0.01)T(-10,10)
    gam6[s] ~ dnorm(0, 0.01)T(-10,10)
    b1[s] ~ dnorm(0, 0.01)T(-10,10)
    b2[s] ~ dnorm(0, 0.01)T(-10,10)
    b3[s] ~ dnorm(0, 0.01)T(-10,10)
    c1[s] ~ dnorm(0, 0.01)T(-10,10)
    c2[s] ~ dnorm(0, 0.01)T(-10,10)
    c5[s] ~ dnorm(0, 0.01)T(-10,10)
    d0[s] ~ dnorm(0, 2)
    d1[s] ~ dnorm(0, 0.01)T(-10,10)
    d2[s] ~ dnorm(0, 0.01)T(-10,10)
    d3[s] ~ dnorm(0, 0.01)T(-10,10)
    d4[s] ~ dnorm(0, 0.01)T(-10,10)
    d5[s] ~ dnorm(0, 0.01)T(-10,10)
    d6[s] ~ dnorm(0, 0.01)T(-10,10)
    # } #k
    c3[s] ~ dnorm(0, 0.01)T(-10,10)
    c4[s] ~ dnorm(0, 0.01)T(-10,10)
    b0.mu[s] ~ dnorm(0,2)
    b0.tau[s] <- pow(b0.sd[s], -2)
    b0.sd[s] ~ dunif(0,2)
    c0.mu[s] ~ dnorm(0,2)
    c0.tau[s] <- pow(c0.sd[s], -2)
    c0.sd[s] ~ dunif(0,2)
    } #s

    # Survival/colonization priors
    for(s in 1:S){
    # for(k in 1:2){
    phi.0[s] ~ dnorm(0,2)       # intercept for survival
    gamma.0[s] ~ dnorm(0,2)     # intercept for colonization
    # }
  }
}
