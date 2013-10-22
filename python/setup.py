from distutils.core import setup
import shunit.version
import os
import sys

if __name__ == "__main__":
    setup(
        name="shunit",
        url="https://www.github.com/akesterson/shunit",
        version=shunit.version.VERSION,
        description="Simple Helpers for printing UNIT test reports",
        long_description="",
        author=("Andrew Kesterson"),
        author_email="andrew@aklabs.net",
        license="MIT",
        install_requires=["colorama"],
        scripts=[],
        packages=["shunit"],
        data_files=[],
        classifiers=[
            'Development Status :: 1 - Planning',
            'Environment :: Console',
            'Intended Audience :: Developers',
            'License :: OSI Approved :: MIT License',
            'Natural Language :: English',
            'Programming Language :: Python :: 2.7',
            'Topic :: Software Development :: Libraries :: Python Modules',
        ],
    )

