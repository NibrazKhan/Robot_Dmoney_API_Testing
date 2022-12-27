*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os

*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   C:/Users/NibrazKhan/Desktop/Python API Automation/DmoneyAPIAutomation/Variables.json

*** Test Cases ***
TC1: Successful Login With Valid Credentials
     create session    mysession     ${base_url}
     ${body}=    create dictionary  email=salman@roadtocareer.net    password=1234
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8
     ${response}=    POST On Session    mysession   /user/login     json=${body}    headers=${header}
#     checking the type of the variable response.
#     ${type}=    Evaluate     type($response)
#     Log To Console     ${type}
#     Extracting value from json response
     ${message}=    get value from json     ${response.json()}      message
     log to console    ${message[0]}
#     Extracting token from json response in another way.
     ${json_response}=  evaluate  json.loads("""${response.content}""")   json
     ${token_response}=      get from dictionary    ${json_response}  token
#     checking the type of the token_response
#     ${type_json}=    Evaluate     type($json_response)
#     Log To Console     ${type_json}
#     Setting the variable as suite variable
     Set Suite Variable    ${token}    ${token_response}
     log to console    \nToken:\n${token}
#     log to console    ${response.json()}
#     log to console   \nToken Generated:\n${response.token}
     #Setting token value in a json file.
     ${json_obj}=   load json from file     ${json_file_path}
     #Converting json object to a python dictionary object
#     ${json_dic}=   evaluate    json.loads('''${json_obj}''')   json
     #Setting the new value in the dictionary keeping token as key
     set to dictionary    ${json_obj}   token=${token}
     #Saving the dictionary into the json file
     dump json to file  ${json_file_path}   ${json_obj}
     # Validations
     should be equal as strings    ${message[0]}   Login successfully
     should be equal as strings    ${response.status_code}  200