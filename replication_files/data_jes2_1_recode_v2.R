#' ---
#' title: "JESII Recode"
#' author: "Gento Kato"
#' date: "April 15, 2021"
#' ---
#' 
#' # Preparation 

## Clean Up Space
rm(list=ls())

## Set Working Directory (Automatically) ##
require(rstudioapi); require(rprojroot)
if (rstudioapi::isAvailable()==TRUE) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path)); 
} 
projdir <- find_root(has_file("thisishome.txt"))
cat(paste("Working Directory Set to:\n",projdir))
setwd(projdir)

## Find Data Directory
### Leviathan (SPSS)
datadir_s <- "JES2.sav"

## Import Original Data
require(haven)

### SSJDA
ds <- read_sav(datadir_s, encoding="SHIFT_JIS")
colnames(ds) <- tolower(colnames(ds)) # lowercase

## All Parties
jimin="自民"; minshu="民主"; komei="公明"; shamin="社民"; kyosan="共産"
hoshushin="保守新"; jiyu="自由"; kokuminshin="国民新"; shakai="社会"; shinsei="新生"
minsha="民社"; sakigake="さきがけ"; shaminren="社民連"; nihonshin="日本新"; shinshin="新進"
sonota="その他"
allps <- c(jimin,shakai,komei,shinsei,kyosan,
           minsha,sakigake,shaminren,nihonshin,shinshin,
           minshu,shamin,hoshushin,jiyu,kokuminshin,
           sonota)
mutoha="無党派"
mikettei="未決定"
kiken="棄権"
shiranai="知らない"
mushozoku="無所属"

#'
#' # Check Relevant Variables
#'
#' ## Leviathan (SPSS) Data
#'

############
## Common ##
############

## Self
table(ds$citysize, useNA="always") # City Size
table(ds$sex, useNA="always") # Gender

##########################
## Wave 5 HoC 1995 Post ##
##########################

## Response
table(ds$sangi95) 

## Self
table(ds$rawage2, useNA="always") # Age
table(ds$cabinet4, useNA="always") # PM Support
table(ds$ptysup5, useNA="always") # Party Support
table(ds$streng5, useNA="always") # Party Support Strength
table(ds$strind, useNA="always") # Shijinashi Strength
table(ds$rsnnopty, useNA="always") # Shijinashi Reason
table(ds$ptylean5, useNA="always") # Party Leaners
table(ds$votesan, useNA="always") # Voted
table(ds$elvote95, useNA="always") # Vote Decision by Party (県選挙区)
table(ds$prvote95, useNA="always") # Vote Decision by Party (PR)
table(ds$polint2, useNA="always") # Political Interest
table(ds$resyr2, useNA="always") # Year of Residence
table(ds$educ2, useNA="always") # Education
table(ds$empst2, useNA="always") # Occupation
table(ds$typres2, useNA="always") # Type of Home
table(ds$incomf2, useNA="always") # Household Income

## Partner 1
table(ds$talk1, useNA="always") # Partner 1 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(ds$relatn1, useNA="always") # Relationship with P1
# table(, useNA="always") # Gender of P1
# table(, useNA="always") # Closeness of P1
table(ds$times1, useNA="always") # Pol. Discussion with P1
# table(, useNA="always") # Watch/Read News Together with P1
# table(, useNA="always") # Perceived Pol. Knowledge of P1
table(ds$votesan1, useNA="always") # Expected Vote Choice of P1
# table(, useNA="always") # Expected Koizumi Support of P1
# table(, useNA="always") # Similarity with P1
# table(, useNA="always") # Relative Social Status of P1

## Partner 2
table(ds$talk2, useNA="always") # Partner 2 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(ds$relatn2, useNA="always") # Relationship with P2
# table(, useNA="always") # Gender of P2
# table(, useNA="always") # Closeness of P2
table(ds$times2, useNA="always") # Pol. Discussion with P2
# table(, useNA="always") # Watch/Read News Together with P2
# table(, useNA="always") # Perceived Pol. Knowledge of P2
table(ds$votesan2, useNA="always") # Expected Vote Choice of P2
# table(, useNA="always") # Expected Koizumi Support of P2
# table(, useNA="always") # Similarity with P2
# table(, useNA="always") # Relative Social Status of P2

## Partner 3
table(ds$talk3, useNA="always") # Partner 3 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(ds$relatn3, useNA="always") # Relationship with P3
# table(, useNA="always") # Gender of P3
# table(, useNA="always") # Closeness of P3
table(ds$times3, useNA="always") # Pol. Discussion with P3
# table(, useNA="always") # Watch/Read News Together with P3
# table(, useNA="always") # Perceived Pol. Knowledge of P3
table(ds$votesan3, useNA="always") # Expected Vote Choice of P3
# table(, useNA="always") # Expected Koizumi Support of P3
# table(, useNA="always") # Similarity with P3
# table(, useNA="always") # Relative Social Status of P3

## Acquaintance Between Partners
# table(, useNA="always") # (IF P1-P3 exist) All know each other 
# table(, useNA="always") # (IF P1-P3 exist) P1 and P2 Knows Each Other
# table(, useNA="always") # (IF P1-P3 exist) P1 and P3 Knows Each Other
# table(, useNA="always") # (IF P1-P3 exist) P2 and P3 Knows Each Other
# table(, useNA="always") # (IF P1-P3 exist) DK
# table(, useNA="always") # (IF P1-P3 exist) NA
# 
# table(, useNA="always") # (IF P1,P2 only) Relationship between P1 & P2

