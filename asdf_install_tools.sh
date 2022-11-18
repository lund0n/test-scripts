#!/bin/bash

check_for_asdf() {
  asdf --version 1> /dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "asdf is not installed. Please visit https://asdf-vm.com/ and follow the installation instructions."
    exit 1
  fi
}

asdf_install_tools() {
  local TOOL_VERSIONS=$1

  if [ -f "$TOOL_VERSIONS" ]; then
    local TOOLS_LIST=($(cut -d " " -f1 "$TOOL_VERSIONS"))
    local VERSIONS_LIST=($(cut -d " " -f2 "$TOOL_VERSIONS"))
    
    # Install missing plugins
    local INSTALLED_PLUGINS=($(asdf plugin list))
    for i in "${!TOOLS_LIST[@]}"
      do
        local TOOL=${TOOLS_LIST[$i]}
        local VERSION=${VERSIONS_LIST[$i]}
        
        # Install plugin, if missing
        if [[ ! " ${INSTALLED_PLUGINS[*]} " =~ " $TOOL " ]]
        then
          echo "Installing $TOOL plugin"
          asdf plugin-add $TOOL 2> /dev/null
        fi

      # Install tool
      echo "Installing $TOOL $VERSION"
      asdf install $TOOL 1> /dev/null
    done
    echo "Installation completed!"
  else
    echo "No .tool-versions file found. Exiting."
    exit 1
  fi
}

# Check for asdf
check_for_asdf

# Install any missing plugins or tools.
asdf_install_tools "$PWD/.tool-versions"
