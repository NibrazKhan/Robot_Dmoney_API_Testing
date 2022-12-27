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
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8   Authorization=${token[0]}  X-AUTH-SECRET-KEY=${secret_key}
     ${response}=    POST On Session    mysession   /user/create     data=${user_info_json}    headers=${header}

#     Extracting value from json response
     ${message}=    get value from json     ${response.json()}      message
     log to console    ${message[0]}
     log to console    response: ${response.json()}
     ${customer1_id}=    get value from json     ${response.json()}      user.id
     set to dictionary    ${json_obj}   customer_1_id=${customer1_id[0]}
     ${customer1_phone_number}=    get value from json     ${response.json()}      user.phone_number
     set to dictionary    ${json_obj}   customer1_phone_number=${customer1_phone_number[0]}
     dump json to file    ${json_file_path}    ${json_obj}
     should be equal as strings    ${message[0]}   User created successfully
     should be equal as strings    ${response.status_code}  201
#*** Keywords ***
#Initialize Test Data
#    ${random_number}=    Generate Random String  8  [NUMBERS]
#    log to console    random number: ${random_number}
#    ${randomName}=  convert to string    TestName${random_number}
#    ${randomEmail}=     convert to string    TestEmail${random_number}@gmail.com
#    ${password}=    convert to string    TestPassword${random_number}
#    ${phoneNumber}=     convert to string    01345${random_number}
#    ${nid}=     convert to string    6452${random_number}
#    ${role}=    convert to string    Customer
#
#    set suite variable    ${random_number}
#    set suite variable    ${randomName}
#    set suite variable    ${randomEmail}
#    set suite variable    ${password}
#    set suite variable    ${nid}
#    set suite variable    ${role}