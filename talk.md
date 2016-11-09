Using DOIs to assess the institutional support for open access publication fees
========================================================
author: Najko Jahn (SUB Göttingen, Germany)
date: 10th November 2016
autosize: true



Agenda
========================================================

- **General background**
-- Limitations of the study of spending on open access publication fees
- **Methods** 
  -- Crowdsourcing spending data and using Crossref to obtain metadata about open access journal articles
- **Results**
  -- Publication fee spending in Germany by publisher and journal
- **Discussion**
 -- Benefits and limits using Crossref
- **Open questions**


General Background
========================================================

Increasing relevance of open access publication fees also APCs in academic publishing

However, the study of spending for these charges has been limited for several resaons:
  - fragmentation of payments across various budgets
  - lack of transparency about who pays for what and the cost of publishing
  - fear of "double-dipping" when subscription costs and fees are not offsetted

Open Data to Open Access Publication Fees
========================================================

Austrian, German and UK initatives have started to collect and share publication fee expenditure in 2014. 

**Metadata curation efforts**

- Thorough coverage of persistent IDs, especially DOI, but also PMID, along with admisntrative information
- To avoid confusion about naming of journals and publishers German Open APC initiative uses self-reported DOIs to gather bibliographic metadata from Crossref


Parsing Crossref TDM-XML
=======================================================

After requesting the `application/vnd.crossref.unixsd+xml` linking resource per DOI, following fields were parsed and merged with the spending data

|variable  |description     | node |
|:--------------|:---------|:-----------------|
|`doi`| Digital Object Identifier | `//ct:doi` |
|`journal_full_title` |Full Title of Journal  | `//journal_metadata//full_title` |
|`publisher` |Title of Publisher  | `//crm-item[@name='publisher-name']` |
|`issn` |International Standard Serial Numbers (collapsed) | `//journal_metadata//issn` |
|`issn_print` |ISSN print | `//journal_metadata//issn[@media_type='print']` |
|`issn_electronic`  |ISSN electronic | `//journal_metadata//issn[@media_type='electronic']` |
|`license_ref`  |License of the article | `//ai:license_ref` |

Method used for this talk
=======================================================

- analysed cost data from the Open APC initiative obtained on 7 Nov 2016 that only covers German universities and research institutions
- retrieved updated bibliographic information from Crossref by the DOIs to reflect ongoing mergers and name changes of publishers and journals
- extend Open APC metadata profile by adding Crossref `member_id`
- used the rOpenSci's `rcrossref:.cr_cn()` function to get the TDM-XML resource

<https://github.com/njahn82/pidapalooza_talk>

Results -- Cumulative growth of the Open APC initiative
========================================================

![plot of chunk unnamed-chunk-2](talk-figure/unnamed-chunk-2-1.png)

Cost distribution
========================================================








```
processing file: talk.Rpres

Attaching package: 'dplyr'

The following objects are masked from 'package:stats':

    filter, lag

The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union

Quitting from lines 126-137 (talk.Rpres) 
Fehler in parse(text = x, srcfile = src) : 
  <text>:10:10: unerwartetes Symbol
9: 
10: Indexing coverage
             ^
Ruft auf: knit ... evaluate -> parse_all -> parse_all.character -> parse
Ausführung angehalten
```
