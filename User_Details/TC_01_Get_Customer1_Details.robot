*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${base_url}     http://dmoney.professionaltrainingbd.com
${json_file_path}   C:/Users/NibrazKhan/Desktop/Python API Automation/DmoneyAPIAutomation/Variables.json
${secret_key}   ROADTOSDET
${req_url}      /user/search/?

*** Test Cases ***
TC1: Successful Login With Valid Credentials
     create session    mysession     ${base_url}

     ${json_obj}=   load json from file     ${json_file_path}
     ${token}=  get value from json    ${json_obj}  $.token
     ${id}=      get value from json    ${json_obj}  $.customer_1_id
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8   Authorization=${token[0]}  X-AUTH-SECRET-KEY=${secret_key}
     ${param}=   create dictionary  id=${id[0]}
     ${response}=    get request    mysession   ${req_url}     params=${param}    headers=${header}

#     Extracting value from json response
     ${customer1_ID}=    get value from json     ${response.json()}      user.id
     log to console    ${response.json()}
     should be equal as strings    ${customer1_ID[0]}   ${id[0]}
     should be equal as strings    ${response.status_code}  200