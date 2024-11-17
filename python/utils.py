
def read_message_file(file_path):
    with open(file_path, 'r') as file:
        return file.read() 
    
def stringify(name, ingredients, steps):
    ingredients_str = "\n".join(ingredients) if ingredients else "No ingredients listed."
    steps_str = "\n".join(steps) if steps else "No steps listed."
    recipe_str = f"Recipe: {name}\nIngredients:\n{ingredients_str}\nSteps:\n{steps_str}"
    return recipe_str