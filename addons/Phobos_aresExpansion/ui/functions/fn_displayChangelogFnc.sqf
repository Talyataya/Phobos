#include "\Phobos_aresExpansion\includes\uidefines.inc"

(findDisplay IDD_CHANGELOG_DIALOG) closeDisplay 0;
profileNamespace setVariable ["Phobos_version",getText(configfile >> "CfgPatches" >> "Phobos" >> "versionStr")];
saveProfileNamespace;