*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${base_url}     http://dmoney.professionaltrainingbd.com
${json_file_path}   C:/Users/NibrazKhan/Desktop/Python API Automation/DmoneyAPIAutomation/Variables.json
${secret_key}   ROADTOSDET

*** Test Cases ***
TC1: Successful Login With Valid Credentials
     create session    mysession     ${base_url}
     ${json_obj}=   load json from file     ${json_file_path}
     ${token}=  get value from json    ${json_obj}  $.token
     ${customer1_phone_number}=      get value from json    ${json_obj}  $.customer1_phone_number
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8   Authorization=${token[0]}  X-AUTH-SECRET-KEY=${secret_key}
     ${response}=    get request    mysession   /transaction/balance/${customer1_phone_number[0]}   headers=${header}

#     Extracting value from json response
     ${customer1_balance}=    get value from json     ${response.json()}      balance
     set to dictionary    ${json_obj}   customer1_balance=${customer1_balance[0]}
     dump json to file    ${json_file_path}   ${json_obj}
     ${message}=    get value from json     ${response.json()}      message
     log to console    ${response.json()}
     should be equal as strings    ${message[0]}    User balance
     should be equal as strings    ${response.status_code}  200