import boto3
import os


def lambda_handler(event, context):
    client = boto3.client('cognito-idp')

    try:
        response = client.initiate_auth(
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={
                'USERNAME': event['username'],
                'PASSWORD': event['password'],
            },
            ClientId=os.environ['COGNITO_CLIENT_ID']
        )
        
    
    except client.exceptions.UserNotConfirmedException as e:
        return {
            'statusCode': 400,
            'body': 'ERROR_EMAIL_NOT_CONFIRMED'
        }
    except client.exceptions.NotAuthorizedException as e:
        return {
            'statusCode': 400,
            'body': 'ERROR_USERNAME_OR_PASSWORD_INVALID'
        }
    else:
        return {
            'statusCode': 200,
            'body': response['AuthenticationResult']['IdToken']
        }
