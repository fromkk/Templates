# Templates

[![Twitter: @fromkk](https://img.shields.io/badge/contact-@fromkk-00801D.svg?style=flat)](https://twitter.com/fromkk)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-F16D39.svg?style=flat)](https://developer.apple.com/swift/)
![Platforms](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/fromkk/Templates/master/LICENSE.md)

## What

CLI tool for replace keywods of multi files.

## Install

```sh
git clone git@github.com:fromkk/Templates.git
cd ./Templates
make install
```

## Usage

```sh
# Configure
Usage: templates set --key ${KEY} --value ${VALUE}

Options:
--key Key string
--value Value string

# Remove key
Usage: templates remove --key ${KEY}

Options:
--key Key string

# Show
Usage: templates show --key ${KEY}

Options:
--key Key string(optional)

# Convert
Usage: templates convert --source ${TEMPLATE_DIR} --output ${OUTPUT_DIR} --prefix ${PREFIX}

Options:
--source Templates directory
--output Output directory
--prefix Prefix string
```

