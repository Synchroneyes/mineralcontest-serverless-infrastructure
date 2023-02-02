import boto3
import os


def lambda_handler(event, context):
    client = boto3.client('cognito-idp')

    try:
        response = client.initiate_auth(
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={
                'USERNAME': event['email'],
                'PASSWORD': event['password'],
            },
            ClientId=os.environ['COGNITO_CLIENT_ID']
        )
    except Exception as e:
        return {
            'statusCode': 400,
            'body': str(e)
        }
    else:
        return {
            'statusCode': 200,
            'body': response
        }
