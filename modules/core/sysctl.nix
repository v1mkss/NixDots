{ lib, ... }:

let
  sysctlDir = ./sysctl.d;
  sysctlDirExists = builtins.pathExists sysctlDir;

  # Function to find the index of '=' in a string
  findEqIndex =
    str:
    let
      indices = lib.range 0 (builtins.stringLength str - 1);
      matches = lib.filter (i: builtins.substring i 1 str == "=") indices;
    in
    if matches == [ ] then null else builtins.head matches;

  # Function to parse sysctl configuration lines into an attribute set
  parseSysctlFiles =
    dir:
    let
      files = builtins.attrNames (builtins.readDir dir);
      confFiles = lib.filter (name: lib.hasSuffix ".conf" name) files;
      # Ensure deterministic order by sorting file names before reading
      sortedConfFiles = lib.sort lib.lessThan confFiles;
      contents = lib.map (name: builtins.readFile (dir + "/${name}")) sortedConfFiles;
      allLines = lib.splitString "\n" (lib.concatStringsSep "\n" contents);

      # Process each line, accumulating settings
      parsedSettings = lib.foldl (
        acc: line:
        let
          trimmedLine = lib.strings.trim line;
          # Skip empty lines and comments (# or ;)
          isComment = lib.hasPrefix "#" trimmedLine || lib.hasPrefix ";" trimmedLine;
        in
        if trimmedLine == "" || isComment then
          acc
        else
          # Find the position of the first '='
          let
            eqPos = findEqIndex trimmedLine;
          in
          if eqPos == null then
            # Line doesn't contain '=', invalid format, skip
            # Consider adding: lib.warn "Invalid sysctl line skipped: ${line}" acc
            acc
          else
            let
              # Extract key and value, trimming whitespace
              key = lib.strings.trim (builtins.substring 0 eqPos trimmedLine);
              # KEEP THE VALUE AS A STRING
              finalValue = lib.strings.trim (
                builtins.substring (eqPos + 1) ((builtins.stringLength trimmedLine) - eqPos - 1) trimmedLine
              );
            in
            # Skip if the key is empty after trimming
            if key == "" then
              # Consider adding: lib.warn "Sysctl line with empty key skipped: ${line}" acc
              acc
            else
              # Add/override entry in attribute set using the key and string value
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
