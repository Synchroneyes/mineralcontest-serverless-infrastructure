import boto3
import os


def lambda_handler(event, context):
    client = boto3.client('cognito-idp')
    email = event['email']
    username = event['username']
    password = event['password']

    try:
        response = client.sign_up(
            ClientId=os.environ['COGNITO_CLIENT_ID'],
            Username=username,
            Password=password,
            UserAttributes=[
                {
                    'Name': 'email',
                    'Value': email
                },
            ]
        )

        print(response)
        return {
            'statusCode': 200,
            'body': 'User added successfully'
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': 'Failed to add user'
        }
