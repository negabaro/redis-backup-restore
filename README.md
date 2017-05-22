![Redis](./images/redis.png)


# Redis Backup

## Overview

You have one or more Redis instances that you want to backup. However, you want a backup that is in a format that is more flexible than the standard `.rdb` or `.aof` file.

Having your data as `JSON` would be ideal so this Docker images exports or imports Redis data sets into that format.


## Configuration

### Environment Variables

There are currently 6 variables that need to be set to run the backup container.
* **redisoperation**: There are two modes that can be set for redisoperation: "IMPORT" or "EXPORT". IMPORT allows you to import a backup set of keys while EXPORT allows you to dump all the keys into a JSON file.
* **rediskeydir**: Where do you want to import from or export (i.e., "/path/to/dir/")?
* **rediskeyfile**: What is the name you want to use for the IMPORT or EXPORT redisoperation (i.e. "nameofkey.json")?
* **redisdb**: What is the database you need to connect (e.g., This typically would be 0, but it may be others depending on how it was setup)?
* **redishost**: What is the hostname or IP address of the Redis instance?
* **redisport**: What port is needed for the Redis instance?

## Usage Examples
The following are a set of example commands:
##### Export
This is an example of running an `EXPORT` operation:
```bash
docker run -v /ebs/data:/ebs/data  -e redisoperation="export" -e rediskeydir="/ebs/data/backup/redis/" -e rediskeyfile="foo_redisbackup.json" -e redishost="172.17.0.1" -e redisport="6379" -e redisdb="0" negabaro/redis-backup-restore 
```
##### Import
This is an example of running an `IMPORT` operation:
```bash
docker run -v /ebs/data:/ebs/data -e redisoperation="import" -e rediskeydir="/ebs/data/backup/redis/" -e rediskeyfile="foo_redisbackup.json" -e redishost="172.17.0.1" -e redisport="6379" -e redisdb="0" negabaro/redis-backup-restore 
```

#### Cron
You can set Redis Backup to run via `Cron`. The following example will backup Redis once every 30 minutes:
```bash
*/30 * * * * /usr/bin/bash -c 'docker run -v /ebs:/ebs -e redisoperation="export" -e rediskeydir="/ebs/data/backup/redis/" -e rediskeyfile="`date +\%Y\%m\%d\%H\%M\%S`_redisbackup.json" -e redishost="172.17.0.1" -e redisport="6379" -e redisdb="0" negabaro/redis-backup-restore' >> /ebs/logs/redisbackup/redisbackup.log 2>&1
```

The Cron export dynamically includes the timestamp in the filename. This allows you to easily run backups at set intervals, creating distinct point-in-time snapshots.
