#' ---
#' title: "無党派層とソーシャル・ネットワーク環境"
#' author: "Gento Kato"
#' date: "April 15, 2021"
#' ---
#' 
#' # Preparation 
#' 

## Clean Up Space
rm(list=ls())

## Set Working Directory (Automatically) ##
require(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)); 

## All Parties
jimin="自民"; minshu="民主"; komei="公明"; shamin="社民"; kyosan="共産"
hoshushin="保守新"; jiyu="自由"; kokuminshin="国民新"; shakai="社会"; shinsei="新生"
minsha="民社"; sakigake="さきがけ"; shaminren="社民連"; nihonshin="日本新"; shinshin="新進"
sonota="その他"
allps <- c(jimin,shakai,komei,shinsei,kyosan,
           minsha,sakigake,shaminren,nihonshin,shinshin,
           minshu,shamin,hoshushin,jiyu,kokuminshin,
           sonota)
mutoha <- "無党派"
mikettei <- "未決定"
kiken="棄権"
shiranai <- "知らない"
mushozoku="無所属"

## Packages
require(MASS)
require(lmtest)
require(multiwayvcov)
require(texreg)
require(ggplot2)
require(haven)

## Import Data

do1 <- readRDS("cnep93.rds")
do2 <- readRDS("jes2_s.rds")
do3 <- readRDS("jes3_s.rds")
d <- rbind(do1,do2,do3)
#d <- subset(d, answered==1)

donet1 <- readRDS("cnep93_net.rds")
donet2 <- readRDS("jes2_net_s.rds")
donet3 <- readRDS("jes3_net_s.rds")
dnet <- rbind(donet1,donet2,donet3)

#' 
#' # Recode variables
#'

## Gender
table(d[d$answered==1,]$fem, d[d$answered==1,]$year, useNA="always")

## Age Cohort
table(d[d$answered==1,]$age, d[d$answered==1,]$year, useNA="always")
d$age2030 <- ifelse(d$age<30,1,0)
d$age4050 <- ifelse(d$age>=30&d$age<60,1,0)
d$age60plus <- ifelse(d$age>=60,1,0)
dnet$age2030 <- ifelse(dnet$age<30,1,0)
dnet$age4050 <- ifelse(dnet$age>=30&dnet$age<60,1,0)
dnet$age60plus <- ifelse(dnet$age>=60,1,0)

## Education Factor
table(d[d$answered==1,]$edu, d[d$answered==1,]$year, useNA="always")
# Fix Some Cases (Borrowing from nearby panel response)
tmp1 <- subset(d, year==1995)
tmp2 <- subset(d, year==1996)
d$edu[d$year==1995][which(is.na(tmp1$edu)&!is.na(tmp2$edu))] <-
  d$edu[d$year==1996][which(is.na(tmp1$edu)&!is.na(tmp2$edu))]
d$edu[d$year==1996][which(!is.na(tmp1$edu)&is.na(tmp2$edu))] <-
  d$edu[d$year==1995][which(!is.na(tmp1$edu)&is.na(tmp2$edu))]
tmp1 <- subset(d, year==2001)
tmp2 <- subset(d, year==2003)
d$edu[d$year==2001][which(is.na(tmp1$edu)&!is.na(tmp2$edu))] <-
  d$edu[d$year==2003][which(is.na(tmp1$edu)&!is.na(tmp2$edu))]
d$edu[d$year==2003][which(!is.na(tmp1$edu)&is.na(tmp2$edu))] <-
  d$edu[d$year==2001][which(!is.na(tmp1$edu)&is.na(tmp2$edu))]
tmp1 <- subset(d, year==2003)
tmp2 <- subset(d, year==2004)
d$edu[d$year==2003][which(is.na(tmp1$edu)&!is.na(tmp2$edu))] <-
  d$edu[d$year==2004][which(is.na(tmp1$edu)&!is.na(tmp2$edu))]
d$edu[d$year==2004][which(!is.na(tmp1$edu)&is.na(tmp2$edu))] <-
  d$edu[d$year==2003][which(!is.na(tmp1$edu)&is.na(tmp2$edu))]
tmp1 <- subset(d, year==2004)
tmp2 <- subset(d, year==2005)
d$edu[d$year==2004][which(is.na(tmp1$edu)&!is.na(tmp2$edu))] <-
  d$edu[d$year==2005][which(is.na(tmp1$edu)&!is.na(tmp2$edu))]
d$edu[d$year==2005][which(!is.na(tmp1$edu)&is.na(tmp2$edu))] <-
  d$edu[d$year==2004][which(!is.na(tmp1$edu)&is.na(tmp2$edu))]
d$edu[d$answered==0] <- NA
## Check Again
table(d[d$answered==1,]$edu, d[d$answered==1,]$year, useNA="always")
## Move values to dnet
dnet$edu <- d$edu[match(paste(dnet$id,dnet$year),paste(d$id,d$year))]
table(dnet[dnet$answered==1,]$edu, 
      dnet[dnet$answered==1,]$year, useNA="always")
d$edu_c1 <- ifelse(d$edu*3==1, 1, 0)
d$edu_c2 <- ifelse(d$edu*3==2, 1, 0)
d$edu_c3 <- ifelse(d$edu*3==3, 1, 0)
dnet$edu_c1 <- ifelse(dnet$edu*3==1, 1, 0)
dnet$edu_c2 <- ifelse(dnet$edu*3==2, 1, 0)
dnet$edu_c3 <- ifelse(dnet$edu*3==3, 1, 0)

## Income Factor
table(d$income, d$year, useNA="always")
## Binning Function https://stackoverflow.com/questions/61605295/r-equal-frequency-binning-functions
bin_equal = function(x, nbin = 3) {
  breaks = quantile(x, probs = seq(0, 1, length.out = nbin + 1), na.rm = TRUE)
  return(cut(x, breaks = breaks, labels = 1:nbin, include.lowest = TRUE))
}
d$income3 <- NA
d$income3[d$year==1993] <- bin_equal(d$income[d$year==1993])
d$income3[d$year==1995] <- bin_equal(d$income[d$year==1995])
d$income3[d$year==1996] <- bin_equal(d$income[d$year==1996])
d$income3[d$year==2001] <- bin_equal(d$income[d$year==2001])
d$income3[d$year==2003] <- bin_equal(d$income[d$year==2003])
d$income3[d$year==2004] <- bin_equal(d$income[d$year==2004])
d$income3[d$year==2005] <- bin_equal(d$income[d$year==2005])
table(d[d$answered==1,]$income3, d[d$answered==1,]$year, useNA="always")
d$income_low <- ifelse(d$answered==0, NA, 
                       ifelse(d$income3%in%1, 1, 0))
d$income_mid <- ifelse(d$answered==0, NA, 
                       ifelse(d$income3%in%2, 1, 0))
d$income_high <- ifelse(d$answered==0, NA, 
                        ifelse(d$income3%in%3, 1, 0))
d$income_dk <- ifelse(d$answered==0, NA, 
                      ifelse(is.na(d$income3), 1, 0))
table(d[d$answered==1,]$income_low, d[d$answered==1,]$year, useNA="always")
table(d[d$answered==1,]$income_mid, d[d$answered==1,]$year, useNA="always")
table(d[d$answered==1,]$income_high, d[d$answered==1,]$year, useNA="always")
table(d[d$answered==1,]$income_dk, d[d$answered==1,]$year, useNA="always")
# Move values to dnet
dnet$income3 <- d$income3[match(paste(dnet$id,dnet$year),paste(d$id,d$year))]
dnet$income_low <- d$income_low[match(paste(dnet$id,dnet$year),paste(d$id,d$year))]
dnet$income_mid <- d$income_mid[match(paste(dnet$id,dnet$year),paste(d$id,d$year))]
dnet$income_high <- d$income_high[match(paste(dnet$id,dnet$year),paste(d$id,d$year))]
dnet$income_dk <- d$income_dk[match(paste(dnet$id,dnet$year),paste(d$id,d$year))]
table(dnet[dnet$answered==1,]$income3, 
      dnet[dnet$answered==1,]$year, useNA="always")
table(dnet[dnet$answered==1,]$income_low, 
      dnet[dnet$answered==1,]$year, useNA="always")
table(dnet[dnet$answered==1,]$income_mid, 
      dnet[dnet$answered==1,]$year, useNA="always")
table(dnet[dnet$answered==1,]$income_high, 
      dnet[dnet$answered==1,]$year, useNA="always")
table(dnet[dnet$answered==1,]$income_dk, 
      dnet[dnet$answered==1,]$year, useNA="always")

## Employed
table(d[d$answered==1,]$employed, d[d$answered==1,]$year, useNA="always")
# Fix Some Cases (Borrowing from nearby panel response)
tmp1 <- subset(d, year==1995)
tmp2 <- subset(d, year==1996)
d$employed[d$year==1995][which(is.na(tmp1$employed)&!is.na(tmp2$employed))] <-
  d$employed[d$year==1996][which(is.na(tmp1$employed)&!is.na(tmp2$employed))]
d$employed[d$year==1996][which(!is.na(tmp1$employed)&is.na(tmp2$employed))] <-
  d$employed[d$year==1995][which(!is.na(tmp1$employed)&is.na(tmp2$employed))]
tmp1 <- subset(d, year==2001)
tmp2 <- subset(d, year==2003)
d$employed[d$year==2001][which(is.na(tmp1$employed)&!is.na(tmp2$employed))] <-
  d$employed[d$year==2003][which(is.na(tmp1$employed)&!is.na(tmp2$employed))]
d$employed[d$year==2003][which(!is.na(tmp1$employed)&is.na(tmp2$employed))] <-
  d$employed[d$year==2001][which(!is.na(tmp1$employed)&is.na(tmp2$employed))]
