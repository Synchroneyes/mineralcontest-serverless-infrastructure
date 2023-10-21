import uuid
import boto3
import os
from datetime import datetime

def lambda_handler(event, context):
    
    table_name = os.environ["mineralcontest_maps_download_table_name"]
    
    # TODO implement
    downloader_ip = event["detail"]["sourceIPAddress"]
    user_agent = event["detail"]["userAgent"]
    downloaded_key = event["detail"]["requestParameters"]["key"]
    
    mapname = downloaded_key.split("/")[0]
    
    item = {
        "id_dl": str(uuid.uuid4()),
        "map_name": mapname,
        "ip": downloader_ip,
        "user_agent": user_agent,
        "date": str(datetime.now())
    }
    
    
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(table_name)
    table.put_item(Item=item)
    
