*** Settings ***
Library			OperatingSystem
Library 		Selenium2Library
Resource        ErrorMsg.txt
Resource        TextMsg.txt
# Force Tags		Portalaaa
# Default Tags	Portal

*** Variables ***
${VERSION}		3.1.5
${BROWSER}      Firefox
${PHASE}		BETA
${LOCALE}		JA-JP
${DELAY}		0
${FF_PROFILE}   C:/CI/MyAccount/FF_Profile

# Define Error messages
${ERROR_MSG_OF_NO_EMAIL_PASS}		${ERROR_MSG_OF_NO_EMAIL_PASS_${LOCALE}}
${ERROR_MSG_OF_NO_PASS}             ${ERROR_MSG_OF_NO_PASS_${LOCALE}}
${ERROR_MSG_OF_NO_EMAIL}            ${ERROR_MSG_OF_NO_EMAIL_${LOCALE}}
${ERROR_MSG_OF_INVALID_ACCOUNT}     ${ERROR_MSG_OF_INVALID_ACCOUNT_${LOCALE}}


# Define MyAccount URL
${MA_URL_ALPHA}				https://accountalpha.trendnet.org/my_account?LANG=
${MA_URL_BETA}				https://accountbeta.trendmicro.com/my_account?LANG=
${MYACCOUNT_LOCATION}		https://accountbeta.trendmicro.com/my_account/

# Define ER path
${ER_PATH_ALPHA}     http://10.1.100.35/GREntry/NonPayment
${ER_PATH_BETA}      http://akagrbeta.trendmicro.com/GREntry/NonPayment
${ER_PATH}           ${ER_PATH_${PHASE}}

# Define GR path
${GR_PATH_ALPHA}     http://10.1.100.35/GREntry/ByParams
${GR_PATH_BETA}      http://akagrbeta.trendmicro.com/GREntry/ByParams
${GR_PATH}           ${GR_PATH_${PHASE}}

# Define page tile variable
${PAGE _TITLE_JA-JP}		トレンドマイクロアカウント | ログイン
${PAGE _TITLE_EN-US}		My Account | Sign In
${PAGE_TITLE}		${PAGE _TITLE_${LOCALE}}

# Forget series variables
${FORGET_EMAIL_LINK_TEXT}				${FORGET_EMAIL_LINK_TEXT_${LOCALE}}
${FORGET_PASSWORD_LINK_TEXT}			${FORGET_PASSWORD_LINK_TEXT_${LOCALE}}
${FORGET_SN_LINK_TEXT}   				${FORGET_SN_LINK_TEXT_${LOCALE}}


${FORGET_EMAIL_ER}      	${ER_PATH}?Target=MyAccount&FunID=ForgetEmail&Locale=${LOCALE}
${FORGET_PASSWORD_ER}   	${ER_PATH}?Target=MyAccount&FunID=ForgetPassword&Locale=${LOCALE}
${FORGET_SN_ER}             ${ER_PATH}?TARGET=MyAccount&FUNID=SignInBySN&LOCALE=${LOCALE}


# Define invalid user accounts
${INVALID_USER}		andylau123@yopmail.com
${INVALID_PASS}		andyalu123


*** Keywords ***
Open Browser To Login Page
	[Arguments]    	${LOCALE}
    Wait Until Keyword Succeeds  2 min  30 sec 		Open Browser 	${MA_URL_${PHASE}}${LOCALE}    ${BROWSER}    ff_profile_dir=${FF_PROFILE}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Page Should Be Open

Submit Credentials
    Click Button  sign_in_button

Page Should Be Open
  	Title Should Be		${PAGE_TITLE}

Input Username
    [Arguments]    ${username}
    Input Text    username    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    password    ${password}

MyAccount Should Be Open
    Location Should Contain  ${MYACCOUNT_LOCATION}
    # Title Should Be  Welcome Page

Login Should Have Failed
    Location Should Be  ${ERROR URL}
    Title Should Be  Error Page

