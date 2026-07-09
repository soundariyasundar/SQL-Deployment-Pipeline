pipeline {

    agent any

    options {
        timestamps()
    }

    parameters {

        choice(
            name: 'TARGET_ENV',
            choices: ['pre-prod', 'production'],
            description: 'Select Environment'
        )

        string(
            name: 'JIRA_TICKET',
            defaultValue: '',
            description: 'Enter JIRA Ticket Number'
        )

        string(
            name: 'SQL_FILE',
            defaultValue: 'update_salary.sql',
            description: 'SQL file inside cicd-sql/queries'
        )

    }

    environment {

        DB_HOST = "172.31.22.97"
        DB_PORT = "3306"
        DB_NAME = "company_db"

    }

    stages {

        stage('1. CONNECTIVITY CHECK') {

            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'mysql-preprod-credentials',
                        usernameVariable: 'DB_USER',
                        passwordVariable: 'DB_PASSWORD'
                    )
                ]) {

                    sh '''
                    chmod +x cicd-sql/scripts/verify-db-connectivity.sh
                    ./cicd-sql/scripts/verify-db-connectivity.sh
                    '''

                }

            }

        }

        stage('2. COMMAND VALIDATION') {

            steps {

                sh """
                chmod +x cicd-sql/scripts/validate-sql.sh

                ./cicd-sql/scripts/validate-sql.sh \
                cicd-sql/queries/${params.SQL_FILE}
                """

            }

        }

        stage('3. APPROVAL BY SQL TEAM') {

            steps {

                input(

                    message: """

JIRA Ticket :

${params.JIRA_TICKET}

SQL File :

${params.SQL_FILE}

Please review the SQL before execution.

Approve?

""",

                    ok: "Approve",

                    submitter: "sqladmin"

                )

            }

        }

        stage('4. PLAN (INTENDED OUTPUT)') {

            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'mysql-preprod-credentials',
                        usernameVariable: 'DB_USER',
                        passwordVariable: 'DB_PASSWORD'
                    )
                ]) {

                    sh """

                    chmod +x cicd-sql/scripts/plan-sql.sh

                    ./cicd-sql/scripts/plan-sql.sh \
                    cicd-sql/queries/${params.SQL_FILE}

                    """

                }

            }

        }

        stage('5. APPROVAL BY APPLICATION TEAM') {

            steps {

                input(

                    message: """

Execution Plan Generated.

JIRA :

${params.JIRA_TICKET}

SQL :

${params.SQL_FILE}

Approve Database Write?

""",

                    ok: "Execute",

                    submitter: "appadmin"

                )

            }

        }

        stage('6. EXECUTE SQL') {

            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'mysql-preprod-credentials',
                        usernameVariable: 'DB_USER',
                        passwordVariable: 'DB_PASSWORD'
                    )
                ]) {

                    sh """

                    chmod +x cicd-sql/scripts/execute-sql.sh

                    ./cicd-sql/scripts/execute-sql.sh \
                    cicd-sql/queries/${params.SQL_FILE}

                    """

                }

            }

        }

    }

    post {

        success {

            echo "=================================="
            echo "SQL Deployment Successful"
            echo "JIRA : ${params.JIRA_TICKET}"
            echo "=================================="

        }

        failure {

            echo "=================================="
            echo "SQL Deployment Failed"
            echo "=================================="

        }

    }

}
