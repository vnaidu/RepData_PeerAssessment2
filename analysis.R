library(tidyverse)
library(stringr)
library(lubridate)
data <- read_csv('./Data/repdata%2Fdata%2FStormData.csv')
storm_data <-
  data %>%
  select(
    BGN_DATE,
    STATE,
    EVTYPE,
    FATALITIES,
    INJURIES,
    PROPDMG,
    PROPDMGEXP,
    CROPDMG,
    CROPDMGEXP,
    LATITUDE,
    LONGITUDE
  )

replace_na(storm_data, list(CROPDMGEXP = '0',
                            PROPDMGEXP = '0'))

m_data <-storm_data %>%
  transmute(
    year = mdy_hms(BGN_DATE) %>% year(),
    state = str_to_lower(STATE),
    prop_damage_exp = PROPDMGEXP %>%
      str_to_lower() %>%
      recode(
        'k' = '3',
        'm' = '6',
        'h' = '2',
        'b' = '9',
        '?' = '0',
        '-' = '0',
        '+' = '0',
        default = '0',
        missing = '0'
      ) %>% str_c('1e', .) %>%
      as.numeric()
  ) %>% unique()
