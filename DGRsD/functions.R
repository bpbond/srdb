
# not in function
'%!in%' <- function(x,y)!('%in%'(x,y))

# find out studies in DGRsD but not in SRDB
dgrsd_notin_srdb <- function () {
  srdbv4 %>% select(Study_number) %>% unique() %>% mutate(srdb_ID = paste(Study_number, "srdb", sep = "-")) -> srdb_study
  DGRsD %>% select(Study_number) %>% unique() -> dgrsd_study
  
  results <- dgrsd_study %>% filter(Study_number %!in% srdb_study$Study_number)
  # results <- left_join(dgrsd_study, srdb_study, by = c("Study_number") )
  return (results)
}

# find out studies in SRDB but not in DGRsD
srdb_notin_dgrsd <- function () {
  srdbv4 %>% select(Study_number) %>% unique() -> srdb_study
  DGRsD %>% select(Study_number) %>% unique() -> dgrsd_study
  
  results <- srdb_study %>% filter(Study_number %!in% dgrsd_study$Study_number) 
  return (results)
}

# Find out those Site_ID in DGRsD but not in SRDB
site_ID_check <- function () {
  srdbv4 %>% select(Study_number, Site_ID) %>% unique() %>% 
    mutate(srdb_ID = paste(Study_number, Site_ID, sep = "-")) -> srdb_SID
  DGRsD %>% select(Study_number, Site_ID) %>% unique() -> dgrsd_SID
  results <- left_join(dgrsd_SID, srdb_SID, by = c("Study_number", "Site_ID"))
  return (results)
}

# Data check 7: check sites by contry (check latitude and longitude)
lot_long_check <- function (sdata, ct) {
  sdata %>% filter(Country == ct) %>% select(Longitude, Latitude) %>% na.omit() %>% unique() -> map
  # coordinates(map) <- ~Longitude + Latitude 
  leaflet(map) %>% 
    addMarkers() %>% 
    addTiles(options = providerTileOptions(minZoom = 1, maxZoom = 4))
}


#*****************************************************************************************************************
# function 1 - Plot Rs~Tsoil and Tair
#*****************************************************************************************************************

