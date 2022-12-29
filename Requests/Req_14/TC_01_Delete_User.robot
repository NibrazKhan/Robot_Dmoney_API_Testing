*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String
Library    OperatingSystem


*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json
${secret_key}   ROADTOSDET

*** Test Cases ***
TC1: Delete User
     create session    mysession     ${base_url}
     ${json_obj}=   load json from file     ${json_file_path}
     ${token}=  get value from json    ${json_obj}  $.token
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8   Authorization=${token[0]}  X-AUTH-SECRET-KEY=${secret_key}
     ${customer_1_id}=  get value from json     ${json_obj}     $.customer_1_id
     ${response}=    delete request        mysession   /user/delete/${customer_1_id[0]}  headers=${header}
     ${message}=    get value from json     ${response.json()}      message
     log to console    ${message[0]}
     should be equal as strings    ${message[0]}    User deleted successfully
     should be equal as strings    ${response.status_code}  200