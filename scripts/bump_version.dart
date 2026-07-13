/// A cross-platform utility script to synchronously bump the application version
/// across `pubspec.yaml` and `lib/core/utils/constants.dart`.
///
/// **Usage:**
/// Run this script from the project root using Dart:
/// ```bash
/// dart run scripts/bump_version.dart [flag]
/// ```
/// 
/// **Flags:**
/// * `--patch` (Default): Increments the patch version (e.g. 1.0.0 -> 1.0.1)
/// * `--minor`: Increments the minor version and resets patch (e.g. 1.0.1 -> 1.1.0)
/// * `--major`: Increments the major version and resets minor/patch (e.g. 1.1.0 -> 2.0.0)
/// * `--set <version>`: Sets a specific version following standard SemVer (e.g. 1.2.3 or 1.2.3+4)
/// 
/// *Note:* The build number (the + suffix) is always incremented automatically unless explicitly overridden via --set.
import 'dart:io';

void main(List<String> args) {
  // Parse command line arguments to determine bump type
  final bool major = args.contains('--major');
  final bool minor = args.contains('--minor');
  final int setIndex = args.indexOf('--set');
  
  String? setVersion;
  if (setIndex != -1 && setIndex + 1 < args.length) {
    setVersion = args[setIndex + 1];
    
    // Strict SemVer validation (Major.Minor.Patch optionally followed by +Build)
    final semverRegex = RegExp(r'^\d+\.\d+\.\d+(?:\+\d+)?$');
    if (!semverRegex.hasMatch(setVersion)) {
      print('Error: Invalid version format "$setVersion". Must be standard SemVer (e.g. 1.2.3 or 1.2.3+4).');
      exit(1);
    }
  }
  
  // Default to patch if no flag is provided
  final bool patch = setVersion == null && !major && !minor;

  // Ensure the script is run from the project root
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('Error: pubspec.yaml not found in the current directory. Run this script from the project root.');
    exit(1);
  }

  // Ensure constants.dart exists
  final constantsFile = File('lib/core/utils/constants.dart');
  if (!constantsFile.existsSync()) {
    print('Error: lib/core/utils/constants.dart not found.');
    exit(1);
  }

  // Read the current pubspec.yaml content
  String pubspecContent = pubspecFile.readAsStringSync();
  
  // Regex to match version strings like 'version: 1.2.3' or 'version: 1.2.3+4'
  final versionRegex = RegExp(r'^version:\s*(\d+)\.(\d+)\.(\d+)(?:\+(\d+))?', multiLine: true);
  final match = versionRegex.firstMatch(pubspecContent);

  if (match == null) {
    print('Error: Could not find version string in pubspec.yaml. Expected format: version: X.Y.Z or version: X.Y.Z+B');
    exit(1);
  }

  // Extract current version components
  int majorVer = int.parse(match.group(1)!);
  int minorVer = int.parse(match.group(2)!);
  int patchVer = int.parse(match.group(3)!);
  
  int buildNum = 0;
  if (match.group(4) != null) {
    buildNum = int.parse(match.group(4)!);
  }

  String newVersion;
  String newVersionWithBuild;

  if (setVersion != null) {
    // User provided a specific version
    final setMatch = RegExp(r'^(\d+\.\d+\.\d+)(?:\+(\d+))?$').firstMatch(setVersion)!;
    newVersion = setMatch.group(1)!;
    
    if (setMatch.group(2) != null) {
      // User explicitly provided a build number
      buildNum = int.parse(setMatch.group(2)!);
      newVersionWithBuild = setVersion;
    } else {
      // Use provided version, but auto-increment existing build number
      buildNum++;
      newVersionWithBuild = '$newVersion+$buildNum';
    }
  } else {
    // Calculate the new version components
    if (major) {
      majorVer++;
      minorVer = 0;
      patchVer = 0;
    } else if (minor) {
      minorVer++;
      patchVer = 0;
    } else if (patch) {
      patchVer++;
    }
    buildNum++; // Always increment the build number

    newVersion = '$majorVer.$minorVer.$patchVer';
    newVersionWithBuild = '$newVersion+$buildNum';
  }

  print('Bumping version to $newVersionWithBuild');

  // Update pubspec.yaml with the new version string
  pubspecContent = pubspecContent.replaceFirst(
    versionRegex,
    'version: $newVersionWithBuild',
  );
  pubspecFile.writeAsStringSync(pubspecContent);

  // Read the current constants.dart content
  String constantsContent = constantsFile.readAsStringSync();
  
  // Regex to match the appVersion constant safely preserving whitespace/formatting
  final constantsRegex = RegExp(r"(static const String appVersion\s*=\s*')([^']+)(';)");
  
  if (!constantsRegex.hasMatch(constantsContent)) {
    print('Error: Could not find appVersion in constants.dart');
    exit(1);
  }

  // Update constants.dart with the new version string
  constantsContent = constantsContent.replaceFirstMapped(
    constantsRegex,
    (m) => "${m.group(1)}$newVersion${m.group(3)}",
  );
  constantsFile.writeAsStringSync(constantsContent);

  print('Successfully updated pubspec.yaml and constants.dart');
}
