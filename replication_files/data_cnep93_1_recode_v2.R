#' ---
#' title: "CNEP 93 Recode"
#' author: "Gento Kato"
#' date: "April 15, 2021"
#' ---
#' 
#' # Preparation 

## Clean Up Space
rm(list=ls())

## Set Working Directory (Automatically) ##
require(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)); 

## Find Data Directory
datadir <- "0145_zenkoku.sav"

## Import Original Data
require(haven)
dc <- read_sav(datadir, encoding="SHIFT_JIS")
colnames(dc) <- tolower(colnames(dc))

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

#'
#' # Check Relevant Variables
#'

# table(, useNA="always") # City Size (Missing)
table(dc$f1, useNA="always") # Gender 1=Male, 2=Female
table(dc$f3, useNA="always") # Age

table(dc$q16, useNA="always") # Party Support
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=そのような政党はない, 12=DK, 13=NA
table(dc$q16s1, useNA="always") # Party Leaners
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=そのような政党はない, 12=DK, 13=NA
table(dc$q14, useNA="always") # Vote Intention 1=Definitely going, 2=if possible, 3=no, 4=DK, 5=NA
table(dc$q14s1, useNA="always") # Vote Decision Intention by Party 
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=まだ決まっていない, 12=DK, 13=NA
table(dc$q11, useNA="always") # Election Interest 1=A lot, 2=some, 3=Not much, 4=not at all, 5=DK, 6=NA
table(dc$f7, useNA="always") # Year of Residence 1=1yr, 2=2-3, 3=4-5, 4=6-9, 5=10-19, 6=>=20, 99=NA
table(dc$f5, useNA="always") # Education 
# 1=小学校, 2=中学校, 3=高校, 4=専門学校・職業訓練校, 5=短大・高専, 6=大学, 7=大学院
# 8=小学校・尋常小学校, 9=高等小学校, 10=旧制中学・女学校, 11=旧制高専, 12=旧制高校, 13=旧制専門学校・予科, 14=旧制大学
table(dc$f4, useNA="always") # Occupation
# 1=商工業・サービス業, 2=自由業, 3=管理職, 4=専門職・技術職, 5=事務職, 
# 6=販売・サービス職, 7=労務職, 8=パート・アルバイト, 9=主婦, 10=学生・生徒, 11=無職・家事手伝い, 12=上記以外, 13=NA
table(dc$f10, useNA="always") # Type of Home 1=一戸建, 2=店舗・事務所兼住宅, 3=集合住宅, 4=その他
table(dc$f8, useNA="always") # Household Income
# ### (No Post-Election Wave)
# table(, useNA="always") # Voted
# table(, useNA="always") # Vote Decision by Party

## Partner 1
table(dc$q29a, useNA="always") # Partner 1 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(dc$q29as1, useNA="always") # Relationship with P1
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
table(dc$q29as2, useNA="always") # Gender of P1
# 1=Male, 2=Female
table(dc$q29as3, useNA="always") # Age of P1 98=DK, 99=NA
table(dc$q29as4, useNA="always") # Frequency of Meeting/Phone with P1: 1=毎日, 2=週1, 3=月1, 4=もっと少ない, 5=DK, 6=NA
table(dc$q29as5, useNA="always") # Pol. Discussion with P1: 1=いつでも, 2=ときどき, 3=たまに, 4=ほとんどない, 5=DK, 6=NA 
# table(, useNA="always") # Watch/Read News Together with P1
# table(, useNA="always") # Perceived Pol. Knowledge of P1
table(dc$q29as6, useNA="always") # Expected Vote Choice of P1
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=投票しない, 12=DK, 13=NA
# table(, useNA="always") # Expected Koizumi Support of P1
# table(, useNA="always") # Similarity with P1
# table(, useNA="always") # Relative Social Status of P1
# table(, useNA="always") # Difference in Opinions with P1

## Partner 2
table(dc$q29b, useNA="always") # Partner 2 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(dc$q29bs1, useNA="always") # Relationship with P2
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
table(dc$q29bs2, useNA="always") # Gender of P2
# 1=Male, 2=Female
table(dc$q29bs3, useNA="always") # Age of P2 98=DK, 99=NA
table(dc$q29bs4, useNA="always") # Frequency of Meeting/Phone with P2: 1=毎日, 2=週1, 3=月1, 4=もっと少ない, 5=DK, 6=NA
table(dc$q29bs5, useNA="always") # Pol. Discussion with P2: 1=いつでも, 2=ときどき, 3=たまに, 4=ほとんどない, 5=DK, 6=NA 
# table(, useNA="always") # Watch/Read News Together with P2
# table(, useNA="always") # Perceived Pol. Knowledge of P2
table(dc$q29bs6, useNA="always") # Expected Vote Choice of P2
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=投票しない, 12=DK, 13=NA
# table(, useNA="always") # Expected Koizumi Support of P2
# table(, useNA="always") # Similarity with P2
# table(, useNA="always") # Relative Social Status of P2
# table(, useNA="always") # Difference in Opinions with P2

