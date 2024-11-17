from flask import Flask, request, jsonify
from flask_cors import CORS
from requesting import combined_message
from converse import fetch_model_response_for_string, fetch_model_response
import boto3
from botocore.exceptions import ClientError
import os
from dotenv import load_dotenv
from utils import read_message_file, stringify

app = Flask(__name__)
CORS(app)

load_dotenv()

# Get AWS credentials
access_key_id = os.getenv("AWS_ACCESS_KEY_ID")
secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY")

# Initialize the AWS Bedrock client
client = boto3.client(
    service_name="bedrock-runtime",
    aws_access_key_id=access_key_id,
    aws_secret_access_key=secret_access_key,
    region_name="us-west-2",
)

# The model ID for the model you want to use
model_id = "us.meta.llama3-2-3b-instruct-v1:0"


@app.route("/send_data", methods=['POST'])
def receiveData():
    try:
        # Parse the incoming JSON
        data = request.get_json()

        # Extract recipe information
        recipe1_name = data.get('recipe1_name')
        recipe1_steps = data.get('recipe1_steps')
        recipe1_ingredients = data.get('recipe1_ingredients')

        recipe2_name = data.get('recipe2_name')
        recipe2_steps = data.get('recipe2_steps')
        recipe2_ingredients = data.get('recipe2_ingredients')

        prev_inputs = data.get('prevInput')

        # Convert the recipes into string format
        recipe1_final = stringify(recipe1_name, recipe1_ingredients, recipe1_steps)
        recipe2_final = stringify(recipe2_name, recipe2_ingredients, recipe2_steps)

        # Generate a combined message using the recipes and additional instructions from a file
        combined_msg = combined_message(recipe1_final, recipe2_final, read_message_file('message.txt'))

        responses = fetch_model_response(client, model_id, combined_msg, prev_inputs)

        # Respond back with a confirmation
        return jsonify({
            "message": "Recipes received successfully",
            "recipe1_name": recipe1_name,
            "recipe2_name": recipe2_name,
            "model_responses": responses
        }), 200

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 400


@app.route("/send_message", methods=['POST'])
def sendMessage():
    try:
        data = request.get_json()
        message = data.get('message')

        if not message:
            return jsonify({"error": "No message provided"}), 400
        
        responsejson = fetch_model_response_for_string(client, model_id, read_message_file('ParseMessage.txt') + message)

        return jsonify({
            "message": "Message received successfully",
            "received_message": responsejson
        }), 200

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({
            "error": "An error occurred while processing your message",
            "message": str(e)
        }), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
