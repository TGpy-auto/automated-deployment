from flask import Flask, render_template # type: ignore

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

if__name__ == "__main__": # type: ignore
app.run(debug=True, host="0.0.0.0")