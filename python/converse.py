import boto3
from botocore.exceptions import ClientError
import os
from dotenv import load_dotenv
from utils import read_message_file, stringify

load_dotenv()

# Put your AWS credentials in a .env file
access_key_id = os.getenv("AWS_ACCESS_KEY_ID")
secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY")

client = boto3.client(
    service_name="bedrock-runtime",
    aws_access_key_id=access_key_id,
    aws_secret_access_key=secret_access_key,
    region_name="us-west-2",
)

# The model ID for the model you want to use
model_id = "us.meta.llama3-2-3b-instruct-v1:0"


def fetch_model_response(client, model_id, user_message, previous_responses=None):
    """
    Fetches the model response from AWS Bedrock with context.

    Args:
        client (boto3.client): The initialized AWS Bedrock client.
        model_id (str): The ID of the model to use.
        user_message (str): The current user message.
        previous_responses (list, optional): The list of previous messages in the conversation.

    Returns:
        str: The model response or None if the response is empty or an error occurs.
    """
    if not user_message:
        return None

    conversation = previous_responses if previous_responses else []
    conversation.append(
        {
            "role": "user",
            "content": [{"text": user_message}],
        }
    )

    try:
        streaming_response = client.converse_stream(
            modelId=model_id,
            messages=conversation,
            inferenceConfig={"maxTokens": 512, "temperature": 0.5, "topP": 0.9},
        )

        response_text = ""
        for chunk in streaming_response["stream"]:
            if "contentBlockDelta" in chunk:
                response_text += chunk["contentBlockDelta"]["delta"]["text"]

        return response_text if response_text else None

    except (ClientError, ValueError, Exception):
        return None


def fetch_model_response_for_string(client, model_id, general_string):
    """
    Fetches the model response from AWS Bedrock for a general string input.

    Args:
        client (boto3.client): The initialized AWS Bedrock client.
        model_id (str): The ID of the model to use.
        general_string (str): The general string to send to the model.

    Returns:
        str: The model response or None if the response is empty or an error occurs.
    """
    if not general_string:
        return None
    conversation = [
        {
            "role": "user",
            "content": [{"text": general_string}],
        }
    ]
    try:
        streaming_response = client.converse_stream(
            modelId=model_id,
            messages=conversation,
            inferenceConfig={"maxTokens": 512, "temperature": 0.5, "topP": 0.9},
        )
        response_text = ""
        for chunk in streaming_response["stream"]:
            if "contentBlockDelta" in chunk:
                response_text += chunk["contentBlockDelta"]["delta"]["text"]
        return response_text if response_text else None
    except (ClientError, ValueError, Exception) as e:
        print(f"Error fetching model response: {e}")
        return None

