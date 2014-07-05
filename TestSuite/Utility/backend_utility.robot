*** Settings ***
Documentation     A test suite for backend utility.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Library			OperatingSystem
Library 		Selenium2Library
Library 		String

Resource          ../Resources/resource.robot
Resource          ../Resources/TextMsg.robot



*** Variables ***
${Response} 	Done
${PHASE}		BETA

# Backend utility FQDN
${ALPHA_FQDN_OF_BACKEND_UTILITY}		http://10.1.100.35/
${BETA_FQDN_OF_BACKEND_UTILITY}      	http://pccregbeta.trendmicro.com/
${FQDN_OF_BACKEND_UTILITY}				${${PHASE}FQDN_OF_BACKEND_UTILITY}


# Backend utility URL for setting expiration date
${ALPHA_SET_EXPIRATION_DATE_URL}		AlphaBackendUtility/PrepareData.aspx?ExeList=SetFullExpireDate
${BETA_SET_EXPIRATION_DATE_URL}			BetaBackendUtility2/PrepareData.aspx?ExeList=SetFullExpireDate
${SET_EXPIRATION_DATE_URL}				${${PHASE}_SET_EXPIRATION_DATE_URL}

# Backend utility URL for getting Ti serial number
${ALPHA_GET_TI_SN_URL}		AlphaBackendUtility/GetSNFromKeyPool.aspx?ProjectName=
${BETA_GET_TI_SN_URL}		BetaBackendUtility2/GetSNFromKeyPool.aspx?ProjectName=
${GET_TI_SN_URL}			${${PHASE}_GET_TI_SN_URL}
${PROJECT_NAME_HE}			Ti50/60_HE_Full
${PROJECT_NAME_MR}			Ti50/60_MR_Full
${PROJECT_NAME_EL}			Ti50/60_EL_Full


# Variables for Reg entry base FQDN
${ALAPH_FQDN_OF_REG_ENTRY}	regalpha.trendnet.org
${BETA_FQDN_OF_REG_ENTRY}	regbeta.trendmicro.com
${FQDN_OF_REG_ENTRY}		${${PHASE}_FQDN_OF_REG_ENTRY}

# Variables for SaaS related
${REG_URL_OF_SSFC_TRIAL}		http://${FQDN_OF_REG_ENTRY}/TERRA/OSA?SN=ZZMJ-0000-0000-0000-0000&PID=OB30
${REG_URL_OF_SSJP_TRIAL}		http://${FQDN_OF_REG_ENTRY}/TERRA/OSA?SN=ZZJJ-0000-0000-0000-0000&PID=OB30
${REG_URL_OF_TMOG_TRIAL}		http://${FQDN_OF_REG_ENTRY}/TERRA/OSA?SN=ZZMJ-0000-0000-0000-0000&PID=PM20



*** Keywords ***
Set expiration date difference from today
	[Arguments]     	${sn} 	${diff_days}
    @{date}=     Get Time   year month day   NOW + ${diff_days} d
    Set expiration date      ${sn}    @{date}[0]@{date}[1]@{date}[2]

Set expiration date
	[Arguments]     	${sn} 	${DATE}
    Wait Until Keyword Succeeds  2 min  30 sec 		Open Browser 	${FQDN_OF_BACKEND_UTILITY}${SET_EXPIRATION_DATE_URL}&SN=${sn}&ExpireDate=${DATE}    ${BROWSER}    ff_profile_dir=${FF_PROFILE}
    Wait Until Page Contains	${Response}  	60 seconds
    [Teardown]    Close Browser

Get Titanium serial number
    [Arguments]     ${pid}
	[Return]  ${serial}
	${sku} =	Get Substring	${pid}	0 	2
	${version} =	Get Substring	${pid}	2 	4

	${project} =	Set Variable If
	...				'${sku}' == 'TE'	${PROJECT_NAME_HE}
	...				'${sku}' == 'TI'	${PROJECT_NAME_MR}
	...				'${sku}' == 'TB'	${PROJECT_NAME_EL}

	Wait Until Keyword Succeeds  2 min  30 sec 		Open Browser 	${FQDN_OF_BACKEND_UTILITY}${GET_TI_SN_URL}${project}    ${BROWSER}    ff_profile_dir=${FF_PROFILE}
    Wait Until Page Contains Element    xpath=//html/body/pre     120 seconds
    ${serial}=   Get Text    xpath=//html/body/pre
    [Teardown]    Close Browser

Get random GUID
	[Return]  ${guid}
	@{date}=     Get Time   year month day hour min sec
	${guid}		Set Variable 	012345678012345678@{date}[0]@{date}[1]@{date}[2]@{date}[3]@{date}[4]@{date}[5]

Open Titanium Reg form
	[Arguments]     	${pid}	${sn} 	${GUID}
	Wait Until Keyword Succeeds  2 min  30 sec 		Open Browser 	https://${FQDN_OF_REG_ENTRY}/Terra/Register?SN=${sn}&GUID=${GUID}&VID=&FLAG=RG&PID=${pid}&CHKVER=0&LOCALE=EN-US&STAG=&ComputerName=Jerry_machine&OSN=    ${BROWSER}    ff_profile_dir=${FF_PROFILE}


# Sample Run Keyword If
	# ${project} =	Run Keyword If		'${sku}' == 'TE'			'${PROJECT_NAME_HE}'
	# ...				ELSE IF				'${sku}' == 'TE'			'${PROJECT_NAME_MR}'
	# ...				ELSE				'${PROJECT_NAME_EL}'

