#' ---
#' title: "JESIII Recode"
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
### SSJDA
datadir_s <- "0530BE.sav"

## Import Original Data
require(haven)

### SSJDA
ds <- read_sav(datadir_s, encoding="SHIFT_JIS")
colnames(ds) <- tolower(colnames(ds))
droprows <- which(is.na(ds$wave_a)) # Seemingly Error Rows
droprows # No rows to drop

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
#' ## SSJDA Data
#'

############
## Common ##
############

## Self
table(ds$citysize, useNA="always") # City Size
table(ds$gender, useNA="always") # Gender
table(ds$borny, useNA="always") # Born Year

###########################
## Wave A (& B) HoC 2001 ##
###########################

## Self
table(ds$a6x4, useNA="always") # PM Support
table(ds$a7, useNA="always") # Party Support
table(ds$a7s1, useNA="always") # Party Support Strength
table(ds$a7s2, useNA="always") # Party Leaners
table(ds$a11, useNA="always") # Vote Intention
table(ds$a11prtya, useNA="always") # Vote Decision by Party (県選挙区)
table(ds$a11prtyb, useNA="always") # Vote Decision by Party (PR)
table(ds$a24, useNA="always") # Political Interest
table(ds$a25, useNA="always") # Ministry Knowledge
table(ds$residyr01, useNA="always") # Year of Residence
table(ds$educat01, useNA="always") # Education
table(ds$occup5a1, useNA="always") # Occupation
table(ds$typeho01, useNA="always") # Type of Home
table(ds$hincome, useNA="always") # Household Income
### Wave B
table(ds$b1, useNA="always") # Voted
table(ds$b2prtya, useNA="always") # Vote Decision by Party (県選挙区)
table(ds$b7prtyb, useNA="always") # Vote Decision by Party (PR)

## Partner 1
table(ds$a45x1, useNA="always") # Partner 1 (1=Yes)
table(ds$a45x1a, useNA="always") # Have Spouse (1=Yes)
table(ds$a45x1s1, useNA="always") # Relationship with P1
table(ds$a45x1s2, useNA="always") # Gender of P1
table(ds$a45x1s3, useNA="always") # Closeness of P1
table(ds$a45x1s4, useNA="always") # Pol. Discussion with P1
table(ds$a45x1s5, useNA="always") # Watch/Read News Together with P1
table(ds$a45x1s6, useNA="always") # Perceived Pol. Knowledge of P1
table(ds$a45x1s7, useNA="always") # Expected Vote Choice of P1
table(ds$a45x1s8, useNA="always") # Expected Koizumi Support of P1
table(ds$a45x1s9, useNA="always") # Similarity with P1
table(ds$a45x1s10, useNA="always") # Relative Social Status of P1

## Partner 2
table(ds$a45x2, useNA="always") # Partner 2 (1=Yes)
table(ds$a45x2a1, useNA="always") # Partner 2 Check if Spouse (1=Yes)
table(ds$a45x2a2, useNA="always") # Have Spouse (1=Yes)
table(ds$a45x2s1, useNA="always") # Relationship with P2
table(ds$a45x2s2, useNA="always") # Gender of P2
table(ds$a45x2s3, useNA="always") # Closeness of P2
table(ds$a45x2s4, useNA="always") # Pol. Discussion with P2
table(ds$a45x2s5, useNA="always") # Watch/Read News Together with P2
table(ds$a45x2s6, useNA="always") # Perceived Pol. Knowledge of P2
table(ds$a45x2s7, useNA="always") # Expected Vote Choice of P2
table(ds$a45x2s8, useNA="always") # Expected Koizumi Support of P2
table(ds$a45x2s9, useNA="always") # Similarity with P2
table(ds$a45x2s10, useNA="always") # Relative Social Status of P2

## Partner 3
table(ds$a45x3, useNA="always") # Partner 3 (1=Yes)
table(ds$a45x3a1, useNA="always") # Partner 3 Check if Spouse (1=Yes)
table(ds$a45x3a2, useNA="always") # Have Spouse (1=Yes)
table(ds$a45x3s1, useNA="always") # Relationship with P3
table(ds$a45x3s2, useNA="always") # Gender of P3
table(ds$a45x3s3, useNA="always") # Closeness of P3
table(ds$a45x3s4, useNA="always") # Pol. Discussion with P3
table(ds$a45x3s5, useNA="always") # Watch/Read News Together with P3
table(ds$a45x3s6, useNA="always") # Perceived Pol. Knowledge of P3
table(ds$a45x3s7, useNA="always") # Expected Vote Choice of P3
table(ds$a45x3s8, useNA="always") # Expected Koizumi Support of P3
table(ds$a45x3s9, useNA="always") # Similarity with P3
table(ds$a45x3s10, useNA="always") # Relative Social Status of P3

## Partner 4
table(ds$a45x4, useNA="always") # Partner 4 (1=Yes)
table(ds$a45x4a1, useNA="always") # Partner 4 Check if Spouse (1=Yes)
table(ds$a45x4a2, useNA="always") # Have Spouse (1=Yes)
table(ds$a45x4s1, useNA="always") # Relationship with P4
table(ds$a45x4s2, useNA="always") # Gender of P4
table(ds$a45x4s3, useNA="always") # Closeness of P4
table(ds$a45x4s4, useNA="always") # Pol. Discussion with P4
table(ds$a45x4s5, useNA="always") # Watch/Read News Together with P4
table(ds$a45x4s6, useNA="always") # Perceived Pol. Knowledge of P4
table(ds$a45x4s7, useNA="always") # Expected Vote Choice of P4
table(ds$a45x4s8, useNA="always") # Expected Koizumi Support of P4
table(ds$a45x4s9, useNA="always") # Similarity with P4
table(ds$a45x4s10, useNA="always") # Relative Social Status of P4

## Acquaintance Between Partners
table(ds$a45s11_1, useNA="always") # P1 and P2 Knows Each Other
table(ds$a45s11_2, useNA="always") # P1 and P3 Knows Each Other
table(ds$a45s11_3, useNA="always") # P1 and P4 Knows Each Other
table(ds$a45s11_4, useNA="always") # P1 Knows Noone
table(ds$a45s11_5, useNA="always") # P1 Acquaintance DK
table(ds$a45s11_6, useNA="always") # P1 Acquaintance NA
table(ds$a45s12_1, useNA="always") # P2 and P3 Knows Each Other 
table(ds$a45s12_2, useNA="always") # P2 and P4 Knows Each Other
table(ds$a45s12_3, useNA="always") # P3 and P4 Knows Each Other
table(ds$a45s12_4, useNA="always") # P2, P3, and P4 Don't Know Each Other
table(ds$a45s12_5, useNA="always") # P2, P3, and P4 Acquaintance DK
table(ds$a45s12_6, useNA="always") # P2, P3, and P4 Acquaintance NA

###########################
## Wave D (& E) HoR 2003 ##
###########################

## Self
table(ds$d7x4, useNA="always") # PM Support
table(ds$d8, useNA="always") # Party Support
table(ds$d8s1, useNA="always") # Party Support Strength
table(ds$d8s2, useNA="always") # Party Leaners
table(ds$d12, useNA="always") # Vote Intention
table(ds$d12prty, useNA="always") # Vote Decision by Party (SMD)
table(ds$d12s4, useNA="always") # Vote Decision by Party (PR)
table(ds$d25, useNA="always") # Political Interest
# table(, useNA="always") # Ministry Knowledge
table(ds$residy03, useNA="always") # Year of Residence
table(ds$educat03, useNA="always") # Education
table(ds$occup5a3, useNA="always") # Occupation
table(ds$typeho03, useNA="always") # Type of Home
table(ds$hincom03, useNA="always") # Household Income
### Wave E
table(ds$e1, useNA="always") # Voted
table(ds$e1s2p, useNA="always") # Vote Decision by Party (SMD)
table(ds$e1s7, useNA="always") # Vote Decision by Party (PR)

## Partner 1
table(ds$d43x1, useNA="always") # Partner 1 (1=Yes)
table(ds$d43x1a, useNA="always") # Have Spouse (1=Yes)
table(ds$d43x1s1, useNA="always") # Relationship with P1
table(ds$d43x1s2, useNA="always") # Gender of P1
# table(, useNA="always") # Closeness of P1
table(ds$d43x1s3, useNA="always") # Pol. Discussion with P1
# table(, useNA="always") # Watch/Read News Together with P1
table(ds$d43x1s4, useNA="always") # Perceived Pol. Knowledge of P1
table(ds$d43x1s5, useNA="always") # Expected Vote Choice of P1
table(ds$d43x1s6, useNA="always") # Expected Koizumi Support of P1
table(ds$d43x1s7, useNA="always") # Similarity with P1
table(ds$d43x1s8, useNA="always") # Relative Social Status of P1

## Partner 2
table(ds$d43x2, useNA="always") # Partner 2 (1=Yes)
table(ds$d43x2a1, useNA="always") # Partner 2 Check if Spouse (1=Yes)
table(ds$d43x2a2, useNA="always") # Have Spouse (1=Yes)
table(ds$d43x2s1, useNA="always") # Relationship with P2
table(ds$d43x2s2, useNA="always") # Gender of P2
# table(, useNA="always") # Closeness of P2
table(ds$d43x2s3, useNA="always") # Pol. Discussion with P2
# table(, useNA="always") # Watch/Read News Together with P2
table(ds$d43x2s4, useNA="always") # Perceived Pol. Knowledge of P2
table(ds$d43x2s5, useNA="always") # Expected Vote Choice of P2
table(ds$d43x2s6, useNA="always") # Expected Koizumi Support of P2
table(ds$d43x2s7, useNA="always") # Similarity with P2
table(ds$d43x2s8, useNA="always") # Relative Social Status of P2

## Partner 3
table(ds$d43x3, useNA="always") # Partner 3 (1=Yes)
table(ds$d43x3a1, useNA="always") # Partner 3 Check if Spouse (1=Yes)
table(ds$d43x3a2, useNA="always") # Have Spouse (1=Yes)
table(ds$d43x3s1, useNA="always") # Relationship with P3
table(ds$d43x3s2, useNA="always") # Gender of P3
# table(, useNA="always") # Closeness of P3
table(ds$d43x3s3, useNA="always") # Pol. Discussion with P3
# table(, useNA="always") # Watch/Read News Together with P3
table(ds$d43x3s4, useNA="always") # Perceived Pol. Knowledge of P3
table(ds$d43x3s5, useNA="always") # Expected Vote Choice of P3
table(ds$d43x3s6, useNA="always") # Expected Koizumi Support of P3
table(ds$d43x3s7, useNA="always") # Similarity with P3
table(ds$d43x3s8, useNA="always") # Relative Social Status of P3

## Partner 4
table(ds$d43x4, useNA="always") # Partner 4 (1=Yes)
table(ds$d43x4a1, useNA="always") # Partner 4 Check if Spouse (1=Yes)
table(ds$d43x4a2, useNA="always") # Have Spouse (1=Yes)
table(ds$d43x4s1, useNA="always") # Relationship with P4
table(ds$d43x4s2, useNA="always") # Gender of P4
# table(, useNA="always") # Closeness of P4
table(ds$d43x4s3, useNA="always") # Pol. Discussion with P4
# table(, useNA="always") # Watch/Read News Together with P4
table(ds$d43x4s4, useNA="always") # Perceived Pol. Knowledge of P4
table(ds$d43x4s5, useNA="always") # Expected Vote Choice of P4
table(ds$d43x4s6, useNA="always") # Expected Koizumi Support of P4
table(ds$d43x4s7, useNA="always") # Similarity with P4
table(ds$d43x4s8, useNA="always") # Relative Social Status of P4