#########################
## Wave 6 & 7 HoR 1996 ##
#########################

## Response
table(ds$preele) # Pre
table(ds$pstele) # Post 

## Self
table(ds$rawage3, useNA="always") # Age
table(ds$cabinet5, useNA="always") # PM Support
table(ds$ptysup7, useNA="always") # Party Support
table(ds$streng7, useNA="always") # Party Support Strength
table(ds$strind7, useNA="always") # Shijinashi Strength
# table(ds$rsnnopt6, useNA="always") # Shijinashi Reason
table(ds$ptylean7, useNA="always") # Party Leaners
table(ds$govote2, useNA="always") # Vote intention
table(ds$ptycmit2, ds$pty6153, useNA="always") # Vote Decision by Party (県選挙区)
table(ds$ptywhich, useNA="always") # Vote Decision by Party (PR)
table(ds$polint3, useNA="always") # Political Interest (Post)
table(ds$resyr3, useNA="always") # Year of Residence
table(ds$educ3, useNA="always") # Education
table(ds$empst3, useNA="always") # Occupation
table(ds$typres3, useNA="always") # Type of Home
table(ds$incomf3, useNA="always") # Household Income
### Post-Election Voting Behavior
table(ds$elvote96, useNA="always") # Voted (Chose option 10)
table(ds$elvote96, useNA="always") # Vote Decision by Party (SMD)
table(ds$prvote96, useNA="always") # Vote Decision by Party (PR)

## Partner 1
table(ds$talk1_2, useNA="always") # Partner 1 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(ds$relat1_2, useNA="always") # Relationship with P1
# table(, useNA="always") # Gender of P1
# table(, useNA="always") # Closeness of P1
table(ds$times1_2, useNA="always") # Pol. Discussion with P1
# table(, useNA="always") # Watch/Read News Together with P1
table(ds$media1, useNA="always") # Discussion about Election News with P1
# table(, useNA="always") # Perceived Pol. Knowledge of P1
table(ds$vote96_1, useNA="always") # Expected Vote Choice of P1
# table(, useNA="always") # Expected Koizumi Support of P1
# table(, useNA="always") # Similarity with P1
# table(, useNA="always") # Relative Social Status of P1

## Partner 2
table(ds$talk2_2, useNA="always") # Partner 2 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(ds$relat2_2, useNA="always") # Relationship with P2
# table(, useNA="always") # Gender of P2
# table(, useNA="always") # Closeness of P2
table(ds$times2_2, useNA="always") # Pol. Discussion with P2
# table(, useNA="always") # Watch/Read News Together with P2
table(ds$media2, useNA="always") # Discussion about Election News with P2
# table(, useNA="always") # Perceived Pol. Knowledge of P2
table(ds$vote96_2, useNA="always") # Expected Vote Choice of P2
# table(, useNA="always") # Expected Koizumi Support of P2
# table(, useNA="always") # Similarity with P2
# table(, useNA="always") # Relative Social Status of P2

## Partner 3
table(ds$talk3_2, useNA="always") # Partner 3 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(ds$relat3_2, useNA="always") # Relationship with P3
# table(, useNA="always") # Gender of P3
# table(, useNA="always") # Closeness of P3
table(ds$times3_2, useNA="always") # Pol. Discussion with P3
# table(, useNA="always") # Watch/Read News Together with P3
table(ds$media3, useNA="always") # Discussion about Election News with P1
# table(, useNA="always") # Perceived Pol. Knowledge of P3
table(ds$vote96_3, useNA="always") # Expected Vote Choice of P3
# table(, useNA="always") # Expected Koizumi Support of P3
# table(, useNA="always") # Similarity with P3
# table(, useNA="always") # Relative Social Status of P3

## Acquaintance Between Partners
table(ds$knowthre, useNA="always") # (IF P1-P3 exist) All know each other 
table(ds$know1x2, useNA="always") # (IF P1-P3 exist) P1 and P2 Knows Each Other
table(ds$know1x3, useNA="always") # (IF P1-P3 exist) P1 and P3 Knows Each Other
table(ds$know2x3, useNA="always") # (IF P1-P3 exist) P2 and P3 Knows Each Other
table(ds$knowdk, useNA="always") # (IF P1-P3 exist) DK
table(ds$knowna, useNA="always") # (IF P1-P3 exist) NA

table(ds$knowtwo, useNA="always") # (IF P1,P2 only) Relationship between P1 & P2

#'
#' # Create New Data
#' 

# Initiate New Leviathan (SPSS) Data Set
s <- data.frame(id = rep(seq(1,nrow(ds)),2), 
                year = rep(c(1995,1996), each=nrow(ds)))

## House of Representative Dummy
s$horelec <- ifelse(s$year%in%c(1996),1,0)

## Sampled Year
s$smpyear <- NA

## Fresh/Panel Sample dummies (NAs for invalid cases)
s$panel <- ifelse(ds$sangi95 == 1 & ds$preele == 1, 1, 0)
s$fresh <- 1 - s$panel
table(s$panel, s$year, useNA="always")
table(s$fresh, s$year, useNA="always")

## Unit Response Dummies
s$answered <- c(ds$sangi95, ds$preele)
table(s$answered, s$year, useNA="always")