## Partner 3
table(dc$q29c, useNA="always") # Partner 3 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(dc$q29cs1, useNA="always") # Relationship with P3
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
table(dc$q29cs2, useNA="always") # Gender of P3
# 1=Male, 2=Female
table(dc$q29cs3, useNA="always") # Age of P3 98=DK, 99=NA
table(dc$q29cs4, useNA="always") # Frequency of Meeting/Phone with P3: 1=毎日, 2=週1, 3=月1, 4=もっと少ない, 5=DK, 6=NA
table(dc$q29cs5, useNA="always") # Pol. Discussion with P3: 1=いつでも, 2=ときどき, 3=たまに, 4=ほとんどない, 5=DK, 6=NA 
# table(, useNA="always") # Watch/Read News Together with P3
# table(, useNA="always") # Perceived Pol. Knowledge of P3
table(dc$q29cs6, useNA="always") # Expected Vote Choice of P3
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=投票しない, 12=DK, 13=NA
# table(, useNA="always") # Expected Koizumi Support of P3
# table(, useNA="always") # Similarity with P3
# table(, useNA="always") # Relative Social Status of P3
# table(, useNA="always") # Difference in Opinions with P3

## Partner 4
table(dc$q29d, useNA="always") # Partner 4 (1=Yes)
# table(, useNA="always") # Have Spouse (1=Yes)
table(dc$q29ds1, useNA="always") # Relationship with P4
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
table(dc$q29ds2, useNA="always") # Gender of P4
# 1=Male, 2=Female
table(dc$q29ds3, useNA="always") # Age of P4 98=DK, 99=NA
table(dc$q29ds4, useNA="always") # Frequency of Meeting/Phone with P4: 1=毎日, 2=週1, 3=月1, 4=もっと少ない, 5=DK, 6=NA
table(dc$q29ds5, useNA="always") # Pol. Discussion with P4: 1=いつでも, 2=ときどき, 3=たまに, 4=ほとんどない, 5=DK, 6=NA 
# table(, useNA="always") # Watch/Read News Together with P4
# table(, useNA="always") # Perceived Pol. Knowledge of P4
table(dc$q29ds6, useNA="always") # Expected Vote Choice of P4
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=投票しない, 12=DK, 13=NA
# table(, useNA="always") # Expected Koizumi Support of P4
# table(, useNA="always") # Similarity with P4
# table(, useNA="always") # Relative Social Status of P4
# table(, useNA="always") # Difference in Opinions with P4

#'
#' # Create New Data
#' 

# Initiate New Keio Data Set
c <- data.frame(id = dc$id, year = 1993)

## House of Representative Dummy
c$horelec <- 1

## Sampled Year
c$smpyear <- NA

## Fresh/Panel Sample dummies (NAs for invalid cases)
c$panel <- 0
c$fresh <- 1

## Unit Response Dummies
c$answered <- 1

## City Size 
c$citysize_big3 <- NA
c$citysize_bigelse <- NA
c$citysize_big <- NA
c$citysize_mid <- NA
c$citysize_sml <- NA
c$citysize_not <- NA
c$citysize <- NA

## Gender (Female)
table(dc$f1, useNA="always") # Gender 1=Male, 2=Female
c$fem <- dc$f1 - 1
table(c$fem)

## Age (To Become in the Given Year)
table(dc$f3, useNA="always") # Age
c$age <- dc$f3
hist(c$age)

## Party Support
table(dc$q16, useNA="always") # Party Support
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=そのような政党はない, 12=DK, 13=NA
table(dc$q16s1, useNA="always") # Party Leaners
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=そのような政党はない, 12=DK, 13=NA

c$pmsup <- NA

### Supporting Party
c$psup <- ifelse(dc$q16%in%1, jimin, #"自民", 
                 ifelse(dc$q16%in%2, shakai, #"社会", 
                        ifelse(dc$q16%in%3, komei, #"公明", 
                               ifelse(dc$q16%in%4, shinsei, #"新生", 
                                      ifelse(dc$q16%in%5, kyosan, #"共産", 
                                             ifelse(dc$q16%in%6, minsha, #"民社",
                                                    ifelse(dc$q16%in%7, sakigake, #"さきがけ",
                                                           ifelse(dc$q16%in%8, shaminren, #"社民連", 
                                                                  ifelse(dc$q16%in%9, nihonshin, #"日本新党",
                                                                         ifelse(dc$q16%in%10, sonota, #"その他", 
                                                                                ifelse(dc$q16%in%11, mutoha, 
                                                                                       NA)))))))))))
