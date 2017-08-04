# Url Lookup Service

Url Lookup Service provides web site secure level for requested url. A client wants to know whether a certain web site contains a malware or abuse such as adult, games, fraud, etc. How to work is that a client passes full uri then this url lookup service returns the safe level in JSON.

## Considerations
* The size of the URL list could grow infinitely, how you might scale this beyond the memory capacity of the system.
* The number of requests may exceed the capacity of this system, how you might solve that.
* What strategies you might use to update the service with new URLs. Updates may be as much as 5 thousand URLs a day with updates arriving every 10 minutes.


## Questions & Answers
- Is local memcache applicable?
  - Pros: faster, 
  - Cons: capacity (max, maintenance issue
  - Considerations: We could use both rails memcached and Redis if response time matters
- Several databases are different clusters or replica?
- Database stores urls which contain malware or both malware and clean urls
- I assume that url updater may call UrlLookupService for add and delete url information such as malware to normal or normal to malware. RESTful API DELETE method remove the url data from database and POST method add a new malware url into database.




## Url Information Lookup
https://github.com/ukmjkim/url_lookup_service/blob/master/docs/UrlLookupService_GET_SequenceDiagram.png


## Unsafe Url Information Creation
https://github.com/ukmjkim/url_lookup_service/blob/master/docs/UrlLookupService_POST_SequenceDiagram.png

## Unsafe Url Information Deletion
https://github.com/ukmjkim/url_lookup_service/blob/master/docs/UrlLookupService_DELETE_SequenceDiagram.png


## Steps in implementation
- impletmenting basic web service
    - GET, POST, DELETE to databse
- [BLOCKER] non-resourceful route issue
- modifying controller to proceed expecting request
- integrating Redis


## Test Instruction
- Run a task to verify the url lookup service
    - $ rake import_malware:import
    - steps for testing
      - import malware urls from sample file (downloaded from a public site)
      - parse the urls and extract hostname and path_querystring 
      - make POST requests to the url lookup service to store them to database and cache
      - make GET requests to assert whether the urls exist in cache
      - make DELETE requests to delete the urls from database and cache
      - make GET requests to assert whether the urls no longer exist in both database and cache

```
=============================================================
Total #:     523
Success #:   523
Cache Hit #: 523
Deleted #:   523
No Hit #:    523
-------------------------------------------------------------
Finished! Took 0.0033476654211111114 hours
=============================================================
```

## Code Coverage & Style Checker Result
- Test cases: 21 exmpales, 0 failures (over 80%)
- Code coverage result file: coverage/index.html
- Style Checker result: 21 files inspected, 7 offenses detected, (Too many lines)

## Installation Guide
TODO