## City Size 
table(ds$citysize, useNA="always") # City Size
# 1 = Tokyo, Osaka
# 2 = Yokohama, Nagoya, Kyoto, Kita-Kyusyu
# 3 = Sapporo, Sendai, Kawasaki, Kobe, Hiroshima, Fukuoka
# 4 = Chiba
# 5 = Cities MT 200T
# 6 = MT 100T
# 7 = LT 100T
# 8 = Towns and Villages

### Big Cities in Three Major Urban Area (Tokyo, Osaka, Yokohama, Nagoya, Kyoto, Kawasaki, Kobe, Chiba)
s$citysize_big3 <- ifelse(
  ds$citysize%in%c(1,4)|(ds$citysize==2&ds$prefectr%in%c(14,23,26))|(ds$citysize==3&ds$prefectr%in%c(14,28)),
  1,0
)
table(s$citysize_big3[s$year==1995])

### Big Cities in Other Area (Kita-Kyusyu, Sapporo, Sendai, Hiroshima, Fukuoka)
s$citysize_bigelse <- ifelse(
  (ds$citysize==2&!ds$prefectr%in%c(14,23,26))|(ds$citysize==3&!ds$prefectr%in%c(14,28)),
  1,0
)
table(s$citysize_bigelse[s$year==1995])

### All Big Cities
s$citysize_big <- s$citysize_big3 + s$citysize_bigelse
table(s$citysize_big[s$year==1995])

### Middle Size Cities (MT 200T)
s$citysize_mid <- ifelse(ds$citysize==5,1,0)
table(s$citysize_mid[s$year==1995])

### Small Cities (LT 200T)
s$citysize_sml <- ifelse(ds$citysize%in%c(6),1,0)
table(s$citysize_sml[s$year==1995])

### Not Cities (Villages/Towns)
s$citysize_not <- ifelse(ds$citysize%in%c(7),1,0)
table(s$citysize_not[s$year==1995])

## All City Sizes
s$citysize <- ifelse(s$citysize_big==1,1,
                     ifelse(s$citysize_mid==1,2/3,
                            ifelse(s$citysize_sml==1,1/3,0)))

## Gender (Female)
s$fem <- ds$sex - 1
table(s$fem[s$year==1995])

## Age (To Become in the Given Year)
table(ds$rawage2, useNA="always") # Born Year
table(ds$rawage3, useNA="always") # Born Year
s$age <- c(ds$rawage2, ds$rawage3)
hist(s$age)

## PM Support
table(ds$cabinet4, useNA="always") # PM Support
table(ds$cabinet5, useNA="always") # PM Support
s$pmsup <- NA
s$pmsup[s$year==1995] <- ifelse(ds$cabinet4>=5,NA,(4-ds$cabinet4)/3)
s$pmsup[s$year==1996] <- ifelse(ds$cabinet5>=6,NA,(5-ds$cabinet5)/4)
table(s$pmsup, s$year, useNA="always")

## Party Support

### Supporting Party
s$psup <- NA
s$psup[c(ds$ptysup5, ds$ptysup7)%in%1] <- jimin 
s$psup[c(ds$ptysup5, ds$ptysup7)%in%2] <- shinshin 
s$psup[c(ds$ptysup5, ds$ptysup7)%in%5] <- kyosan 
s$psup[c(ds$ptysup5, rep(NA,nrow(ds)))%in%3] <- shakai 
s$psup[c(ds$ptysup5, rep(NA,nrow(ds)))%in%4] <- sakigake 
s$psup[c(ds$ptysup5, rep(NA,nrow(ds)))%in%6] <- sonota 
s$psup[c(ds$ptysup5, rep(NA,nrow(ds)))%in%7] <- mutoha 
s$psup[c(rep(NA,nrow(ds)),ds$ptysup7)%in%3] <- minshu 
s$psup[c(rep(NA,nrow(ds)),ds$ptysup7)%in%4] <- shamin 
s$psup[c(rep(NA,nrow(ds)),ds$ptysup7)%in%6] <- sakigake 
s$psup[c(rep(NA,nrow(ds)),ds$ptysup7)%in%7] <- sonota
s$psup[c(rep(NA,nrow(ds)),ds$ptysup7)%in%8] <- mutoha 
s$psup <- factor(s$psup, levels=c(allps,mutoha))
table(s$psup, s$year, useNA="always")

### Party Leaning (Leaning Only)
s$plean <- ifelse(c(ds$ptylean5, ds$ptylean7)%in%1, jimin, 
                  ifelse(c(ds$ptylean5, ds$ptylean7)%in%2, shinshin, 
                         ifelse(c(ds$ptylean5, rep(NA,nrow(ds)))%in%3, shakai, 
                                ifelse(c(ds$ptylean5, rep(NA,nrow(ds)))%in%4, sakigake, 
                                       ifelse(c(ds$ptylean5, ds$ptylean7)%in%5, kyosan, 
                                              ifelse(c(ds$ptylean5, rep(NA,nrow(ds)))%in%c(6), sonota, 
                                                     ifelse(c(ds$ptylean5, rep(NA,nrow(ds)))%in%7, mutoha, 
                                                            NA)))))))
s$plean[c(rep(NA,nrow(ds)),ds$ptylean7)%in%3] <- minshu 
s$plean[c(rep(NA,nrow(ds)),ds$ptylean7)%in%4] <- shamin 
s$plean[c(rep(NA,nrow(ds)),ds$ptylean7)%in%6] <- sakigake 
s$plean[c(rep(NA,nrow(ds)),ds$ptylean7)%in%7] <- sonota
s$plean[c(rep(NA,nrow(ds)),ds$ptylean7)%in%8] <- mutoha 
s$plean <- factor(s$plean, levels=c(allps,mutoha))
table(s$plean, s$year, useNA="always")

