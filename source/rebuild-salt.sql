TRUNCATE TABLE salt;
LOAD DATA LOCAL INFILE '/home/podolske/cmdb/rhel-10-10.csv' INTO TABLE salt FIELDS TERMINATED BY ',' (minion, kernel, hostname, version);
LOAD DATA LOCAL INFILE '/home/podolske/cmdb/ubuntu-10-10.csv' INTO TABLE salt FIELDS TERMINATED BY ',' (minion, kernel, hostname, version);
LOAD DATA LOCAL INFILE '/home/podolske/cmdb/carrier-blurdev.csv' INTO TABLE salt FIELDS TERMINATED BY ',' (minion, kernel, hostname, version);
LOAD DATA LOCAL INFILE '/home/podolske/cmdb/carrier-coresite.csv' INTO TABLE salt FIELDS TERMINATED BY ',' (minion, kernel, hostname, version);
LOAD DATA LOCAL INFILE '/home/podolske/cmdb/carrier-reston.csv' INTO TABLE salt FIELDS TERMINATED BY ',' (minion, kernel, hostname, version);