# --------------------------------------------
#
# For Reminder area
#
# --------------------------------------------
Should have reminder warning in reminder area
    [Arguments]    ${product_name}    ${button_text}    ${button_link}
    # Confirm product name
    Element Text Should Be    jquery=div.reminding.warning div.scroll-container ul.expired_container li div.pd_name     ${product_name}
    # Confirm expiration date
    Page Should Contain Element    jquery=div.reminding.warning div.scroll-container ul.expired_container li div.ex_date
    # Confirm buynow/renew button
    Element Text Should Be    jquery=div.reminding.warning div.scroll-container ul.expired_container li a.push_btn2.gray    ${button_text}
    ${attr}=   Get Element attribute    jquery=div.reminding.warning div.scroll-container ul.expired_container li a.push_btn2.gray@href
    Should Be Equal     ${attr}     ${button_link}

Should not have reminder area
    Page Should Not Contain Element     jquery=div.reminding.warning div.scroll-container ul.expired_container li div.pd_name

Wait until reminder area is displayed
    Wait Until Page Contains Element    jquery=div.reminding.warning div.scroll-container ul.expired_container li div.pd_name     120 seconds

# --------------------------------------------
#
# For Remaining days' area
#
# --------------------------------------------
Should have remaining days info in remaining area
    [Arguments]    ${text}
    Element Text Should Be    jquery=div.license_box p var.day     ${text}

Should have BuyNow Renew Upgrade button in remaining area
    [Arguments]    ${link}      ${text}
    # Get url link
    ${attr1}=   Get Element attribute    jquery=div.license_box a.push_btn2.blue@href
    Should Be Equal     ${attr1}     ${link}
    # Check BuyNow Renew Upgrade button's text
    Element Text Should Be    jquery=div.license_box a.push_btn2.blue     ${text}

Should not have BuyNow Renew Upgrade button in remaining area
    Page Should Not Contain Element     jquery=div.license_box a.push_btn2.blue

Should have AutoRenew switch in remaining area
    [Arguments]    ${ar_status}      ${link}
    # Get AR status
    ${attr1}=   Get Element attribute    jquery=div.autorenew a.toggle_switch@data-autorenew
    Should Be Equal     ${attr1}     ${ar_status}
    # Get AR switch link
    ${attr2}=   Get Element attribute    jquery=div.autorenew a.toggle_switch@href
    Should Be Equal     ${attr2}     ${link}

Should not have AutoRenew switch in remaining area
    Page Should Not Contain Element     jquery=div.autorenew a.toggle_switch

Should have what is AR in remaining area
    [Arguments]    ${link}      ${text}
    # Get what is AR link
    ${attr1}=   Get Element attribute    jquery=div.link.question a@href
    Should Be Equal     ${attr1}     ${link}
    # Check what is AR text
    Element Text Should Be    jquery=div.link.question a     ${text}

Should not have what is AR in remaining area
    Page Should Not Contain Element     jquery=div.link.question a


Should have what credit card link in remaining area

Should not have what credit card link in remaining area

Should have AR management in remaining area
    [Arguments]    ${link}      ${text}
    # Get what is AR link
    ${attr1}=   Get Element attribute    jquery=div.link.mgmt a@href
    Should Be Equal     ${attr1}     ${link}
    # Check what is AR text
    Element Text Should Be    jquery=div.link.link.mgmt a     ${text}

Should not have AR management in remaining area
    Page Should Not Contain Element     jquery=div.link.mgmt a


# --------------------------------------------
#
# For Product list area
#
# --------------------------------------------
Wait until product list is displayed for a single product
    Wait Until Page Contains Element    jquery=div.product.default.clearfix hgroup h4 var     120 seconds

Check product name in product list area
    [Arguments]    ${text}
    Element Text Should Be    jquery=div.product.default.clearfix hgroup h4 var     ${text}

Should have expiration date in product list area
    [Arguments]    ${text}
    Page Should Contain Element     jquery=div.product.default.clearfix hgroup h5.exp-date.a
    Element Should Contain    jquery=div.product.default.clearfix hgroup h5.exp-date.a     ${text}

Should not have expiration date in product list area
    Page Should Not Contain Element     jquery=div.product.default.clearfix hgroup h5.exp-date.a

Should have promotion in product list area


Should not have promotion in product list area
    Page Should Not Contain Element     jquery=div.promotion

Should have download link in product list area
    [Arguments]    ${link}
    # Get download link
    ${attr1}=   Get Element attribute    jquery=ul.action-menu li.sbtn a.download@href
    Should Be Equal     ${attr1}     ${link}

Should not have download link in product list area
    Page Should Not Contain Element     jquery=ul.action-menu li.sbtn a.download@href



