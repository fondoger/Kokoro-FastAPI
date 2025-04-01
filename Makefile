

_install-espeak-macos:
	brew install espeak-ng
_install-espeak-linux:
	apt-get -qq -y install espeak-ng > /dev/null 2>&1
_install-espeak-windows:
	@echo "Please manually via guidance: https://github.com/espeak-ng/espeak-ng/blob/master/docs/guide.md#windows"

# Conditionally install espeak-ng based on the OS
install-espeak:
	@echo "Installing espeak-ng..."
	@if [[ "$$OSTYPE" == "darwin"* ]]; then \
		make install-espeak-macos; \
	elif [[ "$$OSTYPE" == "linux-gnu"* ]]; then \
		make install-espeak-linux; \
	elif [[ "$$OSTYPE" == "msys" || "$$OSTYPE" == "cygwin" ]]; then \
		make install-espeak-windows; \
	else \
		echo "Unsupported OS: $$OSTYPE"; \
	fi
	@echo "espeak-ng installation complete."

download-model:
	uv run --no-sync python docker/scripts/download_model.py --output api/src/models/v1_0