### Party Support plus Leaning
s$psuplean <- s$psup
# Replace with plean if psup==mutoha
s$psuplean[!s$psup%in%c(allps)] <- 
  s$plean[!s$psup%in%c(allps)]
# Define as mutoha if psup==mutoha and plean is NA
s$psuplean[which(s$psup==mutoha & is.na(s$plean))] <- mutoha
table(s$psuplean, s$year, useNA="always")

### Party Support Strength
s$pstr <- NA
s$pstr[s$psuplean%in%mutoha] <- 0
s$pstr[s$plean%in%c(allps)] <- 1
s$pstr[s$psup%in%c(allps)] <- 2
s$pstr[s$pstr%in%2 & c(ds$streng5,ds$streng7)%in%1] <- 3
table(s$pstr, s$year, useNA="always")

## Participation intention # 1 & 2 intend to vote
table(ds$govote2, useNA="always") # Vote Intention (96)
s$voteint <- ifelse(c(rep(NA,nrow(ds)),ds$govote2)%in%1,2,
                    ifelse(c(rep(NA,nrow(ds)),ds$govote2)%in%2,1,
                           ifelse(c(rep(NA,nrow(ds)),ds$govote2)%in%c(3,4,5),0,NA)))
table(s$voteint, s$year, useNA="always")

## Participation 
table(ds$votesan, useNA="always") # 1 = Voted, 2=Not
table(ds$elvote96, useNA="always") # 1-9 Voted 10 Abstained, 11-12 DK/NA
s$voted <- NA
s$voted[c(ds$votesan,rep(NA,nrow(ds)))%in%1] <- 1
s$voted[c(ds$votesan,rep(NA,nrow(ds)))%in%2] <- 0
s$voted[c(rep(NA,nrow(ds)),ds$elvote96)%in%c(1:9)] <- 1
s$voted[c(rep(NA,nrow(ds)),ds$elvote96)%in%10] <- 0
table(s$voted, s$year, useNA="always") 

## Vote Decision Intention

### Single/Multiple Member District
dspvoteintMD96 <- ifelse(ds$ptycmit2%in%c(1:6),ds$ptycmit2,
                         ifelse(ds$pty6153%in%c(1:6),ds$pty6153,NA))
dspvoteintMD96[ds$ptycmit2%in%8] <- 8
dspvoteintMD96[ds$pty6153%in%c(7,8,9)] <- 7
dspvoteintMD96[ds$pty6153%in%11] <- 8
dspvoteintMD96[s$voteint[s$year==1996]==0] <- 9
dspvoteintMD96[ds$govote2%in%5|ds$votcmit2%in%c(3,4)|ds$ptycmit2%in%9|ds$can6153%in%9] <- 10
table(dspvoteintMD96)
s$pvoteintMD <- NA
s$pvoteintMD[c(rep(NA, nrow(ds)), dspvoteintMD96)%in%1] <- jimin 
s$pvoteintMD[c(rep(NA, nrow(ds)), dspvoteintMD96)%in%2] <- shinshin 
s$pvoteintMD[c(rep(NA, nrow(ds)), dspvoteintMD96)%in%5] <- kyosan 
# s$pvoteintMD[c(rep(NA, nrow(ds)), rep(NA,nrow(ds)))%in%3] <- shakai 
# s$pvoteintMD[c(rep(NA, nrow(ds)), rep(NA,nrow(ds)))%in%4] <- sakigake 
# s$pvoteintMD[c(rep(NA, nrow(ds)), rep(NA,nrow(ds)))%in%6] <- sonota 
# s$pvoteintMD[c(rep(NA, nrow(ds)), rep(NA,nrow(ds)))%in%7] <- mushozoku 
s$pvoteintMD[c(rep(NA,nrow(ds)),dspvoteintMD96)%in%3] <- minshu 
s$pvoteintMD[c(rep(NA,nrow(ds)),dspvoteintMD96)%in%4] <- shamin 
s$pvoteintMD[c(rep(NA,nrow(ds)),dspvoteintMD96)%in%6] <- sakigake 
s$pvoteintMD[c(rep(NA,nrow(ds)),dspvoteintMD96)%in%7] <- sonota
s$pvoteintMD[c(rep(NA,nrow(ds)),dspvoteintMD96)%in%8] <- mushozoku 
s$pvoteintMD[c(rep(NA,nrow(ds)),dspvoteintMD96)%in%9] <- kiken 
s$pvoteintMD[c(rep(NA,nrow(ds)),dspvoteintMD96)%in%10] <- mikettei 
s$pvoteintMD <- factor(s$pvoteintMD, levels=c(allps,mushozoku,kiken,mikettei))
table(s$pvoteintMD, s$year, useNA="always")

