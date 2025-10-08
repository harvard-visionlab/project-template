import torch, sys
import visionlab.project_template as m, inspect

print("✅ import successful")
print("module file:", m.__file__)
print("is from working tree? ->", "project_template" in m.__file__)

print("torch:", torch.__version__)
print("torch cuda runtime tag:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())

device = torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'cpu'
print("device:", device)

import litdata
print("litdata version:", litdata.__version__)

import cv2
print("cv2 version:", cv2.__version__)

from visionlab.datasets import StreamingDataset
print("StreamingDataset:", StreamingDataset)
