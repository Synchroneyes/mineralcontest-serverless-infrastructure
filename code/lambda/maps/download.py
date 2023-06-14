import json
import boto3
import uuid

def lambda_handler(event, context):
    # TODO implement
    map_name = event["pathParameters"]["mapname"]
    
    dynamodb = boto3.resource("dynamodb")
    s3 = boto3.client("s3")
    
    dynamodb_download_table_name = "mineralcontest_maps_download"
    dynamodb_table = dynamodb.Table(dynamodb_download_table_name) 
    
    item = {
        "id_dl": str(uuid.uuid4()),
        "map_name": map_name,
        "ip": event["requestContext"]["identity"]["sourceIp"]
    }
    
    dynamodb_table.put_item(Item=item)
    
    # generate presigned url
    presigned_url = s3.generate_presigned_url('get_object', Params={'Bucket': 'mineralcontestmaps', 'Key': "{}/{}.zip".format(map_name, map_name)}, ExpiresIn=3600, HttpMethod="GET")

    return {
        'statusCode': 301,
        "headers": {
            "Location": presigned_url,
            "Cache-Control": "no-cache"
        },
        'body': json.dumps(event)
    }
