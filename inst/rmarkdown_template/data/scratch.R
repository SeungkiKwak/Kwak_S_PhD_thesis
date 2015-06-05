# read data in, three columns Name = lab code, Date = radiocarbon age, Uncertainty = error
dates_EP <- read.csv('inst/rmarkdown_template/data/radiocarbon_EP.csv', stringsAsFactors = FALSE)
dates_KM <- read.csv('inst/rmarkdown_template/data/radiocarbon_KM.csv', stringsAsFactors = FALSE)
dates_SG <- read.csv('inst/rmarkdown_template/data/radiocarbon_SG.csv', stringsAsFactors = FALSE)
dates_SS <- read.csv('inst/rmarkdown_template/data/radiocarbon_SS.csv', stringsAsFactors = FALSE)

# make date names
dates_EP$Name <- paste0("EP_", dates_EP[,1])
dates_KM$Name <- paste0("KM_", dates_KM[,1])
dates_SG$Name <- paste0("SG_", dates_SG[,1])
dates_SS$Name <- paste0("SS_", dates_SS[,1])
# remove spaces
dates_EP$Name <- gsub("[[:space:]]", "_", dates_EP$Name)
dates_KM$Name <- gsub("[[:space:]]", "_", dates_KM$Name)
dates_SG$Name <- gsub("[[:space:]]", "_", dates_SG$Name)
dates_SS$Name <- gsub("[[:space:]]", "_", dates_SS$Name)

# split age and error term
library(stringr)
# EP
date_split  <- str_split_fixed(dates_EP$C14.date..BP..uncalibrated., "!>", 2)
date_split_Age <- as.numeric(gsub("[^0-9]", "", date_split[, 1]))
date_split_Error <- as.numeric(gsub("[^0-9]", "", date_split[, 2]))
# combine into data frame
dates_EP <- data.frame(Name = dates_EP$Name,
                    Date = date_split_Age,
                    Uncertainty = date_split_Error)
# KM
date_split  <- str_split_fixed(dates_KM$C14.date..BP..uncalibrated., "pm", 2)
date_split_Age <- as.numeric(gsub("[^0-9]", "", date_split[, 1]))
date_split_Error <- as.numeric(gsub("[^0-9]", "", date_split[, 2]))
# combine into data frame
dates_KM <- data.frame(Name = dates_KM$Name,
                       Date = date_split_Age,
                       Uncertainty = date_split_Error)
# SG
date_split  <- str_split_fixed(dates_SG$C14.date..BP..uncalibrated., "\\?\\?", 2)
date_split_Age <- as.numeric(gsub("[^0-9]", "", date_split[, 1]))
date_split_Error <- as.numeric(gsub("[^0-9]", "", date_split[, 2]))
# combine into data frame
dates_SG <- data.frame(Name = dates_SG$Name,
                       Date = date_split_Age,
                       Uncertainty = date_split_Error)
# SS
date_split  <- str_split_fixed(dates_SS$C14.date..BP..uncalibrated., "\\?\\?", 2)
date_split_Age <- as.numeric(gsub("[^0-9]", "", date_split[, 1]))
date_split_Error <- as.numeric(gsub("[^0-9]", "", date_split[, 2]))
# combine into data frame
dates_SS <- data.frame(Name = dates_SS$Name,
                       Date = date_split_Age,
                       Uncertainty = date_split_Error)

# combine all dates into one...
dates <- rbind(dates_EP, dates_KM, dates_SG, dates_SS)
dates <- dates[complete.cases(dates), ]

# use the R package BChron...

library(Bchron)
# calibrate
ages = BchronCalibrate(ages=dates$Date, ageSds=dates$Uncertainty, calCurves=rep('intcal13', nrow(dates)))
summary(ages)
# plot(ages)

# remove NAs
dates_SS <- dates_SS[complete.cases(dates_SS),]

# get estimation of activity through age as proxy
Dens_EP = BchronDensity(ages=dates_EP$Date, ageSds=dates_EP$Uncertainty, calCurves=rep('intcal13', nrow(dates_EP)))
Dens_KM = BchronDensity(ages=dates_KM$Date, ageSds=dates_KM$Uncertainty, calCurves=rep('intcal13', nrow(dates_KM)))
Dens_SG = BchronDensity(ages=dates_SG$Date, ageSds=dates_SG$Uncertainty, calCurves=rep('intcal13', nrow(dates_SG)))
Dens_SS = BchronDensity(ages=dates_SS$Date, ageSds=dates_SS$Uncertainty, calCurves=rep('intcal13', nrow(dates_SS)))

plot(Dens_EP, plotSum = T)
plot(Dens_KM, plotSum = T)
plot(Dens_SG, plotSum = T)
plot(Dens_SS, plotSum = T)