tmp1 <- subset(d, year==2003)
tmp2 <- subset(d, year==2004)
d$employed[d$year==2003][which(is.na(tmp1$employed)&!is.na(tmp2$employed))] <-
  d$employed[d$year==2004][which(is.na(tmp1$employed)&!is.na(tmp2$employed))]
d$employed[d$year==2004][which(!is.na(tmp1$employed)&is.na(tmp2$employed))] <-
  d$employed[d$year==2003][which(!is.na(tmp1$employed)&is.na(tmp2$employed))]
tmp1 <- subset(d, year==2004)
tmp2 <- subset(d, year==2005)
d$employed[d$year==2004][which(is.na(tmp1$employed)&!is.na(tmp2$employed))] <-
  d$employed[d$year==2005][which(is.na(tmp1$employed)&!is.na(tmp2$employed))]
d$employed[d$year==2005][which(!is.na(tmp1$employed)&is.na(tmp2$employed))] <-
  d$employed[d$year==2004][which(!is.na(tmp1$employed)&is.na(tmp2$employed))]
d$employed[d$answered==0] <- NA
## Check Again
table(d[d$answered==1,]$employed, d[d$answered==1,]$year, useNA="always")
## Move values to dnet
dnet$employed <- d$employed[match(paste(dnet$id,dnet$year),paste(d$id,d$year))]
table(dnet[dnet$answered==1,]$employed, 
      dnet[dnet$answered==1,]$year, useNA="always")

## Private Home 
table(d[d$answered==1,]$privatehome, d[d$answered==1,]$year, useNA="always")
# Fix Some Cases (Borrowing from nearby panel response)
tmp1 <- subset(d, year==1995)
tmp2 <- subset(d, year==1996)
d$privatehome[d$year==1995][which(is.na(tmp1$privatehome)&!is.na(tmp2$privatehome))] <-
  d$privatehome[d$year==1996][which(is.na(tmp1$privatehome)&!is.na(tmp2$privatehome))]
d$privatehome[d$year==1996][which(!is.na(tmp1$privatehome)&is.na(tmp2$privatehome))] <-
  d$privatehome[d$year==1995][which(!is.na(tmp1$privatehome)&is.na(tmp2$privatehome))]
tmp1 <- subset(d, year==2001)
tmp2 <- subset(d, year==2003)
d$privatehome[d$year==2001][which(is.na(tmp1$privatehome)&!is.na(tmp2$privatehome))] <-
  d$privatehome[d$year==2003][which(is.na(tmp1$privatehome)&!is.na(tmp2$privatehome))]
d$privatehome[d$year==2003][which(!is.na(tmp1$privatehome)&is.na(tmp2$privatehome))] <-
  d$privatehome[d$year==2001][which(!is.na(tmp1$privatehome)&is.na(tmp2$privatehome))]
tmp1 <- subset(d, year==2003)
tmp2 <- subset(d, year==2004)
d$privatehome[d$year==2003][which(is.na(tmp1$privatehome)&!is.na(tmp2$privatehome))] <-
  d$privatehome[d$year==2004][which(is.na(tmp1$privatehome)&!is.na(tmp2$privatehome))]
d$privatehome[d$year==2004][which(!is.na(tmp1$privatehome)&is.na(tmp2$privatehome))] <-
  d$privatehome[d$year==2003][which(!is.na(tmp1$privatehome)&is.na(tmp2$privatehome))]
tmp1 <- subset(d, year==2004)
tmp2 <- subset(d, year==2005)
d$privatehome[d$year==2004][which(is.na(tmp1$privatehome)&!is.na(tmp2$privatehome))] <-
  d$privatehome[d$year==2005][which(is.na(tmp1$privatehome)&!is.na(tmp2$privatehome))]
d$privatehome[d$year==2005][which(!is.na(tmp1$privatehome)&is.na(tmp2$privatehome))] <-
  d$privatehome[d$year==2004][which(!is.na(tmp1$privatehome)&is.na(tmp2$privatehome))]
d$privatehome[d$answered==0] <- NA
## Check Again
table(d[d$answered==1,]$privatehome, d[d$answered==1,]$year, useNA="always")
## Move values to dnet
dnet$privatehome <- d$privatehome[match(paste(dnet$id,dnet$year),paste(d$id,d$year))]
table(dnet[dnet$answered==1,]$privatehome, 
      dnet[dnet$answered==1,]$year, useNA="always")

## 3 categories networksize variable 
table(d$sumnet,d$year)
d$sumnet3 <- as.ordered(ifelse(d$sumnet>=3,3,d$sumnet))
table(d$sumnet3)

## Mutoha Dummies (excl. Leaners)
d$mutoha <- ifelse(d$psup==mutoha,1,0)
dnet$mutoha <- ifelse(dnet$psup==mutoha,1,0)
table(d$mutoha, d$year)
table(dnet$mutoha, dnet$year)

## Political Interest Dummy
table(d$polint, d$year, useNA="always")
d$polint2 <- ifelse(d$polint>0.5,1,0)
dnet$polint2 <- ifelse(dnet$polint>0.5,1,0)

## Mutoha Dummies (incl. Leaners)
d$mutohaL <- ifelse(d$psuplean==mutoha,1,0)
dnet$mutohaL <- ifelse(dnet$psuplean==mutoha,1,0)
table(d$mutohaL, d$year)
table(dnet$mutohaL, dnet$year)

## Net Partner ID Factor
dnet$netfac <- as.factor(dnet$net)

## Political Discussion Frequency with Partner
table(dnet$netpoldis, dnet$year)
dnet$netpoldis2 <- ifelse(dnet$netpoldis>0.5,1,0)

## Perceived Knowledge of Partner
dnet$netknow2 <- ifelse(dnet$netknow>=0.5,1,0)
table(dnet$netknow2, dnet$year)

## Knowledge of Net Vote Choice Dummy
dnet$knnetpvote <- ifelse(dnet$netpvote==shiranai,0,1)

## For Patterns of Disagreement (Party Choice)
table(dnet$netpvote, dnet$year)
table(dnet$pvoteintMD, dnet$year)
table(dnet$pvotedMD, dnet$year)
dnet$netpvotedif <- 
  ifelse(dnet$netpvote%in%c(kiken,shiranai)|dnet$pvoteintMD%in%c(kiken,mikettei,mushozoku),NA,
         ifelse(as.character(dnet$netpvote)==as.character(dnet$pvoteintMD),
                0,1))
dnet$netpvotedif[which(dnet$year%in%c(1995,1996))] <-
  ifelse(dnet$netpvote[which(dnet$year%in%c(1995,1996))]%in%c(kiken,shiranai)|dnet$pvotedMD[which(dnet$year%in%c(1995,1996))]%in%c(kiken),NA,
         ifelse(as.character(dnet[which(dnet$year%in%c(1995,1996)),]$netpvote)==as.character(dnet$pvotedMD[which(dnet$year%in%c(1995,1996))]),
                0,1))
table(dnet$netpvotedif, dnet$year, useNA="always")

## For Patterns of Disagreement (Party Choice)
table(dnet$netpvote, dnet$year)
table(dnet$pvoteintPR, dnet$year)
table(dnet$pvotedPR, dnet$year)
dnet$netpvotedifPR <- 
  ifelse(dnet$netpvote%in%shiranai|dnet$pvoteintPR%in%c(kiken,mikettei),NA,
         ifelse(as.character(dnet$netpvote)==as.character(dnet$pvoteintPR),
                0,1))
dnet$netpvotedifPR[which(dnet$year%in%c(1995,1996))] <-
  ifelse(dnet$netpvote[which(dnet$year%in%c(1995,1996))]%in%shiranai,NA,
         ifelse(as.character(dnet[which(dnet$year%in%c(1995,1996)),]$netpvote)==as.character(dnet$pvotedPR[which(dnet$year%in%c(1995,1996))]),
                0,1))
table(dnet$netpvotedifPR, dnet$year, useNA="always")

## For Network Variables to be numeric
dnet$netfem <- as.numeric(dnet$netfem)
dnet$netfa <- as.numeric(dnet$netfa)
dnet$netwk <- as.numeric(dnet$netwk)
dnet$netfr <- as.numeric(dnet$netfr)

## Subset Data
d <- d[d$answered==1,]
d93 <- d[d$year==1993,]
d95 <- d[d$year==1995,]
d96 <- d[d$year==1996,]
d1 <- d[d$year==2001,]
d3 <- d[d$year==2003,]
d4 <- d[d$year==2004,]
d5 <- d[d$year==2005,]
dnet93 <- dnet[dnet$year==1993,]
dnet95 <- dnet[dnet$year==1995,]
dnet96 <- dnet[dnet$year==1996,]
dnet1 <- dnet[dnet$year==2001,]
dnet3 <- dnet[dnet$year==2003,]
dnet4 <- dnet[dnet$year==2004,]
dnet5 <- dnet[dnet$year==2005,]

#'
#' # Model
#'

# For Main Data
f1 <- formula(. ~ mutoha*polint2)
f2 <- formula(. ~ mutoha*polint2 + 
                fem + age4050 + age60plus + edu_c1 + edu_c2 + edu_c3 + 
                employed + privatehome + 
                income_mid + income_high + income_dk +   
                citysize_big + citysize_mid + citysize_sml)
f21 <- formula(. ~ mutoha*polint2 + 
                fem + age4050 + age60plus + edu_c1 + edu_c2 + edu_c3 + 
                employed + privatehome + 
                income_mid + income_high + income_dk)

# For Network Data
f1net <- formula(. ~ mutoha*polint2 + netfac)
f2net <- formula(. ~ mutoha*polint2 + 
                   fem + age4050 + age60plus + edu_c1 + edu_c2 + edu_c3 + 
                   employed + privatehome +  
                   income_mid + income_high + income_dk +   
                   citysize_big + citysize_mid + citysize_sml + 
                   netfem + netfa + netwk + netfac)
