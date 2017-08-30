# solvebio 2.1.0

* Adds Beacon and BeaconSet methods
* Adds a few "update" methods for PATCH requests (editing objects)
* Adds a few new examples for aggregations
* Raises "stop" errors when Objects cannot be found by full path (previously returned NULL)


# solvebio 2.0.1 / 2.0.2

* Bug fixes 


# solvebio 2.0.0

* Add support for Vaults, Objects (Vault Objects)
* Remove deprecated version 1 methods for Depository and DepositoryVersion
* Upgrade to version 2 endpoints for some methods


# solvebio 0.4.0

* Added support for uploads, dataset imports, migrations, and exports
* Uses dplyr bind_rows to handle JSON inconsistencies in data


# solvebio 0.3.0

* Adds`Dataset.count()` and `Dataset.facets()` methods
* Adds NEWS.md file


# solvebio 0.2.0

* Adds automatic pagination support to `Dataset.query()`


# solvebio 0.1.0

* First alpha release, basic SolveBio API support for querying datasets
