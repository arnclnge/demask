library(reticulate)
library(sf)
library(lubridate)
library(dplyr)
library(here)
#renv::use_python() first time
#py_install('Copernicusmarine')
bbox <- st_bbox(st_transform(study_area,crs  = 4326))
#py_install("h5py")
xmin <- bbox[[1]]
xmax <- bbox[[3]]
ymin <- bbox[[2]]
ymax<- bbox[[4]]
date_start <- "2015-01-01"
date_end <- "2025-12-01"
if(!file.exists(here("data","environmental_data","temp_sal_bottomt.nc"))){
cm <- import("copernicusmarine")
start <- as.POSIXct(date_start, format = "%Y-%m-%d")%>%
  format("%Y-%m-%dT%H:%M:%S")
end <- as.POSIXct(date_end, format = "%Y-%m-%d")%>%
  format("%Y-%m-%dT%H:%M:%S")
#cm$login()
cm$subset(
  dataset_id="cmems_mod_glo_phy_my_0.083deg_P1M-m",
  variables=c("so", "thetao", "bottomT"),
  minimum_longitude=xmin,
  maximum_longitude=xmax,
  minimum_latitude=ymin,
  maximum_latitude=ymax,
  start_datetime=start,
  end_datetime=end,
  minimum_depth=0.49402499198913574,
  maximum_depth=0.49402499198913574,
  output_directory= "data/environmental_data",
  output_filename="temp_sal_bottomt.nc",
  overwrite = TRUE)

} else{
tempsal <- terra::rast(here("data","environmental_data","temp_sal_bottomt.nc"))
}


# bathymetry --------------------------------------------------------------
# Bathymetry data is a bit different as it is coming from EMODnet
## general data handling
library(XML)
library(dplyr)
library(tidyr)
library(reshape2)
library(downloader)

library(raster)
library(sp)
library(mapdata)
library(ncdf4)
library(tiff)

if(!file.exists(here("data","environmental_data","bathy.tif"))){
  
  ifelse(!dir.exists(here("data","environmental_data", "bathy_sliced")), dir.create(here("data","environmental_data", "bathy_sliced")), FALSE)
  #xmin etc are described in 3_1
  stepsize <- 0.4
  number_of_slices <- ceiling((bbox[[3]]-bbox[[1]])/stepsize)
  for(i in 1:number_of_slices){
    beginslice <- bbox[[1]] + (i-1)*stepsize
    endslice <- bbox[[1]] + i*stepsize
    #We get an error because the file is too big, will split up in horizontal slices, and then merge together later 
    con <-paste0("https://ows.emodnet-bathymetry.eu/wcs?service=wcs&version=1.0.0&request=getcoverage&coverage=emodnet:mean&crs=EPSG:4326&BBOX=",beginslice,",",bbox[[2]],",",endslice,",",bbox[[4]],"&format=image/tiff&interpolation=nearest&resx=0.08333333&resy=0.08333333")
    nomfich <- file.path("data","environmental_data",paste0("bathy_sliced/","slice_",i, "img_.tiff"))
    download(con, nomfich, quiet = TRUE, mode = "wb")
    
  }
  
  
  #merge them together
  bathyrasters <- list()
  for(file in list.files(file.path("data","environmental_data","bathy_sliced"))){
    bathyrasters[[file]] <- terra::rast(here("data","environmental_data",paste0("bathy_sliced/",file))) 
  }
  #Put the different spatrasters together in a spatrastercollection
  bathy_coll <- sprc(bathyrasters)
  
  #Merge the spatrastercollection
  bathy <- merge(bathy_coll)
  bathy[bathy>0] <- NA
  tempsal <- terra::rast(file.path("data","environmental_data","temp_sal_bottomt.nc"))
  bathy <- terra::resample(bathy, tempsal[[1]])
  names(bathy) <-"bathy"
  writeRaster(bathy,here("data","environmental_data","bathy.tif"), overwrite=TRUE)
} else{
  cat("Bathymetry layer already exists")
  bathy <- terra::rast(here("data","environmental_data","bathy.tif"))
  bathy <- resample(bathy,tempsal[[1]])
}

#Calculating the layer salinity at the bottom
#Will need to check if this is correct and how to do it seasonally
if(!file.exists(here("data","environmental_data","sal_bottom_cmems.nc"))){
print("Use the CMEMS bathymetry snooper data application to create this layer")
} else {
  bottom_sal <- terra::rast(here("data","environmental_data","sal_bottom_cmems.nc"))
}

