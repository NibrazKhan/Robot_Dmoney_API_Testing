*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   ./Variables.json

*** Test Cases ***
TC1: UnSuccessful Login With InValid Credentials
     create session    mysession     ${base_url}
     ${body}=    create dictionary  email=wrong@roadtocareer.net    password=wrong password
     ${header}=  create dictionary   Content-Type=application/json; charset=utf-8
     ${response}=    Run Keyword And Expect Error  *    POST On Session    mysession   /user/login     json=${body}    headers=${header}
#     checking the type of the variable response.
     log to console    Response: ${response}
     ${type}=    Evaluate     type($response)
     Log To Console     ${type}
     should contain     ${response}     404
