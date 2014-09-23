#coding:utf-8
import tempfile
import unittest
try:
    from unittest import mock
except ImportError: # PY2
    import mock

import packtools


# ------------------------
# Fixtures
# ------------------------
SAMPLE_XML = """<?xml version="1.0" encoding="UTF-8"?>
<article xmlns:xlink="http://www.w3.org/1999/xlink"
         dtd-version="1.0"
         article-type="research-article"
         xml:lang="en">
  <front>
    <article-meta>
      <supplementary-material mimetype="application"
                              mime-subtype="pdf"
                              xlink:href="1234-5678-rctb-45-05-0110-suppl02.pdf"/>
    </article-meta>
  </front>
  <body>
    <sec>
      <p>The Eh measurements... <xref ref-type="disp-formula" rid="e01">equation 1</xref>(in mV):</p>
      <disp-formula id="e01">
        <graphic xlink:href="1234-5678-rctb-45-05-0110-e01.tif"/>
      </disp-formula>
      <p>We also used an... <inline-graphic xlink:href="1234-5678-rctb-45-05-0110-e02.tif"/>.</p>
    </sec>
  </body>
  <back>
    <app-group>
      <app>
        <label>Apêndice</label>
        <p>Vivamus fermentum elit et pellentesque iaculis.</p>
        <media mimetype="video"
               mime-subtype="mp4"
               xlink:href="1234-5678-rctb-45-05-0110-m01.mp4"/>
      </app>
      <app>
        <supplementary-material id="suppl01">
          <label>Fig 1.</label>
          <caption><title>Material Suplementar</title></caption>
          <graphic xlink:href="1234-5678-rctb-45-05-0110-suppl01.tif"/>
        </supplementary-material>
      </app>
    </app-group>
  </back>
</article>
"""


# ------------------------
# Unit tests
# ------------------------
class XMLPackerTests(unittest.TestCase):
    def setUp(self):
        tmpfile = tempfile.NamedTemporaryFile()
        tmpfile.write(SAMPLE_XML)
        tmpfile.seek(0)

        self.tmpfile = tmpfile

    def tearDown(self):
        self.tmpfile.close()

    def test_valid_filepaths(self):
        packer = packtools.XMLPacker(self.tmpfile.name)
        self.assertTrue(isinstance(packer, packtools.XMLPacker))

    def test_invalid_filepath(self):
        self.assertRaises(ValueError,
                lambda: packtools.XMLPacker(self.tmpfile.name + 'zzzzzz'))

    def test_assets(self):
        expected_assets = ['1234-5678-rctb-45-05-0110-e01.tif',
                           '1234-5678-rctb-45-05-0110-suppl01.tif',
                           '1234-5678-rctb-45-05-0110-m01.mp4',
                           '1234-5678-rctb-45-05-0110-e02.tif',
                           '1234-5678-rctb-45-05-0110-suppl02.pdf']

        packer = packtools.XMLPacker(self.tmpfile.name)
        self.assertEqual(sorted(packer.assets), sorted(expected_assets))