## Acquaintance Between Partners
table(ds$d43s9_1, useNA="always") # P1 and P2 Knows Each Other
table(ds$d43s9_2, useNA="always") # P1 and P3 Knows Each Other
table(ds$d43s9_3, useNA="always") # P1 and P4 Knows Each Other
table(ds$d43s9_4, useNA="always") # P1 Knows Noone
table(ds$d43s9_5, useNA="always") # P1 Acquaintance DK
table(ds$d43s9_6, useNA="always") # P1 Acquaintance NA
table(ds$d43s10_1, useNA="always") # P2 and P3 Knows Each Other 
table(ds$d43s10_2, useNA="always") # P2 and P4 Knows Each Other
table(ds$d43s10_3, useNA="always") # P3 and P4 Knows Each Other
table(ds$d43s10_4, useNA="always") # P2, P3, and P4 Don't Know Each Other
table(ds$d43s10_5, useNA="always") # P2, P3, and P4 Acquaintance DK
table(ds$d43s10_6, useNA="always") # P2, P3, and P4 Acquaintance NA

###########################
## Wave G (& H) HoC 2004 ##
###########################

## Self
table(ds$g7x4, useNA="always") # PM Support
table(ds$g8, useNA="always") # Party Support
table(ds$g8s1, useNA="always") # Party Support Strength
table(ds$g8s2, useNA="always") # Party Leaners
table(ds$g12, useNA="always") # Vote Intention
table(ds$g12prtya, useNA="always") # Vote Decision by Party (PREF)
table(ds$g12prtyb, useNA="always") # Vote Decision by Party (PR)
table(ds$g27, useNA="always") # Political Interest
# table(, useNA="always") # Ministry Knowledge
table(ds$residy04, useNA="always") # Year of Residence
table(ds$educat04, useNA="always") # Education
table(ds$occup5a4, useNA="always") # Occupation
table(ds$typeho04, useNA="always") # Type of Home
table(ds$hincom04, useNA="always") # Household Income
### Wave H
table(ds$h1, useNA="always") # Voted
table(ds$h1s2p, useNA="always") # Vote Decision by Party (PREF)
table(ds$h1s7p, useNA="always") # Vote Decision by Party (PR)

## Partner 1
table(ds$g45x1, useNA="always") # Partner 1 (1=Yes)
#table(ds$g45x1b, useNA="always") # Have Spouse (1=Yes)
table(ds$g45x1s1, useNA="always") # Relationship with P1
table(ds$g45x1s2, useNA="always") # Gender of P1
#table(, useNA="always") # Closeness of P1
table(ds$g45x1s3, useNA="always") # Pol. Discussion with P1
# table(, useNA="always") # Watch/Read News Together with P1
table(ds$g45x1s4, useNA="always") # Perceived Pol. Knowledge of P1
table(ds$g45x1s5, useNA="always") # Expected Vote Choice of P1
table(ds$g45x1s6, useNA="always") # Expected Koizumi Support of P1
table(ds$g45x1s7, useNA="always") # Difference in Opinions with P1
table(ds$g45x1s8, useNA="always") # Similarity with P1
table(ds$g45x1s9, useNA="always") # Relative Social Status of P1

## Partner 2
table(ds$g45x2, useNA="always") # Partner 2 (1=Yes)
#table(ds$g45x2b, useNA="always") # Have Spouse (1=Yes)
table(ds$g45x2s1, useNA="always") # Relationship with P2
table(ds$g45x2s2, useNA="always") # Gender of P2
#table(, useNA="always") # Closeness of P2
table(ds$g45x2s3, useNA="always") # Pol. Discussion with P2
# table(, useNA="always") # Watch/Read News Together with P2
table(ds$g45x2s4, useNA="always") # Perceived Pol. Knowledge of P2
table(ds$g45x2s5, useNA="always") # Expected Vote Choice of P2
table(ds$g45x2s6, useNA="always") # Expected Koizumi Support of P2
table(ds$g45x2s7, useNA="always") # Difference in Opinions with P2
table(ds$g45x2s8, useNA="always") # Similarity with P2
table(ds$g45x2s9, useNA="always") # Relative Social Status of P2

## Partner 3
table(ds$g45x3, useNA="always") # Partner 3 (1=Yes)
#table(ds$g45x3b, useNA="always") # Have Spouse (1=Yes)
table(ds$g45x3s1, useNA="always") # Relationship with P3
table(ds$g45x3s2, useNA="always") # Gender of P3
#table(, useNA="always") # Closeness of P3
table(ds$g45x3s3, useNA="always") # Pol. Discussion with P3
# table(, useNA="always") # Watch/Read News Together with P3
table(ds$g45x3s4, useNA="always") # Perceived Pol. Knowledge of P3
table(ds$g45x3s5, useNA="always") # Expected Vote Choice of P3
table(ds$g45x3s6, useNA="always") # Expected Koizumi Support of P3
table(ds$g45x3s7, useNA="always") # Difference in Opinions with P3
table(ds$g45x3s8, useNA="always") # Similarity with P3
table(ds$g45x3s9, useNA="always") # Relative Social Status of P3

## Partner 4
table(ds$g45x4, useNA="always") # Partner 4 (1=Yes)
#table(ds$g45x4b, useNA="always") # Have Spouse (1=Yes)
table(ds$g45x4s1, useNA="always") # Relationship with P4
table(ds$g45x4s2, useNA="always") # Gender of P4
#table(, useNA="always") # Closeness of P4
table(ds$g45x4s3, useNA="always") # Pol. Discussion with P4
# table(, useNA="always") # Watch/Read News Together with P4
table(ds$g45x4s4, useNA="always") # Perceived Pol. Knowledge of P4
table(ds$g45x4s5, useNA="always") # Expected Vote Choice of P4
table(ds$g45x4s6, useNA="always") # Expected Koizumi Support of P4
table(ds$g45x4s7, useNA="always") # Difference in Opinions with P4
table(ds$g45x4s8, useNA="always") # Similarity with P4
table(ds$g45x4s9, useNA="always") # Relative Social Status of P4

## Acquaintance Between Partners
table(ds$g45s10_1, useNA="always") # P1 and P2 Knows Each Other
table(ds$g45s10_2, useNA="always") # P1 and P3 Knows Each Other
table(ds$g45s10_3, useNA="always") # P1 and P4 Knows Each Other
table(ds$g45s10_4, useNA="always") # P1 Knows Noone
table(ds$g45s10_5, useNA="always") # P1 Acquaintance DK
table(ds$g45s10_6, useNA="always") # P1 Acquaintance NA
table(ds$g45s11_1, useNA="always") # P2 and P3 Knows Each Other 
table(ds$g45s11_2, useNA="always") # P2 and P4 Knows Each Other
table(ds$g45s11_3, useNA="always") # P3 and P4 Knows Each Other
table(ds$g45s11_4, useNA="always") # P2, P3, and P4 Don't Know Each Other
table(ds$g45s11_5, useNA="always") # P2, P3, and P4 Acquaintance DK
table(ds$g45s11_6, useNA="always") # P2, P3, and P4 Acquaintance NA

###########################
## Wave J (& K) HoR 2005 ##
###########################

## Self
table(ds$j9x4, useNA="always") # PM Support
table(ds$j10, useNA="always") # Party Support
table(ds$j10s1, useNA="always") # Party Support Strength
table(ds$j10s2, useNA="always") # Party Leaners
table(ds$j15, useNA="always") # Vote Intention
table(ds$j15prty, useNA="always") # Vote Decision by Party (SMD)
table(ds$j15s4, useNA="always") # Vote Decision by Party (PR)
table(ds$j32, useNA="always") # Political Interest
# table(, useNA="always") # Ministry Knowledge
table(ds$residy05, useNA="always") # Year of Residence
table(ds$educat05, useNA="always") # Education
table(ds$occup5a5, useNA="always") # Occupation
table(ds$typeho05, useNA="always") # Type of Home
table(ds$hincom05, useNA="always") # Household Income
### Wave H
table(ds$k1, useNA="always") # Voted
table(ds$k1s2p, useNA="always") # Vote Decision by Party (SMD)
table(ds$k1s7, useNA="always") # Vote Decision by Party (PR)

## Partner 1
table(ds$j53x1, useNA="always") # Partner 1 (1=Yes)
table(ds$j53x1a, useNA="always") # Have Spouse (1=Yes)
table(ds$j53x1s1, useNA="always") # Relationship with P1
table(ds$j53x1s2, useNA="always") # Gender of P1
#table(, useNA="always") # Closeness of P1
table(ds$j53x1s3, useNA="always") # Pol. Discussion with P1
# table(, useNA="always") # Watch/Read News Together with P1
table(ds$j53x1s4, useNA="always") # Perceived Pol. Knowledge of P1
table(ds$j53x1s5, useNA="always") # Expected Vote Choice of P1
table(ds$j53x1s6, useNA="always") # Expected Koizumi Support of P1
# table(, useNA="always") # Difference in Opinions with P1
table(ds$j53x1s7, useNA="always") # Similarity with P1
table(ds$j53x1s8, useNA="always") # Relative Social Status of P1

## Partner 2
table(ds$j53x2, useNA="always") # Partner 2 (1=Yes)
table(ds$j53x2a1, useNA="always") # Partner 2 Check if Spouse (1=Yes)
table(ds$j53x2a2, useNA="always") # Have Spouse (1=Yes)
table(ds$j53x2s1, useNA="always") # Relationship with P2
table(ds$j53x2s2, useNA="always") # Gender of P2
#table(, useNA="always") # Closeness of P2
table(ds$j53x2s3, useNA="always") # Pol. Discussion with P2
# table(, useNA="always") # Watch/Read News Together with P2
table(ds$j53x2s4, useNA="always") # Perceived Pol. Knowledge of P2
table(ds$j53x2s5, useNA="always") # Expected Vote Choice of P2
table(ds$j53x2s6, useNA="always") # Expected Koizumi Support of P2
# table(, useNA="always") # Difference in Opinions with P2
table(ds$j53x2s7, useNA="always") # Similarity with P2
table(ds$j53x2s8, useNA="always") # Relative Social Status of P2

## Partner 3
table(ds$j53x3, useNA="always") # Partner 3 (1=Yes)
table(ds$j53x3a1, useNA="always") # Partner 3 Check if Spouse (1=Yes)
table(ds$j53x3a2, useNA="always") # Have Spouse (1=Yes)
table(ds$j53x3s1, useNA="always") # Relationship with P3
table(ds$j53x3s2, useNA="always") # Gender of P3
#table(, useNA="always") # Closeness of P3
table(ds$j53x3s3, useNA="always") # Pol. Discussion with P3
# table(, useNA="always") # Watch/Read News Together with P3
table(ds$j53x3s4, useNA="always") # Perceived Pol. Knowledge of P3
table(ds$j53x3s5, useNA="always") # Expected Vote Choice of P3
table(ds$j53x3s6, useNA="always") # Expected Koizumi Support of P3
# table(, useNA="always") # Difference in Opinions with P3
table(ds$j53x3s7, useNA="always") # Similarity with P3
table(ds$j53x3s8, useNA="always") # Relative Social Status of P3

## Partner 4
table(ds$j53x4, useNA="always") # Partner 4 (1=Yes)
table(ds$j53x4a1, useNA="always") # Partner 4 Check if Spouse (1=Yes)
table(ds$j53x4a2, useNA="always") # Have Spouse (1=Yes)
table(ds$j53x4s1, useNA="always") # Relationship with P4
table(ds$j53x4s2, useNA="always") # Gender of P4
#table(, useNA="always") # Closeness of P4
table(ds$j53x4s3, useNA="always") # Pol. Discussion with P4
# table(, useNA="always") # Watch/Read News Together with P4
table(ds$j53x4s4, useNA="always") # Perceived Pol. Knowledge of P4
table(ds$j53x4s5, useNA="always") # Expected Vote Choice of P4
table(ds$j53x4s6, useNA="always") # Expected Koizumi Support of P4
# table(, useNA="always") # Difference in Opinions with P4
table(ds$j53x4s7, useNA="always") # Similarity with P4
table(ds$j53x4s8, useNA="always") # Relative Social Status of P4

