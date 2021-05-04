from keras.models import load_model
from flask import Flask, render_template, request
import joblib
app = Flask("HeartCureApp")
model = joblib.load("Randorm_Forest_Heart_Prediction.h5")
@app.route("/home")
def home():
   return render_template("myform.html")

@app.route("/output", methods=[ "GET" ] )
def dia():
      x1 = request.args.get("z1")
      x2 = request.args.get("z2")
      x3 = request.args.get("z3")
      x4 = request.args.get("z4")
      x5 = request.args.get("z5")
      x6 = request.args.get("z6")
      if x6=="Male":
          x6=1
      else:
          x6=0
      x7 = request.args.get("z7")
      if x7=="yes":
          x7=1
      else:
          x7=0
      x8 = request.args.get("z8")
      if x8=="yes":
          x8=1
      else:
          x8=0
      x9 = request.args.get("z9")
      if x9=="yes":
          x9=1
      else:
          x9=0
      x10 = request.args.get("z10")
      if x10=="yes":
          x10=1
      else:
          x10=0
      x11 = request.args.get("z11")
      if x11=="yes":
          x11=1
      else:
          x11=0
      x12 = request.args.get("z12")
      if x12=="yes":
          x12=1
      else:
          x12=0
      x13 = request.args.get("z13")
      if x13=="yes":
          x13=1
      else:
          x13=0
      x14 = request.args.get("z14")
      if x14=="yes":
          x14=1
      else:
          x14=0
      x15 = request.args.get("z15")
      if x15=="yes":
          x15=1
      else:
          x15=0
      x16 = request.args.get("z16")
      if x16=="yes":
          x16=1
      else:
          x16=0
      x17 = request.args.get("z17")
      if x17=="yes":
          x17=1
      else:
          x17=0
      x18 = request.args.get("z18")
      if x18=="yes":
          x18=1
      else:
          x18=0
      x19 = request.args.get("z19")
      if x19=="yes":
          x19=1
      else:
          x19=0
      x20 = request.args.get("z20")
      if x20=="yes":
          x20=1
      else:
          x20=0
      x21 = request.args.get("z21")
      if x21=="yes":
          x21=1
      else:
          x21=0
      x22 = request.args.get("z22")
      if x22=="yes":
          x22=1
      else:
          x22=0
      output = model.predict([[ int(x1), int(x2), int(x3), int(x4), float(x5), int(x6), int(x7), int(x8), int(x9), int(x10),int(x11),
                  int(x12),int(x13),int(x14),int(x15),int(x16),int(x17),int(x18),int(x19),int(x20),int(x21),int(x22)]])
      if str(round(output[0])) == 1:
         data="Consult Doctor for Heart Treatment !"
         return render_template("result.html", data=data)
      else:
          data="No Heart Treatment Required !"
          return render_template("result.html", data=data)
app.run(host="0.0.0.0", port=4444)
