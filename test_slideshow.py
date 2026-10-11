import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
from slideshow import images, set_wallpaper


class SlideshowTests(unittest.TestCase):
    def test_image_filter_and_order(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ['b.jpg', 'a.PNG', 'notes.txt']:
                (root / name).touch()
            self.assertEqual([p.name for p in images(root)], ['a.PNG', 'b.jpg'])

    def test_uri_escapes_spaces_and_sets_both_themes(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'my image.png'
            path.touch()
            with patch('slideshow.subprocess.run') as run:
                set_wallpaper(path)
            self.assertEqual(run.call_count, 3)
            self.assertIn('%20', run.call_args_list[0].args[0][-1])
            self.assertEqual(run.call_args_list[1].args[0][-2], 'picture-uri-dark')


if __name__ == '__main__':
    unittest.main()
