# coding: utf-8
import unittest
from StringIO import StringIO

from lxml import isoschematron, etree

from packtools import stylechecker


SCH = etree.parse(stylechecker.SCHEMAS['sps.sch'])


class JournalIdTests(unittest.TestCase):
    """Tests for article/front/journal-meta/journal-id elements.
    """
    def _run_validation(self, sample):
        schematron = isoschematron.Schematron(SCH, phase='phase.journal-id')
        return schematron.validate(etree.parse(sample))

    def test_case1(self):
        """
        presence(@nlm-ta) is True
        presence(@publisher-id) is True
        presence(@nlm-ta) v presence(@publisher-id) is True
        """
        sample = """<article>
                      <front>
                        <journal-meta>
                          <journal-id journal-id-type="nlm-ta">
                            Rev Saude Publica
                          </journal-id>
                          <journal-id journal-id-type="publisher-id">
                            RSP
                          </journal-id>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertTrue(self._run_validation(sample))

    def test_case2(self):
        """
        presence(@nlm-ta) is True
        presence(@publisher-id) is False
        presence(@nlm-ta) v presence(@publisher-id) is True
        """
        sample = """<article>
                      <front>
                        <journal-meta>
                          <journal-id journal-id-type="nlm-ta">
                            Rev Saude Publica
                          </journal-id>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertTrue(self._run_validation(sample))

    def test_case3(self):
        """
        presence(@nlm-ta) is False
        presence(@publisher-id) is True
        presence(@nlm-ta) v presence(@publisher-id) is True
        """
        sample = """<article>
                      <front>
                        <journal-meta>
                          <journal-id journal-id-type="publisher-id">
                            RSP
                          </journal-id>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertTrue(self._run_validation(sample))

    def test_case4(self):
        """
        presence(@nlm-ta) is False
        presence(@publisher-id) is False
        presence(@nlm-ta) v presence(@publisher-id) is False
        """
        sample = """<article>
                      <front>
                        <journal-meta>
                          <journal-id journal-id-type='doi'>
                            123.plin
                          </journal-id>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertFalse(self._run_validation(sample))


class JournalTitleGroupTests(unittest.TestCase):
    """Tests for article/front/journal-meta/journal-title-group elements.
    """
    def _run_validation(self, sample):
        schematron = isoschematron.Schematron(SCH, phase='phase.journal-title-group')
        return schematron.validate(etree.parse(sample))

    def test_journal_title_group_is_absent(self):
        sample = """<article>
                      <front>
                        <journal-meta>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertFalse(self._run_validation(sample))


    def test_case1(self):
        """
        A: presence(journal-title) is True
        B: presence(abbrev-journal-title[@abbrev-type='publisher']) is True
        A ^ B is True
        """
        sample = """<article>
                      <front>
                        <journal-meta>
                          <journal-title-group>
                            <journal-title>
                              Revista de Saude Publica
                            </journal-title>
                            <abbrev-journal-title abbrev-type='publisher'>
                              Rev. Saude Publica
                            </abbrev-journal-title>
                          </journal-title-group>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertTrue(self._run_validation(sample))

    def test_case2(self):
        """
        A: presence(journal-title) is True
        B: presence(abbrev-journal-title[@abbrev-type='publisher']) is False
        A ^ B is False
        """
        sample = """<article>
                      <front>
                        <journal-meta>
                          <journal-title-group>
                            <journal-title>
                              Revista de Saude Publica
                            </journal-title>
                          </journal-title-group>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertFalse(self._run_validation(sample))

    def test_case3(self):
        """
        A: presence(journal-title) is False
        B: presence(abbrev-journal-title[@abbrev-type='publisher']) is True
        A ^ B is False
        """
        sample = """<article>
                      <front>
                        <journal-meta>
                          <journal-title-group>
                            <abbrev-journal-title abbrev-type='publisher'>
                              Rev. Saude Publica
                            </abbrev-journal-title>
                          </journal-title-group>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertFalse(self._run_validation(sample))

    def test_case4(self):
        """
        A: presence(journal-title) is False
        B: presence(abbrev-journal-title[@abbrev-type='publisher']) is False
        A ^ B is False
        """
        sample = """<article>
                      <front>
                        <journal-meta>
                          <journal-title-group>
                          </journal-title-group>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertFalse(self._run_validation(sample))


class ISSNTests(unittest.TestCase):
    """Tests for article/front/journal-meta/issn elements.
    """
    def _run_validation(self, sample):
        schematron = isoschematron.Schematron(SCH, phase='phase.issn')
        return schematron.validate(etree.parse(sample))

    def test_epub_is_absent(self):
        sample = """<article>
                      <front>
                        <journal-meta>
                          <issn>0959-8138</issn>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertFalse(self._run_validation(sample))

    def test_epub_is_present(self):
        sample = """<article>
                      <front>
                        <journal-meta>
                          <issn pub-type='epub'>0959-8138</issn>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertTrue(self._run_validation(sample))


class PublisherTests(unittest.TestCase):
    """Tests for article/front/journal-meta/publisher elements.
    """
    def _run_validation(self, sample):
        schematron = isoschematron.Schematron(SCH, phase='phase.publisher')
        return schematron.validate(etree.parse(sample))

    def test_publisher_is_present(self):
        sample = """<article>
                      <front>
                        <journal-meta>
                          <publisher>
                            <publisher-name>British Medical Journal</publisher-name>
                          </publisher>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertTrue(self._run_validation(sample))

    def test_publisher_is_absent(self):
        sample = """<article>
                      <front>
                        <journal-meta>
                        </journal-meta>
                      </front>
                    </article>
                 """
        sample = StringIO(sample)

        self.assertFalse(self._run_validation(sample))