f2net1 <- formula(. ~ mutoha*polint2 + 
                    fem + age4050 + age60plus + edu_c1 + edu_c2 + edu_c3 + 
                    employed + privatehome + 
                    income_mid + income_high + income_dk +   
                    netfem + 
                    netfa + netwk + netfac)
f2net2 <- formula(. ~ mutoha*polint2 + 
                   fem + age4050 + age60plus + edu_c1 + edu_c2 + edu_c3 + 
                   employed + privatehome + 
                   income_mid + income_high + income_dk +   
                   citysize_big + citysize_mid + citysize_sml + 
                   netfa + netwk + netfac)

# For Network Data (For netpvote models)
f1pnet <- formula(. ~ mutoha*polint2 + netfac + netpoldis2)
f2pnet <- formula(. ~ mutoha*polint2 + 
                   fem + age4050 + age60plus + edu_c1 + edu_c2 + edu_c3 + 
                   employed + privatehome + 
                   income_mid + income_high + income_dk +   
                   citysize_big + citysize_mid + citysize_sml + 
                   netfem + netfa + netwk + netfac + netpoldis2)
f2pnet1 <- formula(. ~ mutoha*polint2 + 
                    fem + age4050 + age60plus + edu_c1 + edu_c2 + edu_c3 + 
                    employed + privatehome + 
                    income_mid + income_high + income_dk +   
                    netfem + 
                    netfa + netwk + netfac + netpoldis2)
f2pnet2 <- formula(. ~ mutoha*polint2 + 
                    fem + age4050 + age60plus + edu_c1 + edu_c2 + edu_c3 + 
                    employed + privatehome + 
                    income_mid + income_high + income_dk +   
                    citysize_big + citysize_mid + citysize_sml + 
                    netfa + netwk + netfac + netpoldis2)

#'
#' # Estimation
#'

## Network Size

m1_1_93 <- polr(update(as.ordered(sumnet) ~ ., f1), data=d93, Hess=TRUE)
m1_1_95 <- polr(update(as.ordered(sumnet) ~ ., f1), data=d95, Hess=TRUE)
m1_1_96 <- polr(update(as.ordered(sumnet) ~ ., f1), data=d96, Hess=TRUE)
m1_1_01 <- polr(update(as.ordered(sumnet) ~ ., f1), data=d1, Hess=TRUE)
m1_1_03 <- polr(update(as.ordered(sumnet) ~ ., f1), data=d3, Hess=TRUE)
m1_1_04 <- polr(update(as.ordered(sumnet) ~ ., f1), data=d4, Hess=TRUE)
m1_1_05 <- polr(update(as.ordered(sumnet) ~ ., f1), data=d5, Hess=TRUE)

