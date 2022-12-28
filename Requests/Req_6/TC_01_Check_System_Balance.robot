*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json
${secret_key}   ROADTOSDET

*** Test Cases ***
TC1: Check System Balance
     create session    mysession     ${base_url}
     ${json_obj}=   load json from file     ${json_file_path}
     ${token}=  get value from json    ${json_obj}  $.token
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8   Authorization=${token[0]}  X-AUTH-SECRET-KEY=${secret_key}
     ${response}=    get request    mysession   /transaction/balance/SYSTEM  headers=${header}
     log to console    response.json()
#     Extracting value from json response
     ${system_balance}=    get value from json     ${response.json()}      balance
     set to dictionary    ${json_obj}   system_balance=${system_balance[0]}
     dump json to file    ${json_file_path}   ${json_obj}
     ${message}=    get value from json     ${response.json()}      message
     log to console    ${response.json()}
     log to console    "Message:\n ${message[0]}
     should be equal as strings    ${message[0]}    User balance
     should be equal as strings    ${response.status_code}  200