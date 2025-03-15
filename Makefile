.DEFAULT_GOAL: help
.PHONY: help all compile clean run

SDKBIN = ~/Developer/PlaydateSDK/bin
SIM    = "Playdate Simulator"
GAME   = "POO BREAK"

## —— 🎮 The Playdate Makefile 🎮 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

all: clean compile run ## Clean, compile and run PDX on emulator

compile: ## Compile source folder into PDX
	$(SDKBIN)/pdc source $(GAME).pdx

clean: ## Remove compiled PDX
	rm -rf $(GAME).pdx

run: ## Run current PDX on emulator
	$(SDKBIN)/$(SIM).app/Contents/MacOS/$(SIM) $(GAME).pdx