c$psup <- factor(c$psup, levels=c(allps,mutoha))
table(c$psup, c$year, useNA="always")

### Party Leaning (Leaning Only)
c$plean <- ifelse(dc$q16s1%in%1, jimin, #"自民", 
                  ifelse(dc$q16s1%in%2, shakai, #"社会", 
                         ifelse(dc$q16s1%in%3, komei, #"公明", 
                                ifelse(dc$q16s1%in%4, shinsei, #"新生", 
                                       ifelse(dc$q16s1%in%5, kyosan, #"共産", 
                                              ifelse(dc$q16s1%in%6, minsha, #"民社",
                                                     ifelse(dc$q16s1%in%7, sakigake, #"さきがけ",
                                                            ifelse(dc$q16s1%in%8, shaminren, #"社民連", 
                                                                   ifelse(dc$q16s1%in%9, nihonshin, #"日本新党",
                                                                          ifelse(dc$q16s1%in%10, sonota, #"その他", 
                                                                                 ifelse(dc$q16s1%in%11, mutoha, 
                                                                                        NA)))))))))))
c$plean <- factor(c$plean, levels=c(allps,mutoha))
table(c$plean, c$year, useNA="always")

### Party Support plus Leaning
table(c$psup, c$plean, useNA="always")
c$psuplean <- c$psup
# Replace with plean if psup==mutoha
c$psuplean[!c$psup%in%c(allps)] <- 
  c$plean[!c$psup%in%c(allps)]
# Define as mutoha if psup==mutoha and plean is NA
c$psuplean[which(c$psup==mutoha & is.na(c$plean))] <- mutoha
table(c$psuplean, c$year, useNA="always")

### Party Support Strength
c$pstr <- NA
c$pstr[c$psuplean%in%mutoha] <- 0
c$pstr[c$plean%in%allps] <- 1
c$pstr[c$psup%in%allps] <- 2.5
table(c$pstr, c$year, useNA="always")

## Participation intention 
table(dc$q14, useNA="always") 
# Vote Intention 1=Definitely going, 2=if possible, 3=no, 4=DK, 5=NA
c$voteint <- ifelse(dc$q14%in%1,2,
                    ifelse(dc$q14%in%2,1,
                           ifelse(dc$q14%in%c(3,4),0,NA)))
table(c$voteint, c$year, useNA="always")

## Participation
# table(, useNA="always") # Voted
c$voted <- NA
# table(c$voted, useNA="always")

## Vote Decision Intention
table(dc$q14s1, useNA="always") # Vote Decision Intention by Party 
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=まだ決まっていない, 12=DK, 13=NA

### Single/Multiple Member District
c$pvoteintMD <- ifelse(dc$q14s1%in%1, jimin, #"自民", 
                       ifelse(dc$q14s1%in%2, shakai, #"社会", 
                              ifelse(dc$q14s1%in%3, komei, #"公明", 
                                     ifelse(dc$q14s1%in%4, shinsei, #"新生", 
                                            ifelse(dc$q14s1%in%5, kyosan, #"共産", 
                                                   ifelse(dc$q14s1%in%6, minsha, #"民社",
                                                          ifelse(dc$q14s1%in%7, sakigake, #"さきがけ",
                                                                 ifelse(dc$q14s1%in%8, shaminren, #"社民連", 
                                                                        ifelse(dc$q14s1%in%9, nihonshin, #"日本新党",
                                                                               ifelse(dc$q14s1%in%10, sonota, #"その他", 
                                                                                      ifelse(dc$q14s1%in%c(11,12), mikettei, 
                                                                                             NA)))))))))))
c$pvoteintMD[c$voteint%in%0] <- kiken
c$pvoteintMD <- factor(c$pvoteintMD, levels=c(allps,mushozoku,kiken,mikettei))
table(c$pvoteintMD, c$year, useNA="always")

### Proportional Representation
c$pvoteintPR <- NA
c$pvoteintPR <- factor(c$pvoteintPR, levels=c(allps,kiken,mikettei))

## Vote Decision (Post Election)

### Single/Multiple Member District
c$pvotedMD <- NA
c$pvotedMD <- factor(c$pvotedMD, levels=c(allps,mushozoku,kiken))

