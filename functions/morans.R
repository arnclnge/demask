moran_qyear <- function(catch_sf){
# Define the distance bands (note that each band is defined
#by an annulus)
 start <- 0  #Starting distance in meters (the From)
 end <- 100000 # Ending distance in meters (the To)
 incr <- 10000  #Distance increment (which also defines the annulus width)
 incr.v <- seq(start, end, incr)


 # Define empty vector elements to store the I and p-values
 morI.mc <- vector()
 sign.mc <- vector()
 s.coord <- sf::st_coordinates(catch_sf)
 # Loop through each distance band
 for (i in (2:length(incr.v))) {
   s.dist <- dnearneigh(s.coord, incr.v[i - 1], incr.v[i])
   s.lw <- nb2listw(s.dist, style = "W", zero.policy=T)
   s.mor <- moran.mc(catch_sf$Catch, s.lw, nsim=599, zero.policy = TRUE)
   sign.mc[i] <- s.mor$p.value
   morI.mc[i] <- s.mor$statistic
 }

#  Modify p-value to reflect extremes at each end
 sign.mc <- ifelse(sign.mc > 0.5, 1 - sign.mc, sign.mc)

 #First, generate an empty plot
 plot(morI.mc ~ eval(incr.v - incr * 0.5), type = "n", ann = FALSE, axes = FALSE)

 # Set the background plot to grey then add white grids
 u <- par("usr")  #Get plot are coordinates
 rect(u[1], u[3], u[2], u[4], col = "#EEEEEE", border = NA)
 axis(1, lab = ((incr.v) / 1000), at = (incr.v), tck = 1, col = "#FFFFFF", lty = 1)
 axis(2, tck = 1, col = "#FFFFFF", lty = 1, labels = FALSE)

  #Add the theoretical "no autocorelation" line
 abline(h = -1 / (length(catch_sf$Catch)), col = "grey20")

  #Add the plot to the canvas
 par(new = TRUE)
 plot(morI.mc ~ eval(incr.v - incr * 0.5),
      type = "b", xaxt = "n", las = 1,
      xlab = "Distance (km)", ylab = "Moran's I")
 points(morI.mc ~ eval(incr.v - incr * 0.5),
        col = ifelse(sign.mc < 0.01, "red", "grey"),
        pch = 16, cex = 2.0)
title(paste(catch_sf$Year[1],"-",catch_sf$quarter[1]))
  #Add numeric values to points
 text(eval(incr.v - incr * 0.5), morI.mc, round(sign.mc,3), pos = 3, cex = 0.5)
}

moran_qyear(catch_sf)
apply(q_yr_combo,
      1, #to apply it row by row 
      function(x) {
        q <- x["quarter"]
        y <- x["Year"]
        catch_sf <- catch_all%>%
          dplyr::filter(quarter == q,
                        Year == y)%>%
          st_as_sf(coords = c("Longitude", "Latitude"), crs = "EPSG:4326")%>%sf::st_transform(crs = "EPSG:3035")
        moran_qyear(catch_sf) 
      })
 