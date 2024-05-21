from flask import Flask, request, jsonify # type: ignore
from flask_sqlalchemy import SQLAlchemy  # type: ignore
from flask_cors import CORS  # type: ignore
from werkzeug.security import generate_password_hash, check_password_hash # type: ignore

app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///usuarios.db'
db = SQLAlchemy(app)

class Usuario(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50), nullable=False)
    apellido = db.Column(db.String(50), nullable=False)
    correo = db.Column(db.String(100), unique=True, nullable=False)
    contrasena = db.Column(db.String(100), nullable=False)

with app.app_context():
    db.create_all()

@app.route('/')
def index():
    return 'Bienvenido a mi servidor Flask!'

@app.route('/inicio_sesion', methods=['POST'])
def inicio_sesion():
    try:
        datos = request.json
        correo = datos['correo']
        contrasena = datos['contrasena']

        usuario = Usuario.query.filter_by(correo=correo).first()
        if usuario and check_password_hash(usuario.contrasena, contrasena):
            return jsonify({'mensaje': 'Inicio de sesión exitoso'})
        else:
            return jsonify({'mensaje': 'Credenciales inválidas'}), 401  # Retorna código de estado 401 para credenciales inválidas
    except Exception as e:
        return jsonify({'error': str(e)}), 500  # Retorna código de estado 500 para otros errores

@app.route('/registro', methods=['POST'])
def registro():
    try:
        datos = request.json
        nombre = datos['nombre']
        apellido = datos['apellido']
        correo = datos['correo']
        contrasena = datos['contrasena']

        if Usuario.query.filter_by(correo=correo).first() is None:
            nuevo_usuario = Usuario(nombre=nombre, apellido=apellido, correo=correo, contrasena=generate_password_hash(contrasena))
            db.session.add(nuevo_usuario)
            db.session.commit()
            return jsonify({'mensaje': 'Usuario registrado exitosamente'})
        else:
            return jsonify({'mensaje': 'El correo electrónico ya está en uso'}), 409  # Retorna código de estado 409 para conflicto
    except Exception as e:
        return jsonify({'error': str(e)}), 500  # Retorna código de estado 500 para otros errores

if __name__ == '__main__':
    app.run(debug=True)
