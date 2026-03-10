"""
Test if all binaries exist
"""

import importlib
import shutil

import pytest
import torch


@pytest.mark.parametrize("binary", ["python3"])
def test_binaries(binary):
    """Check if binary exists"""
    assert shutil.which(binary)


@pytest.mark.parametrize(
    "pip_package",
    [
        "cv2",
        "loguru",
        "numpy",
        #"open3d",
        "optuna",
        "seaborn",
        "torch",
        "torchvision",
        "transformers",
    ],
)
def test_pip_packages(pip_package):
    """Test if pip packages are installed"""
    try:
        importlib.import_module(pip_package)
    except ModuleNotFoundError:
        pytest.fail(f"{pip_package} not installed!")


def test_torch_gpu():
    """Check if GPU is available"""
    assert torch.cuda.is_available()