### Proportional Representation
c$pvotedPR <- NA
c$pvotedPR <- factor(c$pvotedPR, levels=c(allps,kiken))

## Political Interest (Election Interest)
table(dc$q11, useNA="always") # Election Interest 1=A lot, 2=some, 3=Not much, 4=not at all, 5=DK, 6=NA
c$polint <- ifelse(dc$q11>=5,NA, (4 - dc$q11)/3)
table(c$polint, c$year, useNA="always")

## Knowledge (Will be assigned)
c$kn <- NA

## Years of Residence 1:<=3yrs;2:4-9yrs;3:10-14yrs;4:>=15yrs;5:Since born
table(dc$f7, useNA="always") # Year of Residence 1=1yr, 2=2-3, 3=4-5, 4=6-9, 5=10-19, 6=>=20, 99=NA
c$residyr <- ifelse(dc$f7==99,NA,
                    ifelse(dc$f7<=3,0,
                           ifelse(dc$f7<=9,0.25,
                                  ifelse(dc$f7<=14, 0.5,
                                         ifelse(dc$f7<=24, 0.75, 1)))))
table(c$residyr, c$year, useNA="always")

## Education 1:<=JHS;2:HS;3:Junior College/Higher Techinical;4:Univ/Grad School
table(dc$f5, useNA="always") # Education 
# 1=小学校, 2=中学校, 3=高校, 4=専門学校・職業訓練校, 5=短大・高専, 6=大学, 7=大学院
# 8=小学校・尋常小学校, 9=高等小学校, 10=旧制中学・女学校, 11=旧制高専, 12=旧制高校, 13=旧制専門学校・予科, 14=旧制大学
c$edu <- ifelse(dc$f5==15,NA,
                ifelse(dc$f5%in%c(1,2,8,9), 0, 
                       ifelse(dc$f5%in%c(3,10), 1/3, 
                              ifelse(dc$f5%in%c(4,5,11,12,13), 2/3, 
                                     ifelse(dc$f5%in%c(6,7,14), 1, NA)))))
table(c$edu, c$year, useNA="always")

## Occupation 
## 1:Employed;2:Self-employed;3:Family-business;4:Student;5:Housewife;6:Unemployed;7:Other
table(dc$f4, useNA="always") # Occupation
# 1=商工業・サービス業, 2=自由業, 3=管理職, 4=専門職・技術職, 5=事務職, 
# 6=販売・サービス職, 7=労務職, 8=パート・アルバイト, 9=主婦, 10=学生・生徒, 11=無職・家事手伝い, 12=上記以外, 13=NA
c$employed <- ifelse(dc$f4%in%c(1,2,3,4,5,6,7,8,12),1,
                     ifelse(dc$f4%in%c(9,10,11),0,NA))
table(c$employed, c$year, useNA="always")

## Type of Home 
table(dc$f10, useNA="always") # Type of Home 1=一戸建, 2=店舗・事務所兼住宅, 3=集合住宅, 4=その他
c$ownhome <- NA
c$privatehome <- ifelse(dc$f10%in%c(1,2), 1, ifelse(dc$f10%in%c(3,4),0,NA))
table(c$privatehome, c$year, useNA="always")

## Household Income
table(dc$f8, useNA="always") # Household Income 13=DK, 14=NA
c$income <- ifelse(dc$f8>=13,NA, (dc$f8-1)/11)
table(c$income, c$year, useNA="always")

## Network Variables ##

## Partner 1
table(dc$q29a, useNA="always") # Partner 1 (1=Yes)
c$net.1 <- ifelse(as.numeric(dc$q29a)%in%1,1,0)
table(c$net.1, c$year, useNA="always")

# table(, useNA="always") # Have Spouse (1=Yes)

table(dc$q29as1, useNA="always") # Relationship with P1
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 6=other group, 7=neighbor, 8=friend, 9=other
c$netfa.1 <- ifelse(dc$q29as1%in%c(1,2,3),1,0)
c$netwk.1 <- ifelse(dc$q29as1%in%4,1,0)
c$netfr.1 <- ifelse(dc$q29as1%in%8,1,0)
table(c$netfa.1[c$net.1==1], c$year[c$net.1==1], useNA="always")
table(c$netwk.1[c$net.1==1], c$year[c$net.1==1], useNA="always")
table(c$netfr.1[c$net.1==1], c$year[c$net.1==1], useNA="always")

table(dc$q29as2, useNA="always") # Gender of P1
# 1=Male, 2=Female
c$netfem.1 <- ifelse(dc$q29as2%in%2, 1, ifelse(dc$q29as2%in%1,0,NA))
table(c$netfem.1[c$net.1==1], c$year[c$net.1==1], useNA="always")

