import sys
from pathlib import Path


def test_import_script():
    repo_root = Path(__file__).resolve().parents[2]
    src_dir = repo_root / 'src'
    sys.path.insert(0, str(src_dir))

    import generate_images_from_prompt as gen

    assert hasattr(gen, 'main')