### Proportional Representation
s$pvoteintPR <- NA
s$pvoteintPR[c(rep(NA, nrow(ds)), ds$ptywhich)%in%1] <- jimin 
s$pvoteintPR[c(rep(NA, nrow(ds)), ds$ptywhich)%in%2] <- shinshin 
s$pvoteintPR[c(rep(NA, nrow(ds)), ds$ptywhich)%in%5] <- kyosan 
# s$pvoteintPR[c(rep(NA, nrow(ds)), rep(NA,nrow(ds)))%in%3] <- shakai 
# s$pvoteintPR[c(rep(NA, nrow(ds)), rep(NA,nrow(ds)))%in%4] <- sakigake 
# s$pvoteintPR[c(rep(NA, nrow(ds)), rep(NA,nrow(ds)))%in%6] <- sonota 
s$pvoteintPR[c(rep(NA,nrow(ds)),ds$ptywhich)%in%3] <- minshu 
s$pvoteintPR[c(rep(NA,nrow(ds)),ds$ptywhich)%in%4] <- shamin 
s$pvoteintPR[c(rep(NA,nrow(ds)),ds$ptywhich)%in%6] <- sakigake 
s$pvoteintPR[c(rep(NA,nrow(ds)),ds$ptywhich)%in%7] <- sonota
s$pvoteintPR[c(rep(NA,nrow(ds)),ds$ptywhich)%in%c(8,9)] <- mikettei 
s$pvoteintPR[s$voteint%in%0] <- kiken 
s$pvoteintPR[c(rep(NA,nrow(ds)),ds$govote2)%in%5] <- mikettei 
s$pvoteintPR <- factor(s$pvoteintPR, levels=c(allps,kiken,mikettei))
table(s$pvoteintPR, s$year, useNA="always")

## Vote Decision (Post Election)

### Single/Multiple Member District
s$pvotedMD <- NA
s$pvotedMD[c(ds$elvote95, ds$elvote96)%in%1] <- jimin 
s$pvotedMD[c(ds$elvote95, ds$elvote96)%in%2] <- shinshin 
s$pvotedMD[c(ds$elvote95, ds$elvote96)%in%5] <- kyosan 
s$pvotedMD[c(ds$elvote95, rep(NA,nrow(ds)))%in%3] <- shakai
s$pvotedMD[c(ds$elvote95, rep(NA,nrow(ds)))%in%4] <- sakigake
s$pvotedMD[c(ds$elvote95, rep(NA,nrow(ds)))%in%6] <- sonota
s$pvotedMD[c(ds$elvote95, rep(NA,nrow(ds)))%in%7] <- mushozoku
s$pvotedMD[c(rep(NA,nrow(ds)),ds$elvote96)%in%3] <- minshu 
s$pvotedMD[c(rep(NA,nrow(ds)),ds$elvote96)%in%4] <- shamin 
s$pvotedMD[c(rep(NA,nrow(ds)),ds$elvote96)%in%6] <- sakigake 
s$pvotedMD[c(rep(NA,nrow(ds)),ds$elvote96)%in%7] <- sonota
s$pvotedMD[c(rep(NA,nrow(ds)),ds$elvote96)%in%8] <- mushozoku 
s$pvotedMD[s$voted%in%0] <- kiken
s$pvotedMD <- factor(s$pvotedMD, levels=c(allps,mushozoku,kiken))
table(s$pvotedMD, s$year, useNA="always")

### Proportional Representation
s$pvotedPR <- NA
s$pvotedPR[c(ds$prvote95, ds$prvote96)%in%1] <- jimin 
s$pvotedPR[c(ds$prvote95, ds$prvote96)%in%2] <- shinshin 
s$pvotedPR[c(ds$prvote95, ds$prvote96)%in%5] <- kyosan 
s$pvotedPR[c(ds$prvote95, rep(NA,nrow(ds)))%in%3] <- shakai
s$pvotedPR[c(ds$prvote95, rep(NA,nrow(ds)))%in%4] <- sakigake
s$pvotedPR[c(ds$prvote95, rep(NA,nrow(ds)))%in%c(6,7,8,9)] <- sonota
s$pvotedPR[c(rep(NA,nrow(ds)),ds$prvote96)%in%3] <- minshu 
s$pvotedPR[c(rep(NA,nrow(ds)),ds$prvote96)%in%4] <- shamin 
s$pvotedPR[c(rep(NA,nrow(ds)),ds$prvote96)%in%6] <- sakigake 
s$pvotedPR[c(rep(NA,nrow(ds)),ds$prvote96)%in%7] <- sonota
s$pvotedPR[s$voted%in%0] <- kiken
s$pvotedPR <- factor(s$pvotedPR, levels=c(allps,kiken))
table(s$pvotedPR, s$year, useNA="always")

## Political Interest
s$polint <- ifelse(c(ds$polint2,ds$polint3)>=5,NA,
                   (4 - c(ds$polint2,ds$polint3))/3)
table(s$polint, s$year, useNA="always")

## Knowledge (Not assigned)
s$kn <- NA

## Years of Residence 1:<=3yrs;2:4-9yrs;3:10-14yrs;4:>=15yrs;5:Since born
table(ds$resyr2, useNA="always") # Year of Residence
table(ds$resyr3, useNA="always") # Year of Residence
s$residyr <- ifelse(c(ds$resyr2,ds$resyr3)>5,NA,
                    (c(ds$resyr2,ds$resyr3)-1)/4)
table(s$residyr, s$year, useNA="always")
table(s$residyr[s$answered==1], s$year[s$answered==1], useNA="always")

## Education 1:<=JHS;2:HS;3:Junior College/Higher Techinical;4:Univ/Grad School
table(ds$educ2, useNA="always") # Education
table(ds$educ3, useNA="always") # Education
s$edu <- ifelse(c(ds$educ2,ds$educ3)==5,NA,
                (c(ds$educ2,ds$educ3)-1)/3)
table(s$edu, s$year, useNA="always")
table(s$edu[s$answered==1], s$year[s$answered==1], useNA="always")

