*** Settings ***
Documentation     A test suite for sso signin by email.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Resource          ../Resources/resource.robot
Resource          ../Resources/TextMsg.robot
# Set Tags


*** Variables ***
${valid_username}   poc-eudb-mpa-allvb@yopmail.com
${valid_password}   12345678


${dpjp_product_name}     パスワードマネージャー

*** Keywords ***
Login with invalid credentials should fail
    [Arguments]    	${username} 	${password}   ${selector}    ${error_msg}
    Open Browser To Login Page	   JA-JP
    Input username    ${username}
    Input password    ${password}
    Submit Credentials
    Element Text Should Be    jquery=${selector}     ${error_msg}

    #For a partial match use this:
    #Element Should Contain    locator    expected_text
    #For an exact match use this:
    #Element Text Should Be    locator    expected_text

    # Page Should Contain Element       jquery=${selector}        AAA${error_msg}
    # Wait Until Page Contains Element  jquery=p      20 seconds
    [Teardown]    Close Browser

Page should contain forget email text
    Page Should Contain Link    link=${FORGET_EMAIL_LINK_TEXT}

Page should contain forget password text
    Page Should Contain Link    link=${FORGET_PASSWORD_LINK_TEXT}

Page should contain forget sn text
    Page Should Contain Link    link=${FORGET_SN_LINK_TEXT}



*** Test Cases ***
Sigin by email by a valid account (Locale=JA-JP)
	[Tags]		SSO		Sign-in by email
    Open Browser To Login Page	   JA-JP
    # Confirm forget email/password/sn link are shown on sign-in page
    Page should contain forget email text
    Page should contain forget password text
    Page should contain forget sn text
    # Start to sigin in by email
    Input Username    ${valid_username}
    Input Password    ${valid_password}
    Submit Credentials
    MyAccount Should Be Open
    Wait Until Page Contains    ${dpjp_product_name}     30 seconds
    [Teardown]    Close Browser


Login with invalid credentials
	[Tags]		SSO		SigninByEmail    AAA
	[Template]    Login with invalid credentials should fail
	${INVALID_USER}		${INVALID_PASS}   p.msg.err+p    ${ERROR_MSG_OF_INVALID_ACCOUNT}
	${EMPTY}			${INVALID_PASS}   div.msg.err    ${ERROR_MSG_OF_NO_EMAIL}
    ${INVALID_USER}		${EMPTY}          div.msg.err    ${ERROR_MSG_OF_NO_PASS}
 	${EMPTY}			${EMPTY}          div.msg.err    ${ERROR_MSG_OF_NO_EMAIL_PASS}


# Forget password by valid MPA



