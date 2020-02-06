FROM jupyter/tensorflow-notebook

LABEL maintainer="minhdh@coderschool.vn"

USER root

# Install gcc/g++
# RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc-7 g++-7 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# --- Conda xgboost, lightgbm, catboost, h2o, gensim, mlxtend
RUN conda install --quiet --yes \
    'boost' \
    'lightgbm' \
    'xgboost' \
    'catboost' \
    'gensim' \
    'mlxtend' \
    'tabulate' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# --- Install hyperopt, tpot, sklearn-deap, yellowbrick, spacy
RUN $CONDA_DIR/bin/python -m pip install hyperopt \
    deap \
    update_checker \
    tqdm \
    stopit \
    scikit-mdr \
    skrebate \
    tpot \
    sklearn-deap \
    yellowbrick \
    spacy \
    gplearn \
    kmapper \
    skope-rules \
    shap \
    lime

###########
#
# Add some usefull libs, inspired by kaggle's Dockerfile
# CREDITS : https://hub.docker.com/r/kaggle/python/dockerfile
#
###########
#RUN $CONDA_DIR/bin/python -m pip install --upgrade mpld3
RUN $CONDA_DIR/bin/python -m pip install mplleaflet \
    gpxpy \
    arrow \
    sexmachine \
    Geohash \
    haversine \
    toolz cytoolz \
    sacred \
    plotly \
    git+https://github.com/nicta/dora.git \
    git+https://github.com/hyperopt/hyperopt.git \
    # tflearn. Deep learning library featuring a higher-level API for TensorFlow. http://tflearn.org
    git+https://github.com/tflearn/tflearn.git \
    fitter \
    langid \
    # Delorean. Useful for dealing with datetime
    delorean \
    trueskill \
    heamy \
    vida \
    # Useful data exploration libraries (for missing data and generating reports)
    missingno \
    pandas-profiling \
    s2sphere \
    # CS_FTMLE libaries
    opencv-contrib-python \
    mahotas \
    tensorflow-datasets \
    keras-tuner \
    grpcio

# Issue #1 pandas.read_hdf
RUN $CONDA_DIR/bin/python -m pip install --upgrade tables

# Install from requirements.txt file
COPY requirements.txt /tmp/
RUN python3 -m pip install --requirement /tmp/requirements.txt --user && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# clean up pip cache
RUN rm -rf /root/.cache/pip/*