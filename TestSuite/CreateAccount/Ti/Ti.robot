*** Settings ***
Documentation     A test suite for MyAccount Product tab.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Resource          ../../Resources/resource.robot
Resource          ../../Utility/backend_utility.robot


# Set Tags


*** Variables ***
# ${valid_username}   poc-eudb-mpa-allvb@yopmail.com
# ${valid_password}   12345678


*** Variables ***
# ${PASSWORD}     12345678
# ${BETA_DPJP_FULL}       DPJP_FULL_BETA@yopmail.com
# ${BETA_DPJP_FULL_SN}    BAAB-0012-0924-1993-0800
# ${PRODUCT_NAME_DPJP}    パスワードマネージャー



*** Keywords ***
# Parameter : PID
Register Titanium
	[Arguments]     ${pid}
    # Generate Ti serial number from backend utility
    ${serial}=    Get Titanium serial number    ${pid}
    # Generate a randon GUID
    ${guid}=      Get random GUID
    Open Titanium Reg form      ${pid}    ${serial}   ${guid}


    # Open Browser    http://account.trendmicro.com/?${serial}    ${BROWSER}    ff_profile_dir=${FF_PROFILE}
    # [Teardown]    Close Browser











