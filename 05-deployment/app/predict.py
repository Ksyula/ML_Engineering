import pickle

from flask import Flask
from flask import request
from flask import jsonify


model_file = 'model2.bin'
vectorizer_file = 'dv.bin'
app = Flask('card_prediction')

with open(model_file, 'rb') as model:
    model = pickle.load(model)

with open(vectorizer_file, 'rb') as vectorizer:
    dv = pickle.load(vectorizer)


@app.route('/predict', methods=['POST'])
def predict():
    customer = request.get_json()

    X = dv.transform([customer])
    y_pred = model.predict_proba(X)[0, 1]
    card = y_pred >= 0.5

    result = {
        'probability': float(y_pred),
        'card': bool(card)
    }

    return jsonify(result)


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=9696)