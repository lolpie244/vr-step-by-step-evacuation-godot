VERSION="4.2.2-stable"

cd "$(dirname "$0")"

TMP_DIR="$(mktemp -d)"
ZIP_PATH="${TMP_DIR}/godot_openxr_vendors"
curl -L "https://github.com/GodotVR/godot_openxr_vendors/releases/download/${VERSION}/godotopenxrvendorsaddon.zip" -o "${ZIP_PATH}"

mkdir -p godot_openxr_vendors
unzip -o "${ZIP_PATH}" -d godot_openxr_vendors >/dev/null

rm -rf "${TMP_DIR}"
