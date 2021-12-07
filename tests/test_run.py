#!/usr/bin/env python3

import os
import unittest


class LinuxShell(unittest.TestCase):

    HOME = os.path.expanduser("~")

    def test_bashrc(self):
        self.assertTrue(os.path.exists(f"{self.HOME}/.bashrc"))

    def test_shellrc(self):
        self.assertTrue(os.path.exists(f"{self.HOME}/.shellrc"))


if __name__ == "__main__":
    unittest.main()
