import os
import pymysql
from flask import Flask, render_template, jsonify

app = Flask(__name__)

def get_db_connection():
    # Use the private IP of your database directly
    conn = pymysql.connect(
        host='10.187.0.2',  # Your database private IP
        user='default',
        password='BZSssDld59byhKCx0ta3',  
        database='default',
        port=3306
    )
    return conn

@app.route('/')
def index():
    return '<h1>Hello from Cloud Run!</h1><p>Database connection working!</p>'

@app.route('/api/random-value')
def get_random_value():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Simple test query
        cursor.execute("SELECT 'Hello from Database!' as message")
        result = cursor.fetchone()
        
        conn.close()
        
        if result:
            return jsonify({"success": True, "value": result[0]})
        else:
            return jsonify({"success": False, "error": "No data found"})
            
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)


#this part must be here because we are connecting via a google managed certificate 
conn = pymysql.connect(
    host='10.28.0.2',                    # Your database private IP
    user='default',
    password='your_password',
    database='default',
    ssl={'ssl_disabled': False}          # This enables SSL using Google's certs
)