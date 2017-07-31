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



