From balenalib/rpi-raspbian:stretch

COPY sources.list /etc/apt/sources.list
COPY raspi.list /etc/apt/sources.list.d/raspi.list

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends\
    build-essential \
    python3-dev \
    python3-pip \
    software-properties-common \
    openjdk-8-jdk \
    libatlas-base-dev \
    wget \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY wheels/ /wheels/

WORKDIR /wheels

RUN pip3 --no-cache-dir install \
    -i https://pypi.tuna.tsinghua.edu.cn/simple -U \
    pip \
    setuptools

RUN pip3 --no-cache-dir install \
    -i https://pypi.tuna.tsinghua.edu.cn/simple \
    Pillow-5.4.1-cp35-cp35m-linux_armv7l.whl \
    h5py-2.9.0-cp35-cp35m-linux_armv7l.whl \
    numpy-1.16.0-cp35-cp35m-linux_armv7l.whl \
    scipy-1.2.0-cp35-cp35m-linux_armv7l.whl \
    scikit_learn-0.20.2-cp35-cp35m-linux_armv7l.whl \
    sklearn-0.0-py2.py3-none-any.whl \
    pandas-0.23.4-cp35-cp35m-linux_armv7l.whl \
    others/*.whl \
    mock \
    grpcio==1.17 \
    tensorflow-1.12.0-cp35-none-linux_armv7l.whl \
    jupyter \
    matplotlib-3.0.2-cp35-cp35m-linux_armv7l.whl \
    enum34

RUN mkdir -p /tf/tensorflow-tutorials && chmod -R a+rwx /tf/
WORKDIR /tf/tensorflow-tutorials
RUN wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/basic_classification.ipynb && \
    wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/basic_text_classification.ipynb
RUN apt-get autoremove -y && apt-get remove -y wget
WORKDIR /tf
EXPOSE 8888
RUN python3 -m ipykernel.kernelspec
ENTRYPOINT ["bash", "-c", "jupyter notebook --notebook-dir=/tf --no-browser --allow-root"]
