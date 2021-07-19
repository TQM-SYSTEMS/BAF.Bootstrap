@chcp 65001

call allure generate --clean .\out\allure .\out\allure\smoke -o .\out\allure\allure-report && allure open .\out\allure\allure-report
# Для PowerShell: allure generate --clean .\out\allure -o .\out\allure\allure-report; allure open .\out\allure\allure-report