screenreg(list(m1_1_93,m1_1_95,m1_1_96),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")
screenreg(list(m1_1_01,m1_1_03,m1_1_04,m1_1_05),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

m1_2_93 <- polr(update(as.ordered(sumnet) ~ ., f21), data=d93, Hess=TRUE)
m1_2_95 <- polr(update(as.ordered(sumnet) ~ ., f2), data=d95, Hess=TRUE)
m1_2_96 <- polr(update(as.ordered(sumnet) ~ ., f2), data=d96, Hess=TRUE)
m1_2_01 <- polr(update(as.ordered(sumnet) ~ ., f2), data=d1, Hess=TRUE)
m1_2_03 <- polr(update(as.ordered(sumnet) ~ ., f2), data=d3, Hess=TRUE)
m1_2_04 <- polr(update(as.ordered(sumnet) ~ ., f2), data=d4, Hess=TRUE)
m1_2_05 <- polr(update(as.ordered(sumnet) ~ ., f2), data=d5, Hess=TRUE)

screenreg(list(m1_2_93,m1_2_95,m1_2_96),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")
screenreg(list(m1_2_01,m1_2_03,m1_2_04,m1_2_05),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

## Political Discussion 

m2_1_93 <- glm(update(netpoldis2 ~ ., f1net), data=dnet93, family=binomial("logit"))
m2_1_95 <- glm(update(netpoldis2 ~ ., f1net), data=dnet95, family=binomial("logit"))
m2_1_96 <- glm(update(netpoldis2 ~ ., f1net), data=dnet96, family=binomial("logit"))
m2_1_01 <- glm(update(netpoldis2 ~ ., f1net), data=dnet1, family=binomial("logit"))
m2_1_03 <- glm(update(netpoldis2 ~ ., f1net), data=dnet3, family=binomial("logit"))
m2_1_04 <- glm(update(netpoldis2 ~ ., f1net), data=dnet4, family=binomial("logit"))
m2_1_05 <- glm(update(netpoldis2 ~ ., f1net), data=dnet5, family=binomial("logit"))

m2_1_93_vcov <- cluster.vcov(m2_1_93, cluster=dnet93$id)
m2_1_95_vcov <- cluster.vcov(m2_1_95, cluster=dnet95$id)
m2_1_96_vcov <- cluster.vcov(m2_1_96, cluster=dnet96$id)
m2_1_01_vcov <- cluster.vcov(m2_1_01, cluster=dnet1$id)
m2_1_03_vcov <- cluster.vcov(m2_1_03, cluster=dnet3$id)
m2_1_04_vcov <- cluster.vcov(m2_1_04, cluster=dnet4$id)
m2_1_05_vcov <- cluster.vcov(m2_1_05, cluster=dnet5$id)

screenreg(list(m2_1_93,m2_1_95,m2_1_96),
          override.se = list(coeftest(m2_1_93, vcov.=m2_1_93_vcov)[,2],
                             coeftest(m2_1_95, vcov.=m2_1_95_vcov)[,2],
                             coeftest(m2_1_96, vcov.=m2_1_96_vcov)[,2]),
          override.pvalues = list(coeftest(m2_1_93, vcov.=m2_1_93_vcov)[,4],
                                  coeftest(m2_1_95, vcov.=m2_1_95_vcov)[,4],
                                  coeftest(m2_1_96, vcov.=m2_1_96_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")
screenreg(list(m2_1_01,m2_1_03,m2_1_04,m2_1_05),
          override.se = list(coeftest(m2_1_01, vcov.=m2_1_01_vcov)[,2],
                             coeftest(m2_1_03, vcov.=m2_1_03_vcov)[,2],
                             coeftest(m2_1_04, vcov.=m2_1_04_vcov)[,2],
                             coeftest(m2_1_05, vcov.=m2_1_05_vcov)[,2]),
          override.pvalues = list(coeftest(m2_1_01, vcov.=m2_1_01_vcov)[,4],
                             coeftest(m2_1_03, vcov.=m2_1_03_vcov)[,4],
                             coeftest(m2_1_04, vcov.=m2_1_04_vcov)[,4],
                             coeftest(m2_1_05, vcov.=m2_1_05_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

m2_2_93 <- glm(update(netpoldis2 ~ ., f2net1), data=dnet93, family=binomial("logit"))
m2_2_95 <- glm(update(netpoldis2 ~ ., f2net2), data=dnet95, family=binomial("logit"))
m2_2_96 <- glm(update(netpoldis2 ~ ., f2net2), data=dnet96, family=binomial("logit"))
m2_2_01 <- glm(update(netpoldis2 ~ ., f2net), data=dnet1, family=binomial("logit"))
m2_2_03 <- glm(update(netpoldis2 ~ ., f2net), data=dnet3, family=binomial("logit"))
m2_2_04 <- glm(update(netpoldis2 ~ ., f2net), data=dnet4, family=binomial("logit"))
m2_2_05 <- glm(update(netpoldis2 ~ ., f2net), data=dnet5, family=binomial("logit"))

m2_2_93_vcov <- cluster.vcov(m2_2_93, cluster=dnet93$id)
m2_2_95_vcov <- cluster.vcov(m2_2_95, cluster=dnet95$id)
m2_2_96_vcov <- cluster.vcov(m2_2_96, cluster=dnet96$id)
m2_2_01_vcov <- cluster.vcov(m2_2_01, cluster=dnet1$id)
m2_2_03_vcov <- cluster.vcov(m2_2_03, cluster=dnet3$id)
m2_2_04_vcov <- cluster.vcov(m2_2_04, cluster=dnet4$id)
m2_2_05_vcov <- cluster.vcov(m2_2_05, cluster=dnet5$id)

screenreg(list(m2_2_93,m2_2_95,m2_2_96),
          override.se = list(coeftest(m2_2_93, vcov.=m2_2_93_vcov)[,2],
                             coeftest(m2_2_95, vcov.=m2_2_95_vcov)[,2],
                             coeftest(m2_2_96, vcov.=m2_2_96_vcov)[,2]),
          override.pvalues = list(coeftest(m2_2_93, vcov.=m2_2_93_vcov)[,4],
                                  coeftest(m2_2_95, vcov.=m2_2_95_vcov)[,4],
                                  coeftest(m2_2_96, vcov.=m2_2_96_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")
screenreg(list(m2_2_01,m2_2_03,m2_2_04,m2_2_05),
          override.se = list(coeftest(m2_2_01, vcov.=m2_2_01_vcov)[,2],
                             coeftest(m2_2_03, vcov.=m2_2_03_vcov)[,2],
                             coeftest(m2_2_04, vcov.=m2_2_04_vcov)[,2],
                             coeftest(m2_2_05, vcov.=m2_2_05_vcov)[,2]),
          override.pvalues = list(coeftest(m2_2_01, vcov.=m2_2_01_vcov)[,4],
                                  coeftest(m2_2_03, vcov.=m2_2_03_vcov)[,4],
                                  coeftest(m2_2_04, vcov.=m2_2_04_vcov)[,4],
                                  coeftest(m2_2_05, vcov.=m2_2_05_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

## Perceived Political Knowledge

m3_1_01 <- glm(update(netknow2 ~ ., f1net), data=dnet1, family=binomial("logit"))
m3_1_03 <- glm(update(netknow2 ~ ., f1net), data=dnet3, family=binomial("logit"))
m3_1_04 <- glm(update(netknow2 ~ ., f1net), data=dnet4, family=binomial("logit"))
m3_1_05 <- glm(update(netknow2 ~ ., f1net), data=dnet5, family=binomial("logit"))

m3_1_01_vcov <- cluster.vcov(m3_1_01, cluster=dnet1$id)
m3_1_03_vcov <- cluster.vcov(m3_1_03, cluster=dnet3$id)
m3_1_04_vcov <- cluster.vcov(m3_1_04, cluster=dnet4$id)
m3_1_05_vcov <- cluster.vcov(m3_1_05, cluster=dnet5$id)

screenreg(list(m3_1_01,m3_1_03,m3_1_04,m3_1_05),
          override.se = list(coeftest(m3_1_01, vcov.=m3_1_01_vcov)[,2],
                             coeftest(m3_1_03, vcov.=m3_1_03_vcov)[,2],
                             coeftest(m3_1_04, vcov.=m3_1_04_vcov)[,2],
                             coeftest(m3_1_05, vcov.=m3_1_05_vcov)[,2]),
          override.pvalues = list(coeftest(m3_1_01, vcov.=m3_1_01_vcov)[,4],
                                  coeftest(m3_1_03, vcov.=m3_1_03_vcov)[,4],
                                  coeftest(m3_1_04, vcov.=m3_1_04_vcov)[,4],
                                  coeftest(m3_1_05, vcov.=m3_1_05_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

m3_2_01 <- glm(update(netknow2 ~ ., f2net), data=dnet1, family=binomial("logit"))
m3_2_03 <- glm(update(netknow2 ~ ., f2net), data=dnet3, family=binomial("logit"))
m3_2_04 <- glm(update(netknow2 ~ ., f2net), data=dnet4, family=binomial("logit"))
m3_2_05 <- glm(update(netknow2 ~ ., f2net), data=dnet5, family=binomial("logit"))

m3_2_01_vcov <- cluster.vcov(m3_2_01, cluster=dnet1$id)
m3_2_03_vcov <- cluster.vcov(m3_2_03, cluster=dnet3$id)
m3_2_04_vcov <- cluster.vcov(m3_2_04, cluster=dnet4$id)
m3_2_05_vcov <- cluster.vcov(m3_2_05, cluster=dnet5$id)

screenreg(list(m3_2_01,m3_2_03,m3_2_04,m3_2_05),
          override.se = list(coeftest(m3_2_01, vcov.=m3_2_01_vcov)[,2],
                             coeftest(m3_2_03, vcov.=m3_2_03_vcov)[,2],
                             coeftest(m3_2_04, vcov.=m3_2_04_vcov)[,2],
                             coeftest(m3_2_05, vcov.=m3_2_05_vcov)[,2]),
          override.pvalues = list(coeftest(m3_2_01, vcov.=m3_2_01_vcov)[,4],
                                  coeftest(m3_2_03, vcov.=m3_2_03_vcov)[,4],
                                  coeftest(m3_2_04, vcov.=m3_2_04_vcov)[,4],
                                  coeftest(m3_2_05, vcov.=m3_2_05_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

## Knowledge of Partner's vote/party support

m4_1_93 <- glm(update(knnetpvote ~ ., f1pnet), data=dnet93, family=binomial("logit"))
m4_1_95 <- glm(update(knnetpvote ~ ., f1pnet), data=dnet95, family=binomial("logit"))
m4_1_96 <- glm(update(knnetpvote ~ ., f1pnet), data=dnet96, family=binomial("logit"))
m4_1_01 <- glm(update(knnetpvote ~ ., f1pnet), data=dnet1, family=binomial("logit"))
m4_1_03 <- glm(update(knnetpvote ~ ., f1pnet), data=dnet3, family=binomial("logit"))
m4_1_04 <- glm(update(knnetpvote ~ ., f1pnet), data=dnet4, family=binomial("logit"))
m4_1_05 <- glm(update(knnetpvote ~ ., f1pnet), data=dnet5, family=binomial("logit"))

m4_1_93_vcov <- cluster.vcov(m4_1_93, cluster=dnet93$id)
m4_1_95_vcov <- cluster.vcov(m4_1_95, cluster=dnet95$id)
m4_1_96_vcov <- cluster.vcov(m4_1_96, cluster=dnet96$id)
m4_1_01_vcov <- cluster.vcov(m4_1_01, cluster=dnet1$id)
m4_1_03_vcov <- cluster.vcov(m4_1_03, cluster=dnet3$id)
m4_1_04_vcov <- cluster.vcov(m4_1_04, cluster=dnet4$id)
m4_1_05_vcov <- cluster.vcov(m4_1_05, cluster=dnet5$id)

screenreg(list(m4_1_93,m4_1_95,m4_1_96),
          override.se = list(coeftest(m4_1_93, vcov.=m4_1_93_vcov)[,2],
                             coeftest(m4_1_95, vcov.=m4_1_95_vcov)[,2],
                             coeftest(m4_1_96, vcov.=m4_1_96_vcov)[,2]),
          override.pvalues = list(coeftest(m4_1_93, vcov.=m4_1_93_vcov)[,4],
                                  coeftest(m4_1_95, vcov.=m4_1_95_vcov)[,4],
                                  coeftest(m4_1_96, vcov.=m4_1_96_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")
screenreg(list(m4_1_01,m4_1_03,m4_1_04,m4_1_05),
          override.se = list(coeftest(m4_1_01, vcov.=m4_1_01_vcov)[,2],
                             coeftest(m4_1_03, vcov.=m4_1_03_vcov)[,2],
                             coeftest(m4_1_04, vcov.=m4_1_04_vcov)[,2],
                             coeftest(m4_1_05, vcov.=m4_1_05_vcov)[,2]),
          override.pvalues = list(coeftest(m4_1_01, vcov.=m4_1_01_vcov)[,4],
                                  coeftest(m4_1_03, vcov.=m4_1_03_vcov)[,4],
                                  coeftest(m4_1_04, vcov.=m4_1_04_vcov)[,4],
                                  coeftest(m4_1_05, vcov.=m4_1_05_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

m4_2_93 <- glm(update(knnetpvote ~ ., f2pnet1), data=dnet93, family=binomial("logit"))
m4_2_95 <- glm(update(knnetpvote ~ ., f2pnet2), data=dnet95, family=binomial("logit"))
m4_2_96 <- glm(update(knnetpvote ~ ., f2pnet2), data=dnet96, family=binomial("logit"))
m4_2_01 <- glm(update(knnetpvote ~ ., f2pnet), data=dnet1, family=binomial("logit"))
m4_2_03 <- glm(update(knnetpvote ~ ., f2pnet), data=dnet3, family=binomial("logit"))
m4_2_04 <- glm(update(knnetpvote ~ ., f2pnet), data=dnet4, family=binomial("logit"))
m4_2_05 <- glm(update(knnetpvote ~ ., f2pnet), data=dnet5, family=binomial("logit"))

m4_2_93_vcov <- cluster.vcov(m4_2_93, cluster=dnet93$id)
m4_2_95_vcov <- cluster.vcov(m4_2_95, cluster=dnet95$id)
m4_2_96_vcov <- cluster.vcov(m4_2_96, cluster=dnet96$id)
m4_2_01_vcov <- cluster.vcov(m4_2_01, cluster=dnet1$id)
m4_2_03_vcov <- cluster.vcov(m4_2_03, cluster=dnet3$id)
m4_2_04_vcov <- cluster.vcov(m4_2_04, cluster=dnet4$id)
m4_2_05_vcov <- cluster.vcov(m4_2_05, cluster=dnet5$id)

screenreg(list(m4_2_93,m4_2_95,m4_2_96),
          override.se = list(coeftest(m4_2_93, vcov.=m4_2_93_vcov)[,2],
                             coeftest(m4_2_95, vcov.=m4_2_95_vcov)[,2],
                             coeftest(m4_2_96, vcov.=m4_2_96_vcov)[,2]),
          override.pvalues = list(coeftest(m4_2_93, vcov.=m4_2_93_vcov)[,4],
                                  coeftest(m4_2_95, vcov.=m4_2_95_vcov)[,4],
                                  coeftest(m4_2_96, vcov.=m4_2_96_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")
screenreg(list(m4_2_01,m4_2_03,m4_2_04,m4_2_05),
          override.se = list(coeftest(m4_2_01, vcov.=m4_2_01_vcov)[,2],
                             coeftest(m4_2_03, vcov.=m4_2_03_vcov)[,2],
                             coeftest(m4_2_04, vcov.=m4_2_04_vcov)[,2],
                             coeftest(m4_2_05, vcov.=m4_2_05_vcov)[,2]),
          override.pvalues = list(coeftest(m4_2_01, vcov.=m4_2_01_vcov)[,4],
                                  coeftest(m4_2_03, vcov.=m4_2_03_vcov)[,4],
                                  coeftest(m4_2_04, vcov.=m4_2_04_vcov)[,4],
                                  coeftest(m4_2_05, vcov.=m4_2_05_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

## Difference in the preferred vote choice (senkyoku)

m5_1_93 <- glm(update(netpvotedif ~ ., f1pnet), data=dnet93, family=binomial("logit"))
m5_1_95 <- glm(update(netpvotedif ~ ., f1pnet), data=dnet95, family=binomial("logit"))
m5_1_96 <- glm(update(netpvotedif ~ ., f1pnet), data=dnet96, family=binomial("logit"))
m5_1_01 <- glm(update(netpvotedif ~ ., f1pnet), data=dnet1, family=binomial("logit"))
m5_1_03 <- glm(update(netpvotedif ~ ., f1pnet), data=dnet3, family=binomial("logit"))
m5_1_04 <- glm(update(netpvotedif ~ ., f1pnet), data=dnet4, family=binomial("logit"))
m5_1_05 <- glm(update(netpvotedif ~ ., f1pnet), data=dnet5, family=binomial("logit"))

m5_1_93_vcov <- cluster.vcov(m5_1_93, cluster=dnet93$id)
m5_1_95_vcov <- cluster.vcov(m5_1_95, cluster=dnet95$id)
m5_1_96_vcov <- cluster.vcov(m5_1_96, cluster=dnet96$id)
m5_1_01_vcov <- cluster.vcov(m5_1_01, cluster=dnet1$id)
m5_1_03_vcov <- cluster.vcov(m5_1_03, cluster=dnet3$id)
m5_1_04_vcov <- cluster.vcov(m5_1_04, cluster=dnet4$id)
m5_1_05_vcov <- cluster.vcov(m5_1_05, cluster=dnet5$id)

screenreg(list(m5_1_93,m5_1_95,m5_1_96),
          override.se = list(coeftest(m5_1_93, vcov.=m5_1_93_vcov)[,2],
                             coeftest(m5_1_95, vcov.=m5_1_95_vcov)[,2],
                             coeftest(m5_1_96, vcov.=m5_1_96_vcov)[,2]),
          override.pvalues = list(coeftest(m5_1_93, vcov.=m5_1_93_vcov)[,4],
                                  coeftest(m5_1_95, vcov.=m5_1_95_vcov)[,4],
                                  coeftest(m5_1_96, vcov.=m5_1_96_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")
screenreg(list(m5_1_01,m5_1_03,m5_1_04,m5_1_05),
          override.se = list(coeftest(m5_1_01, vcov.=m5_1_01_vcov)[,2],
                             coeftest(m5_1_03, vcov.=m5_1_03_vcov)[,2],
                             coeftest(m5_1_04, vcov.=m5_1_04_vcov)[,2],
                             coeftest(m5_1_05, vcov.=m5_1_05_vcov)[,2]),
          override.pvalues = list(coeftest(m5_1_01, vcov.=m5_1_01_vcov)[,4],
                                  coeftest(m5_1_03, vcov.=m5_1_03_vcov)[,4],
                                  coeftest(m5_1_04, vcov.=m5_1_04_vcov)[,4],
                                  coeftest(m5_1_05, vcov.=m5_1_05_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

m5_2_93 <- glm(update(netpvotedif ~ ., f2pnet1), data=dnet93, family=binomial("logit"))
m5_2_95 <- glm(update(netpvotedif ~ ., f2pnet2), data=dnet95, family=binomial("logit"))
m5_2_96 <- glm(update(netpvotedif ~ ., f2pnet2), data=dnet96, family=binomial("logit"))
m5_2_01 <- glm(update(netpvotedif ~ ., f2pnet), data=dnet1, family=binomial("logit"))
m5_2_03 <- glm(update(netpvotedif ~ ., f2pnet), data=dnet3, family=binomial("logit"))
m5_2_04 <- glm(update(netpvotedif ~ ., f2pnet), data=dnet4, family=binomial("logit"))
m5_2_05 <- glm(update(netpvotedif ~ ., f2pnet), data=dnet5, family=binomial("logit"))

m5_2_93_vcov <- cluster.vcov(m5_2_93, cluster=dnet93$id)
m5_2_95_vcov <- cluster.vcov(m5_2_95, cluster=dnet95$id)
m5_2_96_vcov <- cluster.vcov(m5_2_96, cluster=dnet96$id)
m5_2_01_vcov <- cluster.vcov(m5_2_01, cluster=dnet1$id)
m5_2_03_vcov <- cluster.vcov(m5_2_03, cluster=dnet3$id)
m5_2_04_vcov <- cluster.vcov(m5_2_04, cluster=dnet4$id)
m5_2_05_vcov <- cluster.vcov(m5_2_05, cluster=dnet5$id)

screenreg(list(m5_2_93,m5_2_95,m5_2_96),
          override.se = list(coeftest(m5_2_93, vcov.=m5_2_93_vcov)[,2],
                             coeftest(m5_2_95, vcov.=m5_2_95_vcov)[,2],
                             coeftest(m5_2_96, vcov.=m5_2_96_vcov)[,2]),
          override.pvalues = list(coeftest(m5_2_93, vcov.=m5_2_93_vcov)[,4],
                                  coeftest(m5_2_95, vcov.=m5_2_95_vcov)[,4],
                                  coeftest(m5_2_96, vcov.=m5_2_96_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")
screenreg(list(m5_2_01,m5_2_03,m5_2_04,m5_2_05),
          override.se = list(coeftest(m5_2_01, vcov.=m5_2_01_vcov)[,2],
                             coeftest(m5_2_03, vcov.=m5_2_03_vcov)[,2],
                             coeftest(m5_2_04, vcov.=m5_2_04_vcov)[,2],
                             coeftest(m5_2_05, vcov.=m5_2_05_vcov)[,2]),
          override.pvalues = list(coeftest(m5_2_01, vcov.=m5_2_01_vcov)[,4],
                                  coeftest(m5_2_03, vcov.=m5_2_03_vcov)[,4],
                                  coeftest(m5_2_04, vcov.=m5_2_04_vcov)[,4],
                                  coeftest(m5_2_05, vcov.=m5_2_05_vcov)[,4]),
          stars = c(0.001, 0.01, 0.05, 0.1), symbol = "+")

#'
#' # Distributions of Political Interest and Mutoha
#' 

table(d$polint2==1&d$mutoha==1, d$year)
table(d$polint2==1&d$mutoha==0, d$year)
table(d$polint2==0&d$mutoha==1, d$year)
table(d$polint2==0&d$mutoha==0, d$year)

d$mutohapolint2 <- 
  ifelse(d$polint2==1&d$mutoha==1,"高関心無党派",
         ifelse(d$polint2==0&d$mutoha==1,"低関心無党派",
                ifelse(d$polint2==0&d$mutoha==0, "低関心有党派",
                       ifelse(d$polint2==1&d$mutoha==0, "高関心有党派",NA))))
d$mutohapolint2 <- factor(
  d$mutohapolint2, 
  levels = c("高関心無党派","低関心無党派","低関心有党派","高関心有党派"))
outtmp <- apply(table(d$mutohapolint2, d$year),2, function(k) k/sum(k))
outdt <- data.frame(prop = as.numeric(outtmp),
                    year = rep(colnames(outtmp), each=4),
                    cat = factor(levels(d$mutohapolint2),
                                 levels=rev(levels(d$mutohapolint2))),
                    mutoha = c("無党派","無党派","有党派","有党派"),
                    polint2 = c("高","低","低","高"))
require(ggplot2)

p <- ggplot(outdt, aes(x=as.factor(year),y=prop)) + 
  geom_bar(aes(fill=polint2), stat="identity") + 
  #coord_flip() + 
  facet_grid(.~mutoha) +
  scale_fill_manual(name="政治関心", values=c("gray60","gray20")) + 
  theme_bw() + 
  labs(x="調査実施年",y="調査回答者全体における割合") + 
  guides(fill = guide_legend(nrow = 1, reverse = T)) + 
  theme(legend.position = "bottom",
        legend.spacing.x = unit(0.1, 'cm'))
p

ggsave("mutohacat.png", p, width=6, height=4)

#'
#' # Preparing for Prediction
#'

## Prediction Data
preddt0 <- data.frame(
  mutoha = c(0,0,1,1),
  polint2 = c(0,1,0,1),
  fem = 0, age4050 = 1, age60plus = 0,
  edu_c1 = 1, edu_c2 = 0, edu_c3 = 0,
  employed = 1, income_low = 0, income_mid = 1, 
  income_high=0, income_dk=0,
  privatehome = 1, 
  citysize_big = 0, citysize_mid = 0, citysize_sml = 1, 
  netfem = 0, 
  netfa = 1, 
  netwk = 0, 
  netfac = factor("1", levels=c("1","2","3")),
  netpoldis2 = 1
)
preddt <- preddt0
preddt$netfac <- factor("1", levels=c("1","2","3","4"))

#'
#' # Prediction (Network Size)
#'


## Function for Predicted Probability ################################################

## DO NOT CHANGE THE CONTENT ##

predictologit <- function(model,
                       profile,
                       cilevel = 0.95,
                       ndraws = 1000,
                       sumonly = TRUE) {
  
  tt <- terms(model)
  Terms <- delete.response(tt)
  profile <- model.matrix(Terms,data=profile)
  profile <- profile[,-1]

  if (class(model)=="polr") {
    # Coefficients
    coeffs <- c(coef(model), summary(model)$zeta)
    # Variance Covariance Matrix
    covmat <- vcov(model)
    # N of Variable
    nvars <- length(coef(model)) 
  } else if (class(model)=="vglm") {
    # Coefficients
    intloc <- grep("Intercept",names(coef(model)))
    cfloc <- seq(1, length(coef(model)), by=1)[-intloc]
    coeffs <- c(coef(model)[cfloc],
                -coef(model)[intloc])
    # Variance Covariance Matrix
    covmat <- vcov(model)
    covmat[intloc, cfloc] <- -covmat[intloc, cfloc]
    covmat[cfloc, intloc] <- -covmat[cfloc, intloc]
    covmat <- covmat[c(cfloc,intloc),c(cfloc,intloc)]
    # N of Variable
    nvars <- length(coef(model)[cfloc]) 
  } 
  
  # Draw
  require(MASS)
  betadraw <- mvrnorm(ndraws, coeffs, covmat)
  
  # Profile * Coefficients
  dim(betadraw[,1:nvars]); dim(profile)
  xb <- profile %*% t(betadraw[,1:nvars])
  # Thresholds
  taos <- betadraw[,seq(nvars+1, length(coeffs), 1)]
  
  # Predicted Probabilities
  prlist <- list()
  for (i in 1:nrow(xb)) {
    tmp <- 
      cbind(rep(0,ndraws), 
            apply(taos, 2, function(taoi) 1/(1 + exp(xb[i,] - taoi))),
            rep(1, ndraws))
    pr <- matrix(NA, nrow=ndraws, ncol=ncol(taos)+1)
    for (j in seq(1,ncol(taos)+1,1)) pr[,j] <- tmp[,(j+1)] - tmp[,j]
    colnames(pr) <- paste0("Pr.",seq(1,ncol(pr),1))
    head(pr)
    prlist[[i]] <- pr
  }
  
  # Function to Summarize Result
  cirange <- c(0.5,(1 - cilevel)/2, 1 - (1 - cilevel)/2)
  sumres <- function(pr) {
    out <- cbind(colMeans(pr),
                 apply(pr, 2, function(k) sd(k)),
                 t(apply(pr, 2, function(k) quantile(k, probs=cirange))))
    colnames(out) <- c("mean","se","median","lowCI","upCI")
    out
  }
  
  # Export Summary of Prediction
  sumlist <- lapply(prlist, sumres)
  if (length(sumlist)==1) {
    sumlist <- sumlist[[1]]
  }
  
  if (sumonly==TRUE) {
    return(sumlist)
  } else {
    return(list(pr=prlist,sum=sumlist))
  }

}

##########################################################################################

pm1_2_93 <- predictologit(m1_2_93, preddt, sumonly=FALSE)
pm1_2_95 <- predictologit(m1_2_95, preddt, sumonly=FALSE)
pm1_2_96 <- predictologit(m1_2_96, preddt, sumonly=FALSE)
pm1_2_01 <- predictologit(m1_2_01, preddt, sumonly=FALSE)
pm1_2_03 <- predictologit(m1_2_03, preddt, sumonly=FALSE)
pm1_2_04 <- predictologit(m1_2_04, preddt, sumonly=FALSE)
pm1_2_05 <- predictologit(m1_2_05, preddt, sumonly=FALSE)

setci = c(0.05,0.95)

pm1dt_2x <- data.frame(mutoha = c("有","有","無","無"),
           polint2 = c("低関心","高関心"),
           year = rep(c("1993\n衆院選",
                        "1995\n参院選","1996\n衆院選"), each=4),
           yearn = rep(c(1,2,3), each=4),
           pr = c(sapply(pm1_2_93$pr, function(k) sum(colMeans(t(apply(k,1,function(k) k*c(0,1,2,3,4)))))),
                  sapply(pm1_2_95$pr, function(k) sum(colMeans(t(apply(k,1,function(k) k*c(0,1,2,3)))))),
                  sapply(pm1_2_96$pr, function(k) sum(colMeans(t(apply(k,1,function(k) k*c(0,1,2,3))))))),
           lci = c(sapply(pm1_2_93$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[1])))),
                   sapply(pm1_2_95$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3))), 2, function(j) quantile(j,probs=setci[1])))),
                   sapply(pm1_2_96$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3))), 2, function(j) quantile(j,probs=setci[1]))))),
           uci = c(sapply(pm1_2_93$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[2])))),
                   sapply(pm1_2_95$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3))), 2, function(j) quantile(j,probs=setci[2])))),
                   sapply(pm1_2_96$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3))), 2, function(j) quantile(j,probs=setci[2]))))
           ))
pm1dt_2y <- data.frame(mutoha = c("有","有","無","無"),
                       polint2 = c("低関心","高関心"),
                       year = rep(c("2001\n参院選","2003\n衆院選",
                                    "2004\n参院選","2005\n衆院選"), each=4),
                       yearn = rep(c(4,5,6,7), each=4),
                       pr = c(sapply(pm1_2_01$pr, function(k) sum(colMeans(t(apply(k,1,function(k) k*c(0,1,2,3,4)))))),
                              sapply(pm1_2_03$pr, function(k) sum(colMeans(t(apply(k,1,function(k) k*c(0,1,2,3,4)))))),
                              sapply(pm1_2_04$pr, function(k) sum(colMeans(t(apply(k,1,function(k) k*c(0,1,2,3,4)))))),
                              sapply(pm1_2_05$pr, function(k) sum(colMeans(t(apply(k,1,function(k) k*c(0,1,2,3,4))))))),
                       lci = c(sapply(pm1_2_01$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[1])))),
                               sapply(pm1_2_03$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[1])))),
                               sapply(pm1_2_04$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[1])))),
                               sapply(pm1_2_05$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[1]))))),
                       uci = c(sapply(pm1_2_01$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[2])))),
                               sapply(pm1_2_03$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[2])))),
                               sapply(pm1_2_04$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[2])))),
                               sapply(pm1_2_05$pr, function(k) sum(apply(t(apply(k,1,function(k) k*c(0,1,2,3,4))), 2, function(j) quantile(j,probs=setci[2]))))
                       ))