## Occupation 
## 1:Employed;2:Self-employed;3:Family-business;4:Student;5:Housewife;6:Unemployed;7:Other
table(ds$empst2, useNA="always") # Occupation
table(ds$empst3, useNA="always") # Occupation
s$employed <- ifelse(c(ds$empst2,ds$empst3)%in%c(1,2,3),1,
                     ifelse(c(ds$empst2,ds$empst3)%in%c(4,5,6),0,NA))
table(s$employed, s$year, useNA="always")
table(s$employed[s$answered==1], s$year[s$answered==1], useNA="always")

## Type of Home 
## 1:Private Home Owned; 2:COndominium owned; 3:Private Home Rent;
## 4:Private Apartment Rent; 5: Public Apartment Rent; 6:Company Apartment
## 7: Dormitory/Room Rent; 8: Others
table(ds$typres2, useNA="always") # Type of Home
table(ds$typres3, useNA="always") # Type of Home
s$ownhome <- ifelse(c(ds$typres2,ds$typres3)%in%c(1,2),1,
                    ifelse(c(ds$typres2,ds$typres3)%in%c(3,4,5,6,7),0,NA))
table(s$ownhome, s$year, useNA="always")
table(s$ownhome[s$answered==1], s$year[s$answered==1], useNA="always")
s$privatehome <- ifelse(c(ds$typres2,ds$typres3)%in%c(1,3),1,
                        ifelse(c(ds$typres2,ds$typres3)%in%c(2,4,5,6,7),0,NA))
table(s$privatehome, s$year, useNA="always")
table(s$privatehome[s$answered==1], s$year[s$answered==1], useNA="always")

## Household Income
## 1:<=200;2:200-400;3:400-600;4:600-800;5:800-1000;6:1000-1200;7:1200-1400;8:1400-2000;9>=2000
table(ds$incomf2, useNA="always") # Household Income (12 cat)
table(ds$incomf3, useNA="always") # Household Income (9 cat)
s$income <- ifelse(c(ds$incomf2,ds$incomf3)>=9,NA,
                   (c(ds$incomf2,ds$incomf3)-1)/7)
table(s$income, s$year, useNA="always")
table(s$income[s$answered==1], s$year[s$answered==1], useNA="always")

## Network Variables ##

## Partner 1
table(ds$talk1, useNA="always") # Partner 1 (1=Yes)
table(ds$talk1_2, useNA="always") # Partner 1 (1=Yes)
s$net.1 <- ifelse(c(ds$talk1,ds$talk1_2)%in%1,1,0)
table(s$net.1, s$year, useNA="always")
table(s$net.1[s$answered==1], s$year[s$answered==1], useNA="always")