t_model_sum <- function () {
  
  # test question 1: whether Ts is good surrogate for Ta?
  pdf( paste(OUTPUT_DIR,'SI-1. Tair for Tsoil.pdf', sep = "/" ), width=8, height=4)
  par( mar=c(2, 0.2, 0.2, 0.2)
       , mai=c(0.6, 0.7, 0.0, 0.1)  # by inches, inner margin
       , omi = c(0.0, 0.1, 0.4, 0.1)  # by inches, outer margin
       , mgp = c(0.5, 0.5, 0) # set distance of axis
       , tcl = 0.4
       , cex.axis = 1.0
       , las = 1
       , mfrow=c(1,2) )
  
  var_study <- unique (DGRsD_TS$Study_number) %>% sort()
  t_results <- data.frame()
  
  # i = 2
  # j = 1
  
  for (i in 1:length(var_study)) {
    sub_study <- subset(DGRsD_TS, Study_number == var_study[i])
    var_site <- unique (sub_study$Site_ID)
    
    for (j in 1:length(var_site)) {
      sub_site <- subset(sub_study, Site_ID == var_site[j])
      
      if (nrow(sub_site) < 6) {next} else {
        
        # first order lm model
        first_lm <- lm(RS_Norm ~ Tsoil, data = sub_site)
        first_a <- summary(first_lm)$coefficients[1,1] %>% round(6)
        first_b <- summary(first_lm)$coefficients[2,1] %>% round(6)
        p_b <- summary(first_lm)$coefficients[2,4]%>% round(6)
        first_R2 <- summary(first_lm)$r.squared %>% round(6)
        obs <- nrow(sub_site)
        
        # polynomial model
        poly_lm <- lm(RS_Norm ~ Tsoil + I(Tsoil^2), data = sub_site)
        poly_a <- summary(poly_lm)$coefficients[1,1] %>% round(6)
        poly_b <- summary(poly_lm)$coefficients[2,1] %>% round(6)
        poly_c <- summary(poly_lm)$coefficients[3,1] %>% round(6)
        p_poly_b <- summary(poly_lm)$coefficients[2,4] %>% round(6)
        p_c <- summary(poly_lm)$coefficients[3,4] %>% round(6)
        poly_R2 <- summary(poly_lm)$r.squared %>% round(6)
        
        # plot all study-site Ts vs Rs results
        plot(sub_site$RS_Norm ~ sub_site$Tsoil
             , main = ""
             , xlab = ""
             , ylab = ""
             , pch = 16
             , col = "gray"
        )
        
        # add SLR curve
        curve( first_a + first_b * x, min(sub_site$Tsoil), max(sub_site$Tsoil), col = "black", lty = 3, lwd = 2, add = T )
        # add polynomial curve, predict y using modp
        curve (poly_a + poly_b * x + poly_c * x^2, min(sub_site$Tsoil), max(sub_site$Tsoil), col = "black", lty = 1, lwd = 2, add = T)
        
        mtext(side = 1, text = expression(Soil~temperature~"("~degree~C~")"), line = 1.75, cex=1, outer = F)
        mtext(side = 2, text = expression(Soil~respiration~"("~g~C~m^{-2}~day^{-1}~")"), line = 2.0, cex=1.0, outer = F, las = 0)
        
        
        # plot all study-site Ta vs Rs results ****************************************************************
        # first order lm model of SWC ~ Pm
        first_Tm <- lm(RS_Norm ~ Tm_Del, data = sub_site)
        first_Tm_a <- summary(first_Tm)$coefficients[1,1] %>% round(6)
        first_Tm_b <- summary(first_Tm)$coefficients[2,1] %>% round(6)
        p_Tm_b <- summary(first_Tm)$coefficients[2,4]%>% round(6)
        first_Tm_R2 <- summary(first_Tm)$r.squared %>% round(6)
        
        # polynomial equation of SWC~Pm
        # poly_pm <- try(lm(RS_Norm ~ poly(Pm_Del,2) , data = sub_site))
        poly_Tm <- try(lm(RS_Norm ~ Tm_Del + I(Tm_Del^2), data = sub_site))
        poly_parameter_c <- try(summary(poly_Tm)$coefficients[3,1] )
        
        if (is(poly_Tm, "try-error") | is(poly_parameter_c, "try-error")) {
          poly_Tm_a <- NA
          poly_Tm_b <- NA
          poly_Tm_c <- NA
          p_poly_Tm_b <- NA
          p_pm_c <- NA
          poly_Tm_R2 <- NA } 
        else {
          poly_Tm_a <- summary(poly_Tm)$coefficients[1,1] %>% round(6)
          poly_Tm_b <- summary(poly_Tm)$coefficients[2,1] %>% round(6)
          poly_Tm_c <- summary(poly_Tm)$coefficients[3,1] %>% round(6)
          p_poly_Tm_b <- summary(poly_Tm)$coefficients[2,4] %>% round(6)
          p_Tm_c <- summary(poly_Tm)$coefficients[3,4] %>% round(6)
          poly_Tm_R2 <- summary(poly_Tm)$r.squared %>% round(6) 
          
          lm_sum = data.frame(sub_site$Study_number[1], var_site[j]
                              , first_a, first_b, p_b, first_R2
                              , poly_a, poly_b, p_poly_b, poly_c, p_c, poly_R2
                              , first_Tm_a, first_Tm_b, p_Tm_b, first_Tm_R2
                              , poly_Tm_a, poly_Tm_b, p_poly_Tm_b, poly_Tm_c, p_Tm_c, poly_Tm_R2
                              , obs)
          
          t_results = rbind(t_results, lm_sum)
          
        }
        
        plot(sub_site$RS_Norm ~ sub_site$Tm_Del
             , main = ""
             , xlab = ""
             , ylab = ""
             , pch = 16
             , col = "gray" )
        
        # add SLR curve
        curve( first_Tm_a + first_Tm_b * x, min(sub_site$Tm_Del), max(sub_site$Tm_Del), col = "black", lty = 3, lwd = 2, add = T )
        # add polynomial curve, predict y using modp
        curve (poly_Tm_a + poly_Tm_b * x + poly_Tm_c * x^2, min(sub_site$Tm_Del), max(sub_site$Tm_Del), col = "black", lty = 1, lwd = 2, add = T)
        
        mtext(side = 1, text = expression(Air~temperature~"("~degree~C~")"), line = 1.75, cex=1, outer = F)
        mtext(side = 2, text = expression(Soil~respiration~"("~g~C~m^{-2}~day^{-1}~")"), line = 2.0, cex=1.0, outer = F, las = 0)
        mtext(side = 3, text = paste0("Study=", var_study[i], ", Site=", var_site[j]), line = 0.75, cex=1.0, outer = T, las = 0)
        
      }
      print(paste0("*****", i, "-----", j))
    }
  }
  
  dev.off()
  return (t_results)
  
}


