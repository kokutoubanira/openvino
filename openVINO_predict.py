import requests
from PIL import Image
from io import BytesIO
import numpy as np
import os
import sys
import math
from openvino.inference_engine import IENetwork, IEPlugin
import matplotlib.pyplot as plt
from openvino.inference_engine import get_version

model_xml = "./torch/torch_model.xml"
model_bin = "./torch/torch_model.bin"

plugin = IEPlugin(device="CPU", plugin_dirs=None)

net = IENetwork(model=model_xml, weights=model_bin)