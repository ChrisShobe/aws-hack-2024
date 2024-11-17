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
        str: The model response or an error message if the response is None.
    """
    # Ensure the user message is not empty or None
    if not user_message:
        print("ERROR: User message is empty. Please provide a valid message.")
        return None

    # Initialize the conversation list
    conversation = []

    # Always start the conversation with a user message
    if not previous_responses:
        # If no previous responses, this must be the first user message
        conversation.append(
            {
                "role": "user",
                "content": [{"text": user_message}],
            }
        )
    else:
        # Validate that the previous responses list starts with a user message
        if previous_responses[0]["role"] != "user":
            print("ERROR: Conversation history is invalid. It must start with a user message.")
            return None

        # Add previous responses to the conversation
        conversation.extend(previous_responses)

        # Append the current user message
        conversation.append(
            {
                "role": "user",
                "content": [{"text": user_message}],
            }
        )

    print("Sending the following conversation to the model:")
    for message in conversation:
        print(f"Role: {message['role']}, Content: {message['content'][0]['text']}")  # Debugging print

    try:
        # Send the request to AWS Bedrock and stream the response
        streaming_response = client.converse_stream(
            modelId=model_id,
            messages=conversation,
            inferenceConfig={"maxTokens": 512, "temperature": 0.5, "topP": 0.9},
        )

        print("\nModel Response:")
        # Extract and print the streamed response text in real-time
        response_text = ""
        for chunk in streaming_response["stream"]:
            if "contentBlockDelta" in chunk:
                text = chunk["contentBlockDelta"]["delta"]["text"]
                print(text, end="")
                response_text += text
        print()  # Add a newline at the end of the response

        if not response_text:
            raise ValueError("Model response is empty or None.")

        return response_text

    except (ClientError, ValueError, Exception) as e:
        print(f"ERROR: Can't invoke '{model_id}'. Reason: {e}")
        return None


def fetch_model_responses_multiple_times(client, model_id, user_message, previous_responses=None, num_requests=3):
    """
    Calls the fetch_model_response function multiple times in a loop.

    Args:
        client (boto3.client): The initialized AWS Bedrock client.
        model_id (str): The model ID for the model to use.
        user_message (str): The user message to send.
        previous_responses (list, optional): List of previous conversation history.
        num_requests (int, optional): The number of times to call fetch_model_response. Default is 3.

    Returns:
        list: A list of responses from the model for each request.
    """
    responses = []
    for i in range(num_requests):
        print(f"Fetching response {i + 1}...")
        response = fetch_model_response(client, model_id, user_message, previous_responses)
        
        if response:
            responses.append(response)
            # Update the conversation history with the user's message and assistant's response
            previous_responses.append(
                {
                    "role": "user",
                    "content": [{"text": user_message}],
                }
            )
            previous_responses.append(
                {
                    "role": "assistant",
                    "content": [{"text": response}],
                }
            )
        else:
            print(f"Error fetching response {i + 1}")

    return responses
