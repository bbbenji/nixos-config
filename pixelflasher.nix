{
  android-tools,
  cacert,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  nix-update-script,
  python3,
  stdenv,
  substituteAll,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pixelflasher";
  version = "7.8.0.1";

  src = fetchFromGitHub {
    owner = "badabing2005";
    repo = "PixelFlasher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NFDM1uHveD+qNiCX8003GVvua/2P6ikGKiqSac9bR+s=";
  };

  disabled = python3.pythonOlder "3.11";

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = with python3.pkgs; [
    android-tools
    attrdict
    beautifulsoup4
    bsdiff4
    chardet
    cryptography
    darkdetect
    httplib2
    json5
    lz4
    markdown
    platformdirs
    protobuf
    psutil
    pyinstaller
    pyperclip
    requests
    rsa
    six
    wxpython
  ];

  patchPhase = ''
    substituteInPlace config.py \
      --replace "platform_tools_path = None" "platform_tools_path = '${lib.getBin android-tools}/bin'"
  '';

  buildPhase = ''
    sh build.sh
  '';

  installPhase = ''
    install -D dist/PixelFlasher $out/bin/pixelflasher
    install -D images/icon-dark-256.png $out/share/pixmaps/pixelflasher.png
    ln -s ${finalAttrs.desktopItem}/share/applications $out/share/
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set REQUESTS_CA_BUNDLE "${cacert}/etc/ssl/certs/ca-bundle.crt"
      --set PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION python
    )
  '';

  desktopItem = makeDesktopItem {
    desktopName = "PixelFlasher";
    name = "pixelflasher";
    exec = "pixelflasher";
    icon = "pixelflasher";
    categories = [ "Utility" ];
    genericName = finalAttrs.meta.description;
    noDisplay = false;
    startupNotify = true;
    terminal = false;
    type = "Application";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pixel™ phone flashing GUI utility with features";
    homepage = "https://github.com/badabing2005/PixelFlasher";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      cjshearer
      samueltardieu
    ];
    mainProgram = "pixelflasher";
    platforms = lib.platforms.all;
  };
})