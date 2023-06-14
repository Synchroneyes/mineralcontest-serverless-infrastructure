import json
import boto3

def lambda_handler(event, context):
    # TODO implement
    map_name = event["pathParameters"]["mapname"]
    
    s3 = boto3.client("s3")
        
    # generate presigned url
    presigned_url = s3.generate_presigned_url('get_object', Params={'Bucket': 'mineralcontestmaps', 'Key': "{}/{}.jpg".format(map_name, map_name)}, ExpiresIn=3600, HttpMethod="GET")

    return {
        'statusCode': 301,
        "headers": {
            "Location": presigned_url,
            "Cache-Control": "max-age=86400"
        },
        'body': json.dumps("Downloading {}".format(map_name))
    }
