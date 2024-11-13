# SUPPLEMENT FOR MANUSCRIPT: THOMAS R BINDER, CHRISTOPHER M HOLBROOK, TODD A HAYDEN, AND CHARLES C KRUEGER. SPATIAL AND TEMPORAL VARIATION IN POSITIONING PROBABILITY OF ACOUSTIC TELEMETRY ARRAYS: FINE-SCALE VARIABILITY AND COMPLEX INTERACTIONS.

# SCRIPT FOR SIMULATING DETECTION (COLLISION PROBABILITY = 1 - DETECTION PROBABILITY) PROBABILITY BASED ON TRANSMITTER DELAY, BURST DURATION, AND NUMBER OF TRANSMITTERS WITHIN DETECTION RANGE
# SIMULATION ESTIMATES DETECTION PROBABILITY DUE ONLY TO COLLISIONS (I.E., NO OTHER VARIABLES INFLUENCE DETECTION PROBABILITY)

# INPUT ARGUMENTS
    # delayRng: Vector containing the minimum and maximum delay for transmitters in seconds
    # burstDur: Duration of a transmission; for VEMCO Global coding, use burstDur = 5.12
    # maxTags: Maximum number of transmitters within detection range at one time
    # nTrans: Number of transmitter histories to simulate

# OUTPUT: Dataframe containing summary statistics for the simulations 
    # nTags: Number of tags within detection range at one time
    # min: Minimum detection probability among simulated tags (nTrans)
    # q1: First quartile of detection probabilities among simulated tags (nTrans)
    # median: Median detection probability among simulated tags (nTrans)
    # q3: Third quartile of detection probabilities among simulated tags (nTrans)
    # max: Maximum detection probability among simulated tags (nTrans)
    # mean: Mean detection probability among simulated tags (nTrans)
    # expDetsPerHr: Expected number of detections per hour assuming perfect detection probability, given the number of tags within detection range (nTags)
    # totDetsPerHr: Observed number of detections per hour for a given number of tags (nTags)
    # effDelay: The effective delay of the transmitter after incorporating collisions
    # detsPerTagPerHr: Mean number of detections per hour per tag




# COLLISION SIMULATION FUNCTION:

calcCollisionProb = function(delayRng = c(500, 700), burstDur = 5.12, maxTags = 50, nTrans = 10000)
    {

	# preallocate objects
	pingHist = vector("list", length = maxTags) # transmission history (before collisions)
	collide = vector("list", length = maxTags) # list of logical value; indicates collision
	detProbs = data.frame(nTags = 1, min = 1, q1 = 1, med = 1, q3 = 1, max = 1, mean = 1) # preallocate and prefill first row
	pingHistObs = vector("list", length = maxTags) # observed detection history (after collisions)

    # define transmission and detection histories for each tag
    for (i in 1:maxTags)
      {
        # create transmission history; each list element is a tag, odd indices = start, even indices = end 
		# - draw transmissions from uniform distribution within delayRng
        pingStart = cumsum(runif(nTrans, delayRng[1], delayRng[2])+burstDur) #random start time 
        pingHist[[i]] = sort(c(pingStart, pingStart + burstDur))
    
        if(i>1)  # check to see if collide with any previous tag
          {
            for(j in 1:(i-1))
              {
                pingInts = findInterval(pingHist[[i]], pingHist[[j]]) # check to see if ith tag transmissions overlaps with any jth tag transissions
            
                collisions = (pingInts/2) != floor(pingInts/2) # logical indicates collision (TRUE) or nonCollision (FALSE)
            
                collide[[j]] = unique(c(collide[[j]], ceiling(pingInts[collisions]/2)))
                collide[[i]] = unique(c(collide[[i]], ceiling(row(as.matrix(collisions))[collisions]/2)))                  
              }
        
            detProb.k = 1 - (sapply(collide[1:i], length)/(sapply(pingHist[1:i], length)/2))
        
            detProbs[i,] = c(i, fivenum(detProb.k), mean(detProb.k))
                        
          }
    
         detProbs = round(detProbs, 3)  
      } #end i
  
      # calculate total number of hourly detects across all fish
      nomDelay = median(delayRng) # nominal delay
      expDetsPerTagPerHr = (3600/(nomDelay + burstDur)) #expected detects per tag per hour
    
      detProbs$expDetsPerHr = expDetsPerTagPerHr*detProbs$nTags
      detProbs$totDetsPerHr = round(with(detProbs, expDetsPerHr*mean), 0)
      detProbs$effDelay = round(with(detProbs, nomDelay*(1/mean)), 0) 
      detProbs$detsPerTagPerHr = round(with(detProbs, totDetsPerHr/nTags))
    
      return(detProbs)
    }



# EXAMPLE: USE OF FUNCTION TO PRODUCE FIG 9 IN THE BINDER ET AL. MANUSCRIPT

nominalDelay = c(60, 90, 120, 150, 180, 210, 240) # Define multiple nominal delays that will display on the same plot

# Maximum and minimum delays are nominal delay +/- 0.5 the nominal delay - input for function
minDelay = nominalDelay - 0.5*nominalDelay 
maxDelay = nominalDelay + 0.5*nominalDelay

burstDur = 5.12 # Set burst duration to 5.12 seconds - input to function

maxTags = 50 # Maximum number of tags within detection range - input to function

nTrans = 10000 # Number of transmitter histories to simulate - input to function

col = colors()[c(35,99,56,81,148,131, 261)] # Define a vector of colors to be looped through when creating the plot

# Loop through each delay in the 'nominalDelay' vector - run the collision probability function and produce a plot of calculated collision probability estimates for each nominal delay listed in 'nominalDelay' 
for(i in 1: length(nominalDelay))
    {

        temp = calcCollisionProb(delayRng=c(minDelay[i],maxDelay[i]), burstDur = burstDur, maxTags = maxTags, nTrans = nTrans) # Output is a dataframe containing summary statistics for the simulations
    
        if(i == 1){
            # Write plot to .png file
             png(filename = "CollisionProbabiity.png", bg = "transparent", height = 1000, width = 1000, pointsize = 32)
         
                par(mar = c(5,5,1,1))

                plot((1-mean)~nTags, data=temp, type='p', pch=20, ylim=c(0,1), xlab="# of transmitters within range", ylab="Probability of collision", col = col[i], las = 1) # Plot probability of collision by subtracting detection probability from 1
                box(lwd = 2)
                  points((1-mean)~nTags, data=temp, type='l', col = col[i], lwd = 2)
                legend(36, 0.4, col = col, legend = nominalDelay, lty = 1, pch = 20, lwd = 2, title = "Nominal delay (s)", cex = 0.75)    
        }else{ # if more than one nominal delay is specified, adds subsequent nominal delay simulations to the existing plot

                points((1-mean)~nTags, data=temp, pch=20, col = col[i])
                points((1-mean)~nTags, data=temp, type='l', col = col[i], lwd = 2)    

        }

    }    
        dev.off()              