# get plot parameters to make a custom plot
BchronDensity_plot_params <- function(ID, x){
n = length(x$calAges)
thetaRange = range(x$calAges[[1]]$ageGrid)
for (i in 2:n) thetaRange = range(c(thetaRange, x$calAges[[i]]$ageGrid))
dateGrid = seq(round(thetaRange[1] * 0.9, 3), round(thetaRange[2] * 
                                                      1.1, 3), length = 1000)
gauss <- function(x, mu, sig) {
  u <- (x - mu)/sig
  y <- exp(-u * u/2)
  y
}
gbase <- function(x, mus) {
  sig <- (mus[2] - mus[1])/2
  G <- outer(x, mus, gauss, sig)
  G
}
Gstar = gbase(dateGrid, x$mu)
dens = vector(length = length(dateGrid))
for (i in 1:nrow(x$p)) {
  dens = dens + Gstar %*% x$p[i, ]
}
densFinal = dens/sum(dens)
return(data.frame(ID = ID, dateGrid = dateGrid, densFinal = densFinal))
}

Dens_EP_plot <- BchronDensity_plot_params("EP", Dens_EP)
Dens_KM_plot <- BchronDensity_plot_params("KM", Dens_KM)
Dens_SG_plot <- BchronDensity_plot_params("SG", Dens_SG)
Dens_SS_plot <- BchronDensity_plot_params("SS", Dens_SS)

plot_all <- rbind(Dens_EP_plot, Dens_KM_plot, Dens_SG_plot, Dens_SS_plot)

library(ggplot2)
ggplot(plot_all, aes(dateGrid, densFinal, colour = ID)) +
  geom_line(size = 0.5) +
  theme_minimal(base_size = 14) +
  xlab("calibrated years BP") +
  ylab("Density") +
  xlim(1000,4000)


####################

# construct OxCal format
oxcal_format <- paste0('R_Date(\"',  gsub("^\\s+|\\s+$", "", dates$Name), '\",', dates$Date, ',', dates$Uncertainty, ');')
# inspect
cat(oxcal_format)

# write formatted dates to text file
write.table(oxcal_format, file = 'oxcal_format.txt', row.names = FALSE, col.names = FALSE, quote = FALSE)

# find location of text file
getwd()


##################

# digitize co-ord of ellipses to identify d13C 
# reference: http://journal.r-project.org/archive/2011-1/RJournal_2011-1_Poisot.pdf
require(devtools) 
install_github("digitize", username="tpoisot", subdir="digitize")
library(digitize)
# select two points at the extremes of each axis...
calibration_points <- ReadAndCal('Pages from thesis.jpg')
# select points on the ellipses... rather slow!
points_from_plot <- DigitData(col = 'red')
# calibrate the points on the ellipses by inputting the coords of the points on the extremes of the axes... Calibrate(data,calpoints,x1,x2,y1,y2)
data <- Calibrate(points_from_plot, calibration_points, -34, -22, -36, -22)
# check 
m <- 1
n <- 130
plot(data$x[m:n], data$y[m:n], xlim=c(-30,-20),ylim=c(-30,-20))
# save
write.csv(data, "ellipses.csv")

fitSS <- function(xy,
                  a0=mean(xy[,1]),
                  b0=mean(xy[,2]),
                  r0 = mean(sqrt((xy[,1]-a0)^2 + (xy[,2]-b0)^2)),
                  ...){
  SS <- function(abr){
    sum((abr[3] - sqrt((xy[,1]-abr[1])^2 + (xy[,2]-abr[2])^2))^2)
  }
  optim(c(a0,b0,r0), SS, ...)
}



fit_xy <- fitSS(data[m:n,])

library(plotrix)
draw.ellipse(x = fit_xy$par[1], y = fit_xy$par[2], 
             a = fit_xy$par[3]*1.3, b = fit_xy$par[3]*0.8,
             angle = 20, border = "green")


library(ggplot2)

ggplot(data[1:130,], aes(x, y)) + 
  stat_ellipse(type = "euclid") +
  geom_point()

###################################################

# JAS paper

# read in data
CSIA_KM <- read.csv('inst/rmarkdown_template/data/CSIA_KM.csv', stringsAsFactors = FALSE)
CSIA_SS <- read.csv('inst/rmarkdown_template/data/CSIA_SS.csv', stringsAsFactors = FALSE)
# combine both into one dataframe
CSIA_KM_and_SS <- rbind(CSIA_KM, CSIA_SS)

# get site ID to control plotting colour and shape
CSIA_KM_and_SS$ID <- substr(CSIA_KM_and_SS$Sample.No., 1, 2)

# plot
library
ggplot2
ggplot(CSIA_KM_and_SS, aes(C16.0....13C., C18.0....13C., colour = ID )) +
  geom_point(size = 4, aes(shape = ID)) +
  theme_minimal(base_size = 14) +
  xlab("C16:0 d13C") +
  ylab("C18:0 d13C") +
  xlim(-40,-10) +
  ylim(-40,-10) 

