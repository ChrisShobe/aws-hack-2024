from flask import Flask, request, jsonify
from flask_cors import CORS
from requesting import combined_message

app = Flask(__name__)
CORS(app)


def read_message_file(file_path):
    with open(file_path, 'r') as file:
        return file.read() 

def stringify(name, ingredients, steps):
    ingredients_str = "\n".join(ingredients) if ingredients else "No ingredients listed."
    steps_str = "\n".join(steps) if steps else "No steps listed."
    recipe_str = f"Recipe: {name}\nIngredients:\n{ingredients_str}\nSteps:\n{steps_str}"
    return recipe_str

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

        recipe1_final = stringify(recipe1_name, recipe1_ingredients, recipe1_steps)
        recipe2_final = stringify(recipe2_name, recipe2_ingredients, recipe2_steps)

        combined_message(recipe1_final, recipe2_final, read_message_file('message.txt'))

        # print(f"Received Recipe 1: {recipe1_name}")
        # print(f"Steps: {recipe1_steps}")
        # print(f"Ingredients: {recipe1_ingredients}")

        # print(f"Received Recipe 2: {recipe2_name}")
        # print(f"Steps: {recipe2_steps}")
        # print(f"Ingredients: {recipe2_ingredients}")

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
    app.run(host='0.0.0.0', port=5001, debug=True)
