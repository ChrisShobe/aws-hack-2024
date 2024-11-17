def combined_message(recipe1, recipe2, more_info):
    """
    Combines two recipes and an additional prompt into a single detailed message
    for the AI model to process.
    
    Args:
        recipe1 (str): The first recipe.
        recipe2 (str): The second recipe.
        additional_prompt (str): Additional context or instructions for the AI.

    Returns:
        str: A crafted message for the AI.
    """
    message = (
        f"I have two recipes:\n\n"
        f"Recipe 1:\n{recipe1}\n\n"
        f"Recipe 2:\n{recipe2}\n\n"
        f"Please create a new recipe that combines the best elements of both. "
        f"{more_info}"
    )
    return message