#*****************************************************************************************************************
# function 2: Plot Rs~swc and Pm
#*****************************************************************************************************************

pm_model_sum <- function () {
  
  # test question 2: wheterh pm is good surrogate of vwc
  pdf( paste(OUTPUT_DIR,'SI-2. Pm for vwc.pdf', sep = "/" ), width=8, height=4)
  
  par( mar=c(2, 0.2, 0.2, 0.2)
       , mai=c(0.6, 0.7, 0.0, 0.1)  # by inches, inner margin
       , omi = c(0.0, 0.1, 0.4, 0.1)  # by inches, outer margin
       , mgp = c(0.5, 0.5, 0) # set distance of axis
       , tcl = 0.4
       , cex.axis = 1.0
       , las = 1
       , mfrow=c(1,2) )
  
  # plot all study-site vwc vs Rs results
  
  var_study <- unique (DGRsD_SWC$Study_number) %>% sort()
  results <- data.frame()
  
  for (i in 1:length(var_study)) {
    # for (i in 3) {
    sub_study <- subset(DGRsD_SWC, Study_number == var_study[i])
    var_site <- unique (sub_study$Site_ID)
    
    for (j in 1:length(var_site)) {
      
      sub_site <- subset(sub_study, Site_ID == var_site[j])
      var_swc <- sub_site$SWC_Type[1]
      
      if (nrow(sub_site) < 6) {next} else {
        
        # first order lm model
        first_lm <- lm(RS_Norm ~ SWC, data = sub_site)
        first_a <- summary(first_lm)$coefficients[1,1] %>% round(6)
        first_b <- summary(first_lm)$coefficients[2,1] %>% round(6)
        p_b <- summary(first_lm)$coefficients[2,4]%>% round(6)
        first_R2 <- summary(first_lm)$r.squared %>% round(6)
        obs <- nrow(sub_site)
        
        # polynomial model
        poly_lm <- lm(RS_Norm ~ SWC + I(SWC^2), data = sub_site)
        poly_a <- summary(poly_lm)$coefficients[1,1] %>% round(6)
        poly_b <- summary(poly_lm)$coefficients[2,1] %>% round(6)
        poly_c <- summary(poly_lm)$coefficients[3,1] %>% round(6)
        p_poly_b <- summary(poly_lm)$coefficients[2,4] %>% round(6)
        p_c <- summary(poly_lm)$coefficients[3,4] %>% round(6)
        poly_R2 <- summary(poly_lm)$r.squared %>% round(6)
        
        plot(sub_site$RS_Norm ~ sub_site$SWC
             , main = ""
             , xlab = ""
             , ylab = ""
             , pch = 16
             , col = "gray" )
        
        mtext(side = 1, text = paste0( var_swc, " ( % )" ), line = 1.75, cex=1, outer = F)
        mtext(side = 2, text = expression(Soil~respiration~"("~g~C~m^{-2}~day^{-1}~")"), line = 2.0, cex=1.0, outer = F, las = 0)
        
        # add SLR curve
        curve( first_a + first_b * x, min(sub_site$SWC), max(sub_site$SWC), col = "black", lty = 3, lwd = 2, add = T )
        
        # add polynomial curve, predict y using modp
        curve (poly_a + poly_b * x + poly_c * x^2, min(sub_site$SWC), max(sub_site$SWC), col = "black", lty = 1, lwd = 2, add = T)
        
        # https://stats.stackexchange.com/questions/95939/how-to-interpret-coefficients-from-a-polynomial-model-fit
        # calculate the new x values using predict.poly()
        # x_poly <- stats:::predict.poly(object = poly(x,2), newdata = 23.4)
        # coef(poly_lm)[1] + coef(poly_lm)[2] * x_poly[1] + coef(poly_lm)[3] * x_poly[2]
        
        # Compare poly with I()
        # summary(lm(RS_Norm ~ SWC + I(SWC^2), data = sub_site)) 
        # -6.84 + 0.43*23.4 + -0.0054*23.4^2
        
        # plot all study-site pm vs Rs results *********************************************************************
        
        # first order lm model of SWC ~ Pm
        first_pm <- lm(RS_Norm ~ Pm_Del, data = sub_site)
        first_pm_a <- summary(first_pm)$coefficients[1,1] %>% round(6)
        first_pm_b <- summary(first_pm)$coefficients[2,1] %>% round(6)
        p_pm_b <- summary(first_pm)$coefficients[2,4]%>% round(6)
        first_pm_R2 <- summary(first_pm)$r.squared %>% round(6)
        
        # polynomial equation of SWC~Pm
        # poly_pm <- try(lm(RS_Norm ~ poly(Pm_Del,2) , data = sub_site))
        poly_pm <- try(lm(RS_Norm ~ Pm_Del + I(Pm_Del^2), data = sub_site))
        poly_parameter_c <- try(summary(poly_pm)$coefficients[3,1] )
        if (is(poly_pm, "try-error") | is(poly_parameter_c, "try-error")) {
          poly_pm_a <- NA
          poly_pm_b <- NA
          poly_pm_c <- NA
          p_poly_pm_b <- NA
          p_pm_c <- NA
          poly_pm_R2 <- NA } 
        else {
          poly_pm_a <- summary(poly_pm)$coefficients[1,1] %>% round(6)
          poly_pm_b <- summary(poly_pm)$coefficients[2,1] %>% round(6)
          poly_pm_c <- summary(poly_pm)$coefficients[3,1] %>% round(6)
          p_poly_pm_b <- summary(poly_pm)$coefficients[2,4] %>% round(6)
          p_pm_c <- summary(poly_pm)$coefficients[3,4] %>% round(6)
          poly_pm_R2 <- summary(poly_pm)$r.squared %>% round(6) 
          
          lm_sum = data.frame(sub_site$Study_number[1], var_site[j], var_swc
                              , first_a, first_b, p_b, first_R2
                              , poly_a, poly_b, p_poly_b, poly_c, p_c, poly_R2
                              , first_pm_a, first_pm_b, p_pm_b, first_pm_R2
                              , poly_pm_a, poly_pm_b, p_poly_pm_b, poly_pm_c, p_pm_c, poly_pm_R2
                              , obs)
          
          results = rbind(results, lm_sum)
          
        }
        
        plot(sub_site$RS_Norm ~ sub_site$Pm_Del
             , main = ""
             , xlab = ""
             , ylab = ""
             , pch = 16
             , col = "gray"
        )
        
        # add curve
        curve( first_pm_a + first_pm_b * x, min(sub_site$Pm_Del), max(sub_site$Pm_Del), col = "black", lty = 3, lwd = 2, add = T )
        # add polynomial curve, predict y using modp
        if (is.na(poly_pm_c)) {next} else {
          curve (poly_pm_a + poly_pm_b * x + poly_pm_c * x^2, min(sub_site$Pm_Del), max(sub_site$Pm_Del), col = "black", lty = 1, lwd = 2, add = T)
        }
        
        mtext(side = 1, text = expression( Pm~"( mm )" ), line = 1.75, cex=1.0, outer = F)
        mtext(side = 2, text = expression(Soil~respiration~"("~g~C~m^{-2}~day^{-1}~")"), line = 2.0, cex=1.0, outer = F, las = 0)
        mtext(side = 3, text = paste0("Study=", var_study[i], ", Site=", var_site[j]), line = 0.75, cex=1.0, outer = T, las = 0)
      }
      print(paste0("*****", i, "-----", j))
    }
  }
  
  dev.off()
  return (results)
}
