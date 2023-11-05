#load and set the rejustify library
#install.packages("remotes")
#remotes::install_github("rejustify/r-package")

library(rejustify)
setCurl(learn=TRUE)

#sample access token, valid until the end of 2023
register(token = "445E-C0D5-D466", email = "undatathon@rejustify.com")

#create empty data template
ccode <- c('AT', 'BE', 'BG', 'HR', 'CY', 'CZ', 'DE', 'DK', 'EE', 'ES', 'FI', 'FR', 'GB', 'GR', 'HU', 'IE', 'IT', 'LT', 'LU', 'LV', 'MT', 'NL', 'PL', 'PT', 'RO', 'SE', 'SI', 'SK') 
df   <- data.frame(country = ccode,
                   education_SDG = NA,
                   check.names = FALSE, stringsAsFactors = FALSE)

#let rejustify analyze the data template
st  <- analyze(df)

#adjust the data repository (if needed)
st  <- adjust(st, column = 2, items = list("class" = "general", "feature" = NA, "provider" = "Eurostat", "table" = "edat_lfs_9911"))

#fill the values!
rdf <- fill(df, st)

#adjust the relevant filters and refill (if needed)
def <- adjust(rdf$default, column = 2, items = list("Sex" = "M",
                                                    "Country of citizenship" = "NAT",
                                                    "International Standard Classification of Education (ISCED 2011)" = "ED5-8",
                                                    "Age class" = "Y30-34"))
rdf <- fill(df, st, default = def)

#plot the values on the map
library(cartography)
data(nuts2006)
rdf$data$education_SDG <- as.numeric(rdf$data$education_SDG)

# plot a layer with the extent of the EU28 countries with only a background color
plot(nuts0.spdf, border = NA, col = NA, bg = "#A6CAE0")

# plot non European space
plot(world.spdf, col  = "#E3DEBF", border=NA, add=TRUE)

#add layer
choroLayer(spdf = nuts0.spdf,
           df = rdf$data,
           dfid = 'country', # country dimension
           var = 'education_SDG', # notification rate
           breaks = quantile(rdf$data$education_SDG,probs = seq(0,1,1/9),na.rm = TRUE), # list of breaks
           border = "grey40", # color of the polygons borders
           lwd = 0.5, # width of the borders
           legend.pos = "right", # position of the legend
           legend.title.txt = "Education level", # title of the legend
           legend.values.rnd = 1, # number of decimal in the legend values
           add = TRUE) # add the layer to the current plot

plot(nuts0.spdf,border = "grey20", lwd=0.75, add=TRUE)