table(dc$q29as3, useNA="always") # Age of P1 98=DK, 99=NA
c$netage.1 <- ifelse(dc$q29as3%in%c(98,99), NA, dc$q29as3)
table(c$netage.1[c$net.1==1], c$year[c$net.1==1], useNA="always")

#table(, useNA="always") # Closeness of P1
c$netclose.1 <- NA

table(dc$q29as4, useNA="always") # Frequency of Meeting/Phone with P1: 1=毎日, 2=週1, 3=月1, 4=もっと少ない, 5=DK, 6=NA
c$netfreq.1 <- ifelse(dc$q29as4%in%c(5,6),NA,(4-dc$q29as4)/3)
table(c$netfreq.1[c$net.1==1], c$year[c$net.1==1], useNA="always")

table(dc$q29as5, useNA="always") # Pol. Discussion with P1: 1=いつでも, 2=ときどき, 3=たまに, 4=ほとんどない, 5=DK, 6=NA 
c$netpoldis.1 <- ifelse(dc$q29as5%in%c(5,6),NA,(4 - dc$q29as5)/3)
table(c$netpoldis.1[c$net.1==1], c$year[c$net.1==1], useNA="always")

# table(, useNA="always") # Watch/Read News Together with P1
c$netwatchnews.1 <- NA

# table(, useNA="always") # Perceived Pol. Knowledge of P1
c$netknow.1 <- NA

table(dc$q29as6, useNA="always") # Expected Vote Choice of P1
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=投票しない, 12=DK, 13=NA
c$netpvote.1 <- ifelse(dc$q29as6%in%1, jimin, #"自民", 
                       ifelse(dc$q29as6%in%2, shakai, #"社会", 
                              ifelse(dc$q29as6%in%3, komei, #"公明", 
                                     ifelse(dc$q29as6%in%4, shinsei, #"新生", 
                                            ifelse(dc$q29as6%in%5, kyosan, #"共産", 
                                                   ifelse(dc$q29as6%in%6, minsha, #"民社",
                                                          ifelse(dc$q29as6%in%7, sakigake, #"さきがけ",
                                                                 ifelse(dc$q29as6%in%8, shaminren, #"社民連", 
                                                                        ifelse(dc$q29as6%in%9, nihonshin, #"日本新党",
                                                                               ifelse(dc$q29as6%in%10, sonota, #"その他", 
                                                                                      ifelse(dc$q29as6%in%11, kiken, 
                                                                                             ifelse(dc$q29as6%in%12, shiranai, 
                                                                                                    NA))))))))))))
c$netpvote.1 <- factor(c$netpvote.1, levels=c(allps,kiken,shiranai))
table(c$netpvote.1, c$year, useNA="always")

# table(, useNA="always") # Expected Koizumi Support of P1
c$netpmsup.1 <- NA

# table(, useNA="always") # Similarity with P1
c$netsim.1 <- NA

# table(, useNA="always") # Relative Social Status of P1
c$netstat.1 <- NA

# table(, useNA="always") # Difference in Opinions with P1
c$netdif.1 <- NA

## Partner 2
table(dc$q29b, useNA="always") # Partner 2 (1=Yes)
c$net.2 <- ifelse(as.numeric(dc$q29b)%in%1,1,0)
table(c$net.2, c$year, useNA="always")
table(c$net.2[c$answered==1], c$year[c$answered==1], useNA="always")

# table(, useNA="always") # Have Spouse (1=Yes)

table(dc$q29bs1, useNA="always") # Relationship with P2
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 6=other group, 7=neighbor, 8=friend, 9=other
c$netfa.2 <- ifelse(dc$q29bs1%in%c(1,2,3),1,0)
c$netwk.2 <- ifelse(dc$q29bs1%in%4,1,0)
c$netfr.2 <- ifelse(dc$q29bs1%in%8,1,0)
table(c$netfa.2[c$net.2==1], c$year[c$net.2==1], useNA="always")
table(c$netwk.2[c$net.2==1], c$year[c$net.2==1], useNA="always")
table(c$netfr.2[c$net.2==1], c$year[c$net.2==1], useNA="always")

table(dc$q29bs2, useNA="always") # Gender of P2
# 1=Male, 2=Female
c$netfem.2 <- ifelse(dc$q29bs2%in%2, 1, ifelse(dc$q29bs2%in%1,0,NA))
table(c$netfem.2[c$net.2==1], c$year[c$net.2==1], useNA="always")

