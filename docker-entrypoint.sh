#!/usr/bin/env bash

 [ -z "${redisoperation:?}" ] && echo "ERROR: Was expecting the IMPORT OR EXPORT to be passed" && exit 1
 [ -z "${rediskeyfile:?}" ] && echo "ERROR: Was expecting the REDISKEYFILE path to be passed" && exit 1
 [ -z "${redishost:?}" ] && echo "ERROR: Was expecting the REDISHOST to be passed" && exit 1
 [ -z "${rediskeydir:?}" ] && echo "ERROR: Was expecting the REDISKEYDIR to be passed" && exit 1
 [ -z "${redisdb:?}" ] && echo "ERROR: Was expecting the REDISDB to be passed" && exit 1
 [ -z "${redisport:?}" ] && echo "ERROR: Was expecting the REDISPORT to be passed" && exit 1

# CREATE BACKUP DIRECTORY
  test -d "${rediskeydir}" && echo "OK: ${rediskeydir} exists" || echo "INFO: Creating ${rediskeydir}..." && mkdir -p "${rediskeydir}"

# TEST CONNECTION
  (printf "PING\r\n"; sleep 1) | nc "${redishost}" "${redisport}" 2>&1 | grep PONG && echo "OK: $redishost exists and is online" || echo "ERROR: $redishost does not seem to be online"

# RUN REDIS OPERATIONS
if [[ "${redisoperation}" = "import" ]]; then

   test -f "${rediskeydir}${rediskeyfile}" && echo "OK: ${rediskeydir}${rediskeyfile} exists. Importing..." || echo "ERROR: Expected ${rediskeydir}${rediskeyfile} but not present"
   ARGS="-H ${redishost} -p ${redisport} -d ${redisdb} -l ${rediskeydir}${rediskeyfile}"
   runredis="redis-tool" && bash -c "${runredis} ${ARGS}"

elif [[ "${redisoperation}" = "export" ]]; then

   ARGS="-H ${redishost} -p ${redisport} -d ${redisdb} -o ${rediskeydir}${rediskeyfile}"
   runredis="redis-tool" && bash -c "${runredis} ${ARGS}"
   test -f "${rediskeydir}${rediskeyfile}" && echo "OK: ${rediskeydir}${rediskeyfile} was exported" || echo "ERROR: There was an issue with the export. Expected ${rediskeydir}${rediskeyfile} but it was not present."

fi

#exec "$@"
