*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String
Library    OperatingSystem
#Suite Setup    Initialize Test Data


*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json
${secret_key}   ROADTOSDET

*** Test Cases ***
TC1: Creation of User_1
     create session    mysession     ${base_url}
     ${random_number}=    Generate Random String  8  [NUMBERS]
     ${randomName}=     generate random string    8-15
     ${randomEmail}=     convert to string    TestEmail${randomName}@gmail.com
     ${password}=    convert to string    TestP@ssword${randomName}
     ${phoneNumber}=     convert to string    017${random_number}
     ${nid}=     convert to string    612345${random_number}
     ${role}=    convert to string    Customer
     ${user_info}=  create dictionary    name=${randomName}     email=${randomEmail}    password=${password}    phone_number=${phoneNumber}   nid=${nid}    role=${role}
     #Converted dictionary to json
     ${user_info_json}=     evaluate    json.dumps(${user_info},indent=4)
     log to console   ${user_info_json}
     ${json_obj}=   load json from file     ${json_file_path}
     ${token}=      get value from json    ${json_obj}  $.token
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8   Authorization=Wrong${token[0]}  X-AUTH-SECRET-KEY=Wrong${secret_key}
     ${response}=   Run Keyword And Expect Error  *      POST On Session    mysession   /user/create     data=${user_info_json}    headers=${header}
     log to console     ${response}
     should contain    ${response}  401

