#!/bin/bash -e

END_POINT="<your-end-point>"
SECRET="<your-secret>"

hasura migrate apply --database-name default --endpoint "${END_POINT}" --admin-secret "${SECRET}"

hasura metadata apply --endpoint "${END_POINT}" --admin-secret "${SECRET}"

hasura metadata reload --endpoint "${END_POINT}" --admin-secret "${SECRET}"
