*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json
${secret_key}   ROADTOSDET

*** Test Cases ***
TC1: Check Agent Balance After Deposit
     create session    mysession     ${base_url}
     ${json_obj}=   load json from file     ${json_file_path}
     ${token}=  get value from json    ${json_obj}  $.token
     ${agent_phone_number}=      get value from json    ${json_obj}  $.Agent_phone_number
     ${agent_previous_balance}=     get value from json    ${json_obj}  $.agent_balance
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8   Authorization=${token[0]}  X-AUTH-SECRET-KEY=${secret_key}
     ${response}=    get request    mysession   /transaction/balance/${agent_phone_number[0]}   headers=${header}
#     ${agent_previous_balance}=     convert to integer    ${agent_previous_balance[0]}
     ${expected_agent_current_balance}=     evaluate    ${agent_previous_balance[0]}-1950
     log to console    expected_agent_current_balance: ${expected_agent_current_balance}
#     Extracting value from json response
     ${agent_current_balance}=    get value from json     ${response.json()}      balance
     ${message}=    get value from json     ${response.json()}      message
     log to console    ${response.json()}
     should be equal as strings    ${message[0]}    User balance
     should be equal as strings    ${response.status_code}  200
     # Failing because agent current balance is wrong
     should be equal as numbers    ${expected_agent_current_balance}    ${agent_current_balance[0]}