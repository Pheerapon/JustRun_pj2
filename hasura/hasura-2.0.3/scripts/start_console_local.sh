#!/bin/bash -e

END_POINT="<your-endpoint-url>"
SECRET="<your-password>"

hasura console --endpoint "${END_POINT}" --admin-secret "${SECRET}"
