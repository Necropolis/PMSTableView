#!/bin/bash

# Short script to generate project
# documentation using Appledoc.
# http://www.gentlebytes.com/home/appledocapp/

PROJECT_LOCATION=`pwd $0`

appledoc \
	-d \
	-h \
	--no-create-docset \
	-o ${PROJECT_LOCATION}/docs \
	-p "PMSTableView" \
	-v "0.1" \
	-c "Firestorm Development" \
	--company-id "net.fsdev" \
	${PROJECT_LOCATION}