import json
import boto3


def lambda_handler(event, context):
    # TODO implement
    map_name = event["pathParameters"]["mapname"]

    dynamodb_client = boto3.client('dynamodb')
    query_params = {
        'TableName': "mineralcontest_maps_download",
        'IndexName': 'map_name-index',
        'KeyConditionExpression': 'map_name = :map_name',
        'ExpressionAttributeValues': {
            ':map_name': {'S': map_name}
        },
        'Select': 'COUNT'
    }

    # Perform the query
    response = dynamodb_client.query(**query_params)

    # Extract the count from the response
    count = response['Count']



    return {
        'statusCode': 200,
        'body': json.dumps({
            "map_url": "https://mineralcontestmaps.s3.eu-west-3.amazonaws.com/{}/{}.zip".format(map_name, map_name),
            "map_name": map_name,
            "map_description": "Une carte atypique et unique crée par Pgjgj. Une seule question se pose, Oseras tu t’aventurer dans les limbes pharaoniques ?",
            "map_size": "7759432",
            "map_folder_name": "mc_egypte",
            "map_file_name": "mc-egypte.zip",
            "map_download_count": count
        })
    }
