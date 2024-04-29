from flask import Flask, request, jsonify
import spacy

app = Flask(__name__)

# Load the English NER model
nlp = spacy.load("en_core_web_sm")

# Named entity recognition function using spaCy
def predict_ner(text):
    doc = nlp(text)
    named_entities = [{'text': ent.text, 'label': ent.label_} for ent in doc.ents]
    return named_entities


@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    text = data['text']
    named_entities = predict_ner(text)
    return jsonify({'named_entities': named_entities})


if __name__ == '__main__':
    app.run(debug=True)
