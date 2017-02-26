
CalcDamages <- function(dmg_base, dmg_exp_raw) {
  dmg_exp <- dmg_exp_raw %>%
    tolower() %>%
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
    )
  str_c(dmg_base, 'e', dmg_exp) %>%
    as.numeric() %>%
    return()
}

us_weather_events <-
  read_csv('./Data/repdata%2Fdata%2FStormData.csv') %>%
  replace_na(list(CROPDMGEXP = '0',
                  PROPDMGEXP = '0')) %>%
  transmute(
    event = str_to_title(EVTYPE) %>% as.factor(),
    state = str_to_lower(STATE),
    #date = mdy_hms(BGN_DATE),
    year = mdy_hms(BGN_DATE) %>% year(),
    lat = LATITUDE,
    long = LONGITUDE,
    prop_damage = CalcDamages(PROPDMG, PROPDMGEXP),
    crop_damage = CalcDamages(CROPDMG, CROPDMGEXP),
    total_damage = prop_damage + crop_damage,
    fatalities = FATALITIES,
    injuries = INJURIES,
    total_casualties = FATALITIES + INJURIES
  )
