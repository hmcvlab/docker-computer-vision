"""
Test if all binaries exist
"""

import torch
import shutil
import pytest
import importlib


@pytest.mark.parametrize(("binary"), ["python3"])
def test_binaries(binary):
    """Check if binary exists"""
    assert shutil.which(binary)


@pytest.mark.parametrize(
    ("pip_package"),
    [
        "torch",
        "optuna",
        "transformers",
        "numpy",
        "open3d",
        "cv2",
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
