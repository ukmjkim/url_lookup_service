# Url Lookup Service

Url Lookup Service provides web site secure level for requested url. A client wants to know whether a certain web site contains a malware or abuse such as adult, games, fraud, etc. How to work is that a client passes full uri then this url lookup service returns the safe level in JSON.

## Considerations
* The size of the URL list could grow infinitely, how you might scale this beyond the memory capacity of the system.
* The number of requests may exceed the capacity of this system, how you might solve that.
* What strategies you might use to update the service with new URLs. Updates may be as much as 5 thousand URLs a day with updates arriving every 10 minutes.



## Lookup Url Information
https://github.com/ukmjkim/url_lookup_service/blob/master/docs/UrlLookupService_GET_SequenceDiagram.png
