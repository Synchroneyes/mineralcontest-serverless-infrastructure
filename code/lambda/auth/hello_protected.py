def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': "Hello, you are accessing a protected page!"
    }
