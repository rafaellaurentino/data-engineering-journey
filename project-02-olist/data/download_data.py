import os
from pathlib import Path
import kaggle

# Get the folder where this script is located
script_folder = Path(__file__).parent

# Define a subfolder for the dataset
data_folder = script_folder / "olist_dataset"
data_folder.mkdir(exist_ok=True)

print(f"Downloading Olist dataset into: {data_folder}")

# Download the dataset from Kaggle
# Replace with the correct Kaggle dataset slug
# Example: "olistbr/brazilian-ecommerce"
kaggle.api.dataset_download_files(
    "olistbr/brazilian-ecommerce",
    path=data_folder,
    unzip=True
)

print("✅ Olist dataset downloaded successfully!")