if(!file.exists(here("data","environmental_data","q1_so.nc"))){
nlyr(tempsal) #396 layers for 3 variables so 132 months. 11 years.
#only keep quarter 1 and two, so we give the months 1,1,1,3,3,3,2,2,2,3,3,3 and discard 3 later
splitlist <- rep(c(1,1,1,0,0,0,2,2,2,0,0,0),times = nlyr(tempsal)/3/12)
splitlist_all <- rep(splitlist, times = 3)
all_q1q3 <- split(tempsal, splitlist_all)
all_q1 <- all_q1q3[[1]]
all_q3 <- all_q1q3[[3]]
split_variables <- c(rep(1,nlyr(all_q1)/3),rep(2,nlyr(all_q1)/3),rep(3,nlyr(all_q1)/3))
q1_so <- split(all_q1,split_variables)[[1]]%>%
  terra::mean()
q1_thetao <- split(all_q1,split_variables)[[2]]%>%
  terra::mean()
q1_bottomT <- split(all_q1,split_variables)[[3]]%>%
  terra::mean()
q3_so <- split(all_q3,split_variables)[[1]]%>%
  terra::mean()
q3_thetao <- split(all_q3,split_variables)[[2]]%>%
  terra::mean()
q3_bottomT <- split(all_q3,split_variables)[[3]]%>%
  terra::mean()
terra::writeCDF(q1_so, here("data","environmental_data","q1_so.nc"))
terra::writeCDF(q1_thetao, here("data","environmental_data","q1_thetao.nc"))
terra::writeCDF(q1_bottomT, here("data","environmental_data","q1_bottomT.nc"))
terra::writeCDF(q3_so, here("data","environmental_data","q3_so.nc"))
terra::writeCDF(q3_thetao, here("data","environmental_data","q3_thetao.nc"))
terra::writeCDF(q3_bottomT, here("data","environmental_data","q3_bottomT.nc"))
} else {
  q1_so <- terra::rast(here("data","environmental_data","q1_so.nc"))
  q1_thetao <- terra::rast(here("data","environmental_data","q1_thetao.nc"))
  q1_bottomT <- terra::rast(here("data","environmental_data","q1_bottomT.nc"))
  q3_so <- terra::rast(here("data","environmental_data","q3_so.nc"))
  q3_thetao <- terra::rast(here("data","environmental_data","q3_thetao.nc"))
  q3_bottomT <- terra::rast(here("data","environmental_data","q3_bottomT.nc"))
}


# Seabed habitat ----------------------------------------------------------

if(!file.exists(here("data","environmental_data","habitats_rast.tiff"))){
  library('rerddap')
  habitats_dataset_id <- "biology_8777_429f_a47a_d420"
  erddap_url <- "https://erddap.emodnet.eu/erddap/"
  # # get info on dataset
  habitats_info <- rerddap::info(datasetid = habitats_dataset_id, url = erddap_url) 
  # habitats_info
  #metadata of which habitat is which category
  # https://eunis.eea.europa.eu/habitats-code-browser-revised.jsp?expand=30000#level_30000
  # The categories of habitat
  # https://erddap.emodnet.eu/erddap/info/biology_8777_429f_a47a_d420/index.html
  # fetch dataset
  habitats_erddap <- 
    rerddap::griddap(datasetx = habitats_info, 
                     longitude = c(-12, 12), 
                     latitude = c(50, 62))
  
  # wrangle
  habitats <- 
    # retain the 'data' col
    habitats_erddap$data |>
    # make an sf obj
    mutate(lat = latitude, lon = longitude) |>
    st_as_sf(coords = c("lon", "lat"), crs = 4326) |>
    st_transform(crs = 3035) %>%
    mutate(longitude = st_coordinates(.)[,1],
           latitude = st_coordinates(.)[,2])
  
  
  
  
  ### ----habitats-rasterise-------------------------------------------------------
  habitats_vect <- terra::vect(habitats)  # terra's format for vector data
  
  
  habitats_rast <- 
    terra::rasterize(habitats_vect, 
                     r, 
                     field = "eusm_benthos_eunis2019ID")
  # To make it a categorical spatraster
  #the categories are the different found classes without NA
  unique_habitats <- sort(unique(habitats_vect$eusm_benthos_eunis2019ID))%>%na.omit()
  levels(habitats_rast) <- data.frame(id = unique_habitats, habitat = unique_habitats)
  terra::writeCDF(habitats_rast, here("data","environmental_data","habitats_rast.nc"), varname = "habitat", overwrite = TRUE)
  terra::writeRaster(habitats_rast, here("data","environmental_data","habitats_rast.tiff"), overwrite = TRUE)
  #todo: Change habitat to the correct names when we get this list
} else {
  habitats_rast <- terra::rast(here("data","environmental_data","habitats_rast.tiff"))
}