table(ds$relatn1, useNA="always") # Relationship with P1
table(ds$relat1_2, useNA="always") # Relationship with P1
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
s$netfa.1 <- ifelse(c(ds$relatn1,ds$relat1_2)%in%c(1,2,3),1,0)
s$netwk.1 <- ifelse(c(ds$relatn1,rep(NA,nrow(ds)))%in%6|c(rep(NA,nrow(ds)),ds$relat1_2)%in%4,1,0)
s$netfr.1 <- ifelse(c(ds$relatn1,rep(NA,nrow(ds)))%in%4|c(rep(NA,nrow(ds)),ds$relat1_2)%in%8,1,0)
table(s$netfa.1[s$net.1==1], s$year[s$net.1==1], useNA="always")
table(s$netwk.1[s$net.1==1], s$year[s$net.1==1], useNA="always")
table(s$netfr.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

s$netfem.1 <- NA

s$netage.1 <- NA

s$netclose.1 <- NA

s$netfreq.1 <- NA

table(ds$times1, useNA="always") # Pol. Discussion with P1
table(ds$times1_2, useNA="always") # Pol. Discussion with P1
s$netpoldis.1 <- ifelse(c(ds$times1,ds$times1_2)%in%c(0,5,6),NA,
                        (4 - c(ds$times1,ds$times1_2))/3)
table(s$netpoldis.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

s$netwatchnews.1 <- NA

s$netknow.1 <- NA

table(ds$votesan1, useNA="always") # Expected Vote Choice of P1
table(ds$vote96_1, useNA="always") # Expected Vote Choice of P1
s$netpvote.1 <- NA
s$netpvote.1[c(ds$votesan1, ds$vote96_1)%in%1] <- jimin 
s$netpvote.1[c(ds$votesan1, ds$vote96_1)%in%2] <- shinshin 
s$netpvote.1[c(ds$votesan1, ds$vote96_1)%in%5] <- kyosan 
s$netpvote.1[c(ds$votesan1, rep(NA,nrow(ds)))%in%3] <- shakai
s$netpvote.1[c(ds$votesan1, rep(NA,nrow(ds)))%in%4] <- sakigake
s$netpvote.1[c(ds$votesan1, rep(NA,nrow(ds)))%in%6] <- sonota
s$netpvote.1[c(ds$votesan1, rep(NA,nrow(ds)))%in%7] <- kiken
s$netpvote.1[c(ds$votesan1, rep(NA,nrow(ds)))%in%8] <- shiranai
s$netpvote.1[c(rep(NA,nrow(ds)),ds$vote96_1)%in%3] <- minshu 
s$netpvote.1[c(rep(NA,nrow(ds)),ds$vote96_1)%in%4] <- shamin 
s$netpvote.1[c(rep(NA,nrow(ds)),ds$vote96_1)%in%6] <- sakigake 
s$netpvote.1[c(rep(NA,nrow(ds)),ds$vote96_1)%in%7] <- sonota
s$netpvote.1[c(rep(NA,nrow(ds)),ds$vote96_1)%in%8] <- kiken
s$netpvote.1[c(rep(NA,nrow(ds)),ds$vote96_1)%in%9] <- shiranai
s$netpvote.1 <- factor(s$netpvote.1, levels=c(allps,kiken,shiranai))
table(s$netpvote.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

s$netpmsup.1 <- NA

s$netsim.1 <- NA

s$netstat.1 <- NA

s$netdif.1 <- NA

## Partner 2
table(ds$talk2, useNA="always") # Partner 2 (1=Yes)
table(ds$talk2_2, useNA="always") # Partner 2 (1=Yes)
s$net.2 <- ifelse(c(ds$talk2,ds$talk2_2)%in%1,1,0)
table(s$net.2, s$year, useNA="always")
table(s$net.2[s$answered==1], s$year[s$answered==1], useNA="always")

table(ds$relatn2, useNA="always") # Relationship with P2
table(ds$relat2_2, useNA="always") # Relationship with P2
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
s$netfa.2 <- ifelse(c(ds$relatn2,ds$relat2_2)%in%c(1,2,3),1,0)
s$netwk.2 <- ifelse(c(ds$relatn2,rep(NA,nrow(ds)))%in%6|c(rep(NA,nrow(ds)),ds$relat2_2)%in%4,1,0)
s$netfr.2 <- ifelse(c(ds$relatn2,rep(NA,nrow(ds)))%in%4|c(rep(NA,nrow(ds)),ds$relat2_2)%in%8,1,0)
table(s$netfa.2[s$net.2==1], s$year[s$net.2==1], useNA="always")
table(s$netwk.2[s$net.2==1], s$year[s$net.2==1], useNA="always")
table(s$netfr.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

s$netfem.2 <- NA

s$netage.2 <- NA

s$netclose.2 <- NA

s$netfreq.2 <- NA

table(ds$times2, useNA="always") # Pol. Discussion with P2
table(ds$times2_2, useNA="always") # Pol. Discussion with P2
s$netpoldis.2 <- ifelse(c(ds$times2,ds$times2_2)%in%c(0,5,6),NA,
                        (4 - c(ds$times2,ds$times2_2))/3)
table(s$netpoldis.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

s$netwatchnews.2 <- NA

s$netknow.2 <- NA

table(ds$votesan2, useNA="always") # Expected Vote Choice of P2
table(ds$vote96_2, useNA="always") # Expected Vote Choice of P2
s$netpvote.2 <- NA
s$netpvote.2[c(ds$votesan2, ds$vote96_2)%in%1] <- jimin 
s$netpvote.2[c(ds$votesan2, ds$vote96_2)%in%2] <- shinshin 
s$netpvote.2[c(ds$votesan2, ds$vote96_2)%in%5] <- kyosan 
s$netpvote.2[c(ds$votesan2, rep(NA,nrow(ds)))%in%3] <- shakai
s$netpvote.2[c(ds$votesan2, rep(NA,nrow(ds)))%in%4] <- sakigake
s$netpvote.2[c(ds$votesan2, rep(NA,nrow(ds)))%in%6] <- sonota
s$netpvote.2[c(ds$votesan2, rep(NA,nrow(ds)))%in%7] <- kiken
s$netpvote.2[c(ds$votesan2, rep(NA,nrow(ds)))%in%8] <- shiranai
s$netpvote.2[c(rep(NA,nrow(ds)),ds$vote96_2)%in%3] <- minshu 
s$netpvote.2[c(rep(NA,nrow(ds)),ds$vote96_2)%in%4] <- shamin 
s$netpvote.2[c(rep(NA,nrow(ds)),ds$vote96_2)%in%6] <- sakigake 
s$netpvote.2[c(rep(NA,nrow(ds)),ds$vote96_2)%in%7] <- sonota
s$netpvote.2[c(rep(NA,nrow(ds)),ds$vote96_2)%in%8] <- kiken
s$netpvote.2[c(rep(NA,nrow(ds)),ds$vote96_2)%in%9] <- shiranai
s$netpvote.2 <- factor(s$netpvote.2, levels=c(allps,kiken,shiranai))
table(s$netpvote.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

s$netpmsup.2 <- NA

s$netsim.2 <- NA

s$netstat.2 <- NA

s$netdif.2 <- NA

## Partner 3
table(ds$talk3, useNA="always") # Partner 3 (1=Yes)
table(ds$talk3_2, useNA="always") # Partner 3 (1=Yes)
s$net.3 <- ifelse(c(ds$talk3,ds$talk3_2)%in%1,1,0)
table(s$net.3, s$year, useNA="always")
table(s$net.3[s$answered==1], s$year[s$answered==1], useNA="always")

table(ds$relatn3, useNA="always") # Relationship with P3
table(ds$relat3_2, useNA="always") # Relationship with P3
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
s$netfa.3 <- ifelse(c(ds$relatn3,ds$relat3_2)%in%c(1,2,3),1,0)
s$netwk.3 <- ifelse(c(ds$relatn3,rep(NA,nrow(ds)))%in%6|c(rep(NA,nrow(ds)),ds$relat3_2)%in%4,1,0)
s$netfr.3 <- ifelse(c(ds$relatn3,rep(NA,nrow(ds)))%in%4|c(rep(NA,nrow(ds)),ds$relat3_2)%in%8,1,0)
table(s$netfa.3[s$net.3==1], s$year[s$net.3==1], useNA="always")
table(s$netwk.3[s$net.3==1], s$year[s$net.3==1], useNA="always")
table(s$netfr.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

s$netfem.3 <- NA

s$netage.3 <- NA

s$netclose.3 <- NA

s$netfreq.3 <- NA

table(ds$times3, useNA="always") # Pol. Discussion with P3
table(ds$times3_2, useNA="always") # Pol. Discussion with P3
s$netpoldis.3 <- ifelse(c(ds$times3,ds$times3_2)%in%c(0,5,6),NA,
                        (4 - c(ds$times3,ds$times3_2))/3)
table(s$netpoldis.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

s$netwatchnews.3 <- NA

s$netknow.3 <- NA

table(ds$votesan3, useNA="always") # Expected Vote Choice of P3
table(ds$vote96_3, useNA="always") # Expected Vote Choice of P3
s$netpvote.3 <- NA
s$netpvote.3[c(ds$votesan3, ds$vote96_3)%in%1] <- jimin 
s$netpvote.3[c(ds$votesan3, ds$vote96_3)%in%2] <- shinshin 
s$netpvote.3[c(ds$votesan3, ds$vote96_3)%in%5] <- kyosan 
s$netpvote.3[c(ds$votesan3, rep(NA,nrow(ds)))%in%3] <- shakai
s$netpvote.3[c(ds$votesan3, rep(NA,nrow(ds)))%in%4] <- sakigake
s$netpvote.3[c(ds$votesan3, rep(NA,nrow(ds)))%in%6] <- sonota
s$netpvote.3[c(ds$votesan3, rep(NA,nrow(ds)))%in%7] <- kiken
s$netpvote.3[c(ds$votesan3, rep(NA,nrow(ds)))%in%8] <- shiranai
s$netpvote.3[c(rep(NA,nrow(ds)),ds$vote96_3)%in%3] <- minshu 
s$netpvote.3[c(rep(NA,nrow(ds)),ds$vote96_3)%in%4] <- shamin 
s$netpvote.3[c(rep(NA,nrow(ds)),ds$vote96_3)%in%6] <- sakigake 
s$netpvote.3[c(rep(NA,nrow(ds)),ds$vote96_3)%in%7] <- sonota
s$netpvote.3[c(rep(NA,nrow(ds)),ds$vote96_3)%in%8] <- kiken
s$netpvote.3[c(rep(NA,nrow(ds)),ds$vote96_3)%in%9] <- shiranai
s$netpvote.3 <- factor(s$netpvote.3, levels=c(allps,kiken,shiranai))
table(s$netpvote.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

s$netpmsup.3 <- NA

s$netsim.3 <- NA

s$netstat.3 <- NA

s$netdif.3 <- NA

## Partner 4 (All NA)
s$net.4 <- NA

s$netfa.4 <- NA
s$netwk.4 <- NA
s$netfr.4 <- NA

s$netfem.4 <- NA

s$netage.4 <- NA

s$netclose.4 <- NA

s$netfreq.4 <- NA

s$netpoldis.4 <- NA

s$netwatchnews.4 <- NA

s$netknow.4 <- NA

s$netpvote.4 <- NA

s$netpmsup.4 <- NA

s$netsim.4 <- NA

s$netstat.4 <- NA

s$netdif.4 <- NA

## Acquaintance Between Partners
table(ds$knowthre, useNA="always") # (IF P1-P3 exist) All know each other 
table(ds$know1x2, useNA="always") # (IF P1-P3 exist) P1 and P2 Knows Each Other
table(ds$know1x3, useNA="always") # (IF P1-P3 exist) P1 and P3 Knows Each Other
table(ds$know2x3, useNA="always") # (IF P1-P3 exist) P2 and P3 Knows Each Other
table(ds$knowdk, useNA="always") # (IF P1-P3 exist) DK
table(ds$knowna, useNA="always") # (IF P1-P3 exist) NA

## Network Summary Variables ##

## Number of People in Network
s$sumnet <- s$net.1 + s$net.2 + s$net.3 #+ s$net.4
table(s$sumnet, s$year, useNA="always")

## Melting Data ##

library(dplyr)
library(tidyr)

# Leviathan (SPSS)

snet <- gather(s, Var, Val, net.1:netdif.4) %>% 
  separate(Var, into = c("Var2", "key")) %>% 
  mutate(key = as.numeric(key)) %>%
  spread(Var2, Val)

## Drop Non-Existing Cases
snet <- subset(snet, snet$net==1)

## Net Variable
snet$net <- snet$key
table(snet$net, snet$year, useNA="always")

snet$netpvote <- factor(snet$netpvote, levels=c(allps,kiken,shiranai))
table(snet$netpvote, snet$year, useNA="always")

#'
#' ## Saving Data
#'

#+ eval=FALSE
saveRDS(s, "jes2_s.rds")
saveRDS(snet, "jes2_net_s.rds")

#+ eval=FALSE, echo=FALSE
# Exporting HTML File
# In R Studio
# rmarkdown::render('data_jes2_1_recode_v2.R', 'github_document', clean=FALSE)
# tmp <- list.files("./")
# tmp <- tmp[grep("\\.spin\\.R$|\\.spin\\.Rmd$|\\.utf8\\.md$|\\.knit\\.md$|\\.log$|\\.tex$",tmp)]
# for (i in 1:length(tmp)) file.remove(paste0("./",tmp[i]))
