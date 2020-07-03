ARG BASE_CONTAINER=techlab.azurecr.io/jupyter/base-notebook:v1
FROM $BASE_CONTAINER

USER root

ENV OPENVINO_PACKAGE=intel-openvino-dev-ubuntu18-2020.3.194

RUN apt-get update && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            libgomp1 \
            usbutils \
            gnupg2

RUN curl -o /tmp/GPG-PUB-KEY-INTEL-OPENVINO-2020 https://apt.repos.intel.com/openvino/2020/GPG-PUB-KEY-INTEL-OPENVINO-2020 \
    && apt-key add /tmp/GPG-PUB-KEY-INTEL-OPENVINO-2020 \
    && rm /tmp/GPG-PUB-KEY-INTEL-OPENVINO-2020 \
    && echo "deb https://apt.repos.intel.com/openvino/2020/ all main" > /etc/apt/sources.list.d/intel-openvino-2020.list

RUN apt-get update && apt-get install -y $OPENVINO_PACKAGE

ENV DL_INSTALL_DIR=/opt/intel/openvino/deployment_tools
ENV PYTHONPATH="/opt/intel/openvino/python/python3.7"
ENV LD_LIBRARY_PATH="$DL_INSTALL_DIR/inference_engine/external/tbb/lib:$DL_INSTALL_DIR/inference_engine/external/mkltiny_lnx/lib:$DL_INSTALL_DIR/inference_engine/lib/intel64:$DL_INSTALL_DIR/ngraph/lib"

# Install Python 3 packages
RUN conda update --all --quiet --yes \
    && conda config --system --prepend channels pytorch \
    && conda install --quiet --yes \
        'opencv=4.*' \
    && conda clean --all -f -y \
    && fix-permissions $CONDA_DIR \
    && fix-permissions /home/$NB_USER

RUN jupyter lab build

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