pm1dt_2 <- rbind(pm1dt_2x,pm1dt_2y)

p <- ggplot(pm1dt_2, aes(x=mutoha, y=pr, ymin=lci, ymax=uci)) + 
  geom_bar(aes(alpha=mutoha),stat="identity") + 
  geom_errorbar(stat="identity", width = 0.2) + 
  facet_grid(polint2 ~ year) + 
  #scale_y_continuous(limits = c(0,1), 
  #                   breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_alpha_manual(values = c(0.4,0.8)) + 
  labs(x="普段支持している政党",
       y="回答者が挙げたネットワーク他者の数（予測値）",
       caption="※グラフ上の棒は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "bottom",
                     axis.title.y = element_text(size=10),
                     plot.caption = element_text(size=7))
p

ggsave("sumnet_pred_v2.png", p, width=6, height=4)

p <- ggplot(pm1dt_2, aes(x=yearn, y=pr, ymin=lci, ymax=uci)) + 
  # geom_ribbon(aes(fill=mutoha),alpha=0.3) + 
  # geom_line(aes(linetype=mutoha,color=mutoha),size=0.75) + 
  # geom_point(aes(shape=mutoha,color=mutoha),size=2.5) + 
  geom_errorbar(aes(color=mutoha),width=0.3, position=position_dodge(width=0.4)) + 
  geom_point(aes(shape=mutoha,color=mutoha),size=2.5, position=position_dodge(width=0.4)) + 
  facet_grid(. ~ polint2) +  
  # scale_y_continuous(limits = c(0,1), 
  #                    breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_x_continuous(breaks=seq(1,7),
                     labels=c("93\n衆","95\n参","96\n衆",#"00\n",
                              "01\n参","03\n衆","04\n参","05\n衆")) + 
  scale_shape_discrete(name="普段支持している政党") + 
  scale_fill_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_color_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_linetype_manual(name="普段支持している政党", values=c(2,1)) + 
  labs(x=NULL,
       y="回答者が挙げたネットワーク他者の数（予測値）",
       caption="※グラフ上の点は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "bottom",
                     axis.title.y = element_text(size=10),
                     plot.caption = element_text(size=7))
