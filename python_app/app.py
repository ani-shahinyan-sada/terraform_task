import os
import pymysql
from flask import Flask, render_template, jsonify

app = Flask(__name__)

def get_db_connection():
    conn = pymysql.connect(
        host='10.83.0.5',  # Your database private IP
        user='default',
        password='Um0=dHUJGqg;r8JF',  
        database='default',
        port=3306,
        ssl={'ssl_disabled': False}  # Enable SSL using Google's certs
    )
    return conn

@app.route('/')
def index():
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <title>🍳 Recipe Generator</title>
        <style>
            body { font-family: Arial; background: #f9f9f9; padding: 20px; text-align: center; }
            .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            .btn { background: #ff6b6b; color: white; padding: 12px 24px; border: none; border-radius: 8px; cursor: pointer; margin: 10px; text-decoration: none; display: inline-block; }
            .btn:hover { background: #ff5252; }
            h1 { color: #333; margin-bottom: 30px; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🍳 Random Recipe Generator</h1>
            <a href="/random-recipe" class="btn">Get Random Recipe 🎲</a>
            <a href="/all-recipes" class="btn">View All Recipes 📋</a>
        </div>
    </body>
    </html>
    '''

@app.route('/random-recipe')
def random_recipe_page():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("SELECT recipe, ingredients FROM recipes ORDER BY RAND() LIMIT 1")
        result = cursor.fetchone()
        
        conn.close()
        
        if result:
            recipe_name = result[0]
            ingredients = result[1].split(', ')
            
            ingredients_html = ''.join([f'<li>✨ {ing}</li>' for ing in ingredients])
            
            return f'''
            <!DOCTYPE html>
            <html>
            <head>
                <title>🍳 {recipe_name}</title>
                <style>
                    body {{ font-family: Arial; background: #f9f9f9; padding: 20px; text-align: center; }}
                    .container {{ max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
                    .recipe-title {{ color: #ff6b6b; margin-bottom: 20px; }}
                    ul {{ text-align: left; display: inline-block; }}
                    li {{ margin: 8px 0; color: #555; }}
                    .btn {{ background: #ff6b6b; color: white; padding: 12px 24px; border: none; border-radius: 8px; cursor: pointer; margin: 10px; text-decoration: none; display: inline-block; }}
                    .btn:hover {{ background: #ff5252; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <h1 class="recipe-title">🍽️ {recipe_name}</h1>
                    <h3>Ingredients:</h3>
                    <ul>{ingredients_html}</ul>
                    <a href="/random-recipe" class="btn">Get Another Recipe 🎲</a>
                    <a href="/" class="btn">Back Home 🏠</a>
                </div>
            </body>
            </html>
            '''
        else:
            return '<h1>No recipes found! 😢</h1>'
            
    except Exception as e:
        return f'<h1>Error: {str(e)} 😵</h1>'

@app.route('/all-recipes')
def all_recipes_page():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("SELECT recipe, ingredients FROM recipes")
        results = cursor.fetchall()
        
        conn.close()
        
        recipes_html = ''
        for row in results:
            recipe_name = row[0]
            ingredients = row[1].split(', ')
            ingredients_list = ''.join([f'<li>✨ {ing}</li>' for ing in ingredients])
            
            recipes_html += f'''
            <div class="recipe-card">
                <h3>🍽️ {recipe_name}</h3>
                <ul>{ingredients_list}</ul>
            </div>
            '''
        
        return f'''
        <!DOCTYPE html>
        <html>
        <head>
            <title>🍳 All Recipes</title>
            <style>
                body {{ font-family: Arial; background: #f9f9f9; padding: 20px; }}
                .container {{ max-width: 800px; margin: 0 auto; }}
                .recipe-card {{ background: white; margin: 20px 0; padding: 20px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }}
                ul {{ margin: 10px 0; }}
                li {{ margin: 5px 0; color: #555; }}
                .btn {{ background: #ff6b6b; color: white; padding: 12px 24px; border: none; border-radius: 8px; cursor: pointer; margin: 10px; text-decoration: none; display: inline-block; }}
                .btn:hover {{ background: #ff5252; }}
                h1 {{ text-align: center; color: #333; }}
            </style>
        </head>
        <body>
            <div class="container">
                <h1>📋 All Recipes</h1>
                {recipes_html}
                <div style="text-align: center;">
                    <a href="/" class="btn">Back Home 🏠</a>
                </div>
            </div>
        </body>
        </html>
        '''
            
    except Exception as e:
        return f'<h1>Error: {str(e)} 😵</h1>'

# Keep the JSON API endpoints too
@app.route('/api/random-recipe')
def get_random_recipe():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("SELECT recipe, ingredients FROM recipes ORDER BY RAND() LIMIT 1")
        result = cursor.fetchone()
        
        conn.close()
        
        if result:
            return jsonify({
                "success": True, 
                "recipe_name": result[0],
                "ingredients": result[1]
            })
        else:
            return jsonify({"success": False, "error": "No recipes found"})
            
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/api/all-recipes')
def get_all_recipes():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("SELECT recipe, ingredients FROM recipes")
        results = cursor.fetchall()
        
        conn.close()
        
        recipes = []
        for row in results:
            recipes.append({
                "recipe_name": row[0],
                "ingredients": row[1]
            })
        
        return jsonify({"success": True, "recipes": recipes})
            
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)