table(dc$q29bs3, useNA="always") # Age of P2 98=DK, 99=NA
c$netage.2 <- ifelse(dc$q29bs3%in%c(98,99), NA, dc$q29bs3)
table(c$netage.2[c$net.2==1], c$year[c$net.2==1], useNA="always")

#table(, useNA="always") # Closeness of P2
c$netclose.2 <- NA

table(dc$q29bs4, useNA="always") # Frequency of Meeting/Phone with P2: 1=毎日, 2=週1, 3=月1, 4=もっと少ない, 5=DK, 6=NA
c$netfreq.2 <- ifelse(dc$q29bs4%in%c(5,6),NA,(4-dc$q29bs4)/3)
table(c$netfreq.2[c$net.2==1], c$year[c$net.2==1], useNA="always")

table(dc$q29bs5, useNA="always") # Pol. Discussion with P2: 1=いつでも, 2=ときどき, 3=たまに, 4=ほとんどない, 5=DK, 6=NA 
c$netpoldis.2 <- ifelse(dc$q29bs5%in%c(5,6),NA,(4 - dc$q29bs5)/3)
table(c$netpoldis.2[c$net.2==1], c$year[c$net.2==1], useNA="always")

# table(, useNA="always") # Watch/Read News Together with P2
c$netwatchnews.2 <- NA

# table(, useNA="always") # Perceived Pol. Knowledge of P2
c$netknow.2 <- NA

table(dc$q29bs6, useNA="always") # Expected Vote Choice of P2
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=投票しない, 12=DK, 13=NA
c$netpvote.2 <- ifelse(dc$q29bs6%in%1, jimin, #"自民", 
                       ifelse(dc$q29bs6%in%2, shakai, #"社会", 
                              ifelse(dc$q29bs6%in%3, komei, #"公明", 
                                     ifelse(dc$q29bs6%in%4, shinsei, #"新生", 
                                            ifelse(dc$q29bs6%in%5, kyosan, #"共産", 
                                                   ifelse(dc$q29bs6%in%6, minsha, #"民社",
                                                          ifelse(dc$q29bs6%in%7, sakigake, #"さきがけ",
                                                                 ifelse(dc$q29bs6%in%8, shaminren, #"社民連", 
                                                                        ifelse(dc$q29bs6%in%9, nihonshin, #"日本新党",
                                                                               ifelse(dc$q29bs6%in%10, sonota, #"その他", 
                                                                                      ifelse(dc$q29bs6%in%11, kiken, 
                                                                                             ifelse(dc$q29bs6%in%12, shiranai, 
                                                                                                    NA))))))))))))
c$netpvote.2 <- factor(c$netpvote.2, levels=c(allps,kiken,shiranai))
table(c$netpvote.2, c$year, useNA="always")

# table(, useNA="always") # Expected Koizumi Support of P2
c$netpmsup.2 <- NA

# table(, useNA="always") # Similarity with P2
c$netsim.2 <- NA

# table(, useNA="always") # Relative Social Status of P2
c$netstat.2 <- NA

# table(, useNA="always") # Difference in Opinions with P2
c$netdif.2 <- NA

## Partner 3
table(dc$q29c, useNA="always") # Partner 3 (1=Yes)
c$net.3 <- ifelse(as.numeric(dc$q29c)%in%1,1,0)
table(c$net.3, c$year, useNA="always")
table(c$net.3[c$answered==1], c$year[c$answered==1], useNA="always")

# table(, useNA="always") # Have Spouse (1=Yes)

table(dc$q29cs1, useNA="always") # Relationship with P3
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 6=other group, 7=neighbor, 8=friend, 9=other
c$netfa.3 <- ifelse(dc$q29cs1%in%c(1,2,3),1,0)
c$netwk.3 <- ifelse(dc$q29cs1%in%4,1,0)
c$netfr.3 <- ifelse(dc$q29cs1%in%8,1,0)
table(c$netfa.3[c$net.3==1], c$year[c$net.3==1], useNA="always")
table(c$netwk.3[c$net.3==1], c$year[c$net.3==1], useNA="always")
table(c$netfr.3[c$net.3==1], c$year[c$net.3==1], useNA="always")

table(dc$q29cs2, useNA="always") # Gender of P3
# 1=Male, 2=Female
c$netfem.3 <- ifelse(dc$q29cs2%in%2, 1, ifelse(dc$q29cs2%in%1,0,NA))
table(c$netfem.3[c$net.3==1], c$year[c$net.3==1], useNA="always")

