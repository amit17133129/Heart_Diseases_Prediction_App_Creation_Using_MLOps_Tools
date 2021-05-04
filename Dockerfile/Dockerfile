FROM centos:latestRUN yum install python3  python3-devel   gcc-c++ -y && \
    python3 -m pip install --upgrade --force-reinstall pip && \
    yum install sudo -y && \
    yum install --assumeyes  python3-pip && \
    pip install keras && \
    pip install tensorflow --no-cache-dir  tensorflow && \
    pip install --upgrade pip tensorflow && \
    pip3 install flask && \
    pip3 install joblib && \
    pip3 install sklearn && \
    mkdir  /heart_app &&  \
    mkdir /heart_app/templatesCOPY  Randorm_Forest_Heart_Prediction.h5    /heart_app
COPY  app.py  /heart_app
COPY  myform.html  /heart_app/templates
COPY  result.html   /heart_app/templates
EXPOSE  4444WORKDIR  /heart_app
CMD export FLASK_APP=app.pyENTRYPOINT flask  run --host=0.0.0.0    --port=4444
