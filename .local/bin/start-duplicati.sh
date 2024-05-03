#!/usr/bin/env bash

AUTOUPDATER_Duplicati_SKIP_UPDATE=1
/usr/bin/mono /opt/duplicati-latest/Duplicati.Server.exe --webservice-port=8200
