*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json
${secret_key}   ROADTOSDET
${req_url}      /user/list

*** Test Cases ***
TC1: Get User List
     create session    mysession     ${base_url}
     ${json_obj}=   load json from file     ${json_file_path}
     ${token}=  get value from json    ${json_obj}  $.token
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8   Authorization=${token[0]}  X-AUTH-SECRET-KEY=${secret_key}
     ${response}=    get request    mysession   ${req_url}  headers=${header}

#     Extracting value from json response
     log to console    ${response.json()}
     ${message}=    get value from json     ${response.json()}      message
     should be equal as strings    ${message[0]}    User list
     should be equal as strings    ${response.status_code}  200