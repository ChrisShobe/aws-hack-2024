from flask import Flask, request, jsonify;

app = Flask(__name__)

@app.route("/recieve-data", methods = ['POST'])
def recieveData():
    try:
        # Parse the incoming JSON
        data = request.get_json()

        # Extract recipe names
        recipe1_name = data.get('recipe1_name')
        recipe2_name = data.get('recipe2_name')

        print(f"Received Recipe 1: {recipe1_name}")
        print(f"Received Recipe 2: {recipe2_name}")

        # Respond back with a confirmation
        return jsonify({
            "message": "Recipes received successfully",
            "recipe1_name": recipe1_name,
            "recipe2_name": recipe2_name
        }), 200
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
