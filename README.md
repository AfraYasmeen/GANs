# GANs (project)

This folder contains GAN utilities, example notebooks and a script for generating
images from text prompts using CLIP-guided latent optimization with StyleGAN2,
plus a structured/tabular GAN notebook for synthesizing and oversampling
tabular data.

Key files
- `src/GANs_Images.ipynb` — notebook conversion of the script for interactive runs.
- `src/requirements.txt` — Python dependencies used by the image-generation notebook/script.
- `src/GANs_Sturctured.ipynb` — a notebook that implements a structured/tabular GAN (generator, discriminator, training loop, oversampling and diagnostics).

Summary of the main components

**1) CLIP-guided StyleGAN2 (text -> image)**

- Purpose: optimize a StyleGAN2 latent (`w`) so generated images match a text prompt using CLIP similarity.
- How it works:
	- Loads a StyleGAN2 `.pkl` (NVIDIA/stylegan2-ada format) using the `legacy.load_network_pkl` loader.
	- Samples a random `z`, maps to `w` via the generator mapping network, and makes `w` a trainable tensor.
	- Encodes the prompt using CLIP (`ViT-B/32`) and iteratively updates `w` with Adam to maximize cosine similarity between the image and text features.
	- Saves the best-scoring image to the output directory.

Usage (command-line):

```bash
python src/generate_images_from_prompt.py \
	--prompt "a fantasy castle on a cliff at sunset" \
	--pkl /path/to/stylegan2-ffhq.pkl \
	--steps 300 \
	--outdir outputs
```

Notes and recommendations:
- The script depends on the NVLabs `stylegan2-ada-pytorch` loader (`legacy.py`, `dnnlib`). If those modules are not importable, clone the repository and add it to `PYTHONPATH`.
- For faster results use a GPU and increase `--steps`; for quick previews reduce `--steps`.
- A notebook version `src/generate_images_from_prompt.ipynb` is included for interactive experimentation and inline display of intermediate images.

**2) Structured / Tabular GAN (in `GANs_Sturctured.ipynb`)**

- Purpose: train a GAN that synthesizes structured/tabular data (useful for class imbalance oversampling or synthetic data generation).
- Notebook highlights (based on the workbook contents):
	- Reads a CSV (example `camp4Final.csv`) and performs preprocessing: drop unused columns, fill/drop NaNs, scale numeric features, and one-hot encode categorical features.
	- Builds a multi-branch generator producing categorical softmax outputs and numerical outputs (sigmoid), and a discriminator that classifies real vs. fake combined vectors.
	- Trains the GAN with alternating discriminator and generator updates, logs losses, and provides an evaluation procedure.
	- Demonstrates generating synthetic minority-class samples, post-processing outputs (rounding categorical predictions, inverse-scaling numeric outputs), and plotting distribution comparisons between original and generated data.

Usage notes for the notebook:
- Open `GANs/src/GANs_Sturctured.ipynb` and run cells sequentially. Adjust file paths and hyperparameters to fit your dataset.
- The notebook includes utility functions for plotting and comparison; inspect and adapt them for your analysis pipeline.

Setup

Install dependencies in a virtualenv and use the `requirements.txt` located in `src` for the image-generation workflow:

```bash
python -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\Activate.ps1 on Windows
pip install -r src/requirements.txt
```

If running the StyleGAN2 script, clone the NVLabs repo and set `PYTHONPATH`:

```bash
git clone https://github.com/NVlabs/stylegan2-ada-pytorch.git
export PYTHONPATH=$PYTHONPATH:/path/to/stylegan2-ada-pytorch
```

Docker

There is a `Dockerfile` in the repository root and in `GANs/` that installs the Python deps; you can build an image and run the script inside a GPU-enabled container.

Testing

Run the (basic) tests:

```bash
pytest -q
```