p

ggsave("sumnet_pred2_v2.png", p, width=6, height=4)

#'
#' # Prediction (Network Data)
#'

## Prediction Function
## Borrowed Mostly From https://stackoverflow.com/questions/3790116/using-clustered-covariance-matrix-in-predict-lm?noredirect=1&lq=1
predict_robust <- function(x,newdata,vcov.){
  if(missing(newdata)){ newdata <- x$model }
  tt <- terms(x)
  Terms <- delete.response(tt)
  m.mat <- model.matrix(Terms,data=newdata)
  m.coef <- x$coef
  fit <- as.vector(m.mat %*% x$coef)
  if (missing(vcov.)) vcov. <- vcov(x)
  se.fit <- sqrt(diag(m.mat%*%vcov.%*%t(m.mat)))
  return(list(fit=fit,se.fit=se.fit))
}

## Political Discussion

pm2_2_93 <- predict_robust(m2_2_93, preddt, m2_2_93_vcov)
pm2_2_95 <- predict_robust(m2_2_95, preddt0, m2_2_95_vcov)
pm2_2_96 <- predict_robust(m2_2_96, preddt0, m2_2_96_vcov)
# pm2_2_00 <- predict_robust(m2_2_00, preddt0, m2_2_00_vcov)
pm2_2_01 <- predict_robust(m2_2_01, preddt, m2_2_01_vcov)
pm2_2_03 <- predict_robust(m2_2_03, preddt, m2_2_03_vcov)
pm2_2_04 <- predict_robust(m2_2_04, preddt, m2_2_04_vcov)
pm2_2_05 <- predict_robust(m2_2_05, preddt, m2_2_05_vcov)

pm2dt_2x <- 
  data.frame(mutoha = c("有","有","無","無"),
             polint2 = c("低関心","高関心"),
             year = rep(c("1993\n衆院選",
                          "1995\n参院選","1996\n衆院選"), each=4),
             yearn = rep(c(1,2,3), each=4),
             pr = plogis(c(pm2_2_93$fit,pm2_2_95$fit,pm2_2_96$fit)),
             lci = plogis(c(pm2_2_93$fit - qnorm(0.95)*pm2_2_93$se.fit,
                            pm2_2_95$fit - qnorm(0.95)*pm2_2_95$se.fit,
                            pm2_2_96$fit - qnorm(0.95)*pm2_2_96$se.fit)),
             uci = plogis(c(pm2_2_93$fit + qnorm(0.95)*pm2_2_93$se.fit,
                            pm2_2_95$fit + qnorm(0.95)*pm2_2_95$se.fit,
                            pm2_2_96$fit + qnorm(0.95)*pm2_2_96$se.fit)))
