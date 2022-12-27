*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String
Library    OperatingSystem


*** Variables ***
${base_url}     http://dmoney.professionaltrainingbd.com
${json_file_path}   C:/Users/NibrazKhan/Desktop/Python API Automation/DmoneyAPIAutomation/Variables.json
${secret_key}   ROADTOSDET

*** Test Cases ***
TC1: Successful Login With Valid Credentials
     create session    mysession     ${base_url}
     ${json_obj}=   load json from file     ${json_file_path}
     ${token}=      get value from json    ${json_obj}  $.token
     ${agent_phone_number}=     get value from json    ${json_obj}  $.Agent_phone_number
     ${amount}=     convert to integer    4000
     ${user_info}=  create dictionary    from_account=SYSTEM     to_account=${agent_phone_number[0]}     amount=${amount}
     #Converted dictionary to json
     ${user_info_json}=     evaluate    json.dumps(${user_info},indent=4)
     log to console   ${user_info_json}
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8   Authorization=${token[0]}  X-AUTH-SECRET-KEY=${secret_key}
     ${response}=    POST On Session    mysession   /transaction/deposit     data=${user_info_json}    headers=${header}
     log to console    ${response.json()}
#     Extracting value from json response
     ${message}=    get value from json     ${response.json()}      message
     log to console    ${message[0]}
     should be equal as strings    ${message[0]}   Deposit successful
     should be equal as strings    ${response.status_code}  201