## Acquaintance Between Partners
table(ds$j53s9_1, useNA="always") # P1 and P2 Knows Each Other
table(ds$j53s9_2, useNA="always") # P1 and P3 Knows Each Other
table(ds$j53s9_3, useNA="always") # P1 and P4 Knows Each Other
table(ds$j53s9_4, useNA="always") # P1 Knows Noone
table(ds$j53s9_5, useNA="always") # P1 Acquaintance DK
table(ds$j53s9_6, useNA="always") # P1 Acquaintance NA
table(ds$j53s10_1, useNA="always") # P2 and P3 Knows Each Other 
table(ds$j53s10_2, useNA="always") # P2 and P4 Knows Each Other
table(ds$j53s10_3, useNA="always") # P3 and P4 Knows Each Other
table(ds$j53s10_4, useNA="always") # P2, P3, and P4 Don't Know Each Other
table(ds$j53s10_5, useNA="always") # P2, P3, and P4 Acquaintance DK
table(ds$j53s10_6, useNA="always") # P2, P3, and P4 Acquaintance NA

#'
#' # Create New Data
#' 
#' ## SSJDA Data
#' 

# Initiate New Keio Data Set
s <-  data.frame(id = rep(seq(1,nrow(ds)),4), 
                year = rep(c(2001, 2003, 2004, 2005), each=nrow(ds)))

## House of Representative Dummy
s$horelec <- ifelse(s$year%in%c(2001,2004),0,1)

## Sampled Year
s$smpyear <- ifelse(ds$wave_a%in%1|ds$wave_b%in%1,2001,
                    ifelse(ds$wave3pan1%in%2|ds$wave3pan2%in%2,2002.5, # Wave C (Conducted in 2003) 
                           ifelse(ds$wave4pan%in%2|ds$wave5pan%in%2,2003,
                                  ifelse(ds$wave6pan%in%2|ds$wave7pan%in%2,2004,NA))))
table(s$smpyear[s$year==2001], useNA="always")

## Fresh/Panel Sample dummies (NAs for invalid cases)
s$panel <- ifelse(s$year - s$smpyear > 0.5, 1, 
                  ifelse(s$year - s$smpyear < 0, NA, 0))
s$fresh <- 1 - s$panel
table(s$panel, s$year, useNA="always")
table(s$fresh, s$year, useNA="always")

## Unit Response Dummies
s$answered <- 0
s$answered[s$year==2001] <- ifelse(ds$wave_a%in%1,1,0) # |ds$wave_b%in%1
s$answered[s$year==2003] <- ifelse(ds$wave_d%in%1,1,0) # |ds$wave_e%in%1
s$answered[s$year==2004] <- ifelse(ds$wave_g%in%1,1,0) # |ds$wave_h%in%1
s$answered[s$year==2005] <- ifelse(ds$wave_j%in%1,1,0) # |ds$wave_k%in%1
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

### Big Cities in Three Major Urban Area (Tokyo, Osaka, Yokohama, Nagoya, Kyoto, Kawasaki, Kobe)
s$citysize_big3 <- ifelse(
  ds$citysize%in%c(1,4)|(ds$citysize==2&ds$pref%in%c(14,23,26))|(ds$citysize==3&ds$pref%in%c(14,28)),
  1,0
)
table(s$citysize_big3[s$year==2001])

### Big Cities in Other Area (Kita-Kyusyu, Sapporo, Sendai, Hiroshima, Fukuoka)
s$citysize_bigelse <- ifelse(
  (ds$citysize==2&!ds$pref%in%c(14,23,26))|(ds$citysize==3&!ds$pref%in%c(14,28)),
  1,0
)
table(s$citysize_bigelse[s$year==2001])

### All Big Cities
s$citysize_big <- s$citysize_big3 + s$citysize_bigelse
table(s$citysize_big[s$year==2001])

### Middle Size Cities (MT 200T)
s$citysize_mid <- ifelse(ds$citysize==5,1,0)
table(s$citysize_mid[s$year==2001])

### Small Cities (LT 200T)
s$citysize_sml <- ifelse(ds$citysize%in%c(6,7),1,0)
table(s$citysize_sml[s$year==2001])

### Not Cities (Villages/Towns)
s$citysize_not <- ifelse(ds$citysize%in%c(8),1,0)
table(s$citysize_not[s$year==2001])

## All City Sizes
s$citysize <- ifelse(s$citysize_big==1,1,
                     ifelse(s$citysize_mid==1,2/3,
                            ifelse(s$citysize_sml==1,1/3,0)))

## Gender (Female)
table(ds$gender, useNA="always") # Gender (1=Male, 2=Female)
s$fem <- ds$gender - 1
table(s$fem[s$year==2001])

## Age (To Become in the Given Year)
table(ds$borny, useNA="always") # Born Year
s$age <- s$year - rep(ds$borny, 4)
hist(s$age)

## Party Support
table(ds$a7, useNA="always") # 1:LDP/2:DPJ/3:CGP/4:SDP/5:JCP/6:NCP/7:LBP/8:Other/9:No
table(ds$a7s1, useNA="always") # Strength: 1:Enthusiastically Support, 2:Not
table(ds$a7s2, useNA="always") # Leaners (same as original)
table(ds$d8, useNA="always") # 1:LDP/2:DPJ/3:CGP/4:SDP/5:JCP/6:NCP/8:Other/9:No
table(ds$d8s1, useNA="always") # Party Support Strength
table(ds$d8s2, useNA="always") # Party Leaners
table(ds$g8, useNA="always") # 1:LDP/2:DPJ/3:CGP/4:SDP/5:JCP/8:Other/9:No
table(ds$g8s1, useNA="always") # Party Support Strength
table(ds$g8s2, useNA="always") # Party Leaners
table(ds$j10, useNA="always") # 1:LDP/2:DPJ/3:CGP/4:SDP/5:JCP/6:PNP/7:NPN/8:Other/9:No
table(ds$j10s1, useNA="always") # Party Support Strength
table(ds$j10s2, useNA="always") # Party Leaners

## PM Support
table(ds$a6x4, useNA="always") # PM Support
table(ds$d7x4, useNA="always") # PM Support
table(ds$g7x4, useNA="always") # PM Support
table(ds$j9x4, useNA="always") # PM Support
s$pmsup <- ifelse(c(ds$a6x4,ds$d7x4,ds$g7x4,ds$j9x4)>=8,NA,
                  (5-c(ds$a6x4,ds$d7x4,ds$g7x4,ds$j9x4))/4)
table(s$pmsup, s$year, useNA="always")

### Supporting Party
s$psup <- ifelse(c(ds$a7,ds$d8,ds$g8,ds$j10)%in%1, jimin, 
                 ifelse(c(ds$a7,ds$d8,ds$g8,ds$j10)%in%2, minshu, 
                        ifelse(c(ds$a7,ds$d8,ds$g8,ds$j10)%in%3, komei, 
                               ifelse(c(ds$a7,ds$d8,ds$g8,ds$j10)%in%4, shamin, 
                                      ifelse(c(ds$a7,ds$d8,ds$g8,ds$j10)%in%5, kyosan, 
                                             ifelse(c(ds$a7,ds$d8,ds$g8,ds$j10)%in%c(6,7,8), sonota, 
                                                    ifelse(c(ds$a7,ds$d8,ds$g8,ds$j10)%in%9, mutoha, 
                                                           NA)))))))
