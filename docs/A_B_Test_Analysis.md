# `r params$report_title`
`r Sys.Date()`  
<script type="text/javascript">
$(function() {
  /* Lets the user click on the images to view them in full resolution. */
  $("img").wrap(function() {
    var link = $('<a/>');
    link.attr('href', $(this).attr('src'));
    link.attr('target', '_blank');
    return link;
  });
});
</script>


This test was run from 2017-06-30 to 2017-07-17 on enwiki. We have 2 test groups: explore_similar_control, explore_similar_test. We include fulltext search in this analysis.





Fetch data: 

```sql
SELECT
  timestamp,
  event_uniqueId AS event_id,
  event_mwSessionId,
  event_pageViewId AS page_id,
  event_searchSessionId AS session_id,
  event_subTest AS `group`,
  wiki,
  MD5(LOWER(TRIM(event_query))) AS query_hash,
  event_action AS event,
  CASE
    WHEN event_position < 0 THEN NULL
    ELSE event_position
    END AS event_position,
  CASE
    WHEN event_action = 'searchResultPage' AND event_hitsReturned > 0 THEN 'TRUE'
    WHEN event_action = 'searchResultPage' AND event_hitsReturned IS NULL THEN 'FALSE'
    ELSE NULL
    END AS `some same-wiki results`,
  CASE
    WHEN event_action = 'searchResultPage' AND event_hitsReturned > -1 THEN event_hitsReturned
    WHEN event_action = 'searchResultPage' AND event_hitsReturned IS NULL THEN 0
    ELSE NULL
    END AS n_results,
  event_scroll,
  event_checkin,
  event_extraParams,
  event_msToDisplayResults AS load_time,
  event_searchToken AS search_token,
  userAgent AS user_agent
FROM TestSearchSatisfaction2_16909631
WHERE LEFT(timestamp, 8) >= '20170630' AND LEFT(timestamp, 8) < '20170718' 
  AND wiki IN('enwiki') 
  AND event_subTest IN('explore_similar_control', 'explore_similar_test') 
  AND event_source IN('fulltext') 
  AND event_searchSessionId <> 'explore_similar_test' 
  AND CASE WHEN event_action = 'searchResultPage' THEN event_msToDisplayResults IS NOT NULL
            WHEN event_action IN ('click', 'iwclick', 'ssclick') THEN event_position IS NOT NULL AND event_position > -1
            WHEN event_action = 'visitPage' THEN event_pageViewId IS NOT NULL
            WHEN event_action = 'checkin' THEN event_checkin IS NOT NULL AND event_pageViewId IS NOT NULL
            ELSE TRUE
       END;
```

## Data Cleansing
Deleted 590 duplicated events. Removed 201 orphan (SERP-less) events. Remove 0 sessions falling into multiple test groups. 











## Data Summary {.tabset}

### Test Summary


Days   Events   Sessions   Page IDs   SERPs    Unique search queries   Searches   Same-wiki clicks   Other clicks 
-----  -------  ---------  ---------  -------  ----------------------  ---------  -----------------  -------------
18     30,699   3,686      15,547     13,092   12,532                  10,617     2,554              124          

#### Number of events
![](reports/A_B_Test_Analysis_files/figure-html/event_count-1.png)<!-- -->

#### Number of searches

Test group                wiki        Search sessions   Searches recorded 
------------------------  ----------  ----------------  ------------------
explore_similar_control   enwiki      1,863             6,262             
explore_similar_test      enwiki      1,823             4,355             
Total                     All Wikis   3,686             10,617            

#### Number of searches with *n* same-wiki result(s) returned
![](reports/A_B_Test_Analysis_files/figure-html/n_results_summary-1.png)<!-- -->

#### Number of SERPs by offset
![](reports/A_B_Test_Analysis_files/figure-html/serp_offset_summary-1.png)<!-- -->

### Sister Search

#### Number of SERPs' sister-search sidebar results by source and position

              1st result   2nd result   3rd result   4th result   5th result     NA     Sum
-----------  -----------  -----------  -----------  -----------  -----------  -----  ------
NA                     0            0            0            0            0   3563    3563
wikibooks           1506         2661         2841          536            6      0    7550
wikiquote           1060         2928         2249          673            8      0    6918
wikisource          6354         1369          545          109            0      0    8377
wikivoyage             8           19           15           39          241      0     322
wiktionary           601          841          751         2827           22      0    5042
Sum                 9529         7818         6401         4184          277   3563   31772

![](reports/A_B_Test_Analysis_files/figure-html/serp_iw_breakdown-1.png)<!-- -->

#### Number of sister search clicks by project
![](reports/A_B_Test_Analysis_files/figure-html/ssclick_project-1.png)<!-- -->

#### Number of sister search clicks by position
![](reports/A_B_Test_Analysis_files/figure-html/ssclick_position-1.png)<!-- -->

#### Number of interwiki clicks by position
![](reports/A_B_Test_Analysis_files/figure-html/iwclick_position-1.png)<!-- -->

### Explore Similar

#### Number of explore similar clicks by section and clicked position

           2nd result   3rd result   Sum
--------  -----------  -----------  ----
NA                  1            0     1
related             1            3     4
Sum                 2            3     5

![](reports/A_B_Test_Analysis_files/figure-html/esclick_breakdown-1.png)<!-- -->

#### Number of hover-over events by section and number of results

              0 result(s)   1 result(s)   2 result(s)   3 result(s)   4 result(s)   5+ result(s)   Sum
-----------  ------------  ------------  ------------  ------------  ------------  -------------  ----
categories              0            16            21            24            27             80   168
languages              54            12             7             8             5             11    97
related                 7             0             0           222             0              0   229
Sum                    61            28            28           254            32             91   494

![](reports/A_B_Test_Analysis_files/figure-html/hover_breakdown-1.png)<!-- -->

## Test Metrics

### Same-wiki Zero Results Rate

![](reports/A_B_Test_Analysis_files/figure-html/zrr-1.png)<!-- -->

### Same-wiki Engagement
![](reports/A_B_Test_Analysis_files/figure-html/engagement-1.png)<!-- -->

**explore_similar_test vs. explore_similar_control** 
![](reports/A_B_Test_Analysis_files/figure-html/engagement_OR-1.png)<!-- -->

### First Clicked Same-Wiki Result’s Position
![](reports/A_B_Test_Analysis_files/figure-html/first_clicked-1.png)<!-- -->

### Maximum Clicked Position for Same-Wiki Results
![](reports/A_B_Test_Analysis_files/figure-html/max_clicked-1.png)<!-- -->

### PaulScore
![](reports/A_B_Test_Analysis_files/figure-html/paulscores-1.png)<!-- -->

### Other Pages of the Search Results
![](reports/A_B_Test_Analysis_files/figure-html/search_offset-1.png)<!-- -->

### Dwell Time per Visited Page
![](reports/A_B_Test_Analysis_files/figure-html/dwelltime-1.png)<!-- -->

### Scroll
![](reports/A_B_Test_Analysis_files/figure-html/scroll-1.png)<!-- -->
