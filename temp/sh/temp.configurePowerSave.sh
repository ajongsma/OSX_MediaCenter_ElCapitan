#!/bin/sh
####################################################################################################
#
# Copyright (c) 2010, JAMF Software, LLC
# All rights reserved.
#
#	Redistribution and use in source and binary forms, with or without
# 	modification, are permitted provided that the following conditions are met:
#		* Redistributions of source code must retain the above copyright
#		  notice, this list of conditions and the following disclaimer.
#		* Redistributions in binary form must reproduce the above copyright
#		  notice, this list of conditions and the following disclaimer in the
#		  documentation and/or other materials provided with the distribution.
#		* Neither the name of the JAMF Software, LLC nor the
#		  names of its contributors may be used to endorse or promote products
#		  derived from this software without specific prior written permission.
#
# 	THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
# 	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# 	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# 	DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
# 	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# 	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# 	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# 	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# 	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# 	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
####################################################################################################
#
# SUPPORT FOR THIS PROGRAM
#
# 	This program is distributed "as is" by JAMF Software, LLC's Resource Kit team. For more 
#	information or support for the Resource Kit, please utilize the following resources:
#
#		http://list.jamfsoftware.com/mailman/listinfo/resourcekit
#
#		http://www.jamfsoftware.com/support/resource-kit
#
#	Please reference our SLA for information regarding support of this application:
#
#		http://www.jamfsoftware.com/support/resource-kit-sla
#
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	configurePowerSave.sh -- Configures Faronics Power Save.
#
# SYNOPSIS
#	sudo configurePowerSave.sh
#	sudo configurePowerSave.sh <mountPoint> <computerName> <currentUsername> <psUsername> <psPassword>
#							<cpuSleep> <displaySleep>
#
# DESCRIPTION
#	This script configures the Power Save application.  To configure a certain setting, either pass
#	the value for the setting, or modify the variable in this script.
#
#	For example, to set the display sleep setting to make the display sleep after 10 minutes, modify
#	the "displaySleep" variable to equal "10"
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Nick Amundsen on June 2nd, 2010
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE
psUsername=""
psPassword=""
cpuSleep=""
displaySleep=""


# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "psUsername"
if [ "$4" != "" ] && [ "$psUsername" == "" ];then
    psUsername=$4
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "psPassword"
if [ "$5" != "" ] && [ "$psPassword" == "" ];then
    psPassword=$5
fi

####################################################################################################
# 
# VARIABLE VERIFICATION FUNCTION
#
####################################################################################################

verifyVariable () {
eval variableValue=\$$1
if [ "$variableValue" != "" ]; then
	echo "Variable \"$1\" value is set to: $variableValue"
else
	echo "Variable \"$1\" is blank.  Please assign a value to the variable."
	exit 1
fi
}

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

# Verify Variables

verifyVariable psUsername
verifyVariable psPassword

if [ -f "/Library/Application Support/Faronics/PowerSave/CLI" ]; then
	# Set CPU Sleep
	if [ "$cpuSleep" != "" ]; then
		echo "Setting CPU Sleep to $cpuSleep minutes..."
		"/Library/Application Support/Faronics/PowerSave/CLI" "$psUsername" "$psPassword" CPUSleep "$cpuSleep"
	fi
	# Set Display Sleep
	if [ "$displaySleep" != "" ]; then
		echo "Setting Display Sleep to $displaySleep minutes..."
		"/Library/Application Support/Faronics/PowerSave/CLI" "$psUsername" "$psPassword" displaySleep "$displaySleep"
	fi
else
	echo "Power Save is not installed."
	exit 1
fi

exit 0