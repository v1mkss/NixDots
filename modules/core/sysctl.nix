{ lib, ... }:

let
  sysctlDir = ./sysctl.d;
  sysctlDirExists = builtins.pathExists sysctlDir;

  # Function to find the index of '=' in a string
  findEqIndex =
    str:
    let
      # Try to find '=' using a range
      indices = lib.range 0 (builtins.stringLength str - 1);
      matches = lib.filter (i: builtins.substring i 1 str == "=") indices;
    in
    if matches == [ ] then null else builtins.head matches;

  # Safe integer conversion
  tryToInt =
    value:
    let
      # Attempt to convert to integer
      parsed = builtins.fromJSON (if builtins.match "[0-9]+" value != null then value else "0");
    in
    if parsed != 0 || value == "0" then parsed else null;

  # Function to parse sysctl configuration lines into an attribute set
  parseSysctlFiles =
    dir:
    let
      # Read all files ending in .conf in the directory
      files = builtins.attrNames (builtins.readDir dir);
      confFiles = lib.filter (name: lib.hasSuffix ".conf" name) files;

      # Read the content of each .conf file
      contents = lib.map (name: builtins.readFile (dir + "/${name}")) confFiles;

      # Combine all content into a single string, then split into lines
      allLines = lib.splitString "\n" (lib.concatStringsSep "\n" contents);

      # Process each line
      parsedSettings = lib.foldl (
        acc: line:
        let
          trimmedLine = lib.strings.trim line;
        in
        # Skip empty lines and comments
        if trimmedLine == "" || lib.hasPrefix "#" trimmedLine then
          acc
        else
          # Find the position of the first '='
          let
            eqPos = findEqIndex trimmedLine;
          in
          if eqPos == null then
            # Line doesn't contain '=', invalid format, skip
            acc
          else
            let
              # Extract key and value, trimming whitespace
              key = lib.strings.trim (builtins.substring 0 eqPos trimmedLine);
              valueStr = lib.strings.trim (
                builtins.substring (eqPos + 1) ((builtins.stringLength trimmedLine) - eqPos - 1) trimmedLine
              );

              # Attempt to convert value to integer if possible, otherwise keep as string
              finalValue =
                let
                  intVal = tryToInt valueStr;
                in
                if intVal != null then intVal else valueStr;

            in
            # Add to attribute set using the key and value
            acc // { "${key}" = finalValue; }
      ) { } allLines;

    in
    parsedSettings;

  # Call the parsing function if the directory exists
  sysctlSettings = if sysctlDirExists then parseSysctlFiles sysctlDir else { };

in
{
  boot.kernel.sysctl = lib.mkIf (sysctlSettings != { }) sysctlSettings;
}
