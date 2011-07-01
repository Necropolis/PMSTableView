#!/bin/bash

# Short script to generate project
# documentation using Appledoc.
# http://www.gentlebytes.com/home/appledocapp/

PROJECT_LOCATION=`pwd $0`
PROJECT_NAME="PMSTableView"
PROJECT_VERSION="0.1"
COMPANY_NAME="Firestorm Development"
COMPANY_ID="net.fsdev"

# Generate HTML for the web
appledoc \
	-h \
	--no-create-docset \
	-o "${PROJECT_LOCATION}/docs" \
	-p "${PROJECT_NAME}" \
	-v "${PROJECT_VERSION}" \
	-c "${COMPANY_NAME}" \
	--company-id "${COMPANY_ID}" \
	--clean-output \
	"${PROJECT_LOCATION}" ;
	
# Generate a Docset for Xcode
appledoc \
	-d \
	-p "${PROJECT_NAME}" \
	-v "${PROJECT_VERSION}" \
	-c "${COMPANY_NAME}" \
	--company-id "${COMPANY_ID}" \
	--clean-output \
	"${PROJECT_LOCATION}" ;
	