pm2dt_2y <- 
  data.frame(mutoha = c("有","有","無","無"),
             polint2 = c("低関心","高関心"),
             year = rep(c(#"2000\n",
                          "2001\n参院選","2003\n衆院選",
                          "2004\n参院選","2005\n衆院選"), each=4),
             yearn = rep(c(4,5,6,7), each=4),
             pr = plogis(c(#pm2_2_00$fit,
                           pm2_2_01$fit,pm2_2_03$fit,
                           pm2_2_04$fit,pm2_2_05$fit)),
             lci = plogis(c(#pm2_2_00$fit - qnorm(0.95)*pm2_2_00$se.fit,
                            pm2_2_01$fit - qnorm(0.95)*pm2_2_01$se.fit,
                            pm2_2_03$fit - qnorm(0.95)*pm2_2_03$se.fit,
                            pm2_2_04$fit - qnorm(0.95)*pm2_2_04$se.fit,
                            pm2_2_05$fit - qnorm(0.95)*pm2_2_05$se.fit)),
             uci = plogis(c(#pm2_2_00$fit + qnorm(0.95)*pm2_2_00$se.fit,
                            pm2_2_01$fit + qnorm(0.95)*pm2_2_01$se.fit,
                            pm2_2_03$fit + qnorm(0.95)*pm2_2_03$se.fit,
                            pm2_2_04$fit + qnorm(0.95)*pm2_2_04$se.fit,
                            pm2_2_05$fit + qnorm(0.95)*pm2_2_05$se.fit)))
pm2dt_2 <- rbind(pm2dt_2x,pm2dt_2y)

p <- ggplot(pm2dt_2, aes(x=mutoha, y=pr, ymin=lci, ymax=uci)) + 
  geom_bar(aes(alpha=mutoha),stat="identity") + 
  geom_errorbar(stat="identity", width = 0.2) + 
  facet_grid(polint2 ~ year) + 
  scale_y_continuous(limits = c(0,1), 
                     breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_alpha_manual(values = c(0.4,0.8)) + 
  labs(x="普段支持している政党",
       y="ネットワーク他者と政治について\nよく話題になる確率（予測値）",
       caption="※グラフ上の棒は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "bottom",
                     axis.title.y = element_text(size=10),
                     plot.caption = element_text(size=7))
p

ggsave("netpoldis_pred_v2.png", p, width=6, height=4)

p <- ggplot(pm2dt_2, aes(x=yearn, y=pr, ymin=lci, ymax=uci)) + 
  # geom_ribbon(aes(fill=mutoha),alpha=0.3) + 
  # geom_line(aes(linetype=mutoha,color=mutoha),size=0.75) + 
  # geom_point(aes(shape=mutoha,color=mutoha),size=2.5) + 
  geom_errorbar(aes(color=mutoha),width=0.3, position=position_dodge(width=0.4)) + 
  geom_point(aes(shape=mutoha,color=mutoha),size=2.5, position=position_dodge(width=0.4)) + 
  facet_grid(. ~ polint2) +  
  scale_y_continuous(limits = c(0,1), 
                     breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_x_continuous(breaks=seq(1,7),
                     labels=c("93\n衆","95\n参","96\n衆",#"00\n",
                              "01\n参","03\n衆","04\n参","05\n衆")) + 
  scale_shape_discrete(name="普段支持している政党") + 
  scale_fill_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_color_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_linetype_manual(name="普段支持している政党", values=c(2,1)) + 
  labs(x=NULL,
       y="ネットワーク他者と政治について\nよく話題になる確率（予測値）",
       caption="※グラフ上の点は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "bottom",
                     axis.title.y = element_text(size=10),
                     plot.caption = element_text(size=7))
p

ggsave("netpoldis_pred2_v2.png", p, width=6, height=4)

## Perceived Political Knowledge

# pm3_2_00 <- predict_robust(m3_2_00, preddt0, m3_2_00_vcov)
pm3_2_01 <- predict_robust(m3_2_01, preddt, m3_2_01_vcov)
pm3_2_03 <- predict_robust(m3_2_03, preddt, m3_2_03_vcov)
pm3_2_04 <- predict_robust(m3_2_04, preddt, m3_2_04_vcov)
pm3_2_05 <- predict_robust(m3_2_05, preddt, m3_2_05_vcov)

pm3dt_2 <- 
  data.frame(mutoha = c("有","有","無","無"),
             polint2 = c("低関心","高関心"),
             year = rep(c(#"2000\n",
                          "2001\n参院選","2003\n衆院選",
                          "2004\n参院選","2005\n衆院選"), each=4),
             yearn = rep(c(1,2,3,4), each=4),
             pr = plogis(c(#pm3_2_00$fit,
                           pm3_2_01$fit,pm3_2_03$fit,
                           pm3_2_04$fit,pm3_2_05$fit)),
             lci = plogis(c(#pm3_2_00$fit - qnorm(0.95)*pm3_2_00$se.fit,
                            pm3_2_01$fit - qnorm(0.95)*pm3_2_01$se.fit,
                            pm3_2_03$fit - qnorm(0.95)*pm3_2_03$se.fit,
                            pm3_2_04$fit - qnorm(0.95)*pm3_2_04$se.fit,
                            pm3_2_05$fit - qnorm(0.95)*pm3_2_05$se.fit)),
             uci = plogis(c(#pm3_2_00$fit + qnorm(0.95)*pm3_2_00$se.fit,
                            pm3_2_01$fit + qnorm(0.95)*pm3_2_01$se.fit,
                            pm3_2_03$fit + qnorm(0.95)*pm3_2_03$se.fit,
                            pm3_2_04$fit + qnorm(0.95)*pm3_2_04$se.fit,
                            pm3_2_05$fit + qnorm(0.95)*pm3_2_05$se.fit)))

p <- ggplot(pm3dt_2, aes(x=mutoha, y=pr, ymin=lci, ymax=uci)) + 
  geom_bar(aes(alpha=mutoha),stat="identity") + 
  geom_errorbar(stat="identity", width = 0.2) + 
  facet_grid(polint2 ~ year) + 
  scale_y_continuous(limits = c(0,1), 
                     breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_alpha_manual(values = c(0.4,0.8)) + 
  labs(x="普段支持している政党",
       caption="※1993ー96の調査には設問が存在しない。グラフ上の点は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "none",
                     axis.title.y = element_text(size=10))
p

ggsave("netknow_pred_v2.png", p, width=6, height=4)

p <- ggplot(pm3dt_2, aes(x=yearn, y=pr, ymin=lci, ymax=uci)) + 
  # geom_ribbon(aes(fill=mutoha),alpha=0.3) + 
  # geom_line(aes(linetype=mutoha,color=mutoha),size=0.75) + 
  # geom_point(aes(shape=mutoha,color=mutoha),size=2.5) + 
  geom_errorbar(aes(color=mutoha),width=0.3, position=position_dodge(width=0.4)) + 
  geom_point(aes(shape=mutoha,color=mutoha),size=2.5, position=position_dodge(width=0.4)) + 
  facet_grid(. ~ polint2) +  
  scale_y_continuous(limits = c(0,1), 
                     breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_x_continuous(breaks=seq(1,4),
                     labels=c(#"00\n",
                              "01\n参","03\n衆","04\n参","05\n衆")) + 
  scale_shape_discrete(name="普段支持している政党") + 
  scale_fill_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_color_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_linetype_manual(name="普段支持している政党", values=c(2,1)) + 
  labs(x=NULL,
       y="ネットワーク他者が政治について詳しいと\n認識している確率（予測値）",
       caption="※1993ー96の調査には設問が存在しない。グラフ上の点は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "bottom",
                     axis.title.y = element_text(size=10),
                     plot.caption = element_text(size=7))
p

ggsave("netknow_pred2_v2.png", p, width=6, height=4)

## Knowing Partner's Vote Choice/Party Support

pm4_2_93 <- predict_robust(m4_2_93, preddt, m4_2_93_vcov)
pm4_2_95 <- predict_robust(m4_2_95, preddt0, m4_2_95_vcov)
pm4_2_96 <- predict_robust(m4_2_96, preddt0, m4_2_96_vcov)
#pm4_2_00 <- predict_robust(m4_2_00, preddt0, m4_2_00_vcov)
pm4_2_01 <- predict_robust(m4_2_01, preddt, m4_2_01_vcov)
pm4_2_03 <- predict_robust(m4_2_03, preddt, m4_2_03_vcov)
pm4_2_04 <- predict_robust(m4_2_04, preddt, m4_2_04_vcov)
pm4_2_05 <- predict_robust(m4_2_05, preddt, m4_2_05_vcov)

pm4dt_2x <- 
  data.frame(mutoha = c("有","有","無","無"),
             polint2 = c("低関心","高関心"),
             year = rep(c("1993\n衆院選",
                          "1995\n参院選","1996\n衆院選"), each=4),
             yearn = rep(c(1,2,3), each=4),
             pr = plogis(c(pm4_2_93$fit,pm4_2_95$fit,pm4_2_96$fit)),
             lci = plogis(c(pm4_2_93$fit - qnorm(0.95)*pm4_2_93$se.fit,
                            pm4_2_95$fit - qnorm(0.95)*pm4_2_95$se.fit,
                            pm4_2_96$fit - qnorm(0.95)*pm4_2_96$se.fit)),
             uci = plogis(c(pm4_2_93$fit + qnorm(0.95)*pm4_2_93$se.fit,
                            pm4_2_95$fit + qnorm(0.95)*pm4_2_95$se.fit,
                            pm4_2_96$fit + qnorm(0.95)*pm4_2_96$se.fit)))
pm4dt_2y <- 
  data.frame(mutoha = c("有","有","無","無"),
             polint2 = c("低関心","高関心"),
             year = rep(c(#"2000\n※",
                          "2001\n参院選","2003\n衆院選",
                          "2004\n参院選","2005\n衆院選"), each=4),
             yearn = rep(c(4,5,6,7), each=4),
             pr = plogis(c(#pm4_2_00$fit,
                           pm4_2_01$fit,pm4_2_03$fit,
                           pm4_2_04$fit,pm4_2_05$fit)),
             lci = plogis(c(#pm4_2_00$fit - qnorm(0.95)*pm4_2_00$se.fit,
                            pm4_2_01$fit - qnorm(0.95)*pm4_2_01$se.fit,
                            pm4_2_03$fit - qnorm(0.95)*pm4_2_03$se.fit,
                            pm4_2_04$fit - qnorm(0.95)*pm4_2_04$se.fit,
                            pm4_2_05$fit - qnorm(0.95)*pm4_2_05$se.fit)),
             uci = plogis(c(#pm4_2_00$fit + qnorm(0.95)*pm4_2_00$se.fit,
                            pm4_2_01$fit + qnorm(0.95)*pm4_2_01$se.fit,
                            pm4_2_03$fit + qnorm(0.95)*pm4_2_03$se.fit,
                            pm4_2_04$fit + qnorm(0.95)*pm4_2_04$se.fit,
                            pm4_2_05$fit + qnorm(0.95)*pm4_2_05$se.fit)))
pm4dt_2 <- rbind(pm4dt_2x,pm4dt_2y)

p <- ggplot(pm4dt_2, aes(x=mutoha, y=pr, ymin=lci, ymax=uci)) + 
  geom_bar(aes(alpha=mutoha),stat="identity") + 
  geom_errorbar(stat="identity", width = 0.2) + 
  facet_grid(polint2 ~ year) + 
  scale_y_continuous(limits = c(0,1), 
                     breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_alpha_manual(values = c(0.4,0.8)) + 
  labs(x="普段支持している政党",
       y="政治がよく話題になるネットワーク他者の選挙区投票先（意向）を\n認識している確率（予測値）",
       caption="※グラフ上の棒は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "bottom",
                     axis.title.y = element_text(size=10),
                     plot.caption = element_text(size=7))
p

ggsave("knnetpvote_pred_v2.png", p, width=6, height=4)

p <- ggplot(pm4dt_2, aes(x=yearn, y=pr, ymin=lci, ymax=uci)) + 
  # geom_ribbon(aes(fill=mutoha),alpha=0.3) + 
  # geom_line(aes(linetype=mutoha,color=mutoha),size=0.75) + 
  # geom_point(aes(shape=mutoha,color=mutoha),size=2.5) + 
  geom_errorbar(aes(color=mutoha),width=0.3, position=position_dodge(width=0.4)) + 
  geom_point(aes(shape=mutoha,color=mutoha),size=2.5, position=position_dodge(width=0.4)) + 
  facet_grid(. ~ polint2) +  
  scale_y_continuous(limits = c(0,1), 
                     breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_x_continuous(breaks=seq(1,7),
                     labels=c("93\n衆","95\n参","96\n衆",#"00\n※",
                              "01\n参","03\n衆","04\n参","05\n衆")) + 
  scale_shape_discrete(name="普段支持している政党") + 
  scale_fill_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_color_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_linetype_manual(name="普段支持している政党", values=c(2,1)) + 
  labs(x=NULL,y="政治がよく話題になるネットワーク他者の\n投票先意向を認識している確率（予測値）",
       caption="※グラフ上の点は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "bottom",
                     axis.title.y = element_text(size=10),
                     plot.caption = element_text(size=7))
p

ggsave("knnetpvote_pred2_v2.png", p, width=6, height=4)

## Difference in the preferred vote choice

pm5_2_93 <- predict_robust(m5_2_93, preddt, m5_2_93_vcov)
pm5_2_95 <- predict_robust(m5_2_95, preddt0, m5_2_95_vcov)
pm5_2_96 <- predict_robust(m5_2_96, preddt0, m5_2_96_vcov)
pm5_2_01 <- predict_robust(m5_2_01, preddt, m5_2_01_vcov)
pm5_2_03 <- predict_robust(m5_2_03, preddt, m5_2_03_vcov)
pm5_2_04 <- predict_robust(m5_2_04, preddt, m5_2_04_vcov)
pm5_2_05 <- predict_robust(m5_2_05, preddt, m5_2_05_vcov)

pm5dt_2x <- 
  data.frame(mutoha = c("有","有","無","無"),
             polint2 = c("低関心","高関心"),
             year = rep(c("1993\n衆院選",
                          "1995\n参院選","1996\n衆院選"), each=4),
             yearn = rep(c(1,2,3), each=4),
             pr = plogis(c(pm5_2_93$fit,pm5_2_95$fit,pm5_2_96$fit)),
             lci = plogis(c(pm5_2_93$fit - qnorm(0.95)*pm5_2_93$se.fit,
                            pm5_2_95$fit - qnorm(0.95)*pm5_2_95$se.fit,
                            pm5_2_96$fit - qnorm(0.95)*pm5_2_96$se.fit)),
             uci = plogis(c(pm5_2_93$fit + qnorm(0.95)*pm5_2_93$se.fit,
                            pm5_2_95$fit + qnorm(0.95)*pm5_2_95$se.fit,
                            pm5_2_96$fit + qnorm(0.95)*pm5_2_96$se.fit)))
pm5dt_2y <- 
  data.frame(mutoha = c("有","有","無","無"),
             polint2 = c("低関心","高関心"),
             year = rep(c("2001\n参院選","2003\n衆院選",
                          "2004\n参院選","2005\n衆院選"), each=4),
             yearn = rep(c(4,5,6,7), each=4),
             pr = plogis(c(pm5_2_01$fit,pm5_2_03$fit,pm5_2_04$fit,pm5_2_05$fit)),
             lci = plogis(c(pm5_2_01$fit - qnorm(0.95)*pm5_2_01$se.fit,
                            pm5_2_03$fit - qnorm(0.95)*pm5_2_03$se.fit,
                            pm5_2_04$fit - qnorm(0.95)*pm5_2_04$se.fit,
                            pm5_2_05$fit - qnorm(0.95)*pm5_2_05$se.fit)),
             uci = plogis(c(pm5_2_01$fit + qnorm(0.95)*pm5_2_01$se.fit,
                            pm5_2_03$fit + qnorm(0.95)*pm5_2_03$se.fit,
                            pm5_2_04$fit + qnorm(0.95)*pm5_2_04$se.fit,
                            pm5_2_05$fit + qnorm(0.95)*pm5_2_05$se.fit)))
pm5dt_2 <- rbind(pm5dt_2x,pm5dt_2y)

p <- ggplot(pm5dt_2, aes(x=mutoha, y=pr, ymin=lci, ymax=uci)) + 
  geom_bar(aes(alpha=mutoha),stat="identity") + 
  geom_errorbar(stat="identity", width = 0.2) + 
  facet_grid(polint2 ~ year) + 
  scale_y_continuous(limits = c(0,1), 
                     breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_alpha_manual(values = c(0.4,0.8)) + 
  labs(x="普段支持している政党",
       y="政治がよく話題になるネットワーク他者と選挙区\n投票先意向が一致しない確率（予測値）",
       caption="※グラフ上の棒は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "bottom",
                     axis.title.y = element_text(size=10),
                     plot.caption = element_text(size=7))
p

ggsave("netpvotedif_pred_v2.png", p, width=6, height=4)

p <- ggplot(pm5dt_2, aes(x=yearn, y=pr, ymin=lci, ymax=uci)) + 
  # geom_ribbon(aes(fill=mutoha),alpha=0.3) + 
  # geom_line(aes(linetype=mutoha,color=mutoha),size=0.75) + 
  # geom_point(aes(shape=mutoha,color=mutoha),size=2.5) + 
  geom_errorbar(aes(color=mutoha),width=0.3, position=position_dodge(width=0.4)) + 
  geom_point(aes(shape=mutoha,color=mutoha),size=2.5, position=position_dodge(width=0.4)) + 
  facet_grid(. ~ polint2) +  
  scale_y_continuous(limits = c(0,1), 
                     breaks=c(0,0.5,1),labels=c("0%","50%","100%")) + 
  scale_x_continuous(breaks=seq(1,7),
                     labels=c("93\n衆","95\n参","96\n衆",
                              "01\n参","03\n衆","04\n参","05\n衆")) + 
  scale_shape_discrete(name="普段支持している政党") + 
  scale_color_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_fill_brewer(name="普段支持している政党", type="qual", palette=2) + 
  scale_linetype_manual(name="普段支持している政党", values=c(2,1)) + 
  labs(x=NULL,y="政治がよく話題になるネットワーク他者と選挙区\n投票先意向が一致しない確率（予測値）",
       caption="※グラフ上の点は予測値、縦線は90%信頼区間を示している。") +
  theme_bw() + theme(legend.position = "bottom",
                     axis.title.y = element_text(size=10),
                     plot.caption = element_text(size=7))
p

ggsave("netpvotedif_pred2_v2.png", p, width=6, height=4)

#+ eval=FALSE, echo=FALSE
# Exporting HTML File
# In R Studio
# rmarkdown::render('analysis_0_main_v2.R', 'github_document', clean=FALSE)
# tmp <- list.files("./")
# tmp <- tmp[grep("\\.spin\\.R$|\\.spin\\.Rmd$|\\.utf8\\.md$|\\.knit\\.md$|\\.log$|\\.tex$",tmp)]
# for (i in 1:length(tmp)) file.remove(paste0("./",tmp[i]))