table(dc$q29cs3, useNA="always") # Age of P3 98=DK, 99=NA
c$netage.3 <- ifelse(dc$q29cs3%in%c(98,99), NA, dc$q29cs3)
table(c$netage.3[c$net.3==1], c$year[c$net.3==1], useNA="always")

#table(, useNA="always") # Closeness of P3
c$netclose.3 <- NA

table(dc$q29cs4, useNA="always") # Frequency of Meeting/Phone with P3: 1=毎日, 2=週1, 3=月1, 4=もっと少ない, 5=DK, 6=NA
c$netfreq.3 <- ifelse(dc$q29cs4%in%c(5,6),NA,(4-dc$q29cs4)/3)
table(c$netfreq.3[c$net.3==1], c$year[c$net.3==1], useNA="always")

table(dc$q29cs5, useNA="always") # Pol. Discussion with P3: 1=いつでも, 2=ときどき, 3=たまに, 4=ほとんどない, 5=DK, 6=NA 
c$netpoldis.3 <- ifelse(dc$q29cs5%in%c(5,6),NA,(4 - dc$q29cs5)/3)
table(c$netpoldis.3[c$net.3==1], c$year[c$net.3==1], useNA="always")

# table(, useNA="always") # Watch/Read News Together with P3
c$netwatchnews.3 <- NA

# table(, useNA="always") # Perceived Pol. Knowledge of P3
c$netknow.3 <- NA

table(dc$q29cs6, useNA="always") # Expected Vote Choice of P3
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=投票しない, 12=DK, 13=NA
c$netpvote.3 <- ifelse(dc$q29cs6%in%1, jimin, #"自民", 
                       ifelse(dc$q29cs6%in%2, shakai, #"社会", 
                              ifelse(dc$q29cs6%in%3, komei, #"公明", 
                                     ifelse(dc$q29cs6%in%4, shinsei, #"新生", 
                                            ifelse(dc$q29cs6%in%5, kyosan, #"共産", 
                                                   ifelse(dc$q29cs6%in%6, minsha, #"民社",
                                                          ifelse(dc$q29cs6%in%7, sakigake, #"さきがけ",
                                                                 ifelse(dc$q29cs6%in%8, shaminren, #"社民連", 
                                                                        ifelse(dc$q29cs6%in%9, nihonshin, #"日本新党",
                                                                               ifelse(dc$q29cs6%in%10, sonota, #"その他", 
                                                                                      ifelse(dc$q29cs6%in%11, kiken, 
                                                                                             ifelse(dc$q29cs6%in%12, shiranai, 
                                                                                                    NA))))))))))))
c$netpvote.3 <- factor(c$netpvote.3, levels=c(allps,kiken,shiranai))
table(c$netpvote.3, c$year, useNA="always")

# table(, useNA="always") # Expected Koizumi Support of P3
c$netpmsup.3 <- NA

# table(, useNA="always") # Similarity with P3
c$netsim.3 <- NA

# table(, useNA="always") # Relative Social Status of P3
c$netstat.3 <- NA

# table(, useNA="always") # Difference in Opinions with P3
c$netdif.3 <- NA

## Partner 4
table(dc$q29d, useNA="always") # Partner 4 (1=Yes)
c$net.4 <- ifelse(as.numeric(dc$q29d)%in%1,1,0)
table(c$net.4, c$year, useNA="always")
table(c$net.4[c$answered==1], c$year[c$answered==1], useNA="always")

# table(, useNA="always") # Have Spouse (1=Yes)

table(dc$q29ds1, useNA="always") # Relationship with P4
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 6=other group, 7=neighbor, 8=friend, 9=other
c$netfa.4 <- ifelse(dc$q29ds1%in%c(1,2,3),1,0)
c$netwk.4 <- ifelse(dc$q29ds1%in%4,1,0)
c$netfr.4 <- ifelse(dc$q29ds1%in%8,1,0)
table(c$netfa.4[c$net.4==1], c$year[c$net.4==1], useNA="always")
table(c$netwk.4[c$net.4==1], c$year[c$net.4==1], useNA="always")
table(c$netfr.4[c$net.4==1], c$year[c$net.4==1], useNA="always")

table(dc$q29ds2, useNA="always") # Gender of P4
# 1=Male, 2=Female
c$netfem.4 <- ifelse(dc$q29ds2%in%2, 1, ifelse(dc$q29ds2%in%1,0,NA))
table(c$netfem.4[c$net.4==1], c$year[c$net.4==1], useNA="always")

table(dc$q29ds3, useNA="always") # Age of P4 98=DK, 99=NA
c$netage.4 <- ifelse(dc$q29ds3%in%c(98,99), NA, dc$q29ds3)
table(c$netage.4[c$net.4==1], c$year[c$net.4==1], useNA="always")