s$psup[c(ds$a7,ds$d8,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin 
s$psup[c(ds$a7,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu 
s$psup[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j10)%in%6] <- kokuminshin 
s$psup[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j10)%in%7] <- sonota 
s$psup <- factor(s$psup, levels=c(allps,mutoha))
table(s$psup, s$year, useNA="always")

### Party Leaning (Leaning Only)
s$plean <- ifelse(c(ds$a7s2,ds$d8s2,ds$g8s2,ds$j10s2)%in%1, jimin, 
                  ifelse(c(ds$a7s2,ds$d8s2,ds$g8s2,ds$j10s2)%in%2, minshu, 
                         ifelse(c(ds$a7s2,ds$d8s2,ds$g8s2,ds$j10s2)%in%3, komei, 
                                ifelse(c(ds$a7s2,ds$d8s2,ds$g8s2,ds$j10s2)%in%4, shamin, 
                                       ifelse(c(ds$a7s2,ds$d8s2,ds$g8s2,ds$j10s2)%in%5, kyosan, 
                                              ifelse(c(ds$a7s2,ds$d8s2,ds$g8s2,ds$j10s2)%in%c(6,7,8), sonota, 
                                                     ifelse(c(ds$a7s2,ds$d8s2,ds$g8s2,ds$j10s2)%in%9, mutoha, 
                                                            NA)))))))
s$plean[c(ds$a7s2,ds$d8s2,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin 
s$plean[c(ds$a7s2,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu 
s$plean[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j10s2)%in%6] <- kokuminshin 
s$plean[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j10s2)%in%7] <- sonota 
s$plean <- factor(s$plean, levels=c(allps,mutoha))
table(s$plean, s$year, useNA="always")

### Party Support plus Leaning
table(s$psup, s$plean, useNA="always")
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
s$pstr[s$pstr%in%2 & c(ds$a7s1,ds$d8s1,ds$g8s1,ds$j10s1)%in%1] <- 3
table(s$pstr, s$year, useNA="always")

## Participation intention 
table(ds$a11, useNA="always") # Vote Intention
table(ds$d12, useNA="always") # Vote Intention
table(ds$g12, useNA="always") # Vote Intention
table(ds$j15, useNA="always") # Vote Intention
s$voteint <- ifelse(c(ds$a11,ds$d12,ds$g12,ds$j15)%in%1,2,
                    ifelse(c(ds$a11,ds$d12,ds$g12,ds$j15)%in%2,1,
                           ifelse(c(ds$a11,ds$d12,ds$g12,ds$j15)%in%c(3,4,5,8),0,NA)))
table(s$voteint, s$year, useNA="always")

## Participation
table(ds$b1, useNA="always") # Voted
table(ds$e1, useNA="always") # Voted
table(ds$h1, useNA="always") # Voted
table(ds$k1, useNA="always") # Voted
s$voted <- ifelse(c(ds$b1,ds$e1,ds$h1,ds$k1)%in%c(1,2),1,
                  ifelse(c(ds$b1,ds$e1,ds$h1,ds$k1)%in%c(3),0,NA))
s$voted <- ifelse(c(ds$b1,ds$e1,ds$h1,ds$k1)%in%c(1,2),1,
                  ifelse(c(ds$b1,ds$e1,ds$h1,ds$k1)%in%c(3),0,NA))
table(s$voted, useNA="always")

## Vote Decision Intention
table(ds$a11prtya, useNA="always") # Vote Decision by Party (県選挙区)
# 1=LDP,2=DPJ,3=CGP,4=SDP,5=JCP,6=NCP,7=LBP,8=Other,9=Independent,10=Undecided,88=DK,99=NA  
table(ds$a11prtyb, useNA="always") # Vote Decision by Party (PR)
# 1=LDP,2=DPJ,3=CGP,4=SDP,5=JCP,6=NCP,7=LBP,8=Jiyu-rengo,9=Other,10=Undecided,88=DK,99=NA  
table(ds$d12prty, useNA="always") # Vote Decision by Party (SMD)
# 1=LDP,2=DPJ,3=CGP,4=SDP,5=JCP,6=NCP,7=blank,8=Other,9=Independent,10=Undecided,88=DK,99=NA  
table(ds$d12s4, useNA="always") # Vote Decision by Party (PR)
# 1=LDP,2=DPJ,3=CGP,4=SDP,5=JCP,6=NCP,8=Jiyu-rengo,9=Other,88=DK,99=NA  
table(ds$g12prtya, useNA="always") # Vote Decision by Party (PREF)
# 1=LDP,2=DPJ,3=CGP,4=SDP,5=JCP,8=Other,9=Independent,10=Undecided,88=DK,99=NA  
table(ds$g12prtyb, useNA="always") # Vote Decision by Party (PR)
# 1=LDP,2=DPJ,3=CGP,4=SDP,5=JCP,8=Midorinokaigi,9=Josei-tou,10=Ishin-Seitou-Shinpu',.12=Undecided,88=DK,99=NA  
table(ds$j15prty, useNA="always") # Vote Decision by Party (SMD)
# 1=LDP,2=DPJ,3=CGP,4=SDP,5=JCP,6=CNP,7=NPJ,8=Other,9=Independent,10=Undecided,88=DK,99=NA  
table(ds$j15s4, useNA="always") # Vote Decision by Party (PR)
# 1=LDP,2=DPJ,3=CGP,4=SDP,5=JCP,6=PNP,7=NPN,8=Other,9=No such party,88=DK,99=NA  

### Single/Multiple Member District
s$pvoteintMD <- NA
s$pvoteintMD[c(ds$a11prtya,ds$d12prty,ds$g12prtya,ds$j15prty)%in%1] <- jimin
s$pvoteintMD[c(ds$a11prtya,ds$d12prty,ds$g12prtya,ds$j15prty)%in%2] <- minshu
s$pvoteintMD[c(ds$a11prtya,ds$d12prty,ds$g12prtya,ds$j15prty)%in%3] <- komei
s$pvoteintMD[c(ds$a11prtya,ds$d12prty,ds$g12prtya,ds$j15prty)%in%4] <- shamin
s$pvoteintMD[c(ds$a11prtya,ds$d12prty,ds$g12prtya,ds$j15prty)%in%5] <- kyosan
s$pvoteintMD[c(ds$a11prtya,ds$d12prty,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin
s$pvoteintMD[c(ds$a11prtya,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu
s$pvoteintMD[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j15prty)%in%6] <- kokuminshin
s$pvoteintMD[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j15prty)%in%7] <- sonota
s$pvoteintMD[c(ds$a11prtya,ds$d12prty,ds$g12prtya,ds$j15prty)%in%8] <- sonota
s$pvoteintMD[c(ds$a11prtya,ds$d12prty,ds$g12prtya,ds$j15prty)%in%9] <- mushozoku
s$pvoteintMD[c(ds$a11prtya,ds$d12prty,ds$g12prtya,ds$j15prty)%in%c(10,88)] <- mikettei
s$pvoteintMD <- factor(s$pvoteintMD, levels=c(allps,mushozoku,mikettei))
table(s$pvoteintMD, s$year, useNA="always")

### Proportional Representation
s$pvoteintPR <- NA
s$pvoteintPR[c(ds$a11prtyb,ds$d12s4,ds$g12prtyb,ds$j15s4)%in%1] <- jimin
s$pvoteintPR[c(ds$a11prtyb,ds$d12s4,ds$g12prtyb,ds$j15s4)%in%2] <- minshu
s$pvoteintPR[c(ds$a11prtyb,ds$d12s4,ds$g12prtyb,ds$j15s4)%in%3] <- komei
s$pvoteintPR[c(ds$a11prtyb,ds$d12s4,ds$g12prtyb,ds$j15s4)%in%4] <- shamin
s$pvoteintPR[c(ds$a11prtyb,ds$d12s4,ds$g12prtyb,ds$j15s4)%in%5] <- kyosan
s$pvoteintPR[c(ds$a11prtyb,ds$d12s4,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin
s$pvoteintPR[c(ds$a11prtyb,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu
s$pvoteintPR[c(ds$a11prtyb,ds$d12s4,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%8] <- sonota
s$pvoteintPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j15s4)%in%6] <- kokuminshin
s$pvoteintPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j15s4)%in%7] <- sonota
s$pvoteintPR[c(ds$a11prtyb,ds$d12s4,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%9] <- sonota
s$pvoteintPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$g12prtyb,rep(NA,nrow(ds)))%in%c(8,9,10)] <- sonota
s$pvoteintPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j15s4)%in%8] <- sonota
s$pvoteintPR[c(ds$a11prtyb,ds$d12s4,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%c(10,88)] <- mikettei
s$pvoteintPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$g12prtyb,rep(NA,nrow(ds)))%in%c(12,88)] <- mikettei
s$pvoteintPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j15s4)%in%c(9,88)] <- mikettei
s$pvoteintPR <- factor(s$pvoteintPR, levels=c(allps,mikettei))
table(s$pvoteintPR, s$year, useNA="always")

## Vote Decision (Post Election)
table(ds$b2prtya, useNA="always") # Vote Decision by Party (県選挙区)
table(ds$b7prtyb, useNA="always") # Vote Decision by Party (PR)
table(ds$e1s2p, useNA="always") # Vote Decision by Party (SMD)
table(ds$e1s7, useNA="always") # Vote Decision by Party (PR)
table(ds$h1s2p, useNA="always") # Vote Decision by Party (PREF)
table(ds$h1s7p, useNA="always") # Vote Decision by Party (PR)
table(ds$k1s2p, useNA="always") # Vote Decision by Party (SMD)
table(ds$k1s7, useNA="always") # Vote Decision by Party (PR)

### Single/Multiple Member District
s$pvotedMD <- NA
s$pvotedMD[c(ds$b2prtya,ds$e1s2p,ds$h1s2p,ds$k1s2p)%in%1] <- jimin
s$pvotedMD[c(ds$b2prtya,ds$e1s2p,ds$h1s2p,ds$k1s2p)%in%2] <- minshu
s$pvotedMD[c(ds$b2prtya,ds$e1s2p,ds$h1s2p,ds$k1s2p)%in%3] <- komei
s$pvotedMD[c(ds$b2prtya,ds$e1s2p,ds$h1s2p,ds$k1s2p)%in%4] <- shamin
s$pvotedMD[c(ds$b2prtya,ds$e1s2p,ds$h1s2p,ds$k1s2p)%in%5] <- kyosan
s$pvotedMD[c(ds$b2prtya,ds$e1s2p,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin
s$pvotedMD[c(ds$b2prtya,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu
s$pvotedMD[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$k1s2p)%in%6] <- kokuminshin
s$pvotedMD[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$k1s2p)%in%7] <- sonota
s$pvotedMD[c(ds$b2prtya,ds$e1s2p,ds$h1s2p,ds$k1s2p)%in%8] <- sonota
s$pvotedMD[c(ds$b2prtya,ds$e1s2p,ds$h1s2p,ds$k1s2p)%in%9] <- mushozoku
s$pvotedMD <- factor(s$pvotedMD, levels=c(allps,mushozoku))
table(s$pvotedMD, s$year, useNA="always")

### Proportional Representation
s$pvotedPR <- NA
s$pvotedPR[c(ds$b7prtyb,ds$e1s7,ds$h1s7p,ds$k1s7)%in%1] <- jimin
s$pvotedPR[c(ds$b7prtyb,ds$e1s7,ds$h1s7p,ds$k1s7)%in%2] <- minshu
s$pvotedPR[c(ds$b7prtyb,ds$e1s7,ds$h1s7p,ds$k1s7)%in%3] <- komei
s$pvotedPR[c(ds$b7prtyb,ds$e1s7,ds$h1s7p,ds$k1s7)%in%4] <- shamin
s$pvotedPR[c(ds$b7prtyb,ds$e1s7,ds$h1s7p,ds$k1s7)%in%5] <- kyosan
s$pvotedPR[c(ds$b7prtyb,ds$e1s7,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin
s$pvotedPR[c(ds$b7prtyb,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu
s$pvotedPR[c(ds$b7prtyb,ds$e1s7,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%8] <- sonota
s$pvotedPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$k1s7)%in%6] <- kokuminshin
s$pvotedPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$k1s7)%in%7] <- sonota
s$pvotedPR[c(ds$b7prtyb,ds$e1s7,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%9] <- sonota
s$pvotedPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$h1s7p,rep(NA,nrow(ds)))%in%c(8,9,10)] <- sonota
s$pvotedPR[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$k1s7)%in%8] <- sonota
s$pvotedPR <- factor(s$pvotedPR, levels=c(allps))
table(s$pvotedPR, s$year, useNA="always")

## Political Interest
table(ds$a24, useNA="always") # Political Interest
table(ds$d25, useNA="always") # Political Interest
table(ds$g27, useNA="always") # Political Interest
table(ds$j32, useNA="always") # Political Interest
s$polint <- ifelse(c(ds$a24,ds$d25,ds$g27,ds$j32)>=8,NA,
                   (4 - c(ds$a24,ds$d25,ds$g27,ds$j32))/3)
table(s$polint, s$year, useNA="always")

## Knowledge (Will be assigned)
s$kn <- NA

## Years of Residence 1:<=3yrs;2:4-9yrs;3:10-14yrs;4:>=15yrs;5:Since born
table(ds$residyr01, useNA="always") # Year of Residence
table(ds$residy03, useNA="always") # Year of Residence
table(ds$residy04, useNA="always") # Year of Residence
table(ds$residy05, useNA="always") # Year of Residence
s$residyr <- ifelse(c(ds$residyr01,ds$residy03,ds$residy04,ds$residy05)==9,NA,
                    (c(ds$residyr01,ds$residy03,ds$residy04,ds$residy05)-1)/4)
table(s$residyr, s$year, useNA="always")
table(s$residyr[s$answered==1], s$year[s$answered==1], useNA="always")

## Education 1:<=JHS;2:HS;3:Junior College/Higher Techinical;4:Univ/Grad School
table(ds$educat01, useNA="always") # Education
table(ds$educat03, useNA="always") # Education
table(ds$educat04, useNA="always") # Education
table(ds$educat05, useNA="always") # Education
s$edu <- ifelse(c(ds$educat01,ds$educat03,ds$educat04,ds$educat05)==9,NA,
                (c(ds$educat01,ds$educat03,ds$educat04,ds$educat05)-1)/3)
table(s$edu, s$year, useNA="always")
table(s$edu[s$answered==1], s$year[s$answered==1], useNA="always")

## Occupation 
## 1:Employed;2:Self-employed;3:Family-business;4:Student;5:Housewife;6:Unemployed;7:Other
table(ds$occup5a1, useNA="always") # Occupation
table(ds$occup5a3, useNA="always") # Occupation
table(ds$occup5a4, useNA="always") # Occupation
table(ds$occup5a5, useNA="always") # Occupation
s$employed <- ifelse(c(ds$occup5a1,ds$occup5a3,ds$occup5a4,ds$occup5a5)%in%c(1,2,3),1,
                     ifelse(c(ds$occup5a1,ds$occup5a3,ds$occup5a4,ds$occup5a5)%in%c(4,5,6),0,NA))
table(s$employed, s$year, useNA="always")
table(s$employed[s$answered==1], s$year[s$answered==1], useNA="always")

## Type of Home 
## 1:Private Home Owned; 2:COndominium owned; 3:Private Home Rent;
## 4:Private Apartment Rent; 5: Public Apartment Rent; 6:Company Apartment
## 7: Dormitory/Room Rent; 8: Others
table(ds$typeho01, useNA="always") # Type of Home
table(ds$typeho03, useNA="always") # Type of Home
table(ds$typeho04, useNA="always") # Type of Home
table(ds$typeho05, useNA="always") # Type of Home
s$ownhome <- ifelse(c(ds$typeho01,ds$typeho03,ds$typeho04,ds$typeho05)%in%c(1,2),1,
                    ifelse(c(ds$typeho01,ds$typeho03,ds$typeho04,ds$typeho05)%in%c(3,4,5,6,7),0,NA))
table(s$ownhome, s$year, useNA="always")
table(s$ownhome[s$answered==1], s$year[s$answered==1], useNA="always")
s$privatehome <- ifelse(c(ds$typeho01,ds$typeho03,ds$typeho04,ds$typeho05)%in%c(1,3),1,
                    ifelse(c(ds$typeho01,ds$typeho03,ds$typeho04,ds$typeho05)%in%c(2,4,5,6,7),0,NA))
table(s$privatehome, s$year, useNA="always")
table(s$privatehome[s$answered==1], s$year[s$answered==1], useNA="always")

## Household Income
## 1:<=200;2:200-400;3:400-600;4:600-800;5:800-1000;6:1000-1200;7:1200-1400;8:1400-2000;9>=2000
table(ds$hincome, useNA="always") # Household Income (9 cat)
table(ds$hincom03, useNA="always") # Household Income (9 cat)
table(ds$hincom04, useNA="always") # Household Income (12 cat)
table(ds$hincom05, useNA="always") # Household Income (9 cat)
s$income <- NA
s$income[s$year%in%c(2001,2003,2005)] <- 
  ifelse(c(ds$hincome,ds$hincom03,ds$hincom05)>9,NA,
         (c(ds$hincome,ds$hincom03,ds$hincom05)-1)/8)
s$income[s$year%in%c(2004)] <- (ds$hincom04-1)/11
table(s$income, s$year, useNA="always")
table(s$income[s$answered==1], s$year[s$answered==1], useNA="always")

## Network Variables ##

## Partner 1
table(ds$a45x1, useNA="always") # Partner 1 (1=Yes)
table(ds$d43x1, useNA="always") # Partner 1 (1=Yes)
table(ds$g45x1, useNA="always") # Partner 1 (1=Yes)
table(ds$j53x1, useNA="always") # Partner 1 (1=Yes)
s$net.1 <- ifelse(c(ds$a45x1,ds$d43x1,ds$g45x1,ds$j53x1)%in%1,1,0)
table(s$net.1, s$year, useNA="always")
table(s$net.1[s$answered==1], s$year[s$answered==1], useNA="always")

table(ds$a45x1a, useNA="always") # Have Spouse (1=Yes)
table(ds$d43x1a, useNA="always") # Have Spouse (1=Yes)
#table(, useNA="always") # Have Spouse (1=Yes)
table(ds$j53x1a, useNA="always") # Have Spouse (1=Yes)

table(ds$a45x1s1, useNA="always") # Relationship with P1
table(ds$d43x1s1, useNA="always") # Relationship with P1
table(ds$g45x1s1, useNA="always") # Relationship with P1
table(ds$j53x1s1, useNA="always") # Relationship with P1
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
s$netfa.1 <- ifelse(c(ds$a45x1s1,ds$d43x1s1,ds$g45x1s1,ds$j53x1s1)%in%c(1,2,3),1,0)
s$netwk.1 <- ifelse(c(ds$a45x1s1,ds$d43x1s1,ds$g45x1s1,ds$j53x1s1)%in%4,1,0)
s$netfr.1 <- ifelse(c(ds$a45x1s1,ds$d43x1s1,ds$g45x1s1,ds$j53x1s1)%in%8,1,0)
table(s$netfa.1[s$net.1==1], s$year[s$net.1==1], useNA="always")
table(s$netwk.1[s$net.1==1], s$year[s$net.1==1], useNA="always")
table(s$netfr.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

table(ds$a45x1s2, useNA="always") # Gender of P1
table(ds$d43x1s2, useNA="always") # Gender of P1
table(ds$g45x1s2, useNA="always") # Gender of P1
table(ds$j53x1s2, useNA="always") # Gender of P1
s$netfem.1 <- ifelse(c(ds$a45x1s2,ds$d43x1s2,ds$g45x1s2,ds$j53x1s2)%in%2,1,
                     ifelse(c(ds$a45x1s2,ds$d43x1s2,ds$g45x1s2,ds$j53x1s2)%in%1,0,NA))
table(s$netfem.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

s$netage.1 <- NA

table(ds$a45x1s3, useNA="always") # Closeness of P1 (Not asked for family)
#table(, useNA="always") # Closeness of P1
#table(, useNA="always") # Closeness of P1
#table(, useNA="always") # Closeness of P1
# 1=very close, 2=somewhat close, 3=not very close
s$netclose.1 <- ifelse(c(ds$a45x1s3,rep(NA,nrow(ds)*3))%in%c(8,9),NA,
                       (3 - c(ds$a45x1s3,rep(NA,nrow(ds)*3)))/2)
table(s$netclose.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

s$netfreq.1 <- NA

table(ds$a45x1s4, useNA="always") # Pol. Discussion with P1
table(ds$d43x1s3, useNA="always") # Pol. Discussion with P1
table(ds$g45x1s3, useNA="always") # Pol. Discussion with P1
table(ds$j53x1s3, useNA="always") # Pol. Discussion with P1
# 1=a lot, 2=some, 3=not much
s$netpoldis.1 <- ifelse(c(ds$a45x1s4,ds$d43x1s3,ds$g45x1s3,ds$j53x1s3)%in%c(8,9),NA,
                        (3 - c(ds$a45x1s4,ds$d43x1s3,ds$g45x1s3,ds$j53x1s3))/2)
table(s$netpoldis.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

table(ds$a45x1s5, useNA="always") # Watch/Read News Together with P1
# table(, useNA="always") # Watch/Read News Together with P1
# table(, useNA="always") # Watch/Read News Together with P1
# table(, useNA="always") # Watch/Read News Together with P1
# 1=often, 2=sometimes, 3=not often
s$netwatchnews.1 <- ifelse(c(ds$a45x1s5,rep(NA,nrow(ds)*3))%in%c(8,9),NA,
                           (3 - c(ds$a45x1s5,rep(NA,nrow(ds)*3)))/2)
table(s$netwatchnews.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

table(ds$a45x1s6, useNA="always") # Perceived Pol. Knowledge of P1
table(ds$d43x1s4, useNA="always") # Perceived Pol. Knowledge of P1
table(ds$g45x1s4, useNA="always") # Perceived Pol. Knowledge of P1
table(ds$j53x1s4, useNA="always") # Perceived Pol. Knowledge of P1
# 1=a lot, 2=some, 3=not much
s$netknow.1 <- ifelse(c(ds$a45x1s6,ds$d43x1s4,ds$g45x1s4,ds$j53x1s4)%in%c(8,9),NA,
                      (3 - c(ds$a45x1s6,ds$d43x1s4,ds$g45x1s4,ds$j53x1s4))/2)
table(s$netknow.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

table(ds$a45x1s7, useNA="always") # Expected Vote Choice of P1
table(ds$d43x1s5, useNA="always") # Expected Vote Choice of P1
table(ds$g45x1s5, useNA="always") # Expected Vote Choice of P1
table(ds$j53x1s5, useNA="always") # Expected Vote Choice of P1
s$netpvote.1 <- NA
s$netpvote.1[c(ds$a45x1s7,ds$d43x1s5,ds$g45x1s5,ds$j53x1s5)%in%1] <- jimin
s$netpvote.1[c(ds$a45x1s7,ds$d43x1s5,ds$g45x1s5,ds$j53x1s5)%in%2] <- minshu
s$netpvote.1[c(ds$a45x1s7,ds$d43x1s5,ds$g45x1s5,ds$j53x1s5)%in%3] <- komei
s$netpvote.1[c(ds$a45x1s7,ds$d43x1s5,ds$g45x1s5,ds$j53x1s5)%in%4] <- shamin
s$netpvote.1[c(ds$a45x1s7,ds$d43x1s5,ds$g45x1s5,ds$j53x1s5)%in%5] <- kyosan
s$netpvote.1[c(ds$a45x1s7,ds$d43x1s5,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin
s$netpvote.1[c(ds$a45x1s7,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu
s$netpvote.1[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),ds$j53x1s5)%in%6] <- kokuminshin
s$netpvote.1[c(ds$a45x1s7,rep(NA,nrow(ds)*3))%in%8] <- sonota
s$netpvote.1[c(rep(NA,nrow(ds)),ds$d43x1s5,rep(NA,nrow(ds)),ds$j53x1s5)%in%7] <- sonota
s$netpvote.1[c(rep(NA,nrow(ds)*2),ds$g45x1s5,rep(NA,nrow(ds)))%in%6] <- sonota
s$netpvote.1[c(ds$a45x1s7,rep(NA,nrow(ds)*3))%in%c(88,99)] <- shiranai
s$netpvote.1[c(rep(NA,nrow(ds)),ds$d43x1s5,ds$g45x1s5,ds$j53x1s5)%in%c(8,9)] <- shiranai
s$netpvote.1 <- factor(s$netpvote.1, levels=c(allps,kiken,shiranai))
table(s$netpvote.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

table(ds$a45x1s8, useNA="always") # Expected Koizumi Support of P1
table(ds$d43x1s6, useNA="always") # Expected Koizumi Support of P1
table(ds$g45x1s6, useNA="always") # Expected Koizumi Support of P1
table(ds$j53x1s6, useNA="always") # Expected Koizumi Support of P1
# 1=yes, 2=no
s$netpmsup.1 <- ifelse(c(ds$a45x1s8,ds$d43x1s6,ds$g45x1s6,ds$j53x1s6)%in%c(8,9),NA,
                       (2 - c(ds$a45x1s8,ds$d43x1s6,ds$g45x1s6,ds$j53x1s6)))
table(s$netpmsup.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

table(ds$a45x1s9, useNA="always") # Similarity with P1
table(ds$d43x1s7, useNA="always") # Similarity with P1
table(ds$g45x1s8, useNA="always") # Similarity with P1
table(ds$j53x1s7, useNA="always") # Similarity with P1
# 1=yes, 2=no
s$netsim.1 <- ifelse(c(ds$a45x1s9,ds$d43x1s7,ds$g45x1s8,ds$j53x1s7)%in%c(8,9),NA,
                     (2 - c(ds$a45x1s9,ds$d43x1s7,ds$g45x1s8,ds$j53x1s7)))
table(s$netsim.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

table(ds$a45x1s10, useNA="always") # Relative Social Status of P1
table(ds$d43x1s8, useNA="always") # Relative Social Status of P1
table(ds$g45x1s9, useNA="always") # Relative Social Status of P1
table(ds$j53x1s8, useNA="always") # Relative Social Status of P1
# 1=yes, 2=no
s$netstat.1 <- ifelse(c(ds$a45x1s10,ds$d43x1s8,ds$g45x1s9,ds$j53x1s8)%in%c(3,4,8,9),0.5,
                      (2 - c(ds$a45x1s10,ds$d43x1s8,ds$g45x1s9,ds$j53x1s8)))
table(s$netstat.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

# table(, useNA="always") # Difference in Opinions with P1
# table(, useNA="always") # Difference in Opinions with P1
table(ds$g45x1s7, useNA="always") # Difference in Opinions with P1
# table(, useNA="always") # Difference in Opinions with P1
# 1=frequently, 2=sometimes, 3=no
s$netdif.1 <- ifelse(c(rep(NA,nrow(ds)*2),ds$g45x1s7,rep(NA,nrow(ds)))%in%c(8,9),NA,
                     ifelse(c(rep(NA,nrow(ds)*2),ds$g45x1s7,rep(NA,nrow(ds)))<=2,1,0))
table(s$netdif.1[s$net.1==1], s$year[s$net.1==1], useNA="always")

## Partner 2
table(ds$a45x2, useNA="always") # Partner 2 (1=Yes)
table(ds$d43x2, useNA="always") # Partner 2 (1=Yes)
table(ds$g45x2, useNA="always") # Partner 2 (1=Yes)
table(ds$j53x2, useNA="always") # Partner 2 (1=Yes)
s$net.2 <- ifelse(c(ds$a45x2,ds$d43x2,ds$g45x2,ds$j53x2)%in%1,1,0)
table(s$net.2, s$year, useNA="always")
table(s$net.2[s$answered==1], s$year[s$answered==1], useNA="always")

table(ds$a45x2a1, useNA="always") # Partner 2 Check if Spouse (1=Yes)
table(ds$d43x2a1, useNA="always") # Partner 2 Check if Spouse (1=Yes)
# table(, useNA="always") # Partner 2 Check if Spouse (1=Yes)
table(ds$j53x2a1, useNA="always") # Partner 2 Check if Spouse (1=Yes)

table(ds$a45x2a2, useNA="always") # Have Spouse (1=Yes)
table(ds$d43x2a2, useNA="always") # Have Spouse (1=Yes)
#table(, useNA="always") # Have Spouse (1=Yes)
table(ds$j53x2a2, useNA="always") # Have Spouse (1=Yes)

table(ds$a45x2s1, useNA="always") # Relationship with P2
table(ds$d43x2s1, useNA="always") # Relationship with P2
table(ds$g45x2s1, useNA="always") # Relationship with P2
table(ds$j53x2s1, useNA="always") # Relationship with P2
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
s$netfa.2 <- ifelse(c(ds$a45x2s1,ds$d43x2s1,ds$g45x2s1,ds$j53x2s1)%in%c(1,2,3),1,0)
s$netwk.2 <- ifelse(c(ds$a45x2s1,ds$d43x2s1,ds$g45x2s1,ds$j53x2s1)%in%4,1,0)
s$netfr.2 <- ifelse(c(ds$a45x2s1,ds$d43x2s1,ds$g45x2s1,ds$j53x2s1)%in%8,1,0)
table(s$netfa.2[s$net.2==1], s$year[s$net.2==1], useNA="always")
table(s$netwk.2[s$net.2==1], s$year[s$net.2==1], useNA="always")
table(s$netfr.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

table(ds$a45x2s2, useNA="always") # Gender of P2
table(ds$d43x2s2, useNA="always") # Gender of P2
table(ds$g45x2s2, useNA="always") # Gender of P2
table(ds$j53x2s2, useNA="always") # Gender of P2
s$netfem.2 <- ifelse(c(ds$a45x2s2,ds$d43x2s2,ds$g45x2s2,ds$j53x2s2)%in%2,1,
                     ifelse(c(ds$a45x2s2,ds$d43x2s2,ds$g45x2s2,ds$j53x2s2)%in%1,0,NA))
table(s$netfem.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

s$netage.2 <- NA

table(ds$a45x2s3, useNA="always") # Closeness of P2
#table(, useNA="always") # Closeness of P2
#table(, useNA="always") # Closeness of P2
#table(, useNA="always") # Closeness of P2
s$netclose.2 <- ifelse(c(ds$a45x2s3,rep(NA,nrow(ds)*3))%in%c(8,9),NA,
                       (3 - c(ds$a45x2s3,rep(NA,nrow(ds)*3)))/2)
table(s$netclose.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

s$netfreq.2 <- NA

table(ds$a45x2s4, useNA="always") # Pol. Discussion with P2
table(ds$d43x2s3, useNA="always") # Pol. Discussion with P2
table(ds$g45x2s3, useNA="always") # Pol. Discussion with P2
table(ds$j53x2s3, useNA="always") # Pol. Discussion with P2
# 1=a lot, 2=some, 3=not much
s$netpoldis.2 <- ifelse(c(ds$a45x2s4,ds$d43x2s3,ds$g45x2s3,ds$j53x2s3)%in%c(8,9),NA,
                        (3 - c(ds$a45x2s4,ds$d43x2s3,ds$g45x2s3,ds$j53x2s3))/2)
table(s$netpoldis.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

table(ds$a45x2s5, useNA="always") # Watch/Read News Together with P2
# table(, useNA="always") # Watch/Read News Together with P2
# table(, useNA="always") # Watch/Read News Together with P2
# table(, useNA="always") # Watch/Read News Together with P2
s$netwatchnews.2 <- ifelse(c(ds$a45x2s5,rep(NA,nrow(ds)*3))%in%c(8,9),NA,
                           (3 - c(ds$a45x2s5,rep(NA,nrow(ds)*3)))/2)
table(s$netwatchnews.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

table(ds$a45x2s6, useNA="always") # Perceived Pol. Knowledge of P2
table(ds$d43x2s4, useNA="always") # Perceived Pol. Knowledge of P2
table(ds$g45x2s4, useNA="always") # Perceived Pol. Knowledge of P2
table(ds$j53x2s4, useNA="always") # Perceived Pol. Knowledge of P2
# 1=a lot, 2=some, 3=not much
s$netknow.2 <- ifelse(c(ds$a45x2s6,ds$d43x2s4,ds$g45x2s4,ds$j53x2s4)%in%c(8,9),NA,
                      (3 - c(ds$a45x2s6,ds$d43x2s4,ds$g45x2s4,ds$j53x2s4))/2)
table(s$netknow.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

table(ds$a45x2s7, useNA="always") # Expected Vote Choice of P2
table(ds$d43x2s5, useNA="always") # Expected Vote Choice of P2
table(ds$g45x2s5, useNA="always") # Expected Vote Choice of P2
table(ds$j53x2s5, useNA="always") # Expected Vote Choice of P2
s$netpvote.2 <- NA
s$netpvote.2[c(ds$a45x2s7,ds$d43x2s5,as.numeric(ds$g45x2s5),as.numeric(ds$j53x2s5))%in%1] <- jimin
s$netpvote.2[c(ds$a45x2s7,ds$d43x2s5,as.numeric(ds$g45x2s5),as.numeric(ds$j53x2s5))%in%2] <- minshu
s$netpvote.2[c(ds$a45x2s7,ds$d43x2s5,as.numeric(ds$g45x2s5),as.numeric(ds$j53x2s5))%in%3] <- komei
s$netpvote.2[c(ds$a45x2s7,ds$d43x2s5,as.numeric(ds$g45x2s5),as.numeric(ds$j53x2s5))%in%4] <- shamin
s$netpvote.2[c(ds$a45x2s7,ds$d43x2s5,as.numeric(ds$g45x2s5),as.numeric(ds$j53x2s5))%in%5] <- kyosan
s$netpvote.2[c(ds$a45x2s7,ds$d43x2s5,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin
s$netpvote.2[c(ds$a45x2s7,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu
s$netpvote.2[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),as.numeric(ds$j53x2s5))%in%6] <- kokuminshin
s$netpvote.2[c(ds$a45x2s7,rep(NA,nrow(ds)*3))%in%8] <- sonota
s$netpvote.2[c(rep(NA,nrow(ds)),ds$d43x2s5,rep(NA,nrow(ds)),as.numeric(ds$j53x2s5))%in%7] <- sonota
s$netpvote.2[c(rep(NA,nrow(ds)*2),as.numeric(ds$g45x2s5),rep(NA,nrow(ds)))%in%6] <- sonota
s$netpvote.2[c(ds$a45x2s7,rep(NA,nrow(ds)*3))%in%c(88,99)] <- shiranai
s$netpvote.2[c(rep(NA,nrow(ds)),ds$d43x2s5,as.numeric(ds$g45x2s5),as.numeric(ds$j53x2s5))%in%c(8,9)] <- shiranai
s$netpvote.2 <- factor(s$netpvote.2, levels=c(allps,kiken,shiranai))
table(s$netpvote.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

table(ds$a45x2s8, useNA="always") # Expected Koizumi Support of P2
table(ds$d43x2s6, useNA="always") # Expected Koizumi Support of P2
table(ds$g45x2s6, useNA="always") # Expected Koizumi Support of P2
table(ds$j53x2s6, useNA="always") # Expected Koizumi Support of P2
# 1=yes, 2=no
s$netpmsup.2 <- ifelse(c(ds$a45x2s8,ds$d43x2s6,ds$g45x2s6,ds$j53x2s6)%in%c(8,9),NA,
                       (2 - c(ds$a45x2s8,ds$d43x2s6,ds$g45x2s6,ds$j53x2s6)))
table(s$netpmsup.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

table(ds$a45x2s9, useNA="always") # Similarity with P2
table(ds$d43x2s7, useNA="always") # Similarity with P2
table(ds$g45x2s8, useNA="always") # Similarity with P2
table(ds$j53x2s7, useNA="always") # Similarity with P2
# 1=yes, 2=no
s$netsim.2 <- ifelse(c(ds$a45x2s9,ds$d43x2s7,ds$g45x2s8,ds$j53x2s7)%in%c(8,9),NA,
                     (2 - c(ds$a45x2s9,ds$d43x2s7,ds$g45x2s8,ds$j53x2s7)))
table(s$netsim.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

table(ds$a45x2s10, useNA="always") # Relative Social Status of P2
table(ds$d43x2s8, useNA="always") # Relative Social Status of P2
table(ds$g45x2s9, useNA="always") # Relative Social Status of P2
table(ds$j53x2s8, useNA="always") # Relative Social Status of P2
# 1=yes, 2=no
s$netstat.2 <- ifelse(c(ds$a45x2s10,ds$d43x2s8,ds$g45x2s9,ds$j53x2s8)%in%c(3,4,8,9),0.5,
                      (2 - c(ds$a45x2s10,ds$d43x2s8,ds$g45x2s9,ds$j53x2s8)))
table(s$netstat.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

# table(, useNA="always") # Difference in Opinions with P2
# table(, useNA="always") # Difference in Opinions with P2
table(ds$g45x2s7, useNA="always") # Difference in Opinions with P2
# table(, useNA="always") # Difference in Opinions with P2
# 1=frequently, 2=sometimes, 3=no
s$netdif.2 <- ifelse(c(rep(NA,nrow(ds)*2),ds$g45x2s7,rep(NA,nrow(ds)))%in%c(8,9),NA,
                     ifelse(c(rep(NA,nrow(ds)*2),ds$g45x2s7,rep(NA,nrow(ds)))<=2,1,0))
table(s$netdif.2[s$net.2==1], s$year[s$net.2==1], useNA="always")

## Partner 3
table(ds$a45x3, useNA="always") # Partner 3 (1=Yes)
table(ds$d43x3, useNA="always") # Partner 3 (1=Yes)
table(ds$g45x3, useNA="always") # Partner 3 (1=Yes)
table(ds$j53x3, useNA="always") # Partner 3 (1=Yes)
s$net.3 <- ifelse(c(ds$a45x3,ds$d43x3,ds$g45x3,ds$j53x3)%in%1,1,0)
table(s$net.3, s$year, useNA="always")
table(s$net.3[s$answered==1], s$year[s$answered==1], useNA="always")

table(ds$a45x3a1, useNA="always") # Partner 3 Check if Spouse (1=Yes)
table(ds$d43x3a1, useNA="always") # Partner 3 Check if Spouse (1=Yes)
# table(, useNA="always") # Partner 3 Check if Spouse (1=Yes)
table(ds$j53x3a1, useNA="always") # Partner 3 Check if Spouse (1=Yes)

table(ds$a45x3a2, useNA="always") # Have Spouse (1=Yes)
table(ds$d43x3a2, useNA="always") # Have Spouse (1=Yes)
#table(, useNA="always") # Have Spouse (1=Yes)
table(ds$j53x3a2, useNA="always") # Have Spouse (1=Yes)

table(ds$a45x3s1, useNA="always") # Relationship with P3
table(ds$d43x3s1, useNA="always") # Relationship with P3
table(ds$g45x3s1, useNA="always") # Relationship with P3
table(ds$j53x3s1, useNA="always") # Relationship with P3
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
s$netfa.3 <- ifelse(c(ds$a45x3s1,ds$d43x3s1,ds$g45x3s1,ds$j53x3s1)%in%c(1,2,3),1,0)
s$netwk.3 <- ifelse(c(ds$a45x3s1,ds$d43x3s1,ds$g45x3s1,ds$j53x3s1)%in%4,1,0)
s$netfr.3 <- ifelse(c(ds$a45x3s1,ds$d43x3s1,ds$g45x3s1,ds$j53x3s1)%in%8,1,0)
table(s$netfa.3[s$net.3==1], s$year[s$net.3==1], useNA="always")
table(s$netwk.3[s$net.3==1], s$year[s$net.3==1], useNA="always")
table(s$netfr.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

table(ds$a45x3s2, useNA="always") # Gender of P3
table(ds$d43x3s2, useNA="always") # Gender of P3
table(ds$g45x3s2, useNA="always") # Gender of P3
table(ds$j53x3s2, useNA="always") # Gender of P3
s$netfem.3 <- ifelse(c(ds$a45x3s2,ds$d43x3s2,ds$g45x3s2,ds$j53x3s2)%in%2,1,
                     ifelse(c(ds$a45x3s2,ds$d43x3s2,ds$g45x3s2,ds$j53x3s2)%in%1,0,NA))
table(s$netfem.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

s$netage.3 <- NA

table(ds$a45x3s3, useNA="always") # Closeness of P3
#table(, useNA="always") # Closeness of P3
#table(, useNA="always") # Closeness of P3
#table(, useNA="always") # Closeness of P3
s$netclose.3 <- ifelse(c(ds$a45x3s3,rep(NA,nrow(ds)*3))%in%c(8,9),NA,
                       (3 - c(ds$a45x3s3,rep(NA,nrow(ds)*3)))/2)
table(s$netclose.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

s$netfreq.3 <- NA

table(ds$a45x3s4, useNA="always") # Pol. Discussion with P3
table(ds$d43x3s3, useNA="always") # Pol. Discussion with P3
table(ds$g45x3s3, useNA="always") # Pol. Discussion with P3
table(ds$j53x3s3, useNA="always") # Pol. Discussion with P3
# 1=a lot, 2=some, 3=not much
s$netpoldis.3 <- ifelse(c(ds$a45x3s4,ds$d43x3s3,ds$g45x3s3,ds$j53x3s3)%in%c(8,9),NA,
                        (3 - c(ds$a45x3s4,ds$d43x3s3,ds$g45x3s3,ds$j53x3s3))/2)
table(s$netpoldis.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

table(ds$a45x3s5, useNA="always") # Watch/Read News Together with P3
# table(, useNA="always") # Watch/Read News Together with P3
# table(, useNA="always") # Watch/Read News Together with P3
# table(, useNA="always") # Watch/Read News Together with P3
s$netwatchnews.3 <- ifelse(c(ds$a45x3s5,rep(NA,nrow(ds)*3))%in%c(8,9),NA,
                           (3 - c(ds$a45x3s5,rep(NA,nrow(ds)*3)))/2)
table(s$netwatchnews.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

table(ds$a45x3s6, useNA="always") # Perceived Pol. Knowledge of P3
table(ds$d43x3s4, useNA="always") # Perceived Pol. Knowledge of P3
table(ds$g45x3s4, useNA="always") # Perceived Pol. Knowledge of P3
table(ds$j53x3s4, useNA="always") # Perceived Pol. Knowledge of P3
# 1=a lot, 2=some, 3=not much
s$netknow.3 <- ifelse(c(ds$a45x3s6,ds$d43x3s4,ds$g45x3s4,ds$j53x3s4)%in%c(8,9),NA,
                      (3 - c(ds$a45x3s6,ds$d43x3s4,ds$g45x3s4,ds$j53x3s4))/2)
table(s$netknow.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

table(ds$a45x3s7, useNA="always") # Expected Vote Choice of P3
table(ds$d43x3s5, useNA="always") # Expected Vote Choice of P3
table(ds$g45x3s5, useNA="always") # Expected Vote Choice of P3
table(ds$j53x3s5, useNA="always") # Expected Vote Choice of P3
s$netpvote.3 <- NA
s$netpvote.3[c(ds$a45x3s7,ds$d43x3s5,as.numeric(ds$g45x3s5),as.numeric(ds$j53x3s5))%in%1] <- jimin
s$netpvote.3[c(ds$a45x3s7,ds$d43x3s5,as.numeric(ds$g45x3s5),as.numeric(ds$j53x3s5))%in%2] <- minshu
s$netpvote.3[c(ds$a45x3s7,ds$d43x3s5,as.numeric(ds$g45x3s5),as.numeric(ds$j53x3s5))%in%3] <- komei
s$netpvote.3[c(ds$a45x3s7,ds$d43x3s5,as.numeric(ds$g45x3s5),as.numeric(ds$j53x3s5))%in%4] <- shamin
s$netpvote.3[c(ds$a45x3s7,ds$d43x3s5,as.numeric(ds$g45x3s5),as.numeric(ds$j53x3s5))%in%5] <- kyosan
s$netpvote.3[c(ds$a45x3s7,ds$d43x3s5,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin
s$netpvote.3[c(ds$a45x3s7,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu
s$netpvote.3[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),as.numeric(ds$j53x3s5))%in%6] <- kokuminshin
s$netpvote.3[c(ds$a45x3s7,rep(NA,nrow(ds)*3))%in%8] <- sonota
s$netpvote.3[c(rep(NA,nrow(ds)),ds$d43x3s5,rep(NA,nrow(ds)),as.numeric(ds$j53x3s5))%in%7] <- sonota
s$netpvote.3[c(rep(NA,nrow(ds)*2),as.numeric(ds$g45x3s5),rep(NA,nrow(ds)))%in%6] <- sonota
s$netpvote.3[c(ds$a45x3s7,rep(NA,nrow(ds)*3))%in%c(88,99)] <- shiranai
s$netpvote.3[c(rep(NA,nrow(ds)),ds$d43x3s5,as.numeric(ds$g45x3s5),as.numeric(ds$j53x3s5))%in%c(8,9)] <- shiranai
s$netpvote.3 <- factor(s$netpvote.3, levels=c(allps,kiken,shiranai))
table(s$netpvote.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

table(ds$a45x3s8, useNA="always") # Expected Koizumi Support of P3
table(ds$d43x3s6, useNA="always") # Expected Koizumi Support of P3
table(ds$g45x3s6, useNA="always") # Expected Koizumi Support of P3
table(ds$j53x3s6, useNA="always") # Expected Koizumi Support of P3
# 1=yes, 2=no
s$netpmsup.3 <- ifelse(c(ds$a45x3s8,ds$d43x3s6,ds$g45x3s6,ds$j53x3s6)%in%c(8,9),NA,
                       (2 - c(ds$a45x3s8,ds$d43x3s6,ds$g45x3s6,ds$j53x3s6)))
table(s$netpmsup.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

table(ds$a45x3s9, useNA="always") # Similarity with P3
table(ds$d43x3s7, useNA="always") # Similarity with P3
table(ds$g45x3s8, useNA="always") # Similarity with P3
table(ds$j53x3s7, useNA="always") # Similarity with P3
# 1=yes, 2=no
s$netsim.3 <- ifelse(c(ds$a45x3s9,ds$d43x3s7,ds$g45x3s8,ds$j53x3s7)%in%c(8,9),NA,
                     (2 - c(ds$a45x3s9,ds$d43x3s7,ds$g45x3s8,ds$j53x3s7)))
table(s$netsim.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

table(ds$a45x3s10, useNA="always") # Relative Social Status of P3
table(ds$d43x3s8, useNA="always") # Relative Social Status of P3
table(ds$g45x3s9, useNA="always") # Relative Social Status of P3
table(ds$j53x3s8, useNA="always") # Relative Social Status of P3
# 1=yes, 2=no
s$netstat.3 <- ifelse(c(ds$a45x3s10,ds$d43x3s8,ds$g45x3s9,ds$j53x3s8)%in%c(3,4,8,9),0.5,
                      (2 - c(ds$a45x3s10,ds$d43x3s8,ds$g45x3s9,ds$j53x3s8)))
table(s$netstat.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

# table(, useNA="always") # Difference in Opinions with P3
# table(, useNA="always") # Difference in Opinions with P3
table(ds$g45x3s7, useNA="always") # Difference in Opinions with P3
# table(, useNA="always") # Difference in Opinions with P3
# 1=frequently, 2=sometimes, 3=no
s$netdif.3 <- ifelse(c(rep(NA,nrow(ds)*2),ds$g45x3s7,rep(NA,nrow(ds)))%in%c(8,9),NA,
                     ifelse(c(rep(NA,nrow(ds)*2),ds$g45x3s7,rep(NA,nrow(ds)))<=2,1,0))
table(s$netdif.3[s$net.3==1], s$year[s$net.3==1], useNA="always")

## Partner 4
table(ds$a45x4, useNA="always") # Partner 4 (1=Yes)
table(ds$d43x4, useNA="always") # Partner 4 (1=Yes)
table(ds$g45x4, useNA="always") # Partner 4 (1=Yes)
table(ds$j53x4, useNA="always") # Partner 4 (1=Yes)
s$net.4 <- ifelse(c(ds$a45x4,ds$d43x4,ds$g45x4,ds$j53x4)%in%1,1,0)
table(s$net.4, s$year, useNA="always")
table(s$net.4[s$answered==1], s$year[s$answered==1], useNA="always")

table(ds$a45x4a1, useNA="always") # Partner 4 Check if Spouse (1=Yes)
table(ds$d43x4a1, useNA="always") # Partner 4 Check if Spouse (1=Yes)
# table(, useNA="always") # Partner 4 Check if Spouse (1=Yes)
table(ds$j53x4a1, useNA="always") # Partner 4 Check if Spouse (1=Yes)

table(ds$a45x4a2, useNA="always") # Have Spouse (1=Yes)
table(ds$d43x4a2, useNA="always") # Have Spouse (1=Yes)
#table(, useNA="always") # Have Spouse (1=Yes)
table(ds$j53x4a2, useNA="always") # Have Spouse (1=Yes)

table(ds$a45x4s1, useNA="always") # Relationship with P4
table(ds$d43x4s1, useNA="always") # Relationship with P4
table(ds$g45x4s1, useNA="always") # Relationship with P4
table(ds$j53x4s1, useNA="always") # Relationship with P4
# 1=spouse, 2=family, 3=relative, 4=coworker, 5=leisure/activity, 7=neighbor, 8=friend, 9=other
s$netfa.4 <- ifelse(c(ds$a45x4s1,ds$d43x4s1,ds$g45x4s1,ds$j53x4s1)%in%c(1,2,3),1,0)
s$netwk.4 <- ifelse(c(ds$a45x4s1,ds$d43x4s1,ds$g45x4s1,ds$j53x4s1)%in%4,1,0)
s$netfr.4 <- ifelse(c(ds$a45x4s1,ds$d43x4s1,ds$g45x4s1,ds$j53x4s1)%in%8,1,0)
table(s$netfa.4[s$net.4==1], s$year[s$net.4==1], useNA="always")
table(s$netwk.4[s$net.4==1], s$year[s$net.4==1], useNA="always")
table(s$netfr.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

table(ds$a45x4s2, useNA="always") # Gender of P4
table(ds$d43x4s2, useNA="always") # Gender of P4
table(ds$g45x4s2, useNA="always") # Gender of P4
table(ds$j53x4s2, useNA="always") # Gender of P4
s$netfem.4 <- ifelse(c(ds$a45x4s2,ds$d43x4s2,ds$g45x4s2,ds$j53x4s2)%in%2,1,
                     ifelse(c(ds$a45x4s2,ds$d43x4s2,ds$g45x4s2,ds$j53x4s2)%in%1,0,NA))
table(s$netfem.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

s$netage.4 <- NA

table(ds$a45x4s3, useNA="always") # Closeness of P4
# table(, useNA="always") # Closeness of P4
#table(, useNA="always") # Closeness of P4
#table(, useNA="always") # Closeness of P4
s$netclose.4 <- ifelse(c(ds$a45x4s3,rep(NA,nrow(ds)*3))%in%c(8,9),NA,
                       (3 - c(ds$a45x4s3,rep(NA,nrow(ds)*3)))/2)
table(s$netclose.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

s$netfreq.4 <- NA

table(ds$a45x4s4, useNA="always") # Pol. Discussion with P4
table(ds$d43x4s3, useNA="always") # Pol. Discussion with P4
table(ds$g45x4s3, useNA="always") # Pol. Discussion with P4
table(ds$j53x4s3, useNA="always") # Pol. Discussion with P4
# 1=a lot, 2=some, 3=not much
s$netpoldis.4 <- ifelse(c(ds$a45x4s4,ds$d43x4s3,ds$g45x4s3,ds$j53x4s3)%in%c(8,9),NA,
                        (3 - c(ds$a45x4s4,ds$d43x4s3,ds$g45x4s3,ds$j53x4s3))/2)
table(s$netpoldis.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

table(ds$a45x4s5, useNA="always") # Watch/Read News Together with P4
# table(, useNA="always") # Watch/Read News Together with P4
# table(, useNA="always") # Watch/Read News Together with P4
# table(, useNA="always") # Watch/Read News Together with P4
s$netwatchnews.4 <- ifelse(c(ds$a45x4s5,rep(NA,nrow(ds)*3))%in%c(8,9),NA,
                           (3 - c(ds$a45x4s5,rep(NA,nrow(ds)*3)))/2)
table(s$netwatchnews.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

table(ds$a45x4s6, useNA="always") # Perceived Pol. Knowledge of P4
table(ds$d43x4s4, useNA="always") # Perceived Pol. Knowledge of P4
table(ds$g45x4s4, useNA="always") # Perceived Pol. Knowledge of P4
table(ds$j53x4s4, useNA="always") # Perceived Pol. Knowledge of P4
# 1=a lot, 2=some, 3=not much
s$netknow.4 <- ifelse(c(ds$a45x4s6,ds$d43x4s4,ds$g45x4s4,ds$j53x4s4)%in%c(8,9),NA,
                      (3 - c(ds$a45x4s6,ds$d43x4s4,ds$g45x4s4,ds$j53x4s4))/2)
table(s$netknow.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

table(ds$a45x4s7, useNA="always") # Expected Vote Choice of P4
table(ds$d43x4s5, useNA="always") # Expected Vote Choice of P4
table(ds$g45x4s5, useNA="always") # Expected Vote Choice of P4
table(ds$j53x4s5, useNA="always") # Expected Vote Choice of P4
s$netpvote.4 <- NA
s$netpvote.4[c(ds$a45x4s7,ds$d43x4s5,as.numeric(ds$g45x4s5),as.numeric(ds$j53x4s5))%in%1] <- jimin
s$netpvote.4[c(ds$a45x4s7,ds$d43x4s5,as.numeric(ds$g45x4s5),as.numeric(ds$j53x4s5))%in%2] <- minshu
s$netpvote.4[c(ds$a45x4s7,ds$d43x4s5,as.numeric(ds$g45x4s5),as.numeric(ds$j53x4s5))%in%3] <- komei
s$netpvote.4[c(ds$a45x4s7,ds$d43x4s5,as.numeric(ds$g45x4s5),as.numeric(ds$j53x4s5))%in%4] <- shamin
s$netpvote.4[c(ds$a45x4s7,ds$d43x4s5,as.numeric(ds$g45x4s5),as.numeric(ds$j53x4s5))%in%5] <- kyosan
s$netpvote.4[c(ds$a45x4s7,ds$d43x4s5,rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%6] <- hoshushin
s$netpvote.4[c(ds$a45x4s7,rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)))%in%7] <- jiyu
s$netpvote.4[c(rep(NA,nrow(ds)),rep(NA,nrow(ds)),rep(NA,nrow(ds)),as.numeric(ds$j53x4s5))%in%6] <- kokuminshin
s$netpvote.4[c(ds$a45x4s7,rep(NA,nrow(ds)*3))%in%8] <- sonota
s$netpvote.4[c(rep(NA,nrow(ds)),ds$d43x4s5,rep(NA,nrow(ds)),as.numeric(ds$j53x4s5))%in%7] <- sonota
s$netpvote.4[c(rep(NA,nrow(ds)*2),as.numeric(ds$g45x4s5),rep(NA,nrow(ds)))%in%6] <- sonota
s$netpvote.4[c(ds$a45x4s7,rep(NA,nrow(ds)*3))%in%c(88,99)] <- shiranai
s$netpvote.4[c(rep(NA,nrow(ds)),ds$d43x4s5,as.numeric(ds$g45x4s5),as.numeric(ds$j53x4s5))%in%c(8,9)] <- shiranai
s$netpvote.4 <- factor(s$netpvote.4, levels=c(allps,kiken,shiranai))
table(s$netpvote.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

table(ds$a45x4s8, useNA="always") # Expected Koizumi Support of P4
table(ds$d43x4s6, useNA="always") # Expected Koizumi Support of P4
table(ds$g45x4s6, useNA="always") # Expected Koizumi Support of P4
table(ds$j53x4s6, useNA="always") # Expected Koizumi Support of P4
# 1=yes, 2=no
s$netpmsup.4 <- ifelse(c(ds$a45x4s8,ds$d43x4s6,ds$g45x4s6,ds$j53x4s6)%in%c(8,9),NA,
                       (2 - c(ds$a45x4s8,ds$d43x4s6,ds$g45x4s6,ds$j53x4s6)))
table(s$netpmsup.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

table(ds$a45x4s9, useNA="always") # Similarity with P4
table(ds$d43x4s7, useNA="always") # Similarity with P4
table(ds$g45x4s8, useNA="always") # Similarity with P4
table(ds$j53x4s7, useNA="always") # Similarity with P4
# 1=yes, 2=no
s$netsim.4 <- ifelse(c(ds$a45x4s9,ds$d43x4s7,ds$g45x4s8,ds$j53x4s7)%in%c(8,9),NA,
                     (2 - c(ds$a45x4s9,ds$d43x4s7,ds$g45x4s8,ds$j53x4s7)))
table(s$netsim.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

table(ds$a45x4s10, useNA="always") # Relative Social Status of P4
table(ds$d43x4s8, useNA="always") # Relative Social Status of P4
table(ds$g45x4s9, useNA="always") # Relative Social Status of P4
table(ds$j53x4s8, useNA="always") # Relative Social Status of P4
# 1=yes, 2=no
s$netstat.4 <- ifelse(c(ds$a45x4s10,ds$d43x4s8,ds$g45x4s9,ds$j53x4s8)%in%c(3,4,8,9),0.5,
                      (2 - c(ds$a45x4s10,ds$d43x4s8,ds$g45x4s9,ds$j53x4s8)))
table(s$netstat.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

# table(, useNA="always") # Difference in Opinions with P4
# table(, useNA="always") # Difference in Opinions with P4
table(ds$g45x4s7, useNA="always") # Difference in Opinions with P4
# table(, useNA="always") # Difference in Opinions with P4
# 1=frequently, 2=sometimes, 3=no
s$netdif.4 <- ifelse(c(rep(NA,nrow(ds)*2),ds$g45x4s7,rep(NA,nrow(ds)))%in%c(8,9),NA,
                     ifelse(c(rep(NA,nrow(ds)*2),ds$g45x4s7,rep(NA,nrow(ds)))<=2,1,0))
table(s$netdif.4[s$net.4==1], s$year[s$net.4==1], useNA="always")

## Acquaintance Between Partners
table(ds$a45s11_1, useNA="always") # P1 and P2 Knows Each Other
table(ds$d43s9_1, useNA="always") # P1 and P2 Knows Each Other
table(ds$g45s10_1, useNA="always") # P1 and P2 Knows Each Other
table(ds$j53s9_1, useNA="always") # P1 and P2 Knows Each Other

table(ds$a45s11_2, useNA="always") # P1 and P3 Knows Each Other
table(ds$d43s9_2, useNA="always") # P1 and P3 Knows Each Other
table(ds$g45s10_2, useNA="always") # P1 and P3 Knows Each Other
table(ds$j53s9_2, useNA="always") # P1 and P3 Knows Each Other

table(ds$a45s11_3, useNA="always") # P1 and P4 Knows Each Other
table(ds$d43s9_3, useNA="always") # P1 and P4 Knows Each Other
table(ds$g45s10_3, useNA="always") # P1 and P4 Knows Each Other
table(ds$j53s9_3, useNA="always") # P1 and P4 Knows Each Other

table(ds$a45s11_4, useNA="always") # P1 Knows Noone
table(ds$d43s9_4, useNA="always") # P1 Knows Noone
table(ds$g45s10_4, useNA="always") # P1 Knows Noone
table(ds$j53s9_4, useNA="always") # P1 Knows Noone

table(ds$a45s11_5, useNA="always") # P1 Acquaintance DK
table(ds$d43s9_5, useNA="always") # P1 Acquaintance DK
table(ds$g45s10_5, useNA="always") # P1 Acquaintance DK
table(ds$j53s9_5, useNA="always") # P1 Acquaintance DK

table(ds$a45s11_6, useNA="always") # P1 Acquaintance NA
table(ds$d43s9_6, useNA="always") # P1 Acquaintance NA
table(ds$g45s10_6, useNA="always") # P1 Acquaintance NA
table(ds$j53s9_6, useNA="always") # P1 Acquaintance NA

table(ds$a45s12_1, useNA="always") # P2 and P3 Knows Each Other 
table(ds$d43s10_1, useNA="always") # P2 and P3 Knows Each Other 
table(ds$g45s11_1, useNA="always") # P2 and P3 Knows Each Other 
table(ds$j53s10_1, useNA="always") # P2 and P3 Knows Each Other 

table(ds$a45s12_2, useNA="always") # P2 and P4 Knows Each Other
table(ds$d43s10_2, useNA="always") # P2 and P4 Knows Each Other
table(ds$g45s11_2, useNA="always") # P2 and P4 Knows Each Other
table(ds$j53s10_2, useNA="always") # P2 and P4 Knows Each Other

table(ds$a45s12_3, useNA="always") # P3 and P4 Knows Each Other
table(ds$d43s10_3, useNA="always") # P3 and P4 Knows Each Other
table(ds$g45s11_3, useNA="always") # P3 and P4 Knows Each Other
table(ds$j53s10_3, useNA="always") # P3 and P4 Knows Each Other

table(ds$a45s12_4, useNA="always") # P2, P3, and P4 Don't Know Each Other
table(ds$d43s10_4, useNA="always") # P2, P3, and P4 Don't Know Each Other
table(ds$g45s11_4, useNA="always") # P2, P3, and P4 Don't Know Each Other
table(ds$j53s10_4, useNA="always") # P2, P3, and P4 Don't Know Each Other

table(ds$a45s12_5, useNA="always") # P2, P3, and P4 Acquaintance DK
table(ds$d43s10_5, useNA="always") # P2, P3, and P4 Acquaintance DK
table(ds$g45s11_5, useNA="always") # P2, P3, and P4 Acquaintance DK
table(ds$j53s10_5, useNA="always") # P2, P3, and P4 Acquaintance DK

table(ds$a45s12_6, useNA="always") # P2, P3, and P4 Acquaintance NA
table(ds$d43s10_6, useNA="always") # P2, P3, and P4 Acquaintance NA
table(ds$g45s11_6, useNA="always") # P2, P3, and P4 Acquaintance NA
table(ds$j53s10_6, useNA="always") # P2, P3, and P4 Acquaintance NA

## Network Summary Variables ##

## Number of People in Network
s$sumnet <- s$net.1 + s$net.2 + s$net.3 + s$net.4
table(s$sumnet, s$year, useNA="always")

## Melting Data ##

library(dplyr)
library(tidyr)

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
saveRDS(s, "jes3_s.rds")
saveRDS(snet, "jes3_net_s.rds")

#+ eval=FALSE, echo=FALSE
# Exporting HTML File
# In R Studio
# rmarkdown::render('data_jes3_1_recode_v2.R', 'github_document', clean=FALSE)
# tmp <- list.files("./")
# tmp <- tmp[grep("\\.spin\\.R$|\\.spin\\.Rmd$|\\.utf8\\.md$|\\.knit\\.md$|\\.log$|\\.tex$",tmp)]
# for (i in 1:length(tmp)) file.remove(paste0("./",tmp[i]))
