import boto3
import os



def lambda_handler(event, context):
    client = boto3.client('cognito-idp')
    
    if 'email' not in event:
        return {
            'statusCode': 400,
            'body': 'ERROR_EMAIL_NOT_PROVIDED'
         }
    
    if 'username' not in event:
        return {
        'statusCode': 400,
        'body': 'ERROR_USERNAME_NOT_PROVIDED'
    }
    
    if 'password' not in event:
        return {
        'statusCode': 400,
        'body': 'ERROR_PASSWORD_NOT_PROVIDED'
    }
    
    
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

        return {
            'statusCode': 200,
            'body': 'USER_SUCESSFULLY_CREATED'
        }
        
    except client.exceptions.UsernameExistsException as e:
        return {
            'statusCode': 400,
            'body': 'ERROR_USER_ALREADY_EXISTS'
        }
    
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': "error"
        }