#table(, useNA="always") # Closeness of P4
c$netclose.4 <- NA

table(dc$q29ds4, useNA="always") # Frequency of Meeting/Phone with P4: 1=毎日, 2=週1, 3=月1, 4=もっと少ない, 5=DK, 6=NA
c$netfreq.4 <- ifelse(dc$q29ds4%in%c(5,6),NA,(4-dc$q29ds4)/3)
table(c$netfreq.4[c$net.4==1], c$year[c$net.4==1], useNA="always")

table(dc$q29ds5, useNA="always") # Pol. Discussion with P4: 1=いつでも, 2=ときどき, 3=たまに, 4=ほとんどない, 5=DK, 6=NA 
c$netpoldis.4 <- ifelse(dc$q29ds5%in%c(5,6),NA,(4 - dc$q29ds5)/3)
table(c$netpoldis.4[c$net.4==1], c$year[c$net.4==1], useNA="always")

# table(, useNA="always") # Watch/Read News Together with P4
c$netwatchnews.4 <- NA

# table(, useNA="always") # Perceived Pol. Knowledge of P4
c$netknow.4 <- NA

table(dc$q29ds6, useNA="always") # Expected Vote Choice of P4
# 1=自民, 2=社会, 3=公明, 4=新生, 5=共産, 6=民社, 7=さきがけ, 
# 8=社民連, 9=日本新党, 10=その他, 11=投票しない, 12=DK, 13=NA
c$netpvote.4 <- ifelse(dc$q29ds6%in%1, jimin, #"自民", 
                       ifelse(dc$q29ds6%in%2, shakai, #"社会", 
                              ifelse(dc$q29ds6%in%3, komei, #"公明", 
                                     ifelse(dc$q29ds6%in%4, shinsei, #"新生", 
                                            ifelse(dc$q29ds6%in%5, kyosan, #"共産", 
                                                   ifelse(dc$q29ds6%in%6, minsha, #"民社",
                                                          ifelse(dc$q29ds6%in%7, sakigake, #"さきがけ",
                                                                 ifelse(dc$q29ds6%in%8, shaminren, #"社民連", 
                                                                        ifelse(dc$q29ds6%in%9, nihonshin, #"日本新党",
                                                                               ifelse(dc$q29ds6%in%10, sonota, #"その他", 
                                                                                      ifelse(dc$q29ds6%in%11, kiken, 
                                                                                             ifelse(dc$q29ds6%in%12, shiranai, 
                                                                                                    NA))))))))))))
c$netpvote.4 <- factor(c$netpvote.4, levels=c(allps,kiken,shiranai))
table(c$netpvote.4, c$year, useNA="always")

# table(, useNA="always") # Expected Koizumi Support of P4
c$netpmsup.4 <- NA

# table(, useNA="always") # Similarity with P4
c$netsim.4 <- NA

# table(, useNA="always") # Relative Social Status of P4
c$netstat.4 <- NA

# table(, useNA="always") # Difference in Opinions with P4
c$netdif.4 <- NA

## Network Summary Variables ##

## Number of People in Network
c$sumnet <- c$net.1 + c$net.2 + c$net.3 + c$net.4
table(c$sumnet, c$year, useNA="always")

## Melting Data ##

library(dplyr)
library(tidyr)

cnet <- gather(c, Var, Val, net.1:netdif.4) %>% 
  separate(Var, into = c("Var2", "key")) %>% 
  mutate(key = as.numeric(key)) %>%
  spread(Var2, Val)

## Drop Non-Existing Cases
cnet <- subset(cnet, cnet$net==1)

## Net Variable
cnet$net <- cnet$key
table(cnet$net, cnet$year, useNA="always")

cnet$netpvote <- factor(cnet$netpvote, levels=c(allps,kiken,shiranai))
table(cnet$netpvote, cnet$year, useNA="always")

#'
#' ## Saving Data
#'

#+ eval=FALSE
saveRDS(c, "cnep93.rds")
saveRDS(cnet, "cnep93_net.rds")

#+ eval=FALSE, echo=FALSE
# Exporting HTML File
# In R Studio
# rmarkdown::render('data_cnep93_1_recode_v2.R', 'github_document', clean=FALSE)
# tmp <- list.files(paste0("./"))
# tmp <- tmp[grep("\\.spin\\.R$|\\.spin\\.Rmd$|\\.utf8\\.md$|\\.knit\\.md$|\\.log$|\\.tex$",tmp)]
# for (i in 1:length(tmp)) file.remove(paste0("./",tmp[i]))
