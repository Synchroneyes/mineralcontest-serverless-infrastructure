import boto3
import os

def lambda_handler(event, context):

    bucket_name = os.environ['S3_MAPS_BUCKET_NAME']
    
    requirements = {
        "map_name": "ERROR_NO_MAP_NAME_PROVIDED",
        "accessToken": "ERROR_NOT_LOGGED_IN",
        "map_description": "ERROR_NO_MAP_DESCRIPTION_PROVIDED",
        "map_archive": "ERROR_NO_MAP_FILE_PROVIDED"
    }

    for requirement in requirements:
        if requirement not in event:
            return {
                'statusCode': 400,
                'body': requirements[requirement]
            }
        
    s3_client = boto3.client('s3')
    #dynamodb_client = boto3.client("dynamodb")

    s3_client.put_object(Bucket=bucket_name, Key=event["map_name"])
    s3_client.upload_file(event['map_archive'], bucket_name, "{}.zip".format(event['map_name']))


