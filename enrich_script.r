## parse crossref

## load apc data from 7 Nov 2016
apc <- readr::read_csv("https://github.com/OpenAPC/openapc-de/raw/1b024b89b660d0d289a4c24b6d75b923f0665f39/data/apc_de.csv", 
                col_names = TRUE)

### preprocess
apc$doi <- tolower(apc$doi)
apc$doi <- gsub("dx.doi.org/", "", apc$doi)

### 0. exclude non-german funders, fees paid in 2016, non journal articles
non_de <- c("Wellcome Trust", "TU Wien", 
            "Harvard U", "FWF - Austrian Science Fund")
apc <- dplyr::filter(apc, !institution %in% non_de)
apc <- dplyr::filter(apc, euro > 0)
# remove intech book chapters
apc <- dplyr::filter(apc, !is.na(journal_full_title))
apc <- dplyr::filter(apc, !period == "2016")

### 1. step exclude NA
apc_doi <- apc[!is.na(apc$doi),]

### 2. fetch metadata from CrossRef with ropensci::rcrossref client and parser for the tdm xml
source("R/cr_parse.r")
apc_cr <- plyr::ldply(apc_doi$doi, plyr::failwith(f = cr_parse))
#### backup
jsonlite::stream_out(apc_cr, file("data/cr-apc.json"))

### 3. repeat for dois not found because of possible time outs
doi_lack <- apc_doi[!tolower(apc_doi$doi) %in% tolower(apc_cr$doi),]
doi_miss <- plyr::ldply(doi_lack$doi, plyr::failwith(f = cr_parse))

apc_cr <- rbind(apc_cr, doi_miss)
jsonlite::stream_out(apc_cr, file("data/cr-apc.json"))

### 4. merge with cost info
require(dplyr)
apc_cr <- jsonlite::stream_in(file("data/cr-apc.json"))
apc_cr$doi <- tolower(apc_cr$doi)
apc_euro <- dplyr::select(apc, institution, period, euro, is_hybrid, doi)
apc_cr_euro <- dplyr::left_join(apc_cr, apc_euro, by = "doi")
variables_needed <- c("doi", "euro", "institution", "publisher", 
                      "journal_full_title", "period", "license_ref", "is_hybrid")
apc_short <- dplyr::select(apc, one_of(variables_needed)) %>% 
  filter(!doi %in% apc_cr_euro$doi)
# no member and journal ids available because articles were not indexed by crossref
apc_short$member_id <- NA
apc_short$journal_id <- NA
apc_cr_all <- dplyr::select(apc_cr_euro, one_of(c(variables_needed, "member_id", "journal_id"))) %>% 
  rbind(., apc_short)
jsonlite::stream_out(apc_cr_all, file("data/cr-apc-all.json"))

### 5. get agencies for non-crossref dois
doi_miss$doi <- tolower(doi_miss$doi)
dois_ac <- doi_lack[!doi_lack$doi %in% doi_miss$doi,]
# backup 
jsonlite::stream_out(dois_ac, file("data/missing_dois.json"))


GET_agency_id <- function(x, ...) {
  if (is.null(x)) {
    NA
  }
  rcrossref::cr_agency(x)$agency$id
}

tt <- lapply(dois_ac$doi, GET_agency_id)
dois_ac$doi_agency <- as.character(tt)
jsonlite::stream_out(dois_ac, file("data/missing_dois